use <../lib/threads.scad>;

$fn = $preview ? 10 : 100;
EPSILON = 0.01;

WALL_THICKNESS = 3.5;

INNER_DIAMETER_40MM = 40;
OUTER_DIAMETER_40MM = 48 + 1;
PITCH_40MM = 5.75;  // 115mm / 20 teeth
TOOTH_HEIGHT_40MM = PITCH_40MM / 2;

INNER_DIAMETER_50MM = 50;
OUTER_DIAMETER_50MM = 58 + 1;
PITCH_50MM = 6.75;  // 135mm / 20 teeth
TOOTH_HEIGHT_50MM = PITCH_50MM * 0.8;

CONNECTOR_LENGTH = 50;
CONNECTOR_THICKNESS = 2.6;
CONNECTOR_BASE_HEIGHT = 38;

module threaded_tube(h, d, pitch) {
  mirror([ 1, 0, 0 ]) {
    difference() {
      cylinder(h = h, r = d / 2 + WALL_THICKNESS);
      translate([ 0, 0, -EPSILON / 2 ]) metric_thread(
          diameter = d, pitch = pitch, length = h + EPSILON, square = false,
          thread_size = pitch * 1.3, internal = true, angle = 40);
    }
  }
}

module move_up(h) { translate([ 0, 0, h ]) children(); }

module tube(h, thickness, d, d1, d2) {
  _d1 = is_undef(d1) ? d : d1;
  _d2 = is_undef(d2) ? d : d2;

  difference() {
    cylinder(h = h, r1 = _d1 / 2, r2 = _d2 / 2);
    translate([ 0, 0, -EPSILON / 2 ]) cylinder(
        h = h + EPSILON, r1 = _d1 / 2 - thickness, r2 = _d2 / 2 - thickness);
  }
}
