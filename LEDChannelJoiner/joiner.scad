$fn = $preview ? 25 : 150;
EPSILON = 0.01;
TOLERANCE = 0.3;

CHANNEL_WIDTH = 14;
CHANNEL_HEIGHT = 7;
JOINER_LENGTH = 35;

THICKNESS = 2.5;

difference() {
  union() {
    difference() {
      cube(
          [
            CHANNEL_WIDTH + THICKNESS * 2, JOINER_LENGTH, CHANNEL_HEIGHT +
            THICKNESS
          ],
          center = true);

      translate([ 0, 0, THICKNESS / 2 ]) cube(
          [
            CHANNEL_WIDTH + TOLERANCE, JOINER_LENGTH + 10, CHANNEL_HEIGHT +
            EPSILON
          ],
          center = true);
    }
    for (a = [ -1, +1 ])
      translate([ CHANNEL_WIDTH / 2 * a, 0, THICKNESS / 2 ])
          cube([ 0.4, JOINER_LENGTH, 0.4 ], center = true);
  }

  // Holes
  for (a = [ -1, +1 ])
    translate([ 0, a * (JOINER_LENGTH / 4), THICKNESS / 2 ])
        rotate([ 0, 90, 0 ])
            cylinder(h = CHANNEL_WIDTH * 2, r = 1.5 / 2, center = true);
}
