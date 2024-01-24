$fn = $preview ? 15 : 100;
EPSILON = 0.01;

bottom_radius = 102.5 / 2;
bottom_thickness = 2.4;

dome_height = 70;
dome_z_scale = dome_height / bottom_radius;

bottom_to_lip_z_offset = 3;
bottom_indent_length = 10;
bottom_indent_thickness = 1.6;
lip_thickness = 5;
lip_radius = bottom_radius - bottom_thickness + lip_thickness;
lip_height = 3;
lip_notch_width = 2.3 + 0.5;
lip_notch_height = 2.6 + 0.4;
lip_spacing = 45;
lip_taper_length = 34.6;
lip_taper_initial_height = 1.8;

top_tube_dome_z_offset = 6.2;
top_tube_bottom_radius = 30.4 / 2;
top_tube_top_radius = 30 / 2;
top_tube_thickness = 2.8;
top_tube_inner_radius = top_tube_top_radius - top_tube_thickness;
top_tube_upper_height = 33;
top_tube_lower_height = 9;
top_tube_total_height = top_tube_upper_height + top_tube_lower_height;
top_tube_notch_width = 5.2;
top_tube_notch_thickness = 3.3;

top_tube_triangle_width = 16;
top_tube_triangle_thickness = 8;
top_tube_triangle_border_radius = 2;
top_tube_triangle_screw_hole_radius = 2 / 2;

// bottom_lip_z_

total_height = dome_height + top_tube_total_height;

module copy_mirror(vec) {
  children();
  mirror(vec) children();
}

module dome() {
  difference() {
    scale([ 1, 1, dome_z_scale ]) {
      difference() {
        sphere(bottom_radius, $fn = $preview ? 25 : 180);
        sphere(bottom_radius - bottom_thickness, $fn = $preview ? 25 : 180);
        translate([ 0, 0, (bottom_radius + EPSILON) * -1 ]) cube(
            [
              bottom_radius * 2 + EPSILON, bottom_radius * 2 + EPSILON,
              bottom_radius * 2 +
              EPSILON
            ],
            center = true);
      }
    }

    copy_mirror([ 1, 0, 0 ]) copy_mirror([ 0, 1, 0 ]) rotate([ 0, 0, -22 ])
        translate([ -bottom_indent_thickness, 0, 0 ]) intersection() {
      difference() {
        cylinder(h = bottom_to_lip_z_offset, r = bottom_radius);
        translate([ 0, 0, -EPSILON / 2 ])
            cylinder(h = bottom_to_lip_z_offset + EPSILON,
                     r = bottom_radius - bottom_thickness);
      }
      translate([
        bottom_indent_length / -2 - bottom_radius + bottom_thickness * 2, 0,
        bottom_to_lip_z_offset / 2
      ])
          cube(
              [
                bottom_indent_length, bottom_indent_length,
                bottom_to_lip_z_offset
              ],
              center = true);
    }
  }

  // Lip
  difference() {
    translate([ 0, 0, bottom_to_lip_z_offset ]) {
      difference() {
        cylinder(h = lip_height, r = lip_radius);
        // Cut out sides
        cube([ lip_radius * 3, lip_spacing, lip_height * 3 ], center = true);
      }

      // Notches
      rotate([ 0, 0, -25 ])
          translate([ 0, 0, lip_height + lip_notch_height / 2 ]) {
        cube([ lip_notch_width, lip_radius * 2, lip_notch_height ],
             center = true);
      }
    }

    sphere(bottom_radius - bottom_thickness);

    // Tapered cut outs for lip
    translate([
      -lip_radius + lip_spacing / 1.5, -lip_radius + lip_spacing / 2.9,
      bottom_to_lip_z_offset +
      lip_taper_initial_height
    ]) translate([ 20 / -2, lip_taper_length / -2, 0 ]) rotate([ 0, 0, 45 ]) {
      taper_points = [
        [ 0, 0, lip_height - lip_taper_initial_height ],   // 0
        [ 20, 0, lip_height - lip_taper_initial_height ],  // 1
        [ 20, lip_taper_length, 0 ],                       // 2
        [ 0, lip_taper_length, 0 ],                        // 3
        [ 0, 0, lip_height ],                              // 4
        [ 20, 0, lip_height ],                             // 5
        [ 20, lip_taper_length,
          lip_height ],                      // 6
        [ 0, lip_taper_length, lip_height ]  // 7
      ];

      taper_faces = [
        [ 0, 1, 2, 3 ],  // bottom
        [ 4, 5, 1, 0 ],  // front
        [ 7, 6, 5, 4 ],  // top
        [ 5, 6, 2, 1 ],  // right
        [ 6, 7, 3, 2 ],  // back
        [ 7, 4, 0, 3 ]   // left
      ];

      polyhedron(taper_points, taper_faces);
    }

    mirror([ 1, 1, 0 ]) translate([
      -lip_radius + lip_spacing / 1.5, -lip_radius + lip_spacing / 4.2,
      bottom_to_lip_z_offset +
      lip_taper_initial_height
    ]) translate([ 20 / -2, lip_taper_length / -2, 0 ]) rotate([ 0, 0, 45 ]) {
      taper_points = [
        [ 0, 0, 0 ],                                                      // 0
        [ 20, 0, 0 ],                                                     // 1
        [ 20, lip_taper_length, lip_height - lip_taper_initial_height ],  // 2
        [ 0, lip_taper_length, lip_height - lip_taper_initial_height ],   // 3
        [ 0, 0, lip_height ],                                             // 4
        [ 20, 0, lip_height ],                                            // 5
        [ 20, lip_taper_length,
          lip_height ],                      // 6
        [ 0, lip_taper_length, lip_height ]  // 7
      ];

      taper_faces = [
        [ 0, 1, 2, 3 ],  // bottom
        [ 4, 5, 1, 0 ],  // front
        [ 7, 6, 5, 4 ],  // top
        [ 5, 6, 2, 1 ],  // right
        [ 6, 7, 3, 2 ],  // back
        [ 7, 4, 0, 3 ]   // left
      ];

      polyhedron(taper_points, taper_faces);
    }
  }
}

module top_tube() {
  translate(
      [ 0, 0, dome_height - top_tube_lower_height - top_tube_dome_z_offset ]) {
    difference() {
      union() {
        translate([ 0, 0, top_tube_lower_height ]) {
          cylinder(h = top_tube_upper_height, r1 = top_tube_bottom_radius,
                   r2 = top_tube_top_radius);
        }
        cylinder(h = top_tube_lower_height, r = top_tube_bottom_radius);
      }
      translate([ 0, 0, -EPSILON / 2 ])
          cylinder(h = top_tube_total_height + EPSILON,
                   r1 = top_tube_bottom_radius - top_tube_thickness,
                   r2 = top_tube_top_radius - top_tube_thickness);
    }

    translate([
      0,
      top_tube_notch_thickness / 2 + top_tube_top_radius - top_tube_thickness,
      top_tube_total_height / 2
    ])
        cube(
            [
              top_tube_notch_width, top_tube_notch_thickness,
              top_tube_total_height
            ],
            center = true);

    // triangle bit
    translate([ 0, -top_tube_bottom_radius + top_tube_thickness, 0 ]) {
      difference() {
        hull() {
          linear_extrude(height = top_tube_lower_height) {
            translate([
              -top_tube_triangle_width / 2 + top_tube_triangle_border_radius,
              -top_tube_triangle_border_radius, 0
            ]) circle(r = top_tube_triangle_border_radius);

            translate([
              top_tube_triangle_width / 2 - top_tube_triangle_border_radius,
              -top_tube_triangle_border_radius, 0
            ]) circle(r = top_tube_triangle_border_radius);

            translate([
              0, -top_tube_triangle_thickness + top_tube_triangle_border_radius,
              0
            ]) circle(r = top_tube_triangle_border_radius);
          }
        }

        // screw hole
        translate([
          0,
          -top_tube_triangle_thickness + top_tube_triangle_border_radius * 1.5,
          -EPSILON
        ]) cylinder(h = top_tube_lower_height,
                    r = top_tube_triangle_screw_hole_radius);
      }
    }
  }
}

top_tube();

difference() {
  dome();
  translate([ 0, 0, total_height / 2 ])
      cylinder(h = total_height, r = top_tube_inner_radius, center = true);
}
