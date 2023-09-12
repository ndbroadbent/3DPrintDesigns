include <base.scad>;

SCREW_THREAD_LENGTH = 50;
MIDDLE_HEIGHT = 20;

ADAPTER_GROOVE_HEIGHT = 4;
ADAPTER_GROOVE_RING_HEIGHT = 3;
ADAPTER_GROOVE_DIAMETER = 38.6;

ADAPTER_LENGTH = 13.2;
ADAPTER_TIP_INNER_DIAMETER = 39.4;
ADAPTER_BASE_INNER_DIAMETER = 42;
ADAPTER_THICKNESS = 2.75;

ADAPTER_GROOVE_RING_DIAMETER =
    ADAPTER_BASE_INNER_DIAMETER - ADAPTER_GROOVE_DIAMETER;

ADAPTER_BASE_OUTER_DIAMETER =
    ADAPTER_BASE_INNER_DIAMETER + 2 * ADAPTER_THICKNESS;
ADAPTER_TIP_OUTER_DIAMETER = ADAPTER_TIP_INNER_DIAMETER + 2 * ADAPTER_THICKNESS;

difference() {
  union() {
    threaded_tube(d = OUTER_DIAMETER_50MM, pitch = PITCH_50MM,
                  h = SCREW_THREAD_LENGTH);

    move_up(SCREW_THREAD_LENGTH) difference() {
      cylinder(h = MIDDLE_HEIGHT, r1 = OUTER_DIAMETER_50MM / 2 + WALL_THICKNESS,
               r2 = ADAPTER_BASE_OUTER_DIAMETER / 2);
      translate([ 0, 0, -EPSILON / 2 ]) {
        cylinder(h = MIDDLE_HEIGHT + EPSILON, r1 = OUTER_DIAMETER_50MM / 2,
                 r2 = ADAPTER_BASE_INNER_DIAMETER / 2);
      }
    }

    move_up(SCREW_THREAD_LENGTH + MIDDLE_HEIGHT) {
      translate([ 0, 0, ADAPTER_GROOVE_RING_DIAMETER / 2 ]) rotate_extrude()
          translate([
            ADAPTER_GROOVE_DIAMETER / 2 + ADAPTER_GROOVE_RING_DIAMETER / 2, 0, 0
          ]) circle(r = ADAPTER_GROOVE_RING_DIAMETER / 2);

      // Groove
      difference() {
        cylinder(h = ADAPTER_GROOVE_HEIGHT,
                 r = ADAPTER_BASE_OUTER_DIAMETER / 2);
        translate([ 0, 0, -EPSILON / 2 ]) {
          cylinder(h = ADAPTER_GROOVE_HEIGHT + EPSILON,
                   r = ADAPTER_GROOVE_DIAMETER / 2 +
                       ADAPTER_GROOVE_RING_DIAMETER / 2);
        }
      }
    }

    move_up(SCREW_THREAD_LENGTH + MIDDLE_HEIGHT + ADAPTER_GROOVE_HEIGHT)
        difference() {
      cylinder(h = ADAPTER_LENGTH, r1 = ADAPTER_BASE_OUTER_DIAMETER / 2,
               r2 = ADAPTER_TIP_OUTER_DIAMETER / 2);
      translate([ 0, 0, -EPSILON / 2 ]) {
        cylinder(h = ADAPTER_LENGTH + EPSILON,
                 r1 = ADAPTER_BASE_INNER_DIAMETER / 2,
                 r2 = ADAPTER_TIP_INNER_DIAMETER / 2);
      }
    }
  }

  translate([
    0, -ADAPTER_BASE_OUTER_DIAMETER / 3,
    SCREW_THREAD_LENGTH + MIDDLE_HEIGHT + ADAPTER_GROOVE_HEIGHT - 1 - 2
  ]) rotate([ 90, 0, 0 ]) cylinder(h = ADAPTER_BASE_OUTER_DIAMETER / 4, r = 3);

  translate([
    0, -ADAPTER_BASE_OUTER_DIAMETER / 2,
    SCREW_THREAD_LENGTH + MIDDLE_HEIGHT + ADAPTER_GROOVE_HEIGHT +
        ADAPTER_LENGTH / 2
  ])
      cube(
          [
            3 * 2, ADAPTER_BASE_OUTER_DIAMETER / 3,
            (SCREW_THREAD_LENGTH + MIDDLE_HEIGHT + ADAPTER_GROOVE_HEIGHT +
             ADAPTER_LENGTH) -
                (SCREW_THREAD_LENGTH + MIDDLE_HEIGHT + ADAPTER_GROOVE_HEIGHT -
                 5)
          ],
          center = true);
}
