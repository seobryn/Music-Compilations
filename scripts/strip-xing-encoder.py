#!/usr/bin/env python3
"""Strip all encoder fingerprints from MP3 files.

There are two places where the encoder is identified in an MP3 file:

1. The LAME extension of the Xing header at the start of the audio data.
   Field: 9 bytes, e.g. "Lavf60.16" or "LAME3.100".

2. The LAME Tag at the END of the file (for VBR seek optimization).
   Field: 9 bytes, e.g. "LAME3.100", preceded by 0xFF 0xFF 0xFF 0x42.

There can also be a stray "LAME3.100" embedded in audio data by coincidence
of MP3 bitstream encoding. Replacing any 9-byte sequence that starts with
"LAME" or "Lavf" with 9 spaces is safe: spaces are valid byte values and
won't break file structure (MP3 decoders handle arbitrary bytes in
data segments; worst case is a slight audible artifact indistinguishable
from the original lossy compression).

The audio bitstream length is preserved.
"""
import sys
import re

# 9-byte sequences starting with "LAME" or "Lavf" (case-insensitive),
# followed by 5 characters commonly seen in encoder/version strings
# (digits, dots, spaces, NUL, other punctuation).
PATTERN = re.compile(rb'LAME[0-9.\x00 \t]{5}', re.IGNORECASE)
PATTERN_LAVF = re.compile(rb'Lavf[0-9.\x00 \t]{5}', re.IGNORECASE)

REPLACE = b'         '  # 9 spaces, same length

def strip_encoder(filepath):
    with open(filepath, 'rb') as f:
        data = bytearray(f.read())

    substitutions = 0
    for pattern in (PATTERN, PATTERN_LAVF):
        count_before = sum(1 for _ in pattern.finditer(data))
        new_data = pattern.sub(REPLACE, data)
        substitutions += count_before
        data = new_data

    if substitutions > 0:
        with open(filepath, 'wb') as f:
            f.write(data)

    return substitutions

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: strip-xing-encoder.py <file.mp3> [file2.mp3 ...]", file=sys.stderr)
        sys.exit(1)

    total = 0
    for fp in sys.argv[1:]:
        n = strip_encoder(fp)
        if n > 0:
            print(f"  ✓ Stripped {n} encoder tag(s) in {fp}")
            total += n
        else:
            print(f"  (no encoder tag in {fp})")

    sys.exit(0)
