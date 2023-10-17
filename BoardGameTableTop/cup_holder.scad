$fn = $preview ? 35 : 100;
EPSILON = 0.01;

INNER_DIAMETER = 86;
INNER_HEIGHT = 55;
THICKNESS = 2.5;
LIP_WIDTH = 8;
BOTTOM_RADIUS = 7;

OUTER_DIAMETER = INNER_DIAMETER + 2 * THICKNESS;  // = 91mm
// OUTER_HEIGHT = INNER_HEIGHT + THICKNESS;

module rounded_cylinder(h, r) {
  cylinder(h = h, r = r - h / 2, center = true);
  rotate_extrude() translate([ r - h / 2, 0, 0 ]) circle(r = h / 2);
}

difference() {
  union() {
    cylinder(h = INNER_HEIGHT, r = OUTER_DIAMETER / 2);
    translate([ 0, 0, THICKNESS / 2 ])
        rounded_cylinder(h = THICKNESS, r = LIP_WIDTH + OUTER_DIAMETER / 2);
    translate([ 0, 0, INNER_HEIGHT + EPSILON ])
        rounded_cylinder(h = BOTTOM_RADIUS, r = OUTER_DIAMETER / 2);
  }

  translate([ 0, 0, -EPSILON / 2 ])
      cylinder(h = INNER_HEIGHT + EPSILON, r = INNER_DIAMETER / 2);

  translate([ 0, 0, INNER_HEIGHT + EPSILON ])
      rounded_cylinder(h = BOTTOM_RADIUS - THICKNESS, r = INNER_DIAMETER / 2);
}
