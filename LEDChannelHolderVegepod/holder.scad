$fn = $preview ? 25 : 150;
EPSILON = 0.01;
TOLERANCE = 0.3;

CHANNEL_WIDTH = 14;
CHANNEL_HEIGHT = 7;
BRACKET_LENGTH = 21.5;

THICKNESS = 2.5;

RING_OFFSET = 13.8;
RING_ANGLE = 0;

difference() {
  union() {
    difference() {
      cube(
          [
            CHANNEL_WIDTH + THICKNESS * 2, BRACKET_LENGTH, CHANNEL_HEIGHT +
            THICKNESS
          ],
          center = true);

      translate([ 0, 0, THICKNESS / 2 ]) cube(
          [
            CHANNEL_WIDTH + TOLERANCE, BRACKET_LENGTH + 10, CHANNEL_HEIGHT +
            EPSILON
          ],
          center = true);
    }
    for (a = [ -1, +1 ])
      translate([ CHANNEL_WIDTH / 2 * a, 0, THICKNESS / 2 ])
          cube([ 0.4, BRACKET_LENGTH, 0.4 ], center = true);
  }

  translate([ 0, 0, THICKNESS / 2 ]) rotate([ 0, 90, 0 ])
      cylinder(h = CHANNEL_WIDTH * 2, r = 1.5 / 2, center = true);

  rotate([ RING_ANGLE, 0, 90 ]) translate([ 0, 0, -RING_OFFSET ]) {
    ring_hollow();
  }
}

module ring_hollow() {
  rotate([ 90, 0, 0 ])
      cylinder(r = (16 + 0.4) / 2, h = 30, center = true, $fn = 60);
}

module ring() {
  rotate([ RING_ANGLE, 0, 90 ]) translate([ 0, 0, -RING_OFFSET ]) {
    difference() {
      rotate([ 90, 0, 0 ])
          cylinder(r = 21.5 / 2, h = 9.2, center = true, $fn = 60);
      ring_hollow();
      translate([ 0, 0, -RING_OFFSET ]) rotate(45)
          cylinder(h = 20, r1 = 22, r2 = 5, center = true, $fn = 4);
    }
  }
}

ring();
