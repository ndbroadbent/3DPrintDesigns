$fn = $preview ? 50 : 250;
EPSILON = 0.01;

scale(1.5) difference() {
  union() {
    translate([ -17, -4, 0 ]) linear_extrude(height = 10) scale(v = 0.4)
        import(file = "bracket.svg", center = false, dpi = 96);

    translate([ 8.5, 96, 5 ]) rotate([ 90, 0, 0 ]) {
      difference() {
        cylinder(h = 75, r = 3.3);
        translate([ -5, -5, -1 ]) cube([ 5, 10, 80 ]);
      }
    }
  }
  translate([ 0, 10, 5 ]) rotate([ 0, 90, 0 ]) cylinder(h = 20, r = 3 / 2);
  translate([ 35, 92, 5 ]) rotate([ 0, 90, -35 ]) cylinder(h = 10, r = 3 / 2);
}
