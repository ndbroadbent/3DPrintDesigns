$fn = $preview ? 25 : 100;
EPSILON = 0.01;

HEIGHT = 4;
DISK_RADIUS = 86;
INNER_DIAMETER = 75;

BOLT_HOLE_DIAMETER = 6;
BOLT_HOLE_OFFSET = 10;

OUTER_BOLT_HOLE_OFFSET = 75.5;

difference() {
  cylinder(h = HEIGHT, r = DISK_RADIUS);
  translate([ 0, 0, -EPSILON ])
      cylinder(h = HEIGHT + 2 * EPSILON, r = INNER_DIAMETER / 2);

  for (i = [0:3]) {
    rotate([ 0, 0, i * 90 ])
        translate([ INNER_DIAMETER / 2 + BOLT_HOLE_OFFSET, 0, -EPSILON ])
            cylinder(h = HEIGHT + 2 * EPSILON, r = BOLT_HOLE_DIAMETER / 2);
  }

  for (i = [0:4]) {
    rotate([ 0, 0, i * (360 / 4) + 45 ])
        translate([ OUTER_BOLT_HOLE_OFFSET, 0, -EPSILON ])
            cylinder(h = HEIGHT + 2 * EPSILON, r = BOLT_HOLE_DIAMETER / 2);
  }
}
