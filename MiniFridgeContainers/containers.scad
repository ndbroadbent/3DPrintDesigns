include <../lib/roundedcube.scad>

$fn = $preview ? 15 : 100;
EPSILON = 0.01;

TOLERANCE = 0.3;

// BOTTOM_TRAY_WIDTH = 350;
// BOTTOM_TRAY_SIDE_PADDING = 40;
BOTTOM_TRAY_WIDTH = 330;
BOTTOM_TRAY_DEPTH = 70;
BOTTOM_TRAY_HEIGHT = 110;
BOTTOM_TRAY_HEIGHT_TO_BAR = 70;

TOP_TRAY_WIDTH = 215;
TOP_TRAY_DEPTH = 80;
TOP_TRAY_DEPTH_TO_HOLE_CENTER = 70;
TOP_TRAY_HEIGHT = 65;
TOP_TRAY_HEIGHT_TO_HOLE_CENTER = 45;
TOP_TRAY_THICKNESS = 3.5;
TOP_TRAY_NOTCH_WIDTH = 2;
TOP_TRAY_BOTTOM_RADIUS = 8;

// TOP_TRAY_BAR_LENGTH = 227;
TOP_TRAY_BAR_LENGTH = 227 - 8;
TOP_TRAY_BAR_WIDTH = 9;
TOP_TRAY_BAR_DEPTH = 5;
TOP_TRAY_BAR_THICKNESS = 2;

module top_tray_bar() {
  rotate([ 0, 90, 0 ]) difference() {
    hull() {
      cylinder(h = TOP_TRAY_BAR_LENGTH, r = TOP_TRAY_BAR_DEPTH / 2,
               center = true);
      translate([ TOP_TRAY_BAR_WIDTH - TOP_TRAY_BAR_DEPTH, 0, 0 ]) cylinder(
          h = TOP_TRAY_BAR_LENGTH, r = TOP_TRAY_BAR_DEPTH / 2, center = true);
    }
    // Hollow center
    // translate([ 0, 0, -EPSILON / 2 ]) hull() {
    //   cylinder(h = TOP_TRAY_BAR_LENGTH + EPSILON,
    //            r = (TOP_TRAY_BAR_DEPTH - TOP_TRAY_BAR_THICKNESS) / 2);
    //   translate([ TOP_TRAY_BAR_WIDTH - TOP_TRAY_BAR_DEPTH, 0, 0 ])
    //       cylinder(h = TOP_TRAY_BAR_LENGTH + EPSILON,
    //                r = (TOP_TRAY_BAR_DEPTH - TOP_TRAY_BAR_THICKNESS) / 2);
    // }
  }
}
// top_tray_bar();

module top_tray() {
  // hull() {
  //   translate([ TOP_TRAY_BOTTOM_RADIUS, TOP_TRAY_BOTTOM_RADIUS, 0 ])
  //       sphere(r = TOP_TRAY_BOTTOM_RADIUS);
  //   translate(
  //       [ TOP_TRAY_WIDTH - TOP_TRAY_BOTTOM_RADIUS, TOP_TRAY_BOTTOM_RADIUS, 0
  //       ]) sphere(r = TOP_TRAY_BOTTOM_RADIUS);

  //   translate([
  //     TOP_TRAY_BOTTOM_RADIUS,
  //     TOP_TRAY_DEPTH_TO_HOLE_CENTER - TOP_TRAY_BOTTOM_RADIUS * 2, 0
  //   ]) sphere(r = TOP_TRAY_BOTTOM_RADIUS);
  //   translate([
  //     TOP_TRAY_WIDTH - TOP_TRAY_BOTTOM_RADIUS,
  //     TOP_TRAY_DEPTH_TO_HOLE_CENTER - TOP_TRAY_BOTTOM_RADIUS * 2, 0
  //   ]) sphere(r = TOP_TRAY_BOTTOM_RADIUS);
  // }

  difference() {
    roundedcube(
        [ TOP_TRAY_WIDTH, TOP_TRAY_DEPTH_TO_HOLE_CENTER, TOP_TRAY_HEIGHT ],
        true, TOP_TRAY_BOTTOM_RADIUS);

    translate([ 0, -TOP_TRAY_THICKNESS, TOP_TRAY_THICKNESS ]) cube(
        [
          TOP_TRAY_WIDTH - TOP_TRAY_THICKNESS * 2,
          TOP_TRAY_DEPTH_TO_HOLE_CENTER - TOP_TRAY_THICKNESS * 2,
          TOP_TRAY_HEIGHT - TOP_TRAY_THICKNESS * 2

        ],
        center = true);
  }

  // cube([
  //   TOP_TRAY_WIDTH, TOP_TRAY_DEPTH_TO_HOLE_CENTER - TOP_TRAY_BOTTOM_RADIUS *
  //   2, TOP_TRAY_THICKNESS
  // ]);
  // cube([ TOP_TRAY_WIDTH, TOP_TRAY_THICKNESS, TOP_TRAY_HEIGHT ]);

  // cube([
  //   TOP_TRAY_THICKNESS,
  //   TOP_TRAY_DEPTH_TO_HOLE_CENTER - TOP_TRAY_BOTTOM_RADIUS * 2,
  //   TOP_TRAY_HEIGHT
  // ]);
  // translate([ TOP_TRAY_WIDTH - TOP_TRAY_THICKNESS, 0, 0 ]) cube([
  //   TOP_TRAY_THICKNESS,
  //   TOP_TRAY_DEPTH_TO_HOLE_CENTER - TOP_TRAY_BOTTOM_RADIUS * 2,
  //   TOP_TRAY_HEIGHT
  // ]);

  // Notches
  // translate([
  //   0, TOP_TRAY_DEPTH_TO_HOLE_CENTER / 2 - TOP_TRAY_THICKNESS,
  //   (-TOP_TRAY_BAR_WIDTH / 2) + TOP_TRAY_HEIGHT_TO_HOLE_CENTER / 2
  // ])
  //     cube(
  //         [
  //           TOP_TRAY_WIDTH + TOP_TRAY_NOTCH_WIDTH * 2, TOP_TRAY_THICKNESS,
  //           TOP_TRAY_BAR_WIDTH
  //         ],
  //         center = true);
  translate([
    0, TOP_TRAY_DEPTH_TO_HOLE_CENTER / 2 - TOP_TRAY_THICKNESS,
    (-TOP_TRAY_BAR_WIDTH / 2) + TOP_TRAY_HEIGHT_TO_HOLE_CENTER / 2
  ]) top_tray_bar();
}
top_tray();
