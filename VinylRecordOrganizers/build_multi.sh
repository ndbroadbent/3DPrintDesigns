#!/bin/bash
set -euo pipefail

OPENSCAD_BIN="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"

BUILD_DIR="build_multi"

LETTER_GROUPS=(
  "A-C"
  "D-E"
  "F-H"
  "I-L"
  "M-O"
  "P-R"
  "S-T"
  "U-Z"
)

for GROUP in "${LETTER_GROUPS[@]}"; do
  FILENAME="${GROUP}.stl"
  if [ -f "./$BUILD_DIR/${FILENAME}" ]; then
    echo "=> $FILENAME already exists..."
    continue
  fi
  echo "=> Rendering $FILENAME..."
  # set -x
  $OPENSCAD_BIN \
    -D "chars=\"${GROUP}\"" \
    --render \
    -o "./$BUILD_DIR/${FILENAME}" \
    organizer.scad
 done
