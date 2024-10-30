$fn = $preview ? 25 : 100;
epsilon = 0.01;

bottom_width = 43;
bottom_height = 82;
bottom_depth = 10;

top_width = 53;
top_height = 76;
top_depth = 4;

total_depth = bottom_depth + top_depth;

battery_terminal_slot_width = 36.5;
battery_terminal_slot_height = 82 - 60;
battery_terminal_slot_depth = 14;

body_height = bottom_height - battery_terminal_slot_height;

// screw_hole_size = 1.77;
// screwdriver_diameter = 3.5;

// impact driver bit: 7.5mm
// small screwdriver head: 8.5mm

screw_hole_size = 2.5;
screwdriver_diameter = 8.5;
screw_hole_head_depth = total_depth - 2.8;

screw_hole_distance = 25;

triangle_size = top_depth;
triangle_points =
    [[triangle_size, triangle_size], [triangle_size, 0], [0, triangle_size]];
triangle_paths = [[ 0, 1, 2 ]];

difference() {
  union() {
    translate([ (top_width - bottom_width) / 2, 0, top_depth ])
        cube([ bottom_width, bottom_height, bottom_depth ]);

    cube([ top_width, top_height, top_depth ]);
  }

  translate([
    (top_width - battery_terminal_slot_width) / 2,
    (battery_terminal_slot_height - bottom_height) * -1, -epsilon / 2
  ])
      cube([
        battery_terminal_slot_width + epsilon,
        battery_terminal_slot_height + epsilon, battery_terminal_slot_depth +
        epsilon
      ]);

  translate([
    0, bottom_height - triangle_size + epsilon, triangle_size + top_depth -
    epsilon
  ]) rotate([ 0, 90, 0 ]) linear_extrude(100)
      polygon(triangle_points, triangle_paths, 10);

  translate([ -epsilon, top_height - top_depth + epsilon, top_depth - epsilon ])
      rotate([ 0, 90, 0 ]) linear_extrude(100)
          polygon(triangle_points, triangle_paths, 10);

  xy_offsets = [ [ 1, -1, 0, 0 ], [ 0, 0, 1, -1 ] ];
  for (i = [0:3]) {
    translate([
      xy_offsets[0][i] * screw_hole_distance / 2,
      xy_offsets[1][i] * screw_hole_distance / 2, 0
    ]) color([ 1, 0, 1 ]) {
      translate([ top_width / 2, body_height / 2, -epsilon / 2 ]) {
        cylinder(h = total_depth + epsilon, d = screw_hole_size);
        cylinder(h = screw_hole_head_depth, d = screwdriver_diameter);
      }
    }
  }
}
