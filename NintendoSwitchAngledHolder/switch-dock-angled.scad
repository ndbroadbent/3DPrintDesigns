include <threads.scad>;

$fn = $preview ? 25 : 100;
EPSILON = 0.01;

// This is a dock holder that angles the dock at 40 degrees
// so that the switch is easier to remove from the dock
// in our entertainment unit.

// Nintendo Switch Dock - OLED
// https://dimensiva.com/3dmodels/nintendo-switch-oled-dock-by-nintendo/

// Dimensions of the dock: H 10 x L 17 x D 5 cm

DOCK_HEIGHT = 100;
DOCK_LENGTH = 170;
DOCK_DEPTH = 50;
DOCK_ANGLE = 40;

MARGIN = 0.5;

BASE_DEPTH = 90;
BASE_HEIGHT = 50;
BASE_LENGTH = DOCK_LENGTH - 50;

difference() {
  translate([ 0, 8, BASE_HEIGHT / 2 ])
      cube(size = [ BASE_LENGTH, BASE_DEPTH, BASE_HEIGHT ], center = true);
  translate([ 0, 0, 12 ]) rotate([ DOCK_ANGLE, 0, 0 ])
      translate([ 0, DOCK_DEPTH / 2, DOCK_HEIGHT / 2 ]) cube(
          size =
              [
                DOCK_LENGTH + MARGIN, DOCK_DEPTH + MARGIN, DOCK_HEIGHT + MARGIN
              ],
          center = true);

  translate([ 0, -21, 13 ]) rotate([ 0, 90, 0 ]) rotate([ 0, 0, 30 ])
      cylinder(h = DOCK_LENGTH + EPSILON, r = 9, center = true);
  translate([ 0, 34, 16 ]) rotate([ 0, 90, 0 ]) rotate([ 0, 0, 30 ])
      cylinder(h = DOCK_LENGTH + EPSILON, r = 12, center = true);

  for (i = [ -0.45, 0, 0.45 ]) {
    translate([ i * (DOCK_LENGTH / 2), 30, BASE_HEIGHT / 2 + 3 ])
        rotate([ 90, 0, 0 ]) cylinder(h = 60 + EPSILON, r = 11, center = true);
  }
}

// for (i = [ -0.45, 0, 0.45 ]) {
//   translate([ i * (DOCK_LENGTH / 2), 0, BASE_HEIGHT / 2 ]) rotate([ 90, 0, 0
//   ])
//       cylinder(h = DOCK_LENGTH + EPSILON, r = 12, center = true);
// }
