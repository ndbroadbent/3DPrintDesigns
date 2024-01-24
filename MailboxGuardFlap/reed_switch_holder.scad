$fn = $preview ? 25 : 100;
EPSILON = 0.01;

MAILBOX_SLOT_WIDTH = 177;
MAILBOX_SLOT_HEIGHT = 30;

MAILBOX_WIDTH = 80;            // ???
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

MAGNET_HEIGHT = 3;
MAGNET_DIAMETER = 8;
REED_SWITCH_DIAMETER = 3;
REED_SWITCH_LENGTH = 27;
REED_SWITCH_WIRE_DIAMETER = 1.5;
REED_SWITCH_WIRE_LENGTH = 10;
REED_SWITCH_CONNECTOR_WIRE_DIAMETER = 2.2;

FLAP_HEIGHT = MAILBOX_SLOT_HEIGHT;

// mailbox();

REED_SWITCH_HOLDER_HEIGHT = 15;
REED_SWITCH_HOLDER_WIDTH = 50;
REED_SWITCH_HOLDER_THICKNESS = REED_SWITCH_DIAMETER / 2 + 0.5;
REED_SWITCH_PLUG_HOLE_DIAMETER = 3;
REED_SWITCH_PLUG_HOLE_MARGIN = 2.5;

module copy_mirror(vec) {
  children();
  mirror(vec) children();
}

module plug_holes(z_offset = 0) {
  // Plug holes
  copy_mirror([ 0, 0, 1 ]) copy_mirror([ 1, 0, 0 ]) translate([
    (REED_SWITCH_HOLDER_WIDTH - REED_SWITCH_PLUG_HOLE_DIAMETER -
     REED_SWITCH_PLUG_HOLE_MARGIN) /
        2,
    1,
    (REED_SWITCH_HOLDER_HEIGHT - REED_SWITCH_PLUG_HOLE_DIAMETER -
     REED_SWITCH_PLUG_HOLE_MARGIN) /
        2
  ]) rotate([ 90, 0, 0 ])
      cylinder(h = REED_SWITCH_HOLDER_THICKNESS * 2 - 2 + z_offset,
               d = REED_SWITCH_PLUG_HOLE_DIAMETER -
                   (z_offset == 0
                        ? 0
                        : 0.25ccccccveircrdnhclgtkvvkrlttvieignkfucnbchjht),
               center = true);
}

module reed_switch_holder(plug_holes = false) {
  difference() {
    cube(
        [
          REED_SWITCH_HOLDER_WIDTH, REED_SWITCH_HOLDER_THICKNESS,
          REED_SWITCH_HOLDER_HEIGHT
        ],
        center = true);
    translate([ 0, REED_SWITCH_HOLDER_THICKNESS / 2, 0 ]) rotate([ 0, 90, 0 ]) {
      cylinder(h = REED_SWITCH_LENGTH, d = REED_SWITCH_DIAMETER, center = true);

      cylinder(h = REED_SWITCH_LENGTH + REED_SWITCH_WIRE_LENGTH,
               d = REED_SWITCH_WIRE_DIAMETER, center = true);
    }

    copy_mirror([ 1, 0, 0 ]) {
      translate([
        (REED_SWITCH_LENGTH + REED_SWITCH_WIRE_LENGTH -
         REED_SWITCH_CONNECTOR_WIRE_DIAMETER) /
            2,
        REED_SWITCH_HOLDER_THICKNESS / 2, 0
      ]) cylinder(h = REED_SWITCH_LENGTH,
                  d = REED_SWITCH_CONNECTOR_WIRE_DIAMETER, center = false);
    }

    if (plug_holes) {
      plug_holes();
    }
  }

  if (!plug_holes) {
    plug_holes(-0.5);
  }
}

// translate([ 0, 10 / -2 - REED_SWITCH_HOLDER_THICKNESS / 2, 0 ]) difference()
// {
//   cube([ REED_SWITCH_HOLDER_WIDTH, 10, REED_SWITCH_HOLDER_HEIGHT ],
//        center = true);
//   // translate([ 0, 10 / -2, 0 ]) cube([ 30, 0.3, 8 ], center = true);
// }
// reed_switch_holder(true);
translate([ 0, 0, REED_SWITCH_HOLDER_HEIGHT + 5 ]) reed_switch_holder(false);
