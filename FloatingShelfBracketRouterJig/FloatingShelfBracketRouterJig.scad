// Guide bush formula
// https://trend-storage.online/productdocuments/dl_gb-offset-formula.pdf

$fn = 200;

FRICTION_OFFSET = 0.3;

ROUTER_BIT_DIAMETER = 8;
ROUTER_GUIDE_BUSH_DIAMETER = 16.9;
ROUTER_TEMPLATE_GUIDE_HEIGHT =
    8 + 1;  // Extra 1mm so guide bush doesn't touch the wood

BRACKET_WIDTH = 61;
BRACKET_DEPTH = 15;

PLANK_THICKNESS = 19;
PLANK_WIDTH = 134;
PLANK_NOTCH_WIDTH = PLANK_THICKNESS + FRICTION_OFFSET;
NOTCH_DEPTH = 15;

router_bush_offset = ROUTER_GUIDE_BUSH_DIAMETER - ROUTER_BIT_DIAMETER;
guide_height = ROUTER_TEMPLATE_GUIDE_HEIGHT + 5;

bracket_template_width = BRACKET_WIDTH + router_bush_offset;
bracket_template_depth = BRACKET_DEPTH + router_bush_offset;

jig_width = bracket_template_width + 50;
jig_depth = bracket_template_depth + 25;
jig_height = ROUTER_TEMPLATE_GUIDE_HEIGHT + NOTCH_DEPTH;
jig_side_width = (jig_depth / 2) - (PLANK_NOTCH_WIDTH / 2);

CLAMP_PLATE_HEIGHT = PLANK_WIDTH - NOTCH_DEPTH;
CLAMP_PLATE_THICKNESS = 4;

module clamp_pin() { cylinder(r = 3, h = 20, center = true); }

module clamp_pins() {
  // Cut out three 8mm radius cyclinders with 1cm height to hold the clamp
  // plate to the jig
  pins_width = jig_width - jig_side_width;

  translate([ jig_width / -2, jig_depth / -2, jig_height / -2 ]) {
    translate([ 0, jig_side_width / 2, 0 ]) {
      for (x = [0:pins_width / 4:pins_width]) {
        translate([ jig_side_width / 2 + x, 0, 0 ]) { clamp_pin(); }
      }
    }
  }
}

module clamp_plate(z_offset = 0) {
  translate([ 0, 0, z_offset ]) {
    difference() {
      union() {
        color([ 0, 1, 0 ]) {
          translate([
            jig_width / -2,
            jig_depth / -2 - CLAMP_PLATE_THICKNESS + jig_side_width,
            (CLAMP_PLATE_HEIGHT +
             (ROUTER_TEMPLATE_GUIDE_HEIGHT + NOTCH_DEPTH) / 2) *
                -1
          ]) {
            color([ 0, 1, 0 ]) {
              cube([ jig_width, CLAMP_PLATE_THICKNESS, CLAMP_PLATE_HEIGHT ]);
            }
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
      }
      clamp_pins();
    }
  }
}

module jig() {
  difference() {
    cube([ jig_width, jig_depth, jig_height ], true);

    cube(
        [
          bracket_template_width + FRICTION_OFFSET,
          bracket_template_depth + FRICTION_OFFSET, NOTCH_DEPTH + guide_height +
          FRICTION_OFFSET
        ],
        true);

    // Remove 1mm deep thin lines on X and Y axis to center the jig
    translate([ 0, 0, (ROUTER_TEMPLATE_GUIDE_HEIGHT + NOTCH_DEPTH) / 2 ]) {
      cube([ jig_width + 1, 1, 2 ], true);
      cube([ 1, jig_depth + 1, 2 ], true);
    }

    // Notch for it to sit flat on the side of the wood.
    translate([ 0, 0, ROUTER_TEMPLATE_GUIDE_HEIGHT / -2 - 1 ]) {
      cube([ jig_width + 5, PLANK_NOTCH_WIDTH, NOTCH_DEPTH + 1 ], true);
    }

    clamp_pins();
  }
}

// This part is for a center punch to mark the center of the hole for
// drilling.
module center_punch_plate() {
  center_punch_card_height = 3;
  difference() {
    union() {
      difference() {
        cube(
            [
              bracket_template_width + FRICTION_OFFSET,
              bracket_template_depth + FRICTION_OFFSET,
              center_punch_card_height
            ],
            true);

        // Cut out grid pattern to save filament
        grid_spacing = 5;
        for (x = [grid_spacing:grid_spacing:bracket_template_width]) {
          for (y = [grid_spacing:grid_spacing:bracket_template_depth]) {
            translate([
              x - (bracket_template_width) / 2,
              y - (bracket_template_depth) / 2 - 0.5, 0
            ]) {
              cube([ 3.5, 3.5, center_punch_card_height * 2 ], true);
            }
          }
        }
      }

      cube([ 14, 10, center_punch_card_height ], true);
    }
    cylinder(r = 1, h = 20, center = true);
  }
}

// jig();
// clamp_plate();
// clamp_pin();
center_punch_plate();
