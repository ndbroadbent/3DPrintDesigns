$fn = $preview ? 35 : 100;
EPSILON = 0.01;

dihedral = 116.565;
size = 100;

module box(size) { cube([ 2 * size, 2 * size, size ], center = true); }

module dodecahedron(size) {
  intersection() {
    box(size);
    intersection_for(i = [1:5]) {
      rotate([ dihedral, 0, 360 / 5 * i ]) box(size);
    }
  }
}
dodecahedron(100);

// intersection() {
//   color([ 1, 0, 1 ]) box(size);
//   color([ 1, 0, 0 ]) rotate([ dihedral, 0, 360 / 5 * 0 ]) box(size);
//   color([ 0, 1, 0 ]) rotate([ dihedral, 0, 360 / 5 * 1 ]) box(size);
//   color([ 0, 0, 1 ]) rotate([ dihedral, 0, 360 / 5 * 2 ]) box(size);
//   color([ 1, 1, 0 ]) rotate([ dihedral, 0, 360 / 5 * 3 ]) box(size);
//   color([ 0, 1, 1 ]) rotate([ dihedral, 0, 360 / 5 * 4 ]) box(size);
// }
