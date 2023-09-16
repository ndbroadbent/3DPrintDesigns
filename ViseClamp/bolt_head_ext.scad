use <../lib/threads.scad>;

$fn = $preview ? 15 : 100;
EPSILON = 0.01;
TOLERANCE = 0.5;

// Convert from flat-to-flat to point-to-point diameter
HEX_FACTOR = 1.155;

BOLT_HEAD_HEIGHT = 7.5;
BOLT_HEAD_DIAMETER = 18.8;
BOLT_THREAD_DIAMETER = 11.8;
BOLT_HEIGHT = 42.6;

HEAD_EXT_WIDTH = 24.5;
HEAD_EXT_HEIGHT = 5;

module bolt() {
  color([ 242 / 255, 168 / 255, 48 / 255 ]) {
    translate([ 0, 0, -BOLT_HEAD_HEIGHT / 2 ]) {
      cylinder(h = BOLT_HEAD_HEIGHT, r = (BOLT_HEAD_DIAMETER * HEX_FACTOR) / 2,
               $fn = 6);
      // cube([ BOLT_HEAD_DIAMETER, BOLT_HEAD_DIAMETER, 1 ], center = true);
      cylinder(h = BOLT_HEIGHT, r = BOLT_THREAD_DIAMETER / 2);
    }
  }
}

module head_extension() {
  difference() {
    cylinder(r = (HEAD_EXT_WIDTH / 2 * HEX_FACTOR) - TOLERANCE,
             h = HEAD_EXT_HEIGHT, $fn = 6);

    // Can't use a thread here since the head needs to be pushed all the way
    // into the hole. Use superglue instead.
    // translate([ 0, 0, -EPSILON / 2 ]) metric_thread(
    //     diameter = 12, pitch = 1.75, length = HEAD_EXT_HEIGHT * 2);

    cylinder(h = HEAD_EXT_HEIGHT + EPSILON,
             r = BOLT_THREAD_DIAMETER / 2 + TOLERANCE / 2);

    translate([ 0, 0, -EPSILON ]) cylinder(
        h = HEAD_EXT_HEIGHT * 0.75,
        r = (BOLT_HEAD_DIAMETER / 2 * HEX_FACTOR) + TOLERANCE / 2, $fn = 6);
  }
}

module head_extension_nut() {
  difference() {
    cylinder(r = (BOLT_HEAD_DIAMETER / 2 * HEX_FACTOR) - TOLERANCE - 1,
             h = 3.5 + 3, $fn = 6);

    translate([ 0, 0, -EPSILON / 2 ]) metric_thread(
        diameter = 12 + 0.4, pitch = 1.75, length = HEAD_EXT_HEIGHT * 2);
  }
}

// head_extension();
head_extension_nut();
// bolt();
