include <base.scad>;

ADAPTER_THICKNESS = 1.5;

// VACUUM_ADAPTER_BASE_DIAMETER = 46.2;
// VACUUM_ADAPTER_TIP_DIAMETER = 44.6;

VACUUM_ADAPTER_INNER_BOTTOM_DIAMETER = 45.6;
VACUUM_ADAPTER_OUTER_BOTTOM_DIAMETER =
    VACUUM_ADAPTER_INNER_BOTTOM_DIAMETER + ADAPTER_THICKNESS * 2;

VACUUM_ADAPTER_INNER_TOP_DIAMETER = 45.2;
VACUUM_ADAPTER_OUTER_TOP_DIAMETER =
    VACUUM_ADAPTER_INNER_TOP_DIAMETER + ADAPTER_THICKNESS * 2;

VACUUM_ADAPTER_LENGTH = 60;
VACUUM_ADAPTER_THICKNESS = 2.75;

MIDDLE_HEIGHT = 25;

ADAPTER_GROOVE_HEIGHT = 4;
ADAPTER_GROOVE_RING_HEIGHT = 3;
ADAPTER_GROOVE_DIAMETER = 38.3 + 4;

ADAPTER_LENGTH = 13.2;
ADAPTER_TIP_INNER_DIAMETER = 39.4 + 3;
ADAPTER_BASE_INNER_DIAMETER = 42 + 3;

ADAPTER_GROOVE_RING_DIAMETER =
    ADAPTER_BASE_INNER_DIAMETER - ADAPTER_GROOVE_DIAMETER;

ADAPTER_BASE_OUTER_DIAMETER =
    ADAPTER_BASE_INNER_DIAMETER + 2 * ADAPTER_THICKNESS;
ADAPTER_TIP_OUTER_DIAMETER = ADAPTER_TIP_INNER_DIAMETER + 2 * ADAPTER_THICKNESS;

difference() {
  union() {
    // threaded_tube(d = OUTER_DIAMETER_50MM, pitch = PITCH_50MM,
    //               h = VACUUM_ADAPTER_LENGTH);

    // tube(h = VACUUM_ADAPTER_LENGTH, thickness = ADAPTER_THICKNESS,
    //      d1 = VACUUM_ADAPTER_OUTER_BOTTOM_DIAMETER,
    //      d2 = VACUUM_ADAPTER_OUTER_TOP_DIAMETER);

    move_up(VACUUM_ADAPTER_LENGTH) difference() {
      cylinder(h = MIDDLE_HEIGHT, r1 = VACUUM_ADAPTER_OUTER_TOP_DIAMETER / 2,
               r2 = ADAPTER_BASE_OUTER_DIAMETER / 2);
      translate([ 0, 0, -EPSILON / 2 ]) {
        cylinder(h = MIDDLE_HEIGHT + EPSILON,
                 r1 = VACUUM_ADAPTER_INNER_TOP_DIAMETER / 2,
                 r2 = ADAPTER_BASE_INNER_DIAMETER / 2);
      }
    }

    move_up(VACUUM_ADAPTER_LENGTH + MIDDLE_HEIGHT) {
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

    move_up(VACUUM_ADAPTER_LENGTH + MIDDLE_HEIGHT + ADAPTER_GROOVE_HEIGHT)
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

  // Slot
  slot_radius = 5;
  slot_z_offset = 8;
  union() {
    // bottom circle
    translate([
      0, -ADAPTER_BASE_OUTER_DIAMETER / 3,
      VACUUM_ADAPTER_LENGTH + ADAPTER_GROOVE_HEIGHT +
      slot_z_offset
    ]) rotate([ 90, 0, 0 ])
        cylinder(h = ADAPTER_BASE_OUTER_DIAMETER / 4, r = slot_radius);
    // Slot
    translate([
      0, -ADAPTER_BASE_OUTER_DIAMETER / 2,
      VACUUM_ADAPTER_LENGTH + MIDDLE_HEIGHT + ADAPTER_GROOVE_HEIGHT +
          ADAPTER_LENGTH / 2 +
      slot_z_offset
    ]) {
      cube(
          [
            slot_radius * 2, ADAPTER_BASE_OUTER_DIAMETER / 3,
            (VACUUM_ADAPTER_LENGTH + MIDDLE_HEIGHT * 3 + ADAPTER_GROOVE_HEIGHT +
             ADAPTER_LENGTH) -
                (VACUUM_ADAPTER_LENGTH + MIDDLE_HEIGHT + ADAPTER_GROOVE_HEIGHT)
          ],
          center = true);
    }
  }
}
