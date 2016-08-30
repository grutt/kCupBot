//kCup solution
//@author gabriel ruttner <gabriel.ruttner@gmail.com>

//dimension variables

/* kCup
 * ----------- diameter_flange
 *  \       /  diameter_top
 *   \     /
 *    \___/   diameter_bottom
 */

kCup_diameter_flange = 20;
kCup_height_flange   = 1;
kCup_diameter_top    = 18;
kCup_diameter_bot    = 15;
kCup_height          = 20;


/*
 * STDandard interferances
 */
 s1 = 1;
 
 
 /*
  * material constraints
  */
t2 = .5; //2mm thickness
mS = 2; //minSolid amount
keyL = 10;//key length
throughAll = 9999;

module kCup(){
     union(){
        translate([0,0,kCup_height]){
            cylinder(kCup_height_flange, 
                    d=kCup_diameter_flange);
        }
        cylinder(kCup_height, d2 = kCup_diameter_top, 
                d1 = kCup_diameter_bot);
    }
}


module kCupSlotPane(){
    width = kCup_diameter_flange;
    height = kCup_height+kCup_height_flange+mS;
    union(){
        difference(){
            difference(){
                //slot for kCup flange
                cube([t2, width, height]);
                translate([0,0,kCup_height]){
                    //@TODO diameter is wrong
                    //actual pannel
                    cube([t2+s1,
                          width*3/4,
                          kCup_height_flange]);
                }
            }
            
            //key holes for kCupSlotBackPane()
            translate([0,kCup_diameter_top, kCup_height/2-keyL/2]){        //keyDim
            cube([throughAll, t2, keyL]);
            }
        }
        
        //bottom key
        translate([0, width/2-keyL/2, -t2]){//bottom key
            cube([t2, keyL, t2]);
        }
        //top key
        translate([0, width/2-keyL/2, height]){//bottom key
            cube([t2, keyL, t2]);
        }       
    }
}

module horizontalPanes(){
    width = 2*kCup_diameter_flange;
    depth = kCup_diameter_flange;
    translate([-width/2, -depth/2+2*t2, 0]){
        cube([width, depth, t2]);
    }
}

module kCupSlotBackPane(){
    width = kCup_diameter_top-t2;
    union(){
        
        translate([0,0,kCup_height/2-keyL/2]){//left key
        cube([t2, t2, keyL]);
        }
        translate([t2,0, 0]){
        cube([width, t2, kCup_height]);
        }
        
        translate([width+t2,0, kCup_height/2-keyL/2]){//right key
        cube([t2, t2, keyL]);
        }
        
        translate([width/2 - keyL/2 + t2 ,0, -t2]){//bottom key
        cube([keyL, t2, t2]);
        }
    }
    
    }

module assembly(){
    
    color("purple", 0.5){
        translate([-kCup_diameter_top/2, kCup_diameter_top/2, 0]){
            kCupSlotBackPane();
        }
    }
    
    translate([0,0,kCup_height+kCup_height_flange+mS]){
        color("red"){
            difference(){
            horizontalPanes();
            translate([0,0,-34]){
                cylinder(d=kCup_diameter_bot/4, h=throughAll);
            }
            }
        }
    }
    
    translate([0,0,-t2]){
        color("red"){
            horizontalPanes();
        }
    }    
    
    translate([kCup_diameter_top/2, -kCup_diameter_top/2, 0]){
        kCupSlotPane();
    }

    translate([-kCup_diameter_top/2, -kCup_diameter_top/2, 0]){
        kCupSlotPane();
    }
    
    color("green"){
        kCup();
    }
    
    
}

assembly();

