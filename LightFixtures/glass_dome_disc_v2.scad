include <threads.scad>;

$fn = $preview ? 25 : 100;
EPSILON = 0.01;

// A simple disc to hold the glass dome pendant lights

DISC_HEIGHT = 3;
DISC_DIAMETER = 64;
DISC_HOLE_DIAMETER = 29;
TOP_DISC_DIAMETER = 42;
TOP_DISC_HEIGHT = 4;

TOTAL_HEIGHT = DISC_HEIGHT + TOP_DISC_HEIGHT;

difference() {
  union() {
    cylinder(h = DISC_HEIGHT, r = DISC_DIAMETER / 2, center = true);
    translate([ 0, 0, DISC_HEIGHT ]) {
      cylinder(h = TOP_DISC_HEIGHT, r = TOP_DISC_DIAMETER / 2, center = true);
    }
  }
  cylinder(h = TOTAL_HEIGHT * 2, r = DISC_HOLE_DIAMETER / 2, center = true);
}
