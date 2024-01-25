$fn = $preview ? 50 : 140;
EPSILON = 0.01;

module copy_mirror(vec) {
  children();
  mirror(vec) children();
}

module copy_rotate(vec) {
  children();
  rotate(vec) children();
}

// Need to add 1mm so it's not such a sharp angle, easier to print
LID_THICKNESS = 3.6 + 1;
LID_EDGE_THICKNESS = 1.35;

LID_DIAMETER = 249;
LID_CHAMFER_LENGTH = 5.4;
LID_CHAMFER_THICKNESS = LID_THICKNESS - LID_EDGE_THICKNESS;

HANDLE_BOTTOM_LENGTH = 193.5;
HANDLE_TOP_LENGTH = 168;
HANDLE_HEIGHT = 14;
HANDLE_BOTTOM_WIDTH = 16.6;
HANDLE_TOP_WIDTH = 15;

// Top lid
module lid() {
  cylinder(h = LID_EDGE_THICKNESS, d = LID_DIAMETER);
  translate([ 0, 0, LID_EDGE_THICKNESS ])
      cylinder(h = LID_THICKNESS - LID_EDGE_THICKNESS, d1 = LID_DIAMETER,
               d2 = LID_DIAMETER - LID_CHAMFER_LENGTH * 2);
}

module test_strip() {
  translate([ 0, 0, LID_THICKNESS / 2 ]) cube(
      [ HANDLE_BOTTOM_LENGTH + 20, HANDLE_BOTTOM_WIDTH + 20, LID_THICKNESS ],
      center = true);
}

module handle(tolerance = 0) {
  bottom_length = HANDLE_BOTTOM_LENGTH + tolerance * 2;
  bottom_width = HANDLE_BOTTOM_WIDTH + tolerance * 2;
  top_length = HANDLE_TOP_LENGTH + tolerance * 2;
  top_width = HANDLE_TOP_WIDTH + tolerance * 2;

  bottom_length_shrunk = HANDLE_BOTTOM_LENGTH - tolerance * 2;
  bottom_width_shrunk = HANDLE_BOTTOM_WIDTH - tolerance * 2;
  top_length_shrunk = HANDLE_TOP_LENGTH - tolerance * 2;
  top_width_shrunk = HANDLE_TOP_WIDTH - tolerance * 2;

  handle_length_diff = (bottom_length - top_length) / 2;
  handle_width_diff = (bottom_width - top_width) / 2;

  // Lid handle (inset into the lid so it can be super glued in place)
  HANDLE_CUBE_LENGTH_MARGIN = 15 + (tolerance * 0.5);
  HANDLE_CUBE_WIDTH_MARGIN = 5 + (tolerance * 0.5);
  HANDLE_RECT_INSET_COUNT = 4;
  total_margins = HANDLE_RECT_INSET_COUNT + 1;
  total_margin_length = HANDLE_CUBE_LENGTH_MARGIN * total_margins;
  total_rect_length = bottom_length_shrunk - total_margin_length;
  rect_length = total_rect_length / HANDLE_RECT_INSET_COUNT;
  rect_plus_margin = rect_length + HANDLE_CUBE_LENGTH_MARGIN;

  HandlePoints = [
    [ 0, 0, 0 ],                                               // 0
    [ 0, bottom_length, 0 ],                                   // 1
    [ bottom_width, bottom_length, 0 ],                        // 2
    [ bottom_width, 0, 0 ],                                    // 3
    [ handle_width_diff, handle_length_diff, HANDLE_HEIGHT ],  // 4
    [
      handle_width_diff, bottom_length - handle_length_diff,
      HANDLE_HEIGHT
    ],  // 5
    [
      HANDLE_TOP_WIDTH + handle_width_diff, bottom_length - handle_length_diff,
      HANDLE_HEIGHT
    ],  // 6
    [ HANDLE_TOP_WIDTH + handle_width_diff, handle_length_diff, HANDLE_HEIGHT ]
  ];  // 7

  HandleFaces = [
    [ 0, 1, 2, 3 ],  // bottom
    [ 4, 5, 1, 0 ],  // front
    [ 7, 6, 5, 4 ],  // top
    [ 5, 6, 2, 1 ],  // right
    [ 6, 7, 3, 2 ],  // back
    [ 7, 4, 0, 3 ]
  ];  // left

  translate([ 0, 0, LID_THICKNESS + EPSILON ]) {
    rotate([ 0, 0, 90 ]) {
      translate([ bottom_width / -2, bottom_length / -2, 0 ]) {
        polyhedron(HandlePoints, HandleFaces);
        translate([ 0, 0, -LID_CHAMFER_THICKNESS ]) difference() {
          cube([ bottom_width, bottom_length, LID_CHAMFER_THICKNESS ]);

          for (i = [ 0, 1, 2, 3 ]) {
            translate([
              HANDLE_CUBE_WIDTH_MARGIN +
                  (bottom_width - bottom_width_shrunk) / 2,
              HANDLE_CUBE_LENGTH_MARGIN + (rect_plus_margin * i) +
                  (bottom_length - bottom_length_shrunk) / 2,
              -EPSILON
            ])
                cube([
                  bottom_width_shrunk - HANDLE_CUBE_WIDTH_MARGIN * 2,
                  rect_length,
                  LID_CHAMFER_THICKNESS
                ]);
          }
        }
      }
    }
  }
}

BOTTOM_CIRCLE_THICKNESS = 2.6;
BOTTOM_CIRCLE_DIAMETER = 196;
BOTTOM_CIRCLE_INNER_DIAMETER =
    BOTTOM_CIRCLE_DIAMETER - BOTTOM_CIRCLE_THICKNESS * 2;
BOTTOM_CIRCLE_HEIGHT = 18;

BOTTOM_DIVIDER_LINE_THICKNESS = 1.9;
BOTTOM_DIVIDER_LINE_HEIGHT = 8.6;

module bottom_circle() {
  // bottom circle
  translate([ 0, 0, -BOTTOM_CIRCLE_HEIGHT / 2 ]) {
    difference() {
      cylinder(h = BOTTOM_CIRCLE_HEIGHT, d = BOTTOM_CIRCLE_DIAMETER,
               center = true);
      cylinder(h = BOTTOM_CIRCLE_HEIGHT + 0.01,
               d = BOTTOM_CIRCLE_INNER_DIAMETER, center = true);
    }
  }

  SMALL_TAB_OUTER_OFFSET = 17.8;
  SMALL_TAB_CENTER_OFFSET =
      BOTTOM_CIRCLE_INNER_DIAMETER / 2 - SMALL_TAB_OUTER_OFFSET;
  SMALL_TAB_LENGTH = 5.1;
  SMALL_TAB_HEIGHT = 13.6;

  // divider line
  difference() {
    translate([ 0, 0, -BOTTOM_DIVIDER_LINE_HEIGHT / 2 ]) {
      cube(
          [
            BOTTOM_DIVIDER_LINE_THICKNESS,
            BOTTOM_CIRCLE_DIAMETER - BOTTOM_CIRCLE_THICKNESS / 2,
            BOTTOM_DIVIDER_LINE_HEIGHT
          ],
          center = true);
    }
    // remove holes
    translate([ 0, 0, -CENTER_HOLE_HEIGHT / 2 ])
        cylinder(h = CENTER_HOLE_HEIGHT + 0.01, d = CENTER_HOLE_INNER_DIAMETER,
                 center = true);
    translate([ 0, SIDE_HOLE_CENTER_OFFSET, SIDE_HOLE_HEIGHT / -2 ])
        cylinder(h = SIDE_HOLE_HEIGHT + 0.01, d = SIDE_HOLE_INNER_DIAMETER,
                 center = true);
  }

  // Small tab next to side hole
  translate([
    0, SMALL_TAB_LENGTH / -2 + SMALL_TAB_CENTER_OFFSET, SMALL_TAB_HEIGHT / -2
  ]) cube([ BOTTOM_DIVIDER_LINE_THICKNESS, SMALL_TAB_LENGTH, SMALL_TAB_HEIGHT ],
          center = true);

  CENTER_HOLE_DIAMETER = 8.46;
  CENTER_HOLE_INNER_DIAMETER = 3.35;
  CENTER_HOLE_HEIGHT = 12.5;

  translate([ 0, 0, -CENTER_HOLE_HEIGHT / 2 ]) {
    difference() {
      cylinder(h = CENTER_HOLE_HEIGHT, d = CENTER_HOLE_DIAMETER, center = true);
      cylinder(h = CENTER_HOLE_HEIGHT + 0.01, d = CENTER_HOLE_INNER_DIAMETER,
               center = true);
    }
  }

  SIDE_HOLE_OUTER_OFFSET = 25.2;
  SIDE_HOLE_CENTER_OFFSET =
      BOTTOM_CIRCLE_INNER_DIAMETER / 2 - SIDE_HOLE_OUTER_OFFSET;
  SIDE_HOLE_DIAMETER = 8;
  SIDE_HOLE_INNER_DIAMETER = 3.35;
  SIDE_HOLE_HEIGHT = 12.29;

  translate([ 0, SIDE_HOLE_CENTER_OFFSET, SIDE_HOLE_HEIGHT / -2 ])
      difference() {
    cylinder(h = SIDE_HOLE_HEIGHT, d = SIDE_HOLE_DIAMETER, center = true);
    cylinder(h = SIDE_HOLE_HEIGHT + 0.01, d = SIDE_HOLE_INNER_DIAMETER,
             center = true);
  }

  // 4x locking tabs

  LOCK_TAB_WIDTH = 10.6;
  LOCK_TAB_EXTRUSION_WIDTH = LOCK_TAB_WIDTH * 5;
  LOCK_TAB_THICKNESS = 2.5;
  LOCK_TAB_LEFT_HEIGHT = 5;
  LOCK_TAB_LEFT_LENGTH = 4.2;

  LOCK_TAB_LEFT_MAX_Z = 8.03;
  LOCK_TAB_MIDDLE_MAX_Z = 6.3;
  LOCK_TAB_MIDDLE_Z_OFFSET = LOCK_TAB_LEFT_MAX_Z - LOCK_TAB_MIDDLE_MAX_Z;

  LOCK_TAB_MIDDLE_LENGTH = 54;
  LOCK_TAB_RIGHT_MAX_Z = 4.4;
  LOCK_TAB_RIGHT_LENGTH = 9.9;

  LOCK_TAB_RIGHT_Z_OFFSET = LOCK_TAB_MIDDLE_MAX_Z - LOCK_TAB_RIGHT_MAX_Z;

  LOCK_TAB_MIDDLE_X1 = LOCK_TAB_LEFT_LENGTH;
  LOCK_TAB_MIDDLE_X2 = LOCK_TAB_MIDDLE_X1 + LOCK_TAB_MIDDLE_LENGTH;
  LOCK_TAB_MIDDLE_Y1 = LOCK_TAB_LEFT_HEIGHT;
  LOCK_TAB_MIDDLE_Y2 = LOCK_TAB_MIDDLE_Y1 + LOCK_TAB_MIDDLE_Z_OFFSET;

  LOCK_TAB_RIGHT_X1 = LOCK_TAB_MIDDLE_X1 + LOCK_TAB_MIDDLE_LENGTH;
  LOCK_TAB_RIGHT_X2 = LOCK_TAB_RIGHT_X1 + LOCK_TAB_RIGHT_LENGTH;
  LOCK_TAB_RIGHT_Y1 = LOCK_TAB_MIDDLE_Y2;
  LOCK_TAB_RIGHT_Y2 = LOCK_TAB_RIGHT_Y1 + LOCK_TAB_RIGHT_Z_OFFSET;
  // rotate([ 90, 0, 0 ]) square(size = [ 20, 40 ], center = true);

  LOCK_TAB_Z_OFFSET = 4.2;

  LOCK_TAB_TOTAL_LENGTH =
      LOCK_TAB_LEFT_LENGTH + LOCK_TAB_MIDDLE_LENGTH + LOCK_TAB_RIGHT_LENGTH;

  copy_rotate([ 0, 0, 180 ]) copy_rotate([ 0, 0, 90 ]) intersection() {
    translate([
      0, BOTTOM_CIRCLE_INNER_DIAMETER / 2, -LOCK_TAB_Z_OFFSET
    ]) mirror([ 1, 0, 0 ]) translate([ 0, LOCK_TAB_EXTRUSION_WIDTH / 2,
                                       0 ]) rotate([ 90, 180, 0 ])
        linear_extrude(height = LOCK_TAB_EXTRUSION_WIDTH) polygon(points = [
          [ 0, 0 ],                     // bottom left
          [ 0, LOCK_TAB_LEFT_HEIGHT ],  // top left
          [
            LOCK_TAB_MIDDLE_X1, LOCK_TAB_MIDDLE_Y1
          ],  // top left of middle part
          [
            LOCK_TAB_MIDDLE_X2, LOCK_TAB_MIDDLE_Y2
          ],                                         // top right of middle part
          [ LOCK_TAB_RIGHT_X1, LOCK_TAB_RIGHT_Y1 ],  // top left of right part
          [ LOCK_TAB_RIGHT_X2, LOCK_TAB_RIGHT_Y2 ],  // top right of right part
          [
            LOCK_TAB_RIGHT_X2, LOCK_TAB_RIGHT_Y2 - LOCK_TAB_THICKNESS
          ],  // bottom right of right part
          [
            LOCK_TAB_RIGHT_X1, LOCK_TAB_RIGHT_Y1 - LOCK_TAB_THICKNESS
          ],  // bottom left of right part

          [
            LOCK_TAB_MIDDLE_X1, LOCK_TAB_MIDDLE_Y1 - LOCK_TAB_THICKNESS
          ],                         // bottom left of middle part
          [ LOCK_TAB_MIDDLE_X1, 0 ]  // bottom right of left part
        ]);

    // Constrain lock tabs to this circular area around the center
    translate([ 0, 0, -BOTTOM_CIRCLE_HEIGHT / 2 ]) difference() {
      cylinder(h = BOTTOM_CIRCLE_HEIGHT,
               d = BOTTOM_CIRCLE_DIAMETER + LOCK_TAB_WIDTH * 2, center = true);
      cylinder(h = BOTTOM_CIRCLE_HEIGHT + 0.01,
               d = BOTTOM_CIRCLE_INNER_DIAMETER, center = true);
    }
  }
}

// difference() {
//   lid();
//   handle(0.2);
// }
// bottom_circle();

// difference() {
//   test_strip();
//   handle(0.2);
// }

handle();

// lid();
