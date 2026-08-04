#!/usr/bin/env bash
# clean-mp3.sh — Limpia y taggea MP3 con la metadata de Seobryn Music.
#
# Workflow: cuando el autor trae un nuevo MP3 (de Suno o DAW), este script:
#   1. Elimina TODA la metadata existente (ID3v1/v2, comentarios, lyrics, etc.)
#   2. Escribe metadata propia limpia (artist, album, track, date, etc.)
#   3. Copia el stream de audio sin re-encodear (-c:a copy) — sin pérdida de calidad
#   4. Elimina el frame TSSE que ffmpeg añade automáticamente (revela versión de la
#      herramienta — relevante para no dejar rastro de AI/Suno)
#   5. Verifica que ningún tag final contenga referencias a AI/Suno/encoders
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

# Buscar eyeD3 en ubicaciones comunes de pip3 --user (no siempre está en PATH).
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

if [ ! -f "$1" ]; then
  echo "✗ Archivo de entrada no existe: $1" >&2
  exit 1
fi

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

# Paso 1: ffmpeg — strip ALL metadata with -map_metadata -1, write our tags.
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

# Paso 2: eyeD3 elimina el frame TSSE (encoder=Lavf<version>) que ffmpeg añade
# automáticamente. Sin este paso, los tags delatan la versión de ffmpeg usada.
# -Q silencia stdout; los demás tags nuestros se preservan intactos.
eyeD3 -Q --remove-frame TSSE "$OUTPUT" >/dev/null

# Paso 3: verificación final — auditar que no quedó ningún rastro de AI/Suno/encoder.
LEAKS=$(ffprobe -v error -show_entries format_tags -of default=noprint_wrappers=1 "$OUTPUT" 2>&1 \
  | grep -iE "suno|ai[^a-z]|artificial|generated|encoder|lavf|ffmpeg|libav|tsse" || true)
if [ -n "$LEAKS" ]; then
  echo "✗ Auditoría final: tags con posibles rastros encontrados:" >&2
  echo "$LEAKS" >&2
  exit 2
fi

echo "✓ $OUTPUT (auditado: sin rastros de AI/Suno/encoders)"
