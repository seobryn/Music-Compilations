#!/usr/bin/env bash
# clean-mp3.sh — Limpia y taggea MP3 con la metadata de Seobryn Music.
#
# Workflow: cuando el autor trae un nuevo MP3 (de Suno o DAW), este script:
#   1. Elimina TODA la metadata existente (ID3v1/v2, comentarios, lyrics, etc.)
#   2. Escribe metadata propia limpia (artist, album, track, date, etc.)
#   3. Copia el stream de audio sin re-encodear (-c:a copy) — sin pérdida de calidad
#
# Uso:
#   ./scripts/clean-mp3.sh <input> <output> <title> <album> <track> [year] [genre]
#
# Argumentos:
#   input   — archivo mp3 de entrada (ej. cancion_3.mp3)
#   output  — ruta final (ej. "Symphonic Metal/Whispers Before the Storm/3. What the Heart Whispered.mp3")
#   title   — título del track (en inglés)
#   album   — álbum al que pertenece
#   track   — número del track (sin cero-padding, ej. "3" o "3/4")
#   year    — año (opcional, default = año actual)
#   genre   — género (opcional, default = "Instrumental Progressive Metal")
#
# Ejemplo:
#   ./scripts/clean-mp3.sh \
#     "Symphonic Metal/Whispers Before the Storm/cancion_3.mp3" \
#     "Symphonic Metal/Whispers Before the Storm/3. What the Heart Whispered.mp3" \
#     "What the Heart Whispered" \
#     "Whispers Before the Storm" \
#     "3" \
#     "2026" \
#     "Progressive Rock / Folk Metal"

set -euo pipefail

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

if [ ! -f "$1" ]; then
  echo "✗ Archivo de entrada no existe: $1" >&2
  exit 1
fi

INPUT="$1"
OUTPUT="$2"
TITLE="$3"
ALBUM="$4"
TRACK="$5"
YEAR="${6:-$(date +%Y)}"
GENRE="${7:-Instrumental Progressive Metal}"
ARTIST="Seobryn Music"

OUT_DIR="$(dirname "$OUTPUT")"
mkdir -p "$OUT_DIR"

# Strip ALL metadata with -map_metadata -1, then write only the tags we want.
# -c:a copy preserves the audio bitstream (no re-encode).
# -write_id3v2 1 + -id3v2_version 3 ensures clean ID3v2.3 tags.
# -vn drops any video stream (defensive).
ffmpeg -y -hide_banner -loglevel error \
  -i "$INPUT" \
  -vn \
  -c:a copy \
  -map_metadata -1 \
  -metadata title="$TITLE" \
  -metadata artist="$ARTIST" \
  -metadata album="$ALBUM" \
  -metadata track="$TRACK" \
  -metadata date="$YEAR" \
  -metadata genre="$GENRE" \
  -metadata encoded_by="$ARTIST" \
  -metadata comment="Instrumental, no vocals" \
  -write_id3v2 1 \
  -id3v2_version 3 \
  "$OUTPUT"

echo "✓ $OUTPUT"
