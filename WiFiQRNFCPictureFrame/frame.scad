$fn = $preview ? 50 : 170;

HEIGHT = 35;
PLEXIGLASS_WIDTH = 3;

difference() {
    cube([150, 150, HEIGHT], center = true);
    translate([0,0,-5])
        cube([125, 125, HEIGHT+5], center = true); 
     translate([0,0,4])
        cube([142, 142, HEIGHT], center = true);   
}

//cube([132, 132, 4], center=true);
//
//intersection() {
//translate([-3,0,2])
//rotate([0,90,0])
//    difference() {
//    cylinder(h=6, r=8);  
//    }
//translate([0,0,5])
//cube([50,50,12], center=true);
//}
