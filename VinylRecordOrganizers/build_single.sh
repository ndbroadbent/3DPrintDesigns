#!/bin/bash
set -euo pipefail

OPENSCAD_BIN="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"

BUILD_DIR="build_single"

for LETTER in $(echo {A..Z}); do
  FILENAME="organizer_${LETTER}.stl"
  if [ -f "./$BUILD_DIR/${FILENAME}" ]; then
    echo "=> $FILENAME already exists..."
    continue
  fi
  echo "=> Rendering $FILENAME..."
  # set -x
  $OPENSCAD_BIN \
    -D "letter=\"${LETTER}\"" \
    --render \
    -o "./$BUILD_DIR/${FILENAME}" \
    organizer.scad
 done
