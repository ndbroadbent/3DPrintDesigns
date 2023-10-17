include <threads.scad>;

$fn = $preview ? 25 : 100;
EPSILON = 0.01;

// A simple disc to hold the glass dome pendant lights

DISC_HEIGHT = 2;
DISC_DIAMETER = 64;
DISC_HOLE_DIAMETER = 29;
TOP_RING_DIAMETER = 42;
TOP_RING_HEIGHT = 7;
TOP_RING_WIDTH = 1.2;

TOTAL_HEIGHT = DISC_HEIGHT + TOP_RING_HEIGHT;

difference() {
  union() {
    cylinder(h = DISC_HEIGHT, r = DISC_DIAMETER / 2, center = true);
    difference() {
      translate([ 0, 0, (DISC_HEIGHT + TOP_RING_HEIGHT) / 2 ]) cylinder(
          h = TOP_RING_HEIGHT, r = TOP_RING_DIAMETER / 2, center = true);
      translate([ 0, 0, (DISC_HEIGHT + TOP_RING_HEIGHT) / 2 ]) cylinder(
          h = TOP_RING_HEIGHT + EPSILON,
          r = TOP_RING_DIAMETER / 2 - (TOP_RING_WIDTH * 2), center = true);
    }
  }
  cylinder(h = TOTAL_HEIGHT * 2, r = DISC_HOLE_DIAMETER / 2, center = true);
}
