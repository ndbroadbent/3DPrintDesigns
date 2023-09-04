include <threads.scad>;

$fn = $preview ? 25 : 100;
EPSILON = 0.01;

// A simple disc to hold the glass dome pendant lights

DISC_HEIGHT = 3;
DISC_DIAMETER = 64;
DISC_HOLE_DIAMETER = 28.2;

difference() {
  cylinder(h = DISC_HEIGHT, r = DISC_DIAMETER / 2, center = true);
  cylinder(h = DISC_HEIGHT + EPSILON, r = DISC_HOLE_DIAMETER / 2,
           center = true);
}
