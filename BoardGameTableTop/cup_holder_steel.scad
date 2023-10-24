// Same dimensions as these:

// https://www.jackspoker.com.au/steel-table-cup-holders-pack-of-10

$fn = $preview ? 35 : 100;
EPSILON = 0.01;

INNER_DIAMETER = 86 - 1;
INNER_HEIGHT = 55;
THICKNESS = 3;
LIP_WIDTH = 8;
BOTTOM_RADIUS = 7;

OUTER_DIAMETER = INNER_DIAMETER + 2 * THICKNESS;  // = 91mm
OUTER_HEIGHT = INNER_HEIGHT + THICKNESS;
// RIM_DIAMETER = LIP_WIDTH * 2 + OUTER_DIAMETER;
RIM_DIAMETER = 101;

module rounded_cylinder(h, r) {
  cylinder(h = h, r = r - h / 2, center = true);
  rotate_extrude() translate([ r - h / 2, 0, 0 ]) circle(r = h / 2);
}

difference() {
  union() {
    cylinder(h = INNER_HEIGHT, r = OUTER_DIAMETER / 2);
    translate([ 0, 0, THICKNESS / 2 ])
        rounded_cylinder(h = THICKNESS, r = RIM_DIAMETER / 2);
    translate([ 0, 0, INNER_HEIGHT + EPSILON ])
        rounded_cylinder(h = BOTTOM_RADIUS, r = OUTER_DIAMETER / 2);
  }

  translate([ 0, 0, -EPSILON / 2 ])
      cylinder(h = INNER_HEIGHT + EPSILON, r = INNER_DIAMETER / 2);

  translate([ 0, 0, INNER_HEIGHT + EPSILON ])
      rounded_cylinder(h = BOTTOM_RADIUS - THICKNESS, r = INNER_DIAMETER / 2);

  for (deg = [0:360 / 4:360]) {
    rotate([ 0, 0, deg ]) translate([ 23, 0, 0 ])
        cylinder(h = INNER_HEIGHT * 2, r = 5);
  }
  // for (deg = [0:360 / 5:360]) {
  //   rotate([ 0, 0, deg ]) translate([ 15, 0, 0 ])
  //       cylinder(h = INNER_HEIGHT * 2, r = 3.5);
  // }
  cylinder(h = INNER_HEIGHT * 2, r = 5);
  // translate([ 0, 0, 60 ]) cylinder(h = 5, r = INNER_DIAMETER / 2 - 5);
}
