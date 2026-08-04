#!/usr/bin/env bash
# clean-mp3.sh — Limpia y taggea MP3 con la metadata de Seobryn Music.
#
# Pipeline completo para garantizar cero rastro de la herramienta generadora:
#   1. ffmpeg   — strip ALL ID3 metadata, escribe tags propios, preserva bitstream
#   2. eyeD3    — elimina el frame TSSE (encoder=Lavf<version>) que ffmpeg añade
#   3. python   — blanquea el campo "Lavf"/"LAME" en el header Xing VBR del MP3
#                 (no está en los tags ID3, está en el bitstream del audio)
#   4. audit    — comprueba tanto los tags ID3 como los bytes crudos del archivo
#
# Uso:
#   ./scripts/clean-mp3.sh <input> <output> <title> <album> <track> [year] [genre]
#
# Argumentos:
#   input   — archivo mp3 de entrada (ej. cancion_3.mp3)
#   output  — ruta final (ej. "Seobryn Music/Whispers Before the Storm/3. What the Heart Whispered.mp3")
#   title   — título del track (en inglés)
#   album   — álbum al que pertenece
#   track   — número del track (sin cero-padding, ej. "3" o "3/4"). Pasar vacío "" para Sin Album (sin track).
#   year    — año (opcional, default = año actual)
#   genre   — género (opcional, default = "Instrumental Progressive Metal")
#
# Ejemplo:
#   ./scripts/clean-mp3.sh \
#     "Seobryn Music/Whispers Before the Storm/cancion_3.mp3" \
#     "Seobryn Music/Whispers Before the Storm/3. What the Heart Whispered.mp3" \
#     "What the Heart Whispered" \
#     "Whispers Before the Storm" \
#     "3" \
#     "2026" \
#     "Progressive Rock / Folk Metal"

set -euo pipefail

# Localización de eyeD3 (pip3 --user install, no siempre en PATH).
# macOS: ~/Library/Python/3.9/bin/ ; Linux: ~/.local/bin
for eyeD3_dir in "$HOME/Library/Python/3.9/bin" "$HOME/Library/Python/3.13/bin" "$HOME/.local/bin"; do
  if [ -x "$eyeD3_dir/eyeD3" ]; then
    export PATH="$eyeD3_dir:$PATH"
    break
  fi
done

if [ "$#" -lt 5 ]; then
  cat >&2 <<EOF
Uso: $0 <input> <output> <title> <album> <track> [year] [genre]

Argumentos obligatorios: input, output, title, album, track
Opcionales: year (default: año actual), genre (default: "Instrumental Progressive Metal")
EOF
  exit 1
fi

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "✗ ffmpeg no está instalado. Instalar con: brew install ffmpeg" >&2
  exit 1
fi

if ! command -v eyeD3 >/dev/null 2>&1; then
  echo "✗ eyeD3 no está instalado. Instalar con: pip3 install --user eyeD3" >&2
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "✗ python3 no está instalado." >&2
  exit 1
fi

if [ ! -f "$1" ]; then
  echo "✗ Archivo de entrada no existe: $1" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

INPUT="$1"
OUTPUT="$2"
TITLE="$3"
ALBUM="$4"
TRACK="${5:-}"
YEAR="${6:-$(date +%Y)}"
GENRE="${7:-Instrumental Progressive Metal}"
ARTIST="Seobryn Music"

OUT_DIR="$(dirname "$OUTPUT")"
mkdir -p "$OUT_DIR"

# Build metadata args. Skip the track frame if empty (used by Sin Album tracks
# which have no track number per AGENTS.md §6).
TAG_ARGS=(
  -metadata title="$TITLE"
  -metadata artist="$ARTIST"
  -metadata album="$ALBUM"
  -metadata date="$YEAR"
  -metadata genre="$GENRE"
  -metadata encoded_by="$ARTIST"
  -metadata comment="Instrumental, no vocals"
)
if [ -n "$TRACK" ]; then
  TAG_ARGS=( -metadata track="$TRACK" "${TAG_ARGS[@]}" )
fi

# ─── Paso 1: ffmpeg ─────────────────────────────────────────────────────────
# Strip ALL metadata with -map_metadata -1, write our tags.
# -c:a copy preserva el bitstream (no re-encode).
# -write_id3v2 1 + -id3v2_version 3 asegura tags ID3v2.3 limpios.
# -vn descarta cualquier stream de video (defensivo).
ffmpeg -y -hide_banner -loglevel error \
  -i "$INPUT" \
  -vn \
  -c:a copy \
  -map_metadata -1 \
  "${TAG_ARGS[@]}" \
  -write_id3v2 1 \
  -id3v2_version 3 \
  "$OUTPUT"

# ─── Paso 2: eyeD3 — elimina el frame TSSE ──────────────────────────────────
# TSSE = "Software/Hardware used for encoding" — ffmpeg lo escribe con
# "Lavf<version>". Sin este paso, los tags delatan la versión de ffmpeg.
# -Q silencia stdout; los demás tags nuestros se preservan intactos.
eyeD3 -Q --remove-frame TSSE "$OUTPUT" >/dev/null

# ─── Paso 3: strip LAME/Lavf encoder tag del header Xing VBR ────────────────
# El header Xing (al inicio del audio data) tiene una extensión LAME con un
# campo de 9 bytes tipo "Lavf60.16.100" o "LAME3.100". NO está en los tags
# ID3 — está en el bitstream del MP3. Algunos players lo exponen como
# "Where from" o similar. Lo blanqueamos a 9 espacios.
python3 "$SCRIPT_DIR/strip-xing-encoder.py" "$OUTPUT" >/dev/null

# ─── Paso 4: auditoría final integral ───────────────────────────────────────
# Comprueba dos cosas: (a) tags ID3, (b) bytes crudos del archivo.
# (a) Tags ID3: ni "suno", "AI", "encoder", "Lavf", "ffmpeg", etc.
# (b) Raw bytes: ni "Lavf" ni "LAME" en ningún punto del archivo.
ID3_LEAKS=$(ffprobe -v error -show_entries format_tags -of default=noprint_wrappers=1 "$OUTPUT" 2>&1 \
  | grep -iE "suno|ai[^a-z]|artificial|generated|encoder|lavf|ffmpeg|libav|tsse" || true)
RAW_LEAKS=$(python3 -c "
import sys
with open(sys.argv[1], 'rb') as f:
    data = f.read()
for needle in (b'Lavf', b'LAME', b'libav'):
    if needle in data:
        print(f'RAW_LEAK: {needle.decode()}')
        sys.exit(0)
sys.exit(0)
" "$OUTPUT" 2>&1 || true)

if [ -n "$ID3_LEAKS" ] || [ -n "$RAW_LEAKS" ]; then
  echo "✗ Auditoría final: rastro de AI/Suno/encoder detectado." >&2
  [ -n "$ID3_LEAKS" ]  && echo "  ID3 tags:" >&2 && echo "$ID3_LEAKS" >&2
  [ -n "$RAW_LEAKS" ]  && echo "  Raw bytes:" >&2 && echo "$RAW_LEAKS" >&2
  exit 2
fi

echo "✓ $OUTPUT (auditado: sin rastros de AI/Suno/encoders, ID3 + raw bytes)"
