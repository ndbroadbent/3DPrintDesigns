include <threads.scad>;
screw_resolution = $preview ? 5 : 0.8;

$fn = $preview ? 15 : 100;
EPSILON = 0.01;

BASE_HEIGHT = 10;
BASE_THICKNESS = 3.5;

HOSE_INNER_DIAMETER = 50;
HOSE_OUTER_DIAMETER = 60;
SCREW_THREAD_LENGTH = 50;

MIDDLE_HEIGHT = 10;

ADAPTER_LENGTH = 60;
ADAPTER_BASE_DIAMETER = 46.2;
ADAPTER_TIP_DIAMETER = 44.6;
ADAPTER_THICKNESS = 2.75;

difference() {
  cylinder(h = BASE_HEIGHT, r = HOSE_OUTER_DIAMETER / 2);
  translate([ 0, 0, -EPSILON / 2 ]) cylinder(
      h = BASE_HEIGHT + EPSILON, r = HOSE_OUTER_DIAMETER / 2 - BASE_THICKNESS);
}

translate([ 0, 0, BASE_HEIGHT ])
    ScrewHole(HOSE_INNER_DIAMETER, SCREW_THREAD_LENGTH, pitch = 4,
              tooth_angle = 24, tolerance = 1, tooth_height = 3) {
  cylinder(h = SCREW_THREAD_LENGTH, r = HOSE_OUTER_DIAMETER / 2);
}

translate([ 0, 0, BASE_HEIGHT + SCREW_THREAD_LENGTH ]) difference() {
  cylinder(h = MIDDLE_HEIGHT, r1 = HOSE_OUTER_DIAMETER / 2,
           r2 = ADAPTER_BASE_DIAMETER / 2);
  translate([ 0, 0, -EPSILON / 2 ]) {
    cylinder(h = MIDDLE_HEIGHT + EPSILON,
             r1 = HOSE_OUTER_DIAMETER / 2 - ADAPTER_THICKNESS,
             r2 = ADAPTER_BASE_DIAMETER / 2 - ADAPTER_THICKNESS);
  }
}

translate([ 0, 0, BASE_HEIGHT + SCREW_THREAD_LENGTH + MIDDLE_HEIGHT ])
    difference() {
  cylinder(h = ADAPTER_LENGTH, r1 = ADAPTER_BASE_DIAMETER / 2,
           r2 = ADAPTER_TIP_DIAMETER / 2);
  translate([ 0, 0, -EPSILON / 2 ]) {
    cylinder(h = ADAPTER_LENGTH + EPSILON,
             r1 = ADAPTER_BASE_DIAMETER / 2 - ADAPTER_THICKNESS,
             r2 = ADAPTER_TIP_DIAMETER / 2 - ADAPTER_THICKNESS);
  }
}
