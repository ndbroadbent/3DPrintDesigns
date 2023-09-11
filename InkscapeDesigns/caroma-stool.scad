include <threads.scad>;

$fn = $preview ? 50 : 250;
EPSILON = 0.01;

module stool() {
  rotate_extrude(angle = 360) translate([ 0, -112.8, 0 ]) rotate([ 0, 180, 0 ])
      import(file = "caroma-stool.svg", center = false, dpi = 96);
}

module hollow_center() {
  intersection() {
    cylinder(h = 220, r = 100, center = true);
    difference() {
      scale(v = [ 0.92, 0.92, 1 ]) stool();
      translate([ 0, 0, -12 ]) cylinder(h = 40, r = 100, center = true);
    }
  }
}

module top_half() {
  difference() {
    stool();
    translate([ 0, 0, -100 ]) cube([ 200, 200, 200 ], center = true);
    hollow_center();
  }
  translate([ 0, 0, -12 ]) difference() {
    cylinder(h = 25, r1 = 21, r2 = 25, center = true);
    cylinder(h = 25 + EPSILON, r = 16, center = true);
  }
}

module bottom_half() {
  difference() {
    stool();
    translate([ 0, 0, 100 ]) cube([ 200, 200, 200 ], center = true);
    hollow_center();
    translate([ 0, 0, -12 ])
        cylinder(h = 26, r1 = 21.1, r2 = 25.1, center = true);
  }
}

// stool();
// hollow_center();
top_half();
// bottom_half();

// difference() {
//   bottom_half();
//   translate([ 0, 0, 50 ]) cube([ 200, 200, 200 ], center = true);
// }
