$fn = $preview ? 50 : 250;
EPSILON = 0.01;

TOLERANCE = 0.3;

CHANNEL_WIDTH = 14;
CHANNEL_HEIGHT = 7 + 0.5;
BRACKET_LENGTH = 15;

THICKNESS = 2.5;

scale(1.5) difference() {
  union() {
    translate([ -17, -4, 0 ]) linear_extrude(height = 10) scale(v = 0.4)
        import(file = "bracket_v2.svg", center = false, dpi = 96);

    translate([ 8.5, 134, 5 ]) rotate([ 90, 0, 0 ]) {
      difference() {
        // supporting cylinder
        cylinder(h = 114, r = 3.3);
        translate([ -5, -5, -1 ]) cube([ 5, 10, 150 ]);
      }
    }
  }

  translate([ 0, 11.5, 5 ]) rotate([ 0, 90, 0 ]) cylinder(h = 20, r = 3 / 2);
  translate([ 0, 2.5, 5 ]) rotate([ 0, 90, 0 ]) cylinder(h = 20, r = 3 / 2);
  // translate([ 35, 92, 5 ]) rotate([ 0, 90, -35 ]) cylinder(h = 10, r = 3 /
  // 2);
}

// LED channel holder
translate([ 18, 130 + 80, BRACKET_LENGTH / 2 ]) {
  rotate([ 90, 0, 90 ]) {
    difference() {
      union() {
        difference() {
          union() {
            cube(
                [
                  CHANNEL_WIDTH + THICKNESS * 2, BRACKET_LENGTH,
                  CHANNEL_HEIGHT +
                  THICKNESS
                ],
                center = true);
            // Top notches
            translate([ 0, 0, (CHANNEL_HEIGHT + THICKNESS) / 2 + 0.6 / 4 ])
                cube([ CHANNEL_WIDTH + THICKNESS * 2, BRACKET_LENGTH, 0.4 ],
                     center = true);
          }

          translate([ 0, 0, THICKNESS / 2 ]) cube(
              [
                CHANNEL_WIDTH + TOLERANCE, BRACKET_LENGTH + 10, CHANNEL_HEIGHT +
                EPSILON
              ],
              center = true);

          // top holder notch on back
          translate([ THICKNESS, 0, CHANNEL_HEIGHT + THICKNESS / 2 ]) cube(
              [
                CHANNEL_WIDTH + TOLERANCE - 0.3 * 2 + THICKNESS * 2,
                BRACKET_LENGTH + 10, CHANNEL_HEIGHT +
                EPSILON
              ],
              center = true);
        }
        for (a = [ -1, +1 ])
          translate([ CHANNEL_WIDTH / 2 * a, 0, THICKNESS / 2 ])
              cube([ 0.4, BRACKET_LENGTH, 0.4 ], center = true);
      }
    }
  }
}
