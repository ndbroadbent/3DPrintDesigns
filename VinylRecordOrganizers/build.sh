#!/bin/bash
set -euo pipefail

OPENSCAD_BIN="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"

for LETTER in $(echo {A..Z}); do
  FILENAME="organizer_${LETTER}.stl"
  if [ -f "./build/${FILENAME}" ]; then
    echo "=> $FILENAME already exists..."
    continue
  fi
  echo "=> Rendering $FILENAME..."
  # set -x
  $OPENSCAD_BIN \
    -D "letter=\"${LETTER}\"" \
    --render \
    -o "./build/${FILENAME}" \
    organizer.scad
 done
