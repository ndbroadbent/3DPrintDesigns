$fn = $preview ? 15 : 40;
// $fn = 6;
EPSILON = 0.01;
// Fridge holder for scissors

// https://danielupshaw.com/openscad-rounded-corners/
module roundedcube(size = [ 1, 1, 1 ], center = false, radius = 0.5,
                   apply_to = "all") {
  // If single value, convert to [x, y, z] vector
  size = (size[0] == undef) ? [ size, size, size ] : size;

  translate_min = radius;
  translate_xmax = size[0] - radius;
  translate_ymax = size[1] - radius;
  translate_zmax = size[2] - radius;

  diameter = radius * 2;

  obj_translate = (center == false)
                      ? [ 0, 0, 0 ]
                      : [ -(size[0] / 2), -(size[1] / 2), -(size[2] / 2) ];

  translate(v = obj_translate) {
    hull() {
      for (translate_x = [ translate_min, translate_xmax ]) {
        x_at = (translate_x == translate_min) ? "min" : "max";
        for (translate_y = [ translate_min, translate_ymax ]) {
          y_at = (translate_y == translate_min) ? "min" : "max";
          for (translate_z = [ translate_min, translate_zmax ]) {
            z_at = (translate_z == translate_min) ? "min" : "max";

            translate(v =
                          [
                            translate_x, translate_y,
                            translate_z
                          ]) if ((apply_to == "all") ||
                                 (apply_to == "xmin" && x_at == "min") ||
                                 (apply_to == "xmax" && x_at == "max") ||
                                 (apply_to == "ymin" && y_at == "min") ||
                                 (apply_to == "ymax" && y_at == "max") ||
                                 (apply_to == "zmin" && z_at == "min") ||
                                 (apply_to == "zmax" && z_at == "max")) {
              sphere(r = radius);
            }
            else {
              rotate =
                  (apply_to == "xmin" || apply_to == "xmax" || apply_to == "x")
                      ? [ 0, 90, 0 ]
                      : ((apply_to == "ymin" || apply_to == "ymax" ||
                          apply_to == "y")
                             ? [ 90, 90, 0 ]
                             : [ 0, 0, 0 ]);
              rotate(a = rotate)
                  cylinder(h = diameter, r = radius, center = true);
            }
          }
        }
      }
    }
  }
}

BLADE_LENGTH = 106;
BLADE_WIDTH_TOP = 15.06;
BLADE_WIDTH_BOTTOM = 7.14;
// BLADE_THICKNESS_TOP = 3.8;
BLADE_THICKNESS_TOP = 9.3;  // Forgot to include the screw earlier
BLADE_THICKNESS_BOTTOM = 2.4;
HOLDER_SPACING = 1;

MAGNET_HEIGHT = 5.84;
MAGNET_DIAMETER = 7.95;

MIN_HOLDER_WALL_THICKNESS = 2;

HOLDER_WIDTH_TOP =
    (BLADE_WIDTH_TOP + 2 * HOLDER_SPACING + 2 * MIN_HOLDER_WALL_THICKNESS) + 7;
// HOLDER_WIDTH_BOTTOM =
//     (BLADE_WIDTH_BOTTOM + 2 * HOLDER_SPACING + 2 *
//     MIN_HOLDER_WALL_THICKNESS);
HOLDER_LENGTH = BLADE_LENGTH + 10;
HOLDER_THICKNESS = (BLADE_THICKNESS_TOP + 2 * HOLDER_SPACING + MAGNET_HEIGHT +
                    2 * MIN_HOLDER_WALL_THICKNESS);

SCISSORS_SLOT_THICKNESS_TOP = HOLDER_SPACING + BLADE_THICKNESS_TOP;
SCISSORS_SLOT_THICKNESS_BOTTOM = HOLDER_SPACING + BLADE_THICKNESS_BOTTOM;
SCISSORS_SLOT_WIDTH_TOP = 2 * HOLDER_SPACING + BLADE_WIDTH_TOP;
SCISSORS_SLOT_WIDTH_BOTTOM = 2 * HOLDER_SPACING + BLADE_WIDTH_BOTTOM;

// Draw polyhedron of outer sheath to hold the scissors,
// with enough thickness to hold two enclosed magnets
// on the top and bottom of the holder.
module holder_outer() {
  // draw a four point shape from top to bottom and linear extrude
  // linear_extrude(height = HOLDER_THICKNESS) {
  //   polygon(points = [
  //     [ 0, 0 ], [ HOLDER_WIDTH_TOP, 0 ],
  //     // [ HOLDER_WIDTH_BOTTOM, HOLDER_LENGTH ],
  //     [ HOLDER_WIDTH_TOP, HOLDER_LENGTH ], [ 0, HOLDER_LENGTH ]
  //   ]);
  // }

  roundedcube(size = [ HOLDER_WIDTH_TOP, HOLDER_LENGTH, HOLDER_THICKNESS + 3 ],
              radius = 3, apply_to = "all");
}

module scissors_slot() {
  // This is subtracted from holder_outer to cut out the slot for the scissors.
  // Center it within the holder.
  translate([
    (HOLDER_WIDTH_TOP - SCISSORS_SLOT_WIDTH_TOP) / 2, 0,
    HOLDER_THICKNESS - MIN_HOLDER_WALL_THICKNESS -
    SCISSORS_SLOT_THICKNESS_TOP
  ])
      polyhedron(
          points =
              [
                [ 0, -1, 0 ], [ 0, -1, SCISSORS_SLOT_THICKNESS_TOP ],
                [ SCISSORS_SLOT_WIDTH_TOP, -1, SCISSORS_SLOT_THICKNESS_TOP ],
                [ SCISSORS_SLOT_WIDTH_TOP, -1, 0 ], [ 0, BLADE_LENGTH + 1, 0 ],
                [ 0, BLADE_LENGTH + 1, SCISSORS_SLOT_THICKNESS_BOTTOM ],
                [
                  SCISSORS_SLOT_WIDTH_BOTTOM, BLADE_LENGTH + 1,
                  SCISSORS_SLOT_THICKNESS_BOTTOM
                ],
                [ SCISSORS_SLOT_WIDTH_BOTTOM, BLADE_LENGTH + 1, 0 ]
              ],
          faces = [
            [ 0, 1, 2, 3 ], [ 7, 6, 5, 4 ], [ 4, 5, 1, 0 ], [ 5, 6, 2, 1 ],
            [ 6, 7, 3, 2 ], [ 7, 4, 0, 3 ]
          ]);
}

module magnet_hole() {
  cylinder(h = MAGNET_HEIGHT + 1 + EPSILON, r = MAGNET_DIAMETER / 2 + 0.4,
           center = false);
}

module inspect() {
  // Cut out cross section to inspect model
  translate([ 0, 0, HOLDER_THICKNESS / 2 ]) {
    cube([ HOLDER_WIDTH_TOP + 1, BLADE_LENGTH + 1, HOLDER_THICKNESS + 1 ],
         center = true);
  }
}

magnet_hole_offset =
    (HOLDER_WIDTH_TOP - MAGNET_DIAMETER) / 2 + MAGNET_DIAMETER / 2;
difference() {
  holder_outer();
  scissors_slot();

  // Top hole
  translate([ HOLDER_WIDTH_TOP / 2, magnet_hole_offset, -EPSILON ])
      magnet_hole();
  // Bottom hole
  translate([
    // HOLDER_WIDTH_BOTTOM / 2,
    HOLDER_WIDTH_TOP / 2, HOLDER_LENGTH - magnet_hole_offset, -EPSILON
  ]) magnet_hole();

  // inspect();
}

// scissors_slot();
// translate([ -30, 0, 0 ]) holder_outer();
