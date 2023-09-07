// Guide bush formula
// https://trend-storage.online/productdocuments/dl_gb-offset-formula.pdf

include <../lib/roundedcube.scad>

$fn = $preview ? 15 : 100;
EPSILON = 0.01;

FRICTION_OFFSET = 0.3;

ROUTER_BIT_DIAMETER = 8;
ROUTER_GUIDE_BUSH_DIAMETER = 16.9;
ROUTER_TEMPLATE_GUIDE_HEIGHT =
    8 + 1;  // Extra 1mm so guide bush doesn't touch the wood

BRACKET_WIDTH = 49;
BRACKET_DEPTH = 13;
BRACKET_HEIGHT = 5;
// BRACKET_HEIGHT = 2;

SCREW_HEAD_HEIGHT = 3;
SCREW_HEAD_DIAMETER = 6.88;
SCREW_THREAD_DIAMETER = 3.5;

PEG_DIAMETER = 7.5;
PEG_HEIGHT = 65;
// PEG_HEIGHT = 4;

PLANK_THICKNESS = 19;
PLANK_WIDTH = 90.5;
PLANK_LENGTH = 330;

PLANK_NOTCH_WIDTH = PLANK_THICKNESS + FRICTION_OFFSET;
NOTCH_DEPTH = 15;

router_bush_offset = ROUTER_GUIDE_BUSH_DIAMETER - ROUTER_BIT_DIAMETER;
guide_height = ROUTER_TEMPLATE_GUIDE_HEIGHT + 5;

BRACKET_TEMPLATE_X_PADDING = 1;
bracket_template_width =
    BRACKET_WIDTH + router_bush_offset + BRACKET_TEMPLATE_X_PADDING;
bracket_template_depth = BRACKET_DEPTH + router_bush_offset;

jig_width = bracket_template_width + 50;
jig_depth = bracket_template_depth + 25;
jig_height = ROUTER_TEMPLATE_GUIDE_HEIGHT + NOTCH_DEPTH;
jig_side_width = (jig_depth / 2) - (PLANK_NOTCH_WIDTH / 2);

CLAMP_PLATE_HEIGHT = 35;  // PLANK_WIDTH - NOTCH_DEPTH;
CLAMP_PLATE_THICKNESS = 4;

module clamp_plate(z_offset = 0) {
  translate([ 0, 0, z_offset ]) {
    difference() {
      union() {
        translate([
          jig_width / -2,
          jig_depth / -2 - CLAMP_PLATE_THICKNESS + jig_side_width,
          (CLAMP_PLATE_HEIGHT +
           (ROUTER_TEMPLATE_GUIDE_HEIGHT + NOTCH_DEPTH) / 2) *
              -1
        ]) {
          cube([ jig_width, CLAMP_PLATE_THICKNESS, CLAMP_PLATE_HEIGHT ]);
        }

        translate([ jig_width / 2, PLANK_NOTCH_WIDTH / -2, jig_height / -2 ])
            rotate([ 0, 90, 180 ]) linear_extrude(height = jig_width) {
          // draw triangle on side of clamp plate next to jig
          polygon(points = [
            [ 0, 0 ],
            [ 0, jig_side_width ],
            [ 10, jig_side_width ],
            [ 10 + jig_side_width, 0 ],
            [ 10, 0 ],
          ]);
        }
      }
      // clamp_pins();
    }
  }
}

module jig() {
  translate([ 0, 0, (ROUTER_TEMPLATE_GUIDE_HEIGHT / -2 - 1) / 2 ])
      difference() {
    // Main dimensions of the jig
    cube([ jig_width, jig_depth, jig_height ], true);

    // Inner cut out for the router bit + guide
    cube(
        [
          bracket_template_width + FRICTION_OFFSET,
          bracket_template_depth + FRICTION_OFFSET, NOTCH_DEPTH + guide_height +
          FRICTION_OFFSET
        ],
        true);

    // Notch for it to slot onto the plank
    translate([ 0, 0, ROUTER_TEMPLATE_GUIDE_HEIGHT / -2 - 1 ]) {
      cube([ jig_width + 5, PLANK_NOTCH_WIDTH, NOTCH_DEPTH + 1 ], true);
    }
  }
}

module countersunk_screw_hole() {
  // translate(
  //   [ 0, 0, (SCREW_HEAD_HEIGHT / 2) - (BRACKET_HEIGHT + FRICTION_OFFSET) ])
  translate([ 0, 0, ((BRACKET_HEIGHT + FRICTION_OFFSET) * -1) - EPSILON ]) {
    translate([ 0, 0, SCREW_HEAD_HEIGHT / 2 ])
        cylinder(h = SCREW_HEAD_HEIGHT, r1 = SCREW_HEAD_DIAMETER / 2,
                 r2 = SCREW_THREAD_DIAMETER / 2, center = true);
    translate([ 0, 0, BRACKET_HEIGHT / 2 + SCREW_HEAD_HEIGHT ]) cylinder(
        h = BRACKET_HEIGHT, r = SCREW_THREAD_DIAMETER / 2, center = true);
  }
}

module bracket() {
  difference() {
    union() {
      translate([ 0, 0, (BRACKET_HEIGHT + FRICTION_OFFSET) / -2 ]) {
        intersection() {
          cube(
              [
                BRACKET_WIDTH + FRICTION_OFFSET + ROUTER_GUIDE_BUSH_DIAMETER,
                BRACKET_DEPTH + FRICTION_OFFSET, BRACKET_HEIGHT +
                FRICTION_OFFSET
              ],
              center = true);

          roundedcube(
              [
                BRACKET_WIDTH + FRICTION_OFFSET,
                BRACKET_DEPTH + FRICTION_OFFSET, BRACKET_HEIGHT +
                FRICTION_OFFSET
              ],
              true, 6, "z");
        }
      }
      rotate([ 2, 0, 0 ]) translate(
          [ 0, 0, PEG_HEIGHT / -2 - (BRACKET_HEIGHT + FRICTION_OFFSET) ])
          cylinder(h = PEG_HEIGHT, r = (PEG_DIAMETER / 2) - FRICTION_OFFSET,
                   center = true);
    }

    translate([ BRACKET_WIDTH / 2 - 7, 0, 0 ]) countersunk_screw_hole();
    translate([ BRACKET_WIDTH / -2 + 7, 0, 0 ]) countersunk_screw_hole();
  }
}

module plank() {
  translate([ 0, 0, -PLANK_WIDTH / 2 ]) rotate([ 90, 0, 0 ])
      color([ 0.88, 0.59, 0 ])
          cube([ PLANK_LENGTH, PLANK_WIDTH, PLANK_THICKNESS ], true);
}

// plank();
bracket();

// countersunk_screw_hole();

// difference() {
//   plank();
//   translate([ 0, 0, 2 ]) bracket();
// }

// jig();
// clamp_plate();
// clamp_pin();
// center_punch_plate();
