$fn = $preview ? 35 : 100;
EPSILON = 0.01;

WALL_THICKNESS = 0.6;
SHADE_WIDTH = 255;

// Calculate SHADE_HEIGHT from max width,
// so that the max width is always 256 on all sides
// Ratio = z: 217.77, y:269.17, x: 256
// Make sure y is 256
SHADE_HEIGHT = SHADE_WIDTH / 2 / sin(180 / 5) * (256 / 269.17);

DISC_HEIGHT = 2;
DISC_DIAMETER = 64;
DISC_HOLE_DIAMETER = 29;
TOP_RING_DIAMETER = 42;
TOP_RING_HEIGHT = 7;
TOP_RING_WIDTH = 1.2;
TOTAL_HEIGHT = DISC_HEIGHT + TOP_RING_HEIGHT;

module box(size) { cube([ 2 * size, 2 * size, size ], center = true); }

module dodecahedron(size) {
  rotate([ 0, 0, 90 / 5 ]) {
    dihedral = 116.565;
    intersection() {
      box(size);
      intersection_for(i = [1:5]) {
        rotate([ dihedral, 0, 360 / 5 * i ]) box(size);
      }
    }
  }
}

difference() {
  dodecahedron(SHADE_HEIGHT);
  dodecahedron(SHADE_HEIGHT - WALL_THICKNESS * 2);
  translate([ 0, 0, SHADE_HEIGHT / 2 ])
      cube([ 256, 256, WALL_THICKNESS * 2 + EPSILON ], center = true);

  // cylinder(h = SHADE_HEIGHT * 2, r = 20, center = true);

  translate([ 0, 0, -SHADE_HEIGHT / 2 ]) difference() {
    cylinder(h = TOTAL_HEIGHT * 2, r = DISC_HOLE_DIAMETER / 2, center = true);
  }
}

translate([ 0, 0, -SHADE_HEIGHT / 2 ]) difference() {
  union() {
    // cylinder(h = DISC_HEIGHT, r = DISC_DIAMETER / 2, center = true);
    difference() {
      translate([ 0, 0, (DISC_HEIGHT + TOP_RING_HEIGHT) / 2 ]) cylinder(
          h = TOP_RING_HEIGHT, r = TOP_RING_DIAMETER / 2, center = true);
      translate([ 0, 0, (DISC_HEIGHT + TOP_RING_HEIGHT) / 2 ]) cylinder(
          h = TOP_RING_HEIGHT + EPSILON,
          r = TOP_RING_DIAMETER / 2 - (TOP_RING_WIDTH * 2), center = true);
    }
  }
  cylinder(h = TOTAL_HEIGHT * 2, r = DISC_HOLE_DIAMETER / 2, center = true);
}
