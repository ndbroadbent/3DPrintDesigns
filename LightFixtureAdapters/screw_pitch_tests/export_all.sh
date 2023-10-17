#!/bin/bash
set -euo pipefail

OPENSCAD_BIN="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"

for PITCH in $(seq 2.1 0.1 2.5 | xargs printf "%0.1f\n"); do
  echo "=> Rendering screw_thread_${PITCH}.stl..."
  $OPENSCAD_BIN \
    -D "SCREW_HOLE_PITCH=${PITCH}" \
    --render \
    -o "./screw_thread_${PITCH}.stl" \
    screw_pitch_tests.scad
 done
