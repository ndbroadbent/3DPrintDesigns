$fn = $preview ? 50 : 128;
EPSILON = 0.01;

module pipe_bend(radius, inner_radius, bend_radius, angle_1, angle_2, length) {
  union() {
    // lower arm
    rotate([ 0, 0, angle_1 ]) translate([ bend_radius + radius, 0.02, 0 ])
        rotate([ 90, 0, 0 ]) difference() {
      cylinder(r = radius, h = length);
      translate([ 0, 0, -1 ]) cylinder(r = inner_radius, h = length + 2);
    }
    // upper arm
    rotate([ 0, 0, angle_2 ]) translate([ bend_radius + radius, -0.02, 0 ])
        rotate([ -90, 0, 0 ]) difference() {
      cylinder(r = radius, h = length);
      translate([ 0, 0, -1 ]) cylinder(r = inner_radius, h = length + 2);
    }

    // bend
    difference() {
      // torus
      rotate_extrude() translate([ bend_radius + radius, 0, 0 ])
          circle(r = radius);

      // torus cutout
      rotate_extrude() translate([ bend_radius + radius, 0, 0 ])
          circle(r = inner_radius);

      // lower cutout
      rotate([ 0, 0, angle_1 ]) translate(
          [ -100 * (((angle_2 - angle_1) <= 180) ? 1 : 0), -200, -100 ])
          cube([ 200, 200, 200 ]);

      // upper cutout
      rotate([ 0, 0, angle_2 ])
          translate([ -100 * (((angle_2 - angle_1) <= 180) ? 1 : 0), 0, -100 ])
              cube([ 200, 200, 200 ]);
    }
  }
}

thickness = 3;
inner_diameter = 32.25;
fitting_length = 18;

difference() {
  pipe_bend(radius = inner_diameter / 2 + thickness, inner_radius = 0,
            bend_radius = 20, angle_1 = 0, angle_2 = 90,
            length = fitting_length);

  translate([ thickness, thickness, 0 ])
      pipe_bend(radius = inner_diameter / 2, inner_radius = 0, bend_radius = 20,
                angle_1 = 0, angle_2 = 90, length = fitting_length + 20);
}
