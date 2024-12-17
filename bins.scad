/*
Author: Samuel Hafen
Description: Laser cuttable Bins Generator, for use with gridfinity standart
*/

/* [Bin] */

// Height of your bin in Units
BIN_HEIGHT_UNITS = 6;
// Width of your bin in Units 
BIN_WIDTH_UNITS = 1;
// Length of your bin in Units
BIN_LENGTH_UNITS = 1;

/* [Material] */

// Thickness of the material
THICKNESS = 2;
// Size of the cut
LASER_SIZE = 0.1;

/* [Hidden] */

// Spacing between the bins
TOLERANCE = 0.5;
// Grid Spacing
GRID_SIZE = 42;
// Height spacing
GRID_HEIGHT = 7;
// Space between parts
PART_SPACING = 5;

// This size is the bin, without the base 
BIN_HEIGHT = BIN_HEIGHT_UNITS * GRID_HEIGHT - THICKNESS;
BIN_WIDTH = BIN_WIDTH_UNITS * GRID_SIZE - TOLERANCE;
BIN_LENGTH = BIN_LENGTH_UNITS * GRID_SIZE - TOLERANCE;

BIN_BUTTOM_TAB = GRID_SIZE / 7;


module base() {
    BASE_SIZE = GRID_SIZE - THICKNESS*2 - TOLERANCE*2;
    //square(BASE_SIZE);
    
    for ( x = [0:BIN_LENGTH_UNITS-1] ) {
        translate([x*GRID_SIZE,0,0]) {
            for ( y = [0:BIN_WIDTH_UNITS-1] ) {
                translate([0,y*GRID_SIZE,0]) {
                    square(BASE_SIZE);
                }
            }
        }
    }
}

module buttom() {
    
    // Length Tabs
    for ( i = [0:BIN_LENGTH_UNITS-1] ) {
        translate([i*GRID_SIZE,0,0]){
            // Create tabs inside grid of 7
            translate([BIN_BUTTOM_TAB*2, 0,0])
            square([BIN_BUTTOM_TAB, BIN_WIDTH]);
            translate([BIN_BUTTOM_TAB*4, 0,0])
            square([BIN_BUTTOM_TAB, BIN_WIDTH]);
            
            // Create the big tabs, if there will be a next iteration
            if ( BIN_LENGTH_UNITS-1 > i ) {
                translate([BIN_BUTTOM_TAB*6, 0,0])
                square([BIN_BUTTOM_TAB*2, BIN_WIDTH]);
            }
        }
    }
    
    // Width Tabs
    for ( i = [0:BIN_WIDTH_UNITS-1] ) {
        translate([0,i*GRID_SIZE,0]){
            // Create tabs inside grid of 7
            translate([0,BIN_BUTTOM_TAB*2,0])
            square([BIN_LENGTH, BIN_BUTTOM_TAB]);
            translate([0,BIN_BUTTOM_TAB*4,0])
            square([BIN_LENGTH, BIN_BUTTOM_TAB]);
            
            // Create the big tabs, if there will be a next iteration
            if ( BIN_WIDTH_UNITS-1 > i ) {
                translate([0,BIN_BUTTOM_TAB*6,0])
                square([BIN_LENGTH, BIN_BUTTOM_TAB*2]);
            }
        }
    }
    
    // Fill
    translate([THICKNESS, THICKNESS])
    square([BIN_LENGTH - THICKNESS*2, BIN_WIDTH - THICKNESS*2]);
}

module length_wall() {
    difference() {
        union() {
            // Create unit height as tabs
            for ( i = [0:BIN_HEIGHT_UNITS-1] ) {
                translate([i % 2 * THICKNESS,i * GRID_HEIGHT,0])
                square([BIN_LENGTH - THICKNESS + LASER_SIZE,GRID_HEIGHT + LASER_SIZE]);
            }  
        }
        
        // Cuts for the buttom Tabs
        for ( i = [0:BIN_LENGTH_UNITS-1] ) {
            translate([i*GRID_SIZE,0,0]){
                // Create cuts inside grid of 7
                translate([BIN_BUTTOM_TAB*2, 0,0])
                square([BIN_BUTTOM_TAB, THICKNESS]);
                translate([BIN_BUTTOM_TAB*4, 0,0])
                square([BIN_BUTTOM_TAB, THICKNESS]);
            
                // Create big cuts, if there will be a next iteration
                if ( BIN_LENGTH_UNITS-1 > i ) {
                    translate([BIN_BUTTOM_TAB*6, 0,0])
                    square([BIN_BUTTOM_TAB*2, THICKNESS]);
                }
            }
        }
    }
}

module width_wall() {
   
    difference() {
        union() {
            // Create unit height as tabs
            for ( i = [0:BIN_HEIGHT_UNITS-1] ) {
                translate([i % 2 * THICKNESS,i * GRID_HEIGHT,0])
                square([BIN_WIDTH - THICKNESS + LASER_SIZE,GRID_HEIGHT + LASER_SIZE]);
            }  
        }
        
        // Cuts for the buttom Tabs
        for ( i = [0:BIN_WIDTH_UNITS-1] ) {
            translate([i*GRID_SIZE,0,0]){
                // Create cuts inside grid of 7
                translate([BIN_BUTTOM_TAB*2, 0,0])
                square([BIN_BUTTOM_TAB, THICKNESS]);
                translate([BIN_BUTTOM_TAB*4, 0,0])
                square([BIN_BUTTOM_TAB, THICKNESS]);
            
                // Create big cuts, if there will be a next iteration
                if ( BIN_WIDTH_UNITS-1 > i ) {
                    translate([BIN_BUTTOM_TAB*6, 0,0])
                    square([BIN_BUTTOM_TAB*2, THICKNESS]);
                }
            }
        }
    } 
}


module 2d_view() {

    length_wall();
    translate([BIN_LENGTH_UNITS*GRID_SIZE+PART_SPACING,0,0])
    length_wall();

    translate([-PART_SPACING,-BIN_WIDTH_UNITS*GRID_SIZE-PART_SPACING,0])
    rotate(90)
    width_wall();

    translate([-BIN_HEIGHT-PART_SPACING*2,-BIN_WIDTH_UNITS*GRID_SIZE-PART_SPACING,0])
    rotate(90)
    width_wall();

    translate([0,-BIN_WIDTH_UNITS*GRID_SIZE-PART_SPACING,0])
    buttom();

    translate([BIN_LENGTH_UNITS*GRID_SIZE+PART_SPACING,-BIN_WIDTH_UNITS*GRID_SIZE-PART_SPACING,0])
    base();

}

translate([0,-BIN_WIDTH_UNITS*GRID_SIZE-PART_SPACING,0])
buttom();

translate([BIN_LENGTH_UNITS*GRID_SIZE+PART_SPACING,-BIN_WIDTH_UNITS*GRID_SIZE-PART_SPACING,0])
base();
