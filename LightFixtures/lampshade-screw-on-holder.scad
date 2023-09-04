include <threads.scad>;

$fn = $preview ? 25 : 100;
EPSILON = 0.01;

// This model is a replacement lampshade holder. It is a conical shape that
// screws onto the thread of the lightbulb holder, and holds the lampshade in
// place.

TOTAL_HEIGHT = 35;
TOP_RING_HEIGHT = 5;
CONE_HEIGHT = TOTAL_HEIGHT - TOP_RING_HEIGHT;

TOP_OUTER_DIAMETER = 34;
BOTTOM_OUTER_DIAMETER = 39;
BOTTOM_WALL_THICKNESS = 1.8;
TOP_WALL_THICKNESS = 3.3;
TOP_INNER_DIAMETER = TOP_OUTER_DIAMETER - (TOP_WALL_THICKNESS * 2);
BOTTOM_INNER_DIAMETER = BOTTOM_OUTER_DIAMETER - (BOTTOM_WALL_THICKNESS * 2);

SCREW_HOLE_HEIGHT = 4;
// SCREW_HOLE_HEIGHT = 10;
SCREW_HOLE_OFFSET = 0.4;
SCREW_HOLE_PITCH = 1.4;
SCREW_HOLE_TOOTH_HEIGHT = 1.1;

ScrewHole(TOP_INNER_DIAMETER, TOP_RING_HEIGHT + 3,
          position = [ 0, 0, (TOTAL_HEIGHT - TOP_RING_HEIGHT) / 2 - 2 ],
          rotation = [ 0, 0, 0 ],
          pitch = is_undef(SCREW_HOLE_PITCH) ? 1.3 : SCREW_HOLE_PITCH,
          tooth_angle = 30, tolerance = 1,
          tooth_height = SCREW_HOLE_TOOTH_HEIGHT) {
  difference() {
    union() {
      translate([ 0, 0, TOTAL_HEIGHT / 2 ]) cylinder(
          h = TOP_RING_HEIGHT, r = TOP_OUTER_DIAMETER / 2, center = true);
      cylinder(h = CONE_HEIGHT, r1 = BOTTOM_OUTER_DIAMETER / 2,
               r2 = TOP_OUTER_DIAMETER / 2, center = true);
    }

    union() {
      translate([ 0, 0, TOTAL_HEIGHT / 2 ])
          cylinder(h = TOP_RING_HEIGHT + EPSILON, r = TOP_INNER_DIAMETER / 2,
                   center = true);
      cylinder(h = CONE_HEIGHT + EPSILON, r1 = BOTTOM_INNER_DIAMETER / 2,
               r2 = TOP_INNER_DIAMETER / 2 + 0.8, center = true);
    }
  }
}
