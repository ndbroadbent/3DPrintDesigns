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
BRACKET_HEIGHT = 6;
// Set the width of your desired notch here:
BRACKET_DEPTH = 14;

// BRACKET_HEIGHT = 2;

PLANK_THICKNESS = 19;
PLANK_WIDTH = 135;
PLANK_LENGTH = 330;

PLANK_NOTCH_WIDTH = PLANK_THICKNESS + FRICTION_OFFSET;
NOTCH_DEPTH = 25;

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

module plank() {
  translate([ 0, 0, -PLANK_WIDTH / 2 ]) rotate([ 90, 0, 0 ])
      color([ 0.88, 0.59, 0 ])
          cube([ PLANK_LENGTH, PLANK_WIDTH, PLANK_THICKNESS ], true);
}

// plank();

jig();
// clamp_plate();
// clamp_pin();
// center_punch_plate();
