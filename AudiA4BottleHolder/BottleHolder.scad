$fn = $preview ? 50 : 170;

RENDER_TOP = false;
RENDER_BOTTOM = true;
RENDER_PEG = false;

// mm to cut of the bottom of the holder block
HOLDER_BOTTOM_SPACE = 10;

LOWER_HEIGHT = 36.5;
BOTTOM_WIDTH = 35.79;
//BOTTOM_WIDTH = 10;
UPPER_HEIGHT = 39.8;
TOP_WIDTH = 36.2;
TOP_LENGTH = 105;
BOTTOM_LENGTH = 87;

WIDTH_DIFF = TOP_WIDTH - BOTTOM_WIDTH;
LENGTH_DIFF = TOP_LENGTH - BOTTOM_LENGTH;
BOTTOM_LENGTH_OFFSET = LENGTH_DIFF/2 * 0.7;

BOTTLE_DIAMETER = 85;
BOTTLE_HOLDER_HEIGHT = 60;
BOTTLE_Y_OFFSET = 7;

LIP_SIZE = 16;
THICKNESS = 7;

PEG_HEIGHT = 10;
PEG_RADIUS = 3;

difference() {
    union() {
        
        if (RENDER_BOTTOM) {
        // Hole wedge
        difference() {
            translate([0, 0, -HOLDER_BOTTOM_SPACE])
            translate([-TOP_WIDTH/2, -TOP_LENGTH/2, 0])
              polyhedron(points = [
            // Bottom
            [WIDTH_DIFF/2, BOTTOM_LENGTH_OFFSET, 0],
            [BOTTOM_WIDTH+WIDTH_DIFF/2, BOTTOM_LENGTH_OFFSET, 0],
            [TOP_WIDTH, BOTTOM_LENGTH + BOTTOM_LENGTH_OFFSET, 0],        
            [0, BOTTOM_LENGTH + BOTTOM_LENGTH_OFFSET, 0],
            
            // Top
            [WIDTH_DIFF/2, 0, UPPER_HEIGHT],
            [BOTTOM_WIDTH+WIDTH_DIFF/2, 0, UPPER_HEIGHT],
            [TOP_WIDTH, TOP_LENGTH, UPPER_HEIGHT],    
            [0, TOP_LENGTH, UPPER_HEIGHT]
        ], faces = [
              [0,1,2,3],  // bottom
              [4,5,1,0],  // front
              [7,6,5,4],  // top
              [5,6,2,1],  // right
              [6,7,3,2],  // back
              [7,4,0,3]   // left
                ]);
            translate([0, 0, -HOLDER_BOTTOM_SPACE])
              cube([100, 100, HOLDER_BOTTOM_SPACE * 2], center = true);
        };
    };
    
    if (RENDER_TOP) {
        // lip
        translate([0, 0, THICKNESS/2 + UPPER_HEIGHT - HOLDER_BOTTOM_SPACE])
        cube([BOTTLE_DIAMETER + LIP_SIZE, TOP_LENGTH + LIP_SIZE + 10, THICKNESS], center = true);
        //TOP_WIDTH + LIP_SIZE + 25

        // Cup holder wall
        translate([0, BOTTLE_Y_OFFSET, UPPER_HEIGHT - HOLDER_BOTTOM_SPACE])
        cylinder(h = BOTTLE_HOLDER_HEIGHT, r = BOTTLE_DIAMETER/2 + LIP_SIZE/2);
    }
    
    };

    if (!RENDER_WEDGE || RENDER_ALL) {
        translate([0, BOTTLE_Y_OFFSET, UPPER_HEIGHT - HOLDER_BOTTOM_SPACE + 5])
        cylinder(h = BOTTLE_HOLDER_HEIGHT + 1, r1 = BOTTLE_DIAMETER/2, r2 = BOTTLE_DIAMETER/2 + 1.5);

        // Cut a notch to allow stretching
        hull() {
            translate([0, -BOTTLE_DIAMETER/2 + BOTTLE_Y_OFFSET - 4, BOTTLE_HOLDER_HEIGHT + UPPER_HEIGHT - 30])
            sphere(r = 12);
            translate([0, -BOTTLE_DIAMETER/2 + BOTTLE_Y_OFFSET - 4, BOTTLE_HOLDER_HEIGHT + UPPER_HEIGHT])
            sphere(r = 12);
            
        }
    }
    
    // peg holes for aligning both parts
    translate([0, 30, UPPER_HEIGHT - PEG_HEIGHT - HOLDER_BOTTOM_SPACE + THICKNESS/2])
        cylinder(h = PEG_HEIGHT, r = PEG_RADIUS);
    translate([0, -30, UPPER_HEIGHT - PEG_HEIGHT - HOLDER_BOTTOM_SPACE + THICKNESS/2])
        cylinder(h = PEG_HEIGHT, r = PEG_RADIUS);
};

if (RENDER_PEG) {
    cylinder(h = PEG_HEIGHT - 0.2, r = PEG_RADIUS-0.15);
}



//    translate([0, BOTTLE_Y_OFFSET, UPPER_HEIGHT - HOLDER_BOTTOM_SPACE + 5])
//    cylinder(h = 280, r1 = BOTTLE_DIAMETER/2, r2 = BOTTLE_DIAMETER/2);