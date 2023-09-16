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
    translate([ 0, 0, -EPSILON / 2 ])
        cylinder(h = HEAD_EXT_HEIGHT + EPSILON,
                 r = BOLT_THREAD_DIAMETER / 2 + TOLERANCE / 2);

    translate([ 0, 0, -EPSILON ]) cylinder(
        h = HEAD_EXT_HEIGHT / 2,
        r = (BOLT_HEAD_DIAMETER / 2 * HEX_FACTOR) + TOLERANCE / 2, $fn = 6);
  }
}

module thumb_screw() {
  // translate([ 0, 0, BOLT_HEIGHT - THUMB_SCREW_HEIGHT ]) {
  cylinder([ BOLT_THREAD_DIAMETER / 2, THUMB_SCREW_HEIGHT ], $fn = 6);
  // }
}

head_extension();
// bolt();
