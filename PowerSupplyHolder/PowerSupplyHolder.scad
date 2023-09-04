$fn = $preview ? 15 : 30;

// How many mm to remove from the height, 
// so that screws will compress and hold the power supply firmly
COMPRESSION = 1;

// Caldigit TS3 Dock
POWER_SUPPLY_WIDTH = 75.3;
POWER_SUPPLY_HEIGHT = 25.0;

// LG Monitor
//POWER_SUPPLY_WIDTH = 86.5;
//POWER_SUPPLY_HEIGHT = 29.2;

BRACKET_LENGTH = 25;
BRACKET_THICKNESS = 2.5;
CORNER_RADIUS = 2;

SCREW_SIZE = 3;
SCREW_HEAD_SIZE = 7;
SCREW_HEAD_DEPTH = 2.5;
SCREW_TAB_THICKNESS = 6;
SCREW_TAB_WIDTH = 20;

module screw_hole(h) {
    translate([0, 0, -SCREW_HEAD_DEPTH])
        // Add 1mm to make sure it subtracts the top surface
        cylinder(h=SCREW_HEAD_DEPTH + 1, r=SCREW_HEAD_SIZE/2);
    translate([0, 0, -h])
        cylinder(h=h, r=SCREW_SIZE/2);
}

bracket_width = POWER_SUPPLY_WIDTH + BRACKET_THICKNESS * 2;
bracket_height = POWER_SUPPLY_HEIGHT + BRACKET_THICKNESS - COMPRESSION;

rotate([90, 0, 0])
difference() {
    union() {
        // Bracket
        cube([bracket_width, BRACKET_LENGTH, bracket_height], 
            center = true);

        // Screw tabs
        translate([0,0,POWER_SUPPLY_HEIGHT/-2 + (SCREW_TAB_THICKNESS - BRACKET_THICKNESS) / 2])
            cube([
                bracket_width + SCREW_TAB_WIDTH * 2, // one on each side 
                BRACKET_LENGTH,
                SCREW_TAB_THICKNESS
            ], center = true);
    };
    
    // Subtract screw holes
    screw_hole_x_offset = (bracket_width + SCREW_TAB_WIDTH)/2;
    for (x_offset = [screw_hole_x_offset, -screw_hole_x_offset])
        translate([
            x_offset, 0, (POWER_SUPPLY_HEIGHT - BRACKET_THICKNESS)/-2 + (SCREW_TAB_THICKNESS - BRACKET_THICKNESS)
        ])
            screw_hole(SCREW_TAB_THICKNESS*2);
    
    // Subtract power supply
    translate([0, 0, -BRACKET_THICKNESS/2 - 5 - COMPRESSION])
        cube([
            POWER_SUPPLY_WIDTH, 
            200, 
            POWER_SUPPLY_HEIGHT + 10
        ], center = true);
};
