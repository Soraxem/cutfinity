/*
Author: Samuel Hafen
Description: Laser cuttable Bins Generator, for use with gridfinity standart
*/


/* [View] */

// View the Model in 3D
3D_VIEW = false;
// Explosion View of you Bins
3D_EXPLODED = false;

/* [Bin] */

// Height of your bin in Units
BIN_HEIGHT_UNITS = 6;
// Width of your bin in Units 
BIN_WIDTH_UNITS = 2;
// Length of your bin in Units
BIN_LENGTH_UNITS = 3;

/* [Material] */

// Thickness of the material
THICKNESS = 3;
// Size of the cut, not visible in 3D View
LASER_SIZE = 0.250;

// Real added Tolerance
LASER_TOLERANCE = 3D_VIEW ? 0:LASER_SIZE;

/* [Hidden] */
// These are the Advanced Settings, they only should be touched if you want to have a system that is incompatible to the Cutfinity sytem.

// Spacing between the bins
TOLERANCE = 1.25;
// Spacing between base and bin wall
BASE_TOLERANCE = 1;
// Grid Spacing
GRID_SIZE = 42;
// Height spacing
GRID_HEIGHT = 7;
// Space between parts
PART_SPACING = 2;
// Factor for Expolosion
3D_EXPLOSION_FACTOR = 3D_EXPLODED ? 20:0;

// This size is the bin, without the base 
BIN_HEIGHT = BIN_HEIGHT_UNITS * GRID_HEIGHT - THICKNESS;
BIN_WIDTH = BIN_WIDTH_UNITS * GRID_SIZE - TOLERANCE + LASER_TOLERANCE;
BIN_LENGTH = BIN_LENGTH_UNITS * GRID_SIZE - TOLERANCE  + LASER_TOLERANCE;

// The Size of a Base
BASE_SIZE = GRID_SIZE - THICKNESS*2 - TOLERANCE - BASE_TOLERANCE*2  + LASER_TOLERANCE;


// Wall
HEIGHT_TAB = GRID_HEIGHT + LASER_TOLERANCE;

// Floor
TAB_SPACING = GRID_SIZE / 7;
BIN_TAB = TAB_SPACING + LASER_TOLERANCE;
BIN_TAB_DOUBLE = TAB_SPACING * 2 + LASER_TOLERANCE;


//Base is Correct
module base() {
    // Generate 1 Base per unit in each direction
    for ( x = [0:BIN_LENGTH_UNITS-1] ) {
        translate([x*GRID_SIZE,0,0]) {
            for ( y = [0:BIN_WIDTH_UNITS-1] ) {
                translate([0,y*GRID_SIZE,0]) {
                    // Put the base in the middle of the grid
                    translate([GRID_SIZE/2,GRID_SIZE/2,0])
                    difference() {
                        square(BASE_SIZE, true);
                        
                        // Connectors
                        translate([0, 8,0])
                        square(THICKNESS*2 + LASER_TOLERANCE, true);
                        translate([0, -8,0])
                        square(THICKNESS*2 + LASER_TOLERANCE, true);
                        
                        // Connector holes
                        translate([10, 0,0])
                        square([THICKNESS, THICKNESS*2 - LASER_TOLERANCE], true);
                        translate([-10, 0,0])
                        square([THICKNESS, THICKNESS*2 - LASER_TOLERANCE], true);
                    }
                }
            }
        }
    }
}

module buttom() {
    
    difference() {
    
    union() {
    
    // Add tabs to Length
    translate([TAB_SPACING / 2, BIN_WIDTH_UNITS * GRID_SIZE / 2, 0])
    for ( x = [0:BIN_LENGTH_UNITS-1] ) {
        translate([x * GRID_SIZE, 0, 0]) {
            translate([TAB_SPACING * 2, 0, 0])
            square([BIN_TAB, BIN_WIDTH], true);
            
            translate([TAB_SPACING * 4, 0, 0])
            square([BIN_TAB, BIN_WIDTH], true);
            
            // Create the big tabs, if there will be a next iteration
            if ( BIN_LENGTH_UNITS-1 > x ) {
                translate([TAB_SPACING * 6.5, 0, 0])
                square([BIN_TAB_DOUBLE, BIN_WIDTH], true);
            }
        }
    }
    
    // Add Tabs to Width
    translate([BIN_LENGTH_UNITS * GRID_SIZE / 2, TAB_SPACING / 2, 0])
    for ( y = [0:BIN_WIDTH_UNITS-1] ) {
        translate([0, y * GRID_SIZE, 0]) {
            translate([0, TAB_SPACING * 2, 0])
            square([BIN_LENGTH, BIN_TAB], true);
        
            translate([0, TAB_SPACING * 4, 0])
            square([BIN_LENGTH, BIN_TAB], true);
            
            // Create the big tabs, if there will be a next iteration
            if ( BIN_WIDTH_UNITS-1 > y ) {
                translate([0, TAB_SPACING * 6.5, 0])
                square([BIN_LENGTH, BIN_TAB_DOUBLE], true);
            }
        }
    }
    
    // Fill the area
    translate([BIN_LENGTH_UNITS * GRID_SIZE / 2, BIN_WIDTH_UNITS * GRID_SIZE / 2, 0])
    square([BIN_LENGTH - THICKNESS*2, BIN_WIDTH - THICKNESS*2], true);
    }
    
    // Generate 1 Base per unit in each direction
    for ( x = [0:BIN_LENGTH_UNITS-1] ) {
        translate([x*GRID_SIZE,0,0]) {
            for ( y = [0:BIN_WIDTH_UNITS-1] ) {
                translate([0,y*GRID_SIZE,0]) {
                    // Put the base in the middle of the grid
                    translate([GRID_SIZE/2,GRID_SIZE/2,0])
                    union() {
                        // Connector holes
                        translate([10, 0,0])
                        square([THICKNESS, THICKNESS*2 - LASER_TOLERANCE], true);
                        translate([-10, 0,0])
                        square([THICKNESS, THICKNESS*2 - LASER_TOLERANCE], true);
                    }
                }
            }
        }
    }
    
    }
    
}

module wall( SIZE, SIZE_UNITS ) {
    
    difference() {
        union() {
            translate([SIZE_UNITS * GRID_SIZE / 2, GRID_HEIGHT / 2, 0]) {
                // Creates tabs for each height Unit
                for ( h = [0:BIN_HEIGHT_UNITS-1] ) {
                    translate([ ( h % 2 ) ? -THICKNESS/2 : THICKNESS/2, h * GRID_HEIGHT,0])
                    square([SIZE - THICKNESS, HEIGHT_TAB], true);
                }
            }
        }   
    
        translate([TAB_SPACING / 2, THICKNESS/2 - LASER_TOLERANCE/2, 0])
        for ( x = [0:SIZE_UNITS-1] ) {
            translate([x * GRID_SIZE, 0, 0]) {
                translate([TAB_SPACING * 2, 0, 0])
                square([BIN_TAB - LASER_TOLERANCE*2, THICKNESS], true);
            
                translate([TAB_SPACING * 4, 0, 0])
                square([BIN_TAB - LASER_TOLERANCE*2, THICKNESS], true);
            
                // Create the big tabs, if there will be a next iteration
                if ( SIZE_UNITS-1 > x ) {
                    translate([TAB_SPACING * 6.5, 0, 0])
                    square([BIN_TAB_DOUBLE - LASER_TOLERANCE*2, THICKNESS], true);
                }
            }
        }
        
    }
}

module 2d_view() {
    
    translate([0,-BIN_WIDTH_UNITS*GRID_SIZE - PART_SPACING,0])
    base();
    
    buttom();
    
    translate([0,BIN_WIDTH_UNITS*GRID_SIZE + PART_SPACING,0])
    wall(BIN_LENGTH, BIN_LENGTH_UNITS);
    
    translate([0,BIN_WIDTH_UNITS*GRID_SIZE + BIN_HEIGHT + PART_SPACING*4,0])
    wall(BIN_LENGTH, BIN_LENGTH_UNITS);
    
    translate([-PART_SPACING,0,0])
    rotate(90)
    wall(BIN_WIDTH, BIN_WIDTH_UNITS);
    
    translate([-PART_SPACING,-BIN_WIDTH_UNITS*GRID_SIZE - PART_SPACING,0])
    rotate(90)
    wall(BIN_WIDTH, BIN_WIDTH_UNITS);

}

module 3d_view() {
    translate([-BIN_LENGTH_UNITS*GRID_SIZE/2,-BIN_WIDTH_UNITS*GRID_SIZE/2,0])
    linear_extrude(THICKNESS)
    buttom();
    
    color("green")
    translate([0,0,-3D_EXPLOSION_FACTOR])
    translate([-BIN_LENGTH_UNITS*GRID_SIZE/2,-BIN_WIDTH_UNITS*GRID_SIZE/2,-THICKNESS])
    linear_extrude(THICKNESS)
    base();
    
    color("pink")
    translate([-BIN_LENGTH_UNITS*GRID_SIZE/2, BIN_WIDTH/2 + 3D_EXPLOSION_FACTOR, 0])
    rotate([90,0,0])
    linear_extrude(THICKNESS)
    wall(BIN_LENGTH, BIN_LENGTH_UNITS);
    
    color("pink")
    translate([BIN_LENGTH_UNITS*GRID_SIZE/2, -BIN_WIDTH/2 - 3D_EXPLOSION_FACTOR, 0])
    rotate([90,0,180])
    linear_extrude(THICKNESS)
    wall(BIN_LENGTH, BIN_LENGTH_UNITS);
    
    
    color("violet")
    translate([-BIN_LENGTH/2 - 3D_EXPLOSION_FACTOR, -BIN_WIDTH_UNITS*GRID_SIZE/2, 0])
    rotate([90,0,90])
    linear_extrude(THICKNESS)
    wall(BIN_WIDTH, BIN_WIDTH_UNITS);
    
    color("violet")
    translate([BIN_LENGTH/2 + 3D_EXPLOSION_FACTOR, BIN_WIDTH_UNITS*GRID_SIZE/2, 0])
    rotate([90,0,-90])
    linear_extrude(THICKNESS)
    wall(BIN_WIDTH, BIN_WIDTH_UNITS);
}


if ( 3D_VIEW ) {
    3d_view();
} else {
    2d_view();
}