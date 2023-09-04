$fn=100;

seed = 12;


difference() {
  difference() {
    for(x=[0:16])
      for(y=[0:16])
        translate([x*10, y*10, 0])
          cylinder(
              r = 5 + rands(0, 5, 1, seed + x + (y * x))[0],
              h = sin(x * 20) * sin(y * 20) * 30 + 35 -
                rands(0, 3, 1, seed + x + (y * x))[0] );

    for(x=[0:10])
      for(y=[0:10])
        translate([x*10, y*10, 0])
          cube([
            3 + sin(x * 20) * 3,
            3 + sin(x * 20) * 3,
            200], center=true);

  }

  // Cut out an interesting wave formation
  for(x=[0:10])
    for(y=[0:16])
      translate([x*10, y*10, 0])
        cube([
          3 + cos(x * 20) * 10 + sin(y * 20) * 3,
          3 + cos(x * 20) * 10 + sin(y * 20) * 3,
          200], center=true);


  translate([-85, -40, -10])
    cube([100, 400, 300]);
}
