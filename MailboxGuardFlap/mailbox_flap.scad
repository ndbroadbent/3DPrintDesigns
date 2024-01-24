$fn = $preview ? 25 : 100;
EPSILON = 0.01;

module bottomWedge(r, d, rodH, tolerance, other) {
  wedgeH = (r + tolerance) * sin(45);
  wedgeBottom = max(r + tolerance, d);
  wedgeFlip = other ? 1 : -1;
  linear_extrude(height = rodH) polygon(
      points = [[wedgeH, wedgeFlip * -r], [wedgeH, wedgeFlip * wedgeH],
                [wedgeBottom, wedgeFlip * (wedgeH - (wedgeBottom - wedgeH))],
                [wedgeBottom, wedgeFlip * -r]]);
}

module hingeRodNegative(r, d, h, tolerance, tip, other) {
  difference() {
    translate([ 0, 0, d ]) rotate([ 0, 90, 0 ]) {
      translate([ 0, 0, -tolerance / 2 ]) {
        rodH = h + (tip ? tolerance / 2 : 0) + tolerance / 2;
        cylinder(r = r + tolerance, h = rodH);
        bottomWedge(r, d, rodH, tolerance, other);
      }
      if (tip) {
        translate([ 0, 0, h ]) cylinder(r = r, h = tolerance + 0.01);
        translate([ 0, 0, h + tolerance ])
            cylinder(r1 = r, r2 = 0, h = r + tolerance);
      } else {
        translate([ 0, 0, h ]) cylinder(r = r + tolerance, h = tolerance / 2);
      }
    }
    translate([ -tolerance / 2 - 0.01, other ? -r - tolerance : 0, -0.01 ])
        cube([
          h + tolerance + +0.02 + (tip ? r + tolerance * 1.5 : 0),
          r + tolerance, d + r + tolerance + 0.02
        ]);
  }
}

module hingeRod(r, d, h, tip, dip, tolerance, negative, other) {
  if (negative) {
    hingeRodNegative(r, d, h, tolerance, tip, other);
  } else {
    toleranceTip = tip ? tolerance / 2 : 0;
    toleranceDip = dip ? tolerance / 2 : 0;
    translate([ 0, 0, d ]) rotate([ 0, 90, 0 ]) difference() {
      union() {
        rodH = h - toleranceTip - toleranceDip;
        translate([ 0, 0, toleranceDip ]) {
          cylinder(r = r, h = rodH);
          bottomWedge(r, d, rodH, 0, !other);
        }
        if (tip) {
          translate([ 0, 0, h - toleranceTip - 0.01 ])
              cylinder(r1 = r, r2 = 0, h = r + 0.01);
        }
      }
      if (dip) {
        translate([ 0, 0, toleranceDip - 0.01 ])
            cylinder(r1 = r, r2 = 0, h = r + tolerance);
      }
    }
  }
}

function xor (a, b) = (a && !b) || (b && !a);

module hingeCorner(r, cornerHeight, hingeLength, pieces, other, negative,
                   tolerance) {
  startAtFirst = xor(other, negative);
  for (i = [1:pieces]) {
    if (i % 2 == (startAtFirst ? 0 : 1)) {
      translate([ hingeLength / pieces * (i - 1), 0, 0 ])
          hingeRod(r, cornerHeight, hingeLength / pieces,
                   i != pieces || cornerHeight > (hingeLength / pieces), i != 1,
                   tolerance, negative, other);
    }
  }
}

module applyHingeCorner(position = [ 0, 0, 0 ], rotation = [ 0, 0, 0 ], r = 3,
                        cornerHeight = 5, hingeLength = 15, pieces = 3,
                        tolerance = 0.3) {
  translate(position) for (i = [0:1]) {
    difference() {
      translate(-position) children(i);
      rotate(rotation) hingeCorner(r, cornerHeight, hingeLength, pieces, i == 0,
                                   true, tolerance);
    }
    rotate(rotation) hingeCorner(r, cornerHeight, hingeLength, pieces, i == 0,
                                 false, tolerance);
  }
  if ($children > 2) {
    children([2:$children - 1]);
  }
}

module applyHinges(positions, rotations, r, cornerHeight, hingeLength, pieces,
                   tolerance) {
  difference() {
    children();
    for (j = [0:1:len(positions) - 1]) {
      translate(positions[j])
          rotate([ 0, 0, rotations[j] ]) for (b = [ 0, 1 ]) {
        hingeCorner(r, cornerHeight, hingeLength, pieces, b == 0, true,
                    tolerance);
      }
    }
  }
  for (j = [0:1:len(positions) - 1]) {
    translate(positions[j]) rotate([ 0, 0, rotations[j] ]) for (b = [ 0, 1 ]) {
      hingeCorner(r, cornerHeight, hingeLength, pieces, b == 0, false,
                  tolerance);
    }
  }
}

module negativeExtraAngle(position, rotation, cornerHeight, centerHeight,
                          hingeLength, pieces, tolerance, other, angle) {
  translate(position) rotate(rotation) {
    startAtFirst = !other;
    l = (cornerHeight + tolerance - centerHeight) / tan(90 - angle / 2);
    for (i = [1:pieces]) {
      if (i % 2 == (startAtFirst ? 0 : 1)) {
        dip = i != 1;
        w = hingeLength / pieces + (dip ? 1 : 0.5) * tolerance;
        positionX = (i - 1) * hingeLength / pieces + (dip ? -tolerance / 2 : 0);
        difference() {
          translate([ positionX, 0, centerHeight ])
              rotate([ other ? -angle : angle, 0, 0 ])
                  translate([ 0, other ? -l : 0, -centerHeight ])
                      cube([ w, l, cornerHeight + tolerance ]);

          translate(
              [ positionX - 0.01, other ? -cornerHeight + 0.01 : -0.01, 0 ])
              cube([ w + 0.02, cornerHeight, 2 * cornerHeight ]);

          diffY = norm([ l, cornerHeight + tolerance ]);
          translate([
            positionX - 0.01, other ? -0.01 : -diffY - 2 * tolerance + 0.01,
            cornerHeight + 0.01
          ]) cube([ w + 0.02, diffY + 2 * tolerance, diffY ]);
        }
      }
    }
  }
}

module applyExtraAngle(positions, rotations, cornerHeight, centerHeight,
                       hingeLength, pieces, tolerance, angle) {
  difference() {
    children();
    for (j = [0:1:len(positions) - 1]) {
      negativeExtraAngle(positions[j], rotations[j], cornerHeight, centerHeight,
                         hingeLength, pieces, tolerance, false, angle);
      negativeExtraAngle(positions[j], rotations[j], cornerHeight, centerHeight,
                         hingeLength, pieces, tolerance, true, angle);
    }
  }
}

MAILBOX_SLOT_WIDTH = 177;
MAILBOX_SLOT_HEIGHT = 30;

MAILBOX_WIDTH = 80;
MAILBOX_HEIGHT = 105;          // ???
MAILBOX_DEPTH = 250;           // ???
MAILBOX_WALL_THICKNESS = 2.5;  // ???
module mailbox() {
  color([ 0.8, 0.8, 0.8 ]) difference() {
    cube([ MAILBOX_WIDTH, MAILBOX_DEPTH, MAILBOX_HEIGHT ], center = true);
    // Inside
    translate([ 0, MAILBOX_WALL_THICKNESS * -1, 0 ]) cube(
        [
          (MAILBOX_WIDTH - MAILBOX_WALL_THICKNESS), MAILBOX_DEPTH,
          (MAILBOX_HEIGHT - MAILBOX_WALL_THICKNESS)
        ],
        center = true);
    // Mail slot
    translate([
      0, (MAILBOX_DEPTH / 2 - 10), (MAILBOX_HEIGHT - MAILBOX_SLOT_HEIGHT) / 2 -
      MAILBOX_WALL_THICKNESS
    ]) cube([ MAILBOX_SLOT_WIDTH, 50, MAILBOX_SLOT_HEIGHT ], center = true);
  }
}

REED_SWITCH_DIAMETER = 3;
REED_SWITCH_LENGTH = 27;
REED_SWITCH_WIRE_DIAMETER = 1.5;
REED_SWITCH_WIRE_LENGTH = 10;
REED_SWITCH_CONNECTOR_WIRE_DIAMETER = 2.2;

REED_SWITCH_HOLDER_HEIGHT = 15;
REED_SWITCH_HOLDER_WIDTH = 50;
REED_SWITCH_HOLDER_THICKNESS = REED_SWITCH_DIAMETER / 2 + 0.5;
REED_SWITCH_PLUG_HOLE_DIAMETER = 3;
REED_SWITCH_PLUG_HOLE_MARGIN = 2.5;

module copy_mirror(vec) {
  children();
  mirror(vec) children();
}

// mailbox();

MAGNET_HEIGHT = 3;
MAGNET_DIAMETER = 8;
MAGNET_MARGIN = 2;

FLAP_HEIGHT = MAILBOX_SLOT_HEIGHT + MAGNET_DIAMETER + MAGNET_MARGIN * 2;
FLAP_WIDTH = MAILBOX_SLOT_WIDTH;
FLAP_THICKNESS = MAGNET_HEIGHT + 2;

TOP_FLAP_WIDTH = MAILBOX_SLOT_WIDTH;
TOP_FLAP_LENGTH = 20;
TOP_FLAP_HINGE_DIAMETER = 5;
TOP_FLAP_HINGE_INNER_DIAMETER = 3;
TOP_FLAP_THICKNESS = 2;

// translate([ 0, 0, FLAP_HEIGHT / -2 - TOP_FLAP_HINGE_DIAMETER / 2 ]) {
//   difference() {
//     // flap
//     translate([ 0, (FLAP_THICKNESS) / 2, 0 ]) cube(
//         [ MAILBOX_SLOT_WIDTH, FLAP_THICKNESS, FLAP_HEIGHT ], center = true);

//     // hinge hole cutout
//     translate([ 0, TOP_FLAP_HINGE_DIAMETER / 2, FLAP_HEIGHT / 2 ])
//         rotate([ 0, 90, 0 ])
//             cylinder(h = TOP_FLAP_WIDTH + 0.1,
//                      d = TOP_FLAP_HINGE_INNER_DIAMETER, center = true);

//   // magnet cutout (inside)
//   color([ 0.8, 0, 0 ]) translate([
//     0, (MAGNET_HEIGHT) / 2 + 1.01, FLAP_HEIGHT / -2 + MAGNET_DIAMETER / 2 +
//     MAGNET_MARGIN
//   ]) rotate([ 90, 0, 0 ])
//       cylinder(h = MAGNET_HEIGHT + 0.5, d = MAGNET_DIAMETER, center =
//       true);
// }
// }

// // top part
// translate([ 0, TOP_FLAP_LENGTH / -2 + FLAP_THICKNESS, TOP_FLAP_THICKNESS / 2
// ])
//     cube([ TOP_FLAP_WIDTH, TOP_FLAP_LENGTH, TOP_FLAP_THICKNESS ],
//          center = true);

// // hinge cylinder
// translate([ 0, TOP_FLAP_HINGE_DIAMETER / 2, TOP_FLAP_HINGE_DIAMETER / -2 ])
//     rotate([ 0, 90, 0 ]) difference() {
//   cylinder(h = TOP_FLAP_WIDTH, d = TOP_FLAP_HINGE_DIAMETER, center = true);
//   cylinder(h = TOP_FLAP_WIDTH + 0.1, d = TOP_FLAP_HINGE_INNER_DIAMETER,
//            center = true);
// }

HINGE_TOLERANCE = 0.6;
HINGE_HEIGHT = FLAP_THICKNESS;
HINGE_COUNT = 10;

difference() {
  union() {
    // magnet flap
    translate([ 0, HINGE_TOLERANCE, 0 ])
        cube([ FLAP_WIDTH, FLAP_HEIGHT, FLAP_THICKNESS ]);
    // top part
    translate([ 0, -HINGE_TOLERANCE - 20, 0 ]) cube([ FLAP_WIDTH, 20, 3 ]);
  }
  hingeCorner(HINGE_HEIGHT / 2, HINGE_HEIGHT / 2, FLAP_WIDTH, HINGE_COUNT, true,
              true, HINGE_TOLERANCE);
  negativeExtraAngle([ 0, 0, 0 ], [ 0, 0, 0 ], HINGE_HEIGHT, HINGE_HEIGHT / 2,
                     FLAP_WIDTH, HINGE_COUNT, HINGE_TOLERANCE, true, 90);
  hingeCorner(HINGE_HEIGHT / 2, HINGE_HEIGHT / 2, FLAP_WIDTH, HINGE_COUNT,
              false, true, HINGE_TOLERANCE);
  negativeExtraAngle([ 0, 0, 0 ], [ 0, 0, 0 ], HINGE_HEIGHT, HINGE_HEIGHT / 2,
                     FLAP_WIDTH, HINGE_COUNT, HINGE_TOLERANCE, false, 90);

  // magnet cutout (inside)
  translate([
    FLAP_WIDTH / 2 - MAGNET_DIAMETER / 2 + MAGNET_MARGIN,
    FLAP_HEIGHT - MAGNET_DIAMETER / 2 - MAGNET_MARGIN, MAGNET_HEIGHT / 2 + 1
  ]) color([ 0.8, 0, 0 ])
      cylinder(h = MAGNET_HEIGHT + 0.5, d = MAGNET_DIAMETER, center = true);
}
hingeCorner(HINGE_HEIGHT / 2, HINGE_HEIGHT / 2, FLAP_WIDTH, HINGE_COUNT, true,
            false, HINGE_TOLERANCE);
hingeCorner(HINGE_HEIGHT / 2, HINGE_HEIGHT / 2, FLAP_WIDTH, HINGE_COUNT, false,
            false, HINGE_TOLERANCE);
