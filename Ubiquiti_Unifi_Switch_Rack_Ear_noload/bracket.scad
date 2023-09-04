$fn = $preview ? 20 : 100;

// Parameters
front_thickness = 3.6;
front_width = 17;
side_thickness = 1.35;
side_height = 42.85;
side_inner_width = 48;  // Inner width (not including front thickness)
side_width = side_inner_width + side_thickness;

front_slot_length = 12.5;
m6_thread_diameter = 5.87;
small_screw_thread_diameter = 3.87;
small_screw_head_diameter = 7;
small_screw_head_length = 2.22;
hole_edge_offset = 9;
hole_spacing = 25;  // Center of 4 side holes are 25mm apart

conical_part_extension = 0;

// Front part with pill-shaped slot for M6 screw
module front() {
  difference() {
    cube([ front_thickness, front_width, side_height ]);

    // Pill-shaped slot
    rectangle_length = front_slot_length - m6_thread_diameter;
    translate([ front_thickness / 2, front_width / 2, side_height / 2 ])
        cube([ front_width + 2, rectangle_length, m6_thread_diameter ],
             center = true);

    translate([
      front_thickness / 2, front_width / 2 + rectangle_length / 2,
      side_height / 2
    ]) rotate([ 0, 90, 0 ]) cylinder(r = m6_thread_diameter / 2,
                                     h = front_width + 2, center = true);
    translate([
      front_thickness / 2, front_width / 2 - rectangle_length / 2,
      side_height / 2
    ]) rotate([ 0, 90, 0 ]) cylinder(r = m6_thread_diameter / 2,
                                     h = front_width + 2, center = true);
  }
}

// Side part with countersunk holes
module side() {
  difference() {
    cube([ side_width, side_thickness, side_height ]);

    y_offset = small_screw_head_length - conical_part_extension + 0.2;
    for (x_offset =
             [
               side_width - hole_edge_offset - hole_spacing, side_width -
               hole_edge_offset
             ],
        z_offset = [ hole_edge_offset, side_height - hole_edge_offset ]) {
      translate([ x_offset, -y_offset, z_offset ]) countersunkHole();
    }
  }
}

// Countersunk hole for small screws
module countersunkHole() {
  rotate([ 270, 0, 0 ]) {
    translate([ 0, 0, side_thickness / 2 ])
        cylinder(r = small_screw_thread_diameter / 2, h = side_thickness + 2,
                 center = true);
    translate([ 0, 0, side_thickness / 2 + small_screw_head_length ])
        cylinder(r2 = small_screw_head_diameter / 2,
                 r1 = small_screw_thread_diameter / 2,
                 h = small_screw_head_length, center = true);
  }
}

// Assemble the bracket
translate([ 0, 0, 0 ]) front();
translate([ front_thickness, 0, 0 ]) side();
