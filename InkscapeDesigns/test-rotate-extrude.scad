include <threads.scad>;

$fn = $preview ? 25 : 100;
EPSILON = 0.01;


import(file = "test-rotate-extrude.svg", center = false, dpi = 96);
