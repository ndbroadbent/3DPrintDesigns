$fn = $preview ? 25 : 100;
EPSILON = 0.01;

// 7mm from top
// 6.5mm from side
// Bracket:
//  20mm length
//  16.5mm wide
// Hole diameter: 4mm, radius: 2mm

// bracket
// difference() {
//   cube([ 20, 16.5, 1 ], center = true);
//   cylinder(height = 10, r = 4, center = true)
// }

WALL_OFFSET = 7;

// padding
difference() {
  cube([ 20, 16.5 + WALL_OFFSET, 7 ], center = true);
  translate([ 0, WALL_OFFSET / 2, 0 ]) cylinder(h = 10, r = 2, center = true);
}
