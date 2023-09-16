// https://www.thingiverse.com/thing:678913/files

$fn = $preview ? 15 : 100;
EPSILON = 0.01;
TOLERANCE = 0.3;
HEX_FACTOR = 1.155;

// Knurled hex nut holder
// Glyn Cowles Feb 2015
BOLT_THREAD_DIAMETER = 11.8;
BOLT_HOLE_TOLERANCE = 0.5;

// Total diameter of knob
knob_diameter = 28;
// Nut should stick out ~1mm so the metal is providing the force
nut_height = 9.8 - 1.2;
lid_height = 3;
height = nut_height + lid_height;

// Nut diameter (flat to flat)
nut_diameter = 18.88;
// Number of knurls
knurls = 12;

difference() {
  cylinder(h = height - EPSILON,
           r = knob_diameter / 2 + BOLT_HOLE_TOLERANCE / 2, $fn = 25);
  translate([ 0, 0, -EPSILON / 2 ]) {
    cylinder(h = height + EPSILON,
             r = BOLT_THREAD_DIAMETER / 2 + TOLERANCE / 2);

    translate([ 0, 0, -lid_height ])
        cylinder(h = height,
                 r = (nut_diameter / 2 * HEX_FACTOR) + TOLERANCE / 2, $fn = 6);
    for (r = [0:360 / knurls:360]) {
      rotate([ 0, 0, r ]) translate([ knob_diameter / 1.8, 0, 0 ]) cylinder(
          h = height, r = (knob_diameter / 5 + TOLERANCE) / 2, $fn = 15);
    }
  }
}
