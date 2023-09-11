include <threads.scad>;
screw_resolution = $preview ? 5 : 0.8;

$fn = $preview ? 15 : 100;
EPSILON = 0.01;

HOSE_1_INNER_DIAMETER = 40;
HOSE_1_OUTER_DIAMETER = 48;

HOSE_2_INNER_DIAMETER = 50;
HOSE_2_OUTER_DIAMETER = 58;

CONNECTOR_LENGTH = 50;
CONNECTOR_THICKNESS = 2.6;
CONNECTOR_BASE_HEIGHT = 38;
CONNECTOR_BASE_THICKNESS = 3.3;

ADAPTER_MIDDLE_HEIGHT = 10;

ScrewHole(HOSE_1_INNER_DIAMETER, CONNECTOR_LENGTH, pitch = 4, tooth_angle = 24,
          tolerance = 1, tooth_height = 3) {
  cylinder(h = CONNECTOR_LENGTH, r = HOSE_1_OUTER_DIAMETER / 2);
}

translate([ 0, 0, CONNECTOR_LENGTH ]) {
  difference() {
    cylinder(h = ADAPTER_MIDDLE_HEIGHT, r1 = HOSE_1_OUTER_DIAMETER / 2,
             r2 = HOSE_2_OUTER_DIAMETER / 2);
    translate([ 0, 0, -EPSILON / 2 ]) {
      cylinder(h = ADAPTER_MIDDLE_HEIGHT + EPSILON,
               r1 = HOSE_1_OUTER_DIAMETER / 2 - CONNECTOR_BASE_THICKNESS,
               r2 = HOSE_2_OUTER_DIAMETER / 2 - CONNECTOR_BASE_THICKNESS);
    }
  }
}

translate([ 0, 0, CONNECTOR_LENGTH + ADAPTER_MIDDLE_HEIGHT ]) {
  ScrewHole(HOSE_2_INNER_DIAMETER, CONNECTOR_LENGTH, pitch = 4,
            tooth_angle = 24, tolerance = 1, tooth_height = 3) {
    cylinder(h = CONNECTOR_LENGTH, r = HOSE_2_OUTER_DIAMETER / 2);
  }
}

// 40mm test
// ScrewHole(HOSE_1_INNER_DIAMETER, 24, pitch = 4, tooth_angle = 24, tolerance =
// 1,
//           tooth_height = 3) {
//   cylinder(h = 24, r = HOSE_1_OUTER_DIAMETER / 2);
// }

// 50mm test
// ScrewHole(HOSE_2_INNER_DIAMETER, 24, pitch = 4, tooth_angle = 24, tolerance =
// 1,
//           tooth_height = 3) {
//   cylinder(h = 24, r = HOSE_2_OUTER_DIAMETER / 2);
// }
