include <BOSL2/std.scad>
// The Belfry OpenSCAD Library V2
// Source: https://github.com/revarbat/BOSL2
// Documentation: https://github.com/revarbat/BOSL2/wiki
// BOSL2 is licensed under BSD 2-Clause License
//    https://github.com/revarbat/BOSL2/blob/master/LICENSE

////////////////////////////////////////////////////////////////////
// cell: takes three parameters and returns a single hexagonal cell
//
//   SW_hole: scalar value that specifies the width across the flats
//     of the interior hexagon
//   height: scalar value that specifies the height/depth of the 
//     cell (i.e. distance from from front to back
//   wall: scalar vale that specifies the thickness of the wall 
//     surrounding the interior hex (hole). e.g. if SW_hole is 8 
//     and wall is 2 then the total width across the flats of the
//     cell is 8 + 2(2) = 12.
////////////////////////////////////////////////////////////////////
module cell(SW_hole, height, wall) {
  tol = 0.001; // used to clean up difference artifacts
  difference() {
    cyl(d=SW_hole+2*wall,h=height,$fn=6,circum=true);
    cyl(d=SW_hole,h=height+tol,$fn=6,circum=true);
  }
}

////////////////////////////////////////////////////////////////////
// grid: takes three parameters and returns the initial grid of 
//    hexagons
//
//    size: 3-vector (x,y,z) that specifies the  size of the cube 
//      that contains the hex grid
//    cell_hole: scalar value specifying width across flats of the 
//      interior hexagon (hole)
//    cell_wall: scalar value that specifies wall thickness of the
//      hexagon
////////////////////////////////////////////////////////////////////
module hexgrid(size,cell_hole,cell_wall) {
  dx=cell_hole*sqrt(3)+cell_wall*sqrt(3);
  dy=cell_hole+cell_wall;

  ycopies(spacing=dy,l=size[1])    
    xcopies(spacing=dx,l=size[0]) {
      cell(SW_hole=cell_hole,
           height=size[2],
           wall=cell_wall);
      right(dx/2)fwd(dy/2)
      cell(SW_hole=cell_hole,
          height=size[2],
          wall=cell_wall);
    }
 }

////////////////////////////////////////////////////////////////////
// mask: creates a mask that is used by the module create_grid()
//   The mask is used to remove extra cells that are outside the 
//   cube that holds the final grid
////////////////////////////////////////////////////////////////////
module mask(size) {
  difference() {
    cuboid(size=2*size);
    cuboid(size=size);
  }
}

////////////////////////////////////////////////////////////////////
// create_grid: creates a rectangular grid of hexagons with a border
//   thickness specified in the parameter (wall).
//
//   size: 3-vector (x,y,z) that specifies the length, width, and 
//     depth of the final grid
//   SW: scalar value that specifies the width across the flats of
//     the interior hexagon (the hole)
//   wall: scalar value that specifies the width of each hexagon's 
//     wall thickness and the thickness of the surrounding
//     rectangular frame
////////////////////////////////////////////////////////////////////
module create_grid(size,SW,wall) {
  b = 2*wall;
  union() {
    difference () {
      cuboid(size=size);
      cuboid(size=[size[0]-b,size[1]-b,size[2]+b]);
    }
  }
  
  difference() {
    hexgrid(size=size,cell_hole=SW,cell_wall=wall);
    mask(size);
  }
}

////////////////////////////////////////////////////////////////////
// Example
// To use call create_grid with
//   size: (x,y,z)
//   SW: (width across the flats of the hex
//   wall: (thickness of wall
////////////////////////////////////////////////////////////////////
//create_grid(size=[100,150,10],SW=20,wall=4);




$fn=25;

// Add 6cm for the box on the left
//BOX_W = 110; // Box Width
BOX_W = 170; // Box Width

BOX_L = 160;// Box Length
BOX_H = 50; // Box Height
SCREW_SIZE = 3; // Screw size in mm
SCREW_HEAD_SIZE = 7; // Screw head size in mm
SCREW_HEAD_DEPTH = 2.5;
CORNER_RADIUS = 4; // Radius of corners
WALL_THICKNESS = 2;// Wall Thickness
POST_RADIUS=12;
POST_OFFSET=0;

TAB_HEIGHT=6;


coordinates = [ [0,0],[0,BOX_L],[BOX_W,BOX_L],[BOX_W,0] ];

BOTTOM_PADDING = BOX_W * 0.14;

module box() {
    
difference() {
    linear_extrude( BOX_H )
        difference() {
            offset(r=CORNER_RADIUS) 
                square( [BOX_W, BOX_L], center=true );
            offset( r= CORNER_RADIUS - WALL_THICKNESS )
                square( [BOX_W-WALL_THICKNESS, BOX_L-WALL_THICKNESS], center=true );
        }

// cut out holes for cables (add extra 2 for larger box)
    translate([1*(18 + 4), 0, BOX_H])
rotate([90,0,0])
  cylinder(h=BOX_L*1.5,r=14, center = true);
        
    translate([-1*(18 + 4), 0, BOX_H])
rotate([90,0,0])
  cylinder(h=BOX_L*1.5,r=14, center = true);
      
    translate([-1*(58 + 4), 0, BOX_H])
rotate([90,0,0])
  cylinder(h=BOX_L*1.5,r=14, center = true);      
        
    translate([1*(58 + 4), 0, BOX_H])
rotate([90,0,0])
  cylinder(h=BOX_L*1.5,r=14, center = true);              
}

intersection(){
        translate([-BOX_W/2,-BOX_L/2,0])
            union() {
               translate([0, BOX_L / 2])
                   difference(){
                     cylinder(h=BOX_H,r=POST_RADIUS);
                     translate([4,0,-CORNER_RADIUS])
                     cylinder(h=BOX_H,r=SCREW_SIZE/2);
                   };
               translate([BOX_W, BOX_L / 2])
                   difference(){
                     cylinder(h=BOX_H,r=POST_RADIUS);
                     translate([-4,0,-CORNER_RADIUS])
                     cylinder(h=BOX_H,r=SCREW_SIZE/2);
                   };     
               }              
                   
                   
    linear_extrude( BOX_H )               
    offset(r=CORNER_RADIUS) 
        square( [BOX_W, BOX_L], center=true );                   
}

TAB_WIDTH = 40;
TAB_LENGTH = 16;

translate ( [0, 0, BOX_H - TAB_HEIGHT] )
    difference() {
        linear_extrude(TAB_HEIGHT) {
            difference() {
                union() {
                   translate([1 * ((BOX_W + CORNER_RADIUS)/2 + TAB_LENGTH/2),0,0])
                        offset(r=CORNER_RADIUS)
                            square( [TAB_LENGTH, TAB_WIDTH], center=true );

                   translate([-1 * ((BOX_W + CORNER_RADIUS)/2 + TAB_LENGTH/2),0,0])
                        offset(r=CORNER_RADIUS)
                            square( [TAB_LENGTH, TAB_WIDTH], center=true );      
              };

                               offset( r= CORNER_RADIUS - WALL_THICKNESS )
                        square( [BOX_W-WALL_THICKNESS, BOX_L-WALL_THICKNESS], center=true );
            }
        };
        
     // screw holes
     translate([1 * ((BOX_W + CORNER_RADIUS)/2 + TAB_LENGTH/2),0,0])
     translate([CORNER_RADIUS, 0])
     union() {
        cylinder(h=BOX_H,r=SCREW_SIZE/2);
        cylinder(h=SCREW_HEAD_DEPTH,r=SCREW_HEAD_SIZE/2);
     };
     
     translate([-1 * ((BOX_W + CORNER_RADIUS)/2 + TAB_LENGTH/2),0,0])
     translate([-CORNER_RADIUS, 0])
     union() {
        cylinder(h=BOX_H,r=SCREW_SIZE/2);
        cylinder(h=SCREW_HEAD_DEPTH,r=SCREW_HEAD_SIZE/2);
     };
    }

}


module lid() {
    difference() {
       linear_extrude( CORNER_RADIUS + 4)
            difference() {
                offset( r= CORNER_RADIUS - WALL_THICKNESS )
                    square( [BOX_W-WALL_THICKNESS, BOX_L-WALL_THICKNESS], center=true );
                offset( r= CORNER_RADIUS - WALL_THICKNESS*3 )
                    square( [BOX_W-WALL_THICKNESS, BOX_L-WALL_THICKNESS], center=true );            
            };
    box();
    }
    
    union() {
    difference() {
        translate([0,0,0])
        linear_extrude( CORNER_RADIUS )
            difference() {
                offset(r=CORNER_RADIUS) 
                    square( [BOX_W, BOX_L], center=true );
                offset( r= CORNER_RADIUS - WALL_THICKNESS - 1 )
                    square( [BOX_W-WALL_THICKNESS, BOX_L-WALL_THICKNESS], center=true );
            }
        translate([0, 0, BOX_H])
    rotate([90,0,0])
      cylinder(h=BOX_L*1.5,r=16, center = true);
    }

    difference() {
        translate ( [-BOX_W/2, -BOX_L/2] )
        hull()
           for (i = coordinates)
              translate(i) sphere(CORNER_RADIUS);
           
        translate ( [0, 0, -CORNER_RADIUS] )    
        linear_extrude(CORNER_RADIUS * 2)
        square([BOX_W - BOTTOM_PADDING, BOX_L - BOTTOM_PADDING], center=true);


    // Screw holes
            translate([-BOX_W/2,-BOX_L/2,0])
                union() {
                   // Screws
                   translate([0, BOX_L / 2])
                         translate([4,0,-CORNER_RADIUS])
                         union() {
                            cylinder(h=BOX_H,r=SCREW_SIZE/2);
                            cylinder(h=SCREW_HEAD_DEPTH,r=SCREW_HEAD_SIZE/2);
                         };
       
                   translate([BOX_W, BOX_L / 2])
                         translate([-4,0,-CORNER_RADIUS])
                         union() {
                            cylinder(h=BOX_H,r=SCREW_SIZE/2);
                            cylinder(h=SCREW_HEAD_DEPTH,r=SCREW_HEAD_SIZE/2);
                         };
             
                     }
                 }
    }
    
    intersection() {
        translate ( [0, 0, -CORNER_RADIUS] )    
        linear_extrude(CORNER_RADIUS * 2)
        square([BOX_W - BOTTOM_PADDING, BOX_L - BOTTOM_PADDING], center=true);
        
        hexgrid(size=[BOX_W * 1.5, BOX_L * 1.5, CORNER_RADIUS*2],cell_hole=23,cell_wall=4);
    }
}

//p_w = BOX_W - POST_OFFSET + POST_RADIUS + WALL_THICKNESS;
//p_l = BOX_L - POST_OFFSET + POST_RADIUS + WALL_THICKNESS;

box();
//lid();