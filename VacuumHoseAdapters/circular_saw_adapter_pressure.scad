include <base.scad>;

ADAPTER_THICKNESS = 2;

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

MIDDLE_HEIGHT = 15;

ADAPTER_GROOVE_HEIGHT = 3;
ADAPTER_GROOVE_RING_HEIGHT = 2;
ADAPTER_GROOVE_DIAMETER = 38.3 + 4;

ADAPTER_LENGTH = 23;
ADAPTER_TIP_INNER_DIAMETER = 39.4 + 4;
ADAPTER_TIP_OUTER_DIAMETER = ADAPTER_TIP_INNER_DIAMETER + 2 * ADAPTER_THICKNESS;

ADAPTER_BASE_INNER_DIAMETER = 42 + 3;

ADAPTER_GROOVE_RING_DIAMETER =
    ADAPTER_BASE_INNER_DIAMETER - ADAPTER_GROOVE_DIAMETER;

ADAPTER_BASE_OUTER_DIAMETER =
    ADAPTER_BASE_INNER_DIAMETER + 2 * ADAPTER_THICKNESS;

difference() {
  union() {
    move_up(VACUUM_ADAPTER_LENGTH) {
      move_up(MIDDLE_HEIGHT) {
        move_up(ADAPTER_LENGTH) {
          difference() {
            cylinder(h = ADAPTER_GROOVE_RING_HEIGHT,
                     r = ADAPTER_TIP_OUTER_DIAMETER / 2 + 2);
            translate([ 0, 0, -EPSILON / 2 ]) {
              cylinder(h = ADAPTER_LENGTH,
                       r = ADAPTER_TIP_INNER_DIAMETER / 2 - 2);
            }
          }
        }

        difference() {
          cylinder(h = ADAPTER_LENGTH, r = ADAPTER_TIP_OUTER_DIAMETER / 2);
          translate([ 0, 0, -EPSILON / 2 ]) {
            cylinder(h = ADAPTER_LENGTH + EPSILON,
                     r = ADAPTER_TIP_INNER_DIAMETER / 2);
          }
        }
      }
      difference() {
        cylinder(h = MIDDLE_HEIGHT, r1 = VACUUM_ADAPTER_OUTER_TOP_DIAMETER / 2,
                 r2 = ADAPTER_TIP_OUTER_DIAMETER / 2);
        translate([ 0, 0, -EPSILON / 2 ]) {
          cylinder(
              h = MIDDLE_HEIGHT + EPSILON,
              r1 = VACUUM_ADAPTER_OUTER_TOP_DIAMETER / 2 - ADAPTER_THICKNESS,
              r2 = ADAPTER_TIP_INNER_DIAMETER / 2);
        }
      }
    }

    // threaded_tube(d = OUTER_DIAMETER_50MM, pitch = PITCH_50MM,
    //               h = VACUUM_ADAPTER_LENGTH);

    tube(h = VACUUM_ADAPTER_LENGTH, thickness = ADAPTER_THICKNESS,
         d1 = VACUUM_ADAPTER_OUTER_BOTTOM_DIAMETER,
         d2 = VACUUM_ADAPTER_OUTER_TOP_DIAMETER);
  }

  // Slot
  slot_radius = 8;
  slot_z_offset = 8;
  union() {
    move_up(VACUUM_ADAPTER_LENGTH + MIDDLE_HEIGHT + slot_radius) {
      for (deg = [ 0, 120, 240 ]) {
        rotate([ 0, 0, deg ]) {
          // bottom circle
          rotate([ 90, 0, 0 ])
              cylinder(h = ADAPTER_BASE_OUTER_DIAMETER, r = slot_radius);

          translate([ 0, -ADAPTER_BASE_OUTER_DIAMETER / 2, 0 ]) {
            move_up((ADAPTER_LENGTH + ADAPTER_GROOVE_RING_HEIGHT) / 2) {
              cube(
                  [
                    slot_radius * 2, ADAPTER_BASE_OUTER_DIAMETER,
                    ADAPTER_LENGTH +
                    ADAPTER_GROOVE_RING_HEIGHT
                  ],
                  center = true);
            }
          }
        }
      }
    }
  }
}

// slot_radius = 8;
// slot_z_offset = 8;
// union() {
//   move_up(VACUUM_ADAPTER_LENGTH + MIDDLE_HEIGHT + slot_radius) {
//     for (deg = [ 0, 120, 240 ]) {
//       rotate([ 0, 0, deg ]) {
//         // bottom circle
//         rotate([ 90, 0, 0 ])
//             cylinder(h = ADAPTER_BASE_OUTER_DIAMETER, r = slot_radius);

//         translate([ 0, -ADAPTER_BASE_OUTER_DIAMETER / 2, 0 ]) {
//           move_up((ADAPTER_LENGTH + ADAPTER_GROOVE_RING_HEIGHT) / 2) {
//             cube(
//                 [
//                   slot_radius * 2, ADAPTER_BASE_OUTER_DIAMETER,
//                   ADAPTER_LENGTH + ADAPTER_GROOVE_RING_HEIGHT
//                 ],
//                 center = true);
//           }
//         }
//       }
//     }
//   }
// }
