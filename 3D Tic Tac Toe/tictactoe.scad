include <../lib/roundedcube.scad>

$fn = $preview ? 35 : 100;
EPSILON = 0.01;
rand_seed = 3;

WIDTH = 115;
BASE_HEIGHT = 15;
PIECE_RADIUS = 14;

POLE_RADIUS = 4;
POLE_RADIUS_TOLERANCE = 0.8;
POLE_HEIGHT = PIECE_RADIUS * 6 + BASE_HEIGHT + 8;

module piece_hole() {
  difference() {
    children();
    cylinder(h = POLE_HEIGHT, r = POLE_RADIUS + POLE_RADIUS_TOLERANCE,
             center = true);
  }
}

module piece_x() {
  // X_WIDTH = 13.5;
  X_WIDTH = 10;

  color([ 0.3, 0.5, 1 ]) piece_hole() {
    intersection() {
      cube([ PIECE_RADIUS * 2, PIECE_RADIUS * 2, PIECE_RADIUS * 2 ], true);

      union() {
        rotate([ 45, 0, 0 ])
            cube([ PIECE_RADIUS * 3, X_WIDTH, PIECE_RADIUS * 3 ], true);
        rotate([ -45, 0, 0 ])
            cube([ PIECE_RADIUS * 3, X_WIDTH, PIECE_RADIUS * 3 ], true);
      }
    }
  }
}

module piece_o() {
  RING_THICKNESS = 5;

  color([ 1, 0.3, 1 ]) piece_hole() {
    // sphere(PIECE_RADIUS);
    rotate([ 0, 90, 0 ]) difference() {
      cylinder(h = PIECE_RADIUS * 2, r = PIECE_RADIUS, center = true);
      cylinder(h = PIECE_RADIUS * 2 + EPSILON,
               r = PIECE_RADIUS - RING_THICKNESS, center = true);
    }
  }
}

module base() {
  color([ 0.2, 0.2, 0.2 ]) difference() {
    intersection() {
      roundedcube([ WIDTH, WIDTH, BASE_HEIGHT ], true, 10, "z");
      cube([ WIDTH + 10, WIDTH + 10, BASE_HEIGHT ], true);
    }

    for (x = [ -1, 0, +1 ]) {
      for (y = [ -1, 0, +1 ]) {
        translate([
          x * (WIDTH / 2 - PIECE_RADIUS - 4),
          y * (WIDTH / 2 - PIECE_RADIUS - 4), -EPSILON
        ]) {
          translate([ 0, 0, BASE_HEIGHT / -2 ]) pole();
        }
      }
    }
  }
}

module pole() {
  color([ 0.2, 0.2, 0.2 ]) cylinder(h = POLE_HEIGHT, r = POLE_RADIUS);
}

module example() {
  base();

  for (x = [ -1, 0, +1 ]) {
    for (y = [ -1, 0, +1 ]) {
      translate([
        x * (WIDTH / 2 - PIECE_RADIUS - 4), y * (WIDTH / 2 - PIECE_RADIUS - 4),
        0
      ]) {
        translate([ 0, 0, BASE_HEIGHT / -2 ]) pole();

        translate([ 0, 0, PIECE_RADIUS + BASE_HEIGHT / 2 ]) {
          for (z = [ 0, 1, 2 ]) {
            translate([ 0, 0, (PIECE_RADIUS * 2 + 2) * z ]) {
              val = rands(0, 1, 1, rand_seed + x + y * 3 + z * 9)[0];
              if (val < 0.5)
                piece_x();
              else
                piece_o();
            }
          }
        }
      }
    }
  }
}

// base();
// pole();
// piece_x();
// piece_o();

example();
