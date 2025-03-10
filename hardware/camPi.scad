/*
The MIT License (MIT)

Copyright (c) 2015 Paolo Negrini

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

//$fn = 250;
//Need to fix servo tilt suport issue. The spheric part does not move with the arm when you change xPos parameter
// RPi supports does not touch the bottom of the case
include <rpi.scad>;
PIcameraDiam = 8;
PIcameraX = 25;
PIcameraY = 25;

mik = 2;
shellThickness = 3;
supportBaseHeight = 5;
//5.4 is the height of the 
baseHeight = 31 + shellThickness - 5.4;
tolerance = 1.5;
gimballWidth = 45; //for 50 gives R = 86

R = sqrt(3 * gimballWidth * gimballWidth) / 2;
panSupport = sqrt(R * R - (gimballWidth * gimballWidth / 4));
gimballPivotR = R / 2;
supportY = 2 * sqrt(R * R - (gimballWidth / 2) * (gimballWidth / 2));
supportX = R - gimballWidth / 2;
supportZ = 1.1 * R;

servoX = 11.8;
servoY = 22.2;

servoHornThickness = 5.5;
servoHornWidth = 8;
servoHornLenght = 32;

servoClerance = 31 - 16 - servoHornThickness;
eccentricity = 22.2 / 2 - 5;
servoBodySupport = 20;


screwDiam = 3;
screwLenght = 10;
screwTolerance = 0.3;

Piwidth = 56;
Pilength = 85;
Piheight = 1.5;

boxLength = Pilength + 8;
boxDepth = 2 * R + 10;
boxHeight = 48;
boxThickness = 1;
topCoverHeight = 15;

servoPanZ = boxHeight - 20 + topCoverHeight - servoClerance;
servoPanBoxX = (servoX - 2 * boxThickness - tolerance);
servoPanBoxThickness = 2;

function RatX(x) = sqrt(R * R - (x * x));



//---------------------------------------
module panSupport() {
    //rotate([0,270,0])servoTiltSupport(15,"pan");
    difference() {
        union() {
            color("blue", 0.5) multmatrix(m = [
                [1, 0, 0, 0],
                [0, 1, 0.4, 0],
                [0, 0, 1, 0],
                [0, 0, 0, 1]
            ]) cylinder(h = servoPanZ, d1 = boxDepth, d2 = servoY + 2 * servoPanBoxThickness, center = true);
            //Creates bottom support blocks add -mik to y translate if you want to zero the mechanical interference
            translate([0, boxDepth / 2 - 20 / 2 - mik, -servoPanZ / 2 + 5]) cube([boxHeight / 2 + servoPanBoxX, 20, 10], center = true);
            mirror([0, 1, 0]) translate([0, boxDepth / 2 - 20 / 2 - mik, -servoPanZ / 2 + 5]) cube([boxHeight / 2 + (servoX - 2 * boxThickness - tolerance), 20, 10], center = true);
        }

        //Cuts the support from a cylinder
        translate([boxHeight / 2 + (servoX - 2 * boxThickness - tolerance), 0, 0]) cube([boxHeight, boxDepth + 10, boxHeight - 20 + topCoverHeight - servoClerance], center = true);
        mirror(1, 0, 0) translate([boxHeight / 2 + (servoX - 2 * boxThickness - tolerance), 0, 0]) cube([boxHeight, boxDepth + 10, boxHeight - 20 + topCoverHeight - servoClerance], center = true);

        color("blue", 0.5) multmatrix(m = [
            [1, 0, 0, 0],
            [0, 1, 0.4, 0],
            [0, 0, 1, 0],
            [0, 0, 0, 1]
        ]) cylinder(h = servoPanZ, d1 = boxDepth - 10, d2 = servoY - 10, center = true);

        //Cuts the support to fit case
        translate([0, +eccentricity, 10]) cube([servoPanBoxX + servoPanBoxThickness + 4, servoY + servoPanBoxThickness + 1.5, 20], center = true);
        translate([0, -(boxDepth / 2 + 10 - mik), -servoPanZ / 2 + 5]) cube([boxHeight / 2 + servoPanBoxX, 20, 10], center = true);

        //Slot for video
        translate([0, boxDepth / 2 - 10, -servoPanZ / 2 + 5]) rotate([90, 0, 0]) scale([1.2, 1.5, 1]) cube([8, 20, 20], center = true);

    }
    rotate([0, 90, 90]) translate([3.25, 0, 0]) miscroServoSupport();

}

//--------------------------------------- 
//This was the verion for RPi v1
module panSupportRPiV1() {
    //rotate([0,270,0])servoTiltSupport(15,"pan");
    difference() {
        union() {
            color("blue", 0.5) multmatrix(m = [
                [1, 0, 0, 0],
                [0, 1, 0.4, 0],
                [0, 0, 1, 0],
                [0, 0, 0, 1]
            ]) cylinder(h = servoPanZ, d1 = boxDepth, d2 = servoY + 2 * servoPanBoxThickness, center = true);
            //Creates bottom support blocks add -mik to y translate if you want to zero the mechanical interference
            translate([0, boxDepth / 2 - 20 / 2 - mik, -servoPanZ / 2 + 5]) cube([boxHeight / 2 + servoPanBoxX, 20, 10], center = true);
            mirror([0, 1, 0]) translate([0, boxDepth / 2 - 20 / 2 - mik, -servoPanZ / 2 + 5]) cube([boxHeight / 2 + (servoX - 2 * boxThickness - tolerance), 20, 10], center = true);
        }

        //Cuts the support from a cylinder
        translate([boxHeight / 2 + (servoX - 2 * boxThickness - tolerance), 0, 0]) cube([boxHeight, boxDepth + 10, boxHeight - 20 + topCoverHeight - servoClerance], center = true);
        mirror(1, 0, 0) translate([boxHeight / 2 + (servoX - 2 * boxThickness - tolerance), 0, 0]) cube([boxHeight, boxDepth + 10, boxHeight - 20 + topCoverHeight - servoClerance], center = true);

        color("blue", 0.5) multmatrix(m = [
            [1, 0, 0, 0],
            [0, 1, 0.4, 0],
            [0, 0, 1, 0],
            [0, 0, 0, 1]
        ]) cylinder(h = servoPanZ, d1 = boxDepth - 10, d2 = servoY - 10, center = true);

        //Cuts the support to fit case
        translate([0, +eccentricity, 10]) cube([servoPanBoxX + servoPanBoxThickness + 4, servoY + servoPanBoxThickness + 1.5, 20], center = true);
        translate([0, -(boxDepth / 2 + 10 - mik), -servoPanZ / 2 + 5]) cube([boxHeight / 2 + servoPanBoxX, 20, 10], center = true);

        //Slot for video
        translate([0, boxDepth / 2 - 10, -servoPanZ / 2 + 5]) rotate([90, 0, 0]) scale([1.2, 1.5, 1]) cube([8, 20, 20], center = true);

    }
    rotate([0, 90, 90]) translate([3.25, 0, 0]) miscroServoSupport();

}


module miscroServoSupport() {

    translate([-servoBodySupport / 2, 0, eccentricity]) {
        //This is the servo box
        difference() {
            cube([servoBodySupport, 12 + 1 + shellThickness, 22.2 + 1 + shellThickness], center = true);
            cube([servoBodySupport, 12 + 1, 22.2 + 1], center = true);

            //Servo cable slot
            translate([0, 0, -2 * eccentricity]) cube([100, 3, 3], center = true);

        }

    }

}



//--------------------------------
module box(Xdim, Ydim, Zdim, thickness, application)
    //Creates a box, dimensions are internal
    {
        difference() {

            cube([Xdim + thickness, Ydim + thickness, Zdim], center = true);
            translate([0, 0, thickness / 2]) cube([Xdim, Ydim, Zdim], center = true);
            if (application == "servo") {
                translate([-Xdim / 2, 0, -0.5 * Zdim]) cube([5, Ydim + 2 * thickness, Zdim / 2 + thickness], center = true);
                translate([+Xdim / 2, 0, -0.5 * Zdim]) cube([5, Ydim + 2 * thickness, Zdim / 2 + thickness], center = true);
                translate([+Xdim / 2, 0, 0]) cube([thickness / 2, 0.3 * Ydim, Zdim], center = true);
                translate([-Xdim / 2, 0, 0]) cube([thickness / 2, 0.3 * Ydim, Zdim], center = true);
            }
        }
    }

//Baseplate for pan mechanism
module base(servo) {
        difference() {

            {
                minkowski() {
                    cylinder(r = R + mik, h = supportBaseHeight);
                    rotate([90, 0, 0]) cylinder(r = mik, h = 1);
                }

                //This to create a anchoring mechanism with the pan base
                //translate([0, 0,-mik])cylinder(r = R + mik+3, h = 2);
            }
            if (servo == true) {
                translate([0, 0, -supportZ - servoHornThickness - mik]) rotate([0, 90, 0]) servoHorn("cross");
                cylinder(r = 2.5, h = 15, center = true);
            }
        }
    }
  

module supportSection() {
        intersection() {
            difference() {
                sphere(R);
                cube([gimballWidth, 2 * gimballWidth, 2 * gimballWidth], center = true);

            }
            translate([R - supportX / 2, 0, 0]) cube([supportX, supportY, 10], center = true);
        }
    }
    //-------------------------

    //This creates the supporting pillar for the camera shell
    module tiltSupport()

    {
        union() {
            difference() {
                sphere(R);
                cube([gimballWidth, 2 * gimballWidth, 2 * gimballWidth], center = true);
                translate([-gimballWidth, 0, 0]) cube([2 * gimballWidth, 2 * gimballWidth, 2 * gimballWidth], center = true);

            }

            hull() {
                translate([0, 0, -5]) supportSection();
                translate([0, 0, -supportZ]) supportSection();
            }
        }

    }


module servoTiltSupport(xPos, Pos) {
    //The module ned to be rewritten to be easy to read!!!
        //Need to center the servo shaft, the second figure is the distance form border
        supportPosition = xPos;
        //Need to adjust the clearance to account for the Xpos
        supportCurvature = 30;

        rotate([-0, 0, 0]) difference() {

            union() {

                difference() {
                    translate([-shellThickness / 2 + supportPosition, 0, 0]) {
                        cube([shellThickness, 30, 1.8 * RatX(gimballWidth / 2)], center = true);
                    }
                       
               difference(){sphere(5*R);sphere(R - shellThickness);}
                       difference() {
                        }
                    }

  
                translate([-servoBodySupport / 2 + supportPosition, 0, eccentricity]) {
                    //This is the servo box
                     difference() {
                        cube([servoBodySupport, 12 + tolerance + shellThickness + 3 , 22.2 + 3 + shellThickness], center = true);
                        cube([servoBodySupport, 12 + tolerance, 22.2 + 1.1*tolerance], center = true);

                        //Servo cable slot
                        translate([0, 0, -2 * eccentricity]) cube([100, 4, 4], center = true);

                    }


                }
            }

            //This is the slot in the servo arm
            translate([servoClerance + 8 + shellThickness, 0, eccentricity]) {
                cube([20 + tolerance, 12 + tolerance, 32.2 ], center = true);
                translate([-31 / 2, 0, 0]) cube([31 + 1, 12, 22.2 + + 1.1*tolerance], center = true);

            }
        }

        //This is the curved extra support for the connection with the gimball internal shell
             translate([0, 0, 0])SUB_tiltwedge(xPos);
             mirror([0,0,1])translate([0, 0, 0])SUB_tiltwedge(xPos);

  
 

    }


    //-------------------------

module SUB_tiltwedge(xPos) {
   supportCurvature = 30;
	
            difference() {
                translate([12, 0, +RatX(xPos) - 10])
                difference() {
                    cube([16, 30, 50], center = true);
                    translate([-supportCurvature, 0, -supportCurvature]) sphere(r = supportCurvature + 20, center=true);

                }

                difference() {
                    sphere(10*R);

                    sphere(R - shellThickness);

                }


            }

}


module cameraSupport() {
        difference() {
            difference() {
                sphere(R);
                sphere(R - shellThickness);
            }

            translate([R + gimballWidth / 2, 0, 0]) cube([2 * R, 2 * R, 2 * R], center = true);
            translate([-R - gimballWidth / 2, 0, 0]) cube([2 * R, 2 * R, 2 * R], center = true);
              //Creates camera support
            translate([0, R - 7, 0]) cube([PIcameraX + tolerance, 3, PIcameraY + tolerance], center = true);
            translate([0, R - 7, 0]) cube([2, 3, PIcameraY], center = true);
            //Slot for camera wires
            translate([0, R - 8, -PIcameraY / 2 - 2]) cube([PIcameraX - 5, 3, 3], center = true);


            //Hole for the camera
            translate([0, R, 0]) rotate([90, 0, 0]) cube([PIcameraDiam + 2*tolerance, 10, PIcameraDiam + 2*tolerance], center = true);
		translate([0,0.9*R,0])SUB_PiCamHoles(0.3);
            }

        //Need to hardwire the servo dimensions

        {
            servoTiltSupport(gimballWidth/2, "tilt");


        }
        //Pivot mechanism. Need to understand why 0.98 otherwise a layer gets created
        translate([-gimballWidth / 2, 0, 0]) {
            difference() {
                rotate([0, 90, 0]) cylinder(r = panSupport, h = 0.98*shellThickness);
                gimballPivot(1);
                rotate([0, 90, 0]) cylinder(r = gimballPivotR - shellThickness, h = shellThickness);

            }
            gimballPivot(1);
        }
    }
      
    //-------------------------

module SUB_PiCamHoles(T) {
// T is the tolerance for holes
        translate([PIcameraX/2-2, 0, PIcameraY/2-1])rotate([90,0,0])cylinder(r=1+T,h=10, center=true);
		translate([-(PIcameraX/2-2), 0, PIcameraY/2-1])rotate([90,0,0])cylinder(r=1+T,h=10, center=true);
		translate([PIcameraX/2-2, 0, (PIcameraY/2-1)-12.5])rotate([90,0,0])cylinder(r=1+T,h=10, center=true);
		translate([-(PIcameraX/2-2), 0, (PIcameraY/2-1)-12.5])rotate([90,0,0])cylinder(r=1+T,h=10, center=true); 
    
}    
    
    


module camBolt() {
    difference(){
         SUB_camBoltFrame();
        SUB_PiCamHoles(0.1);
      
    
}
}



module SUB_camBoltFrame(){


translate([PIcameraX/2-2,0,PIcameraY/2-2])rotate([90,0,0])cylinder(r=3,h=8, center=true);
translate([-(PIcameraX/2-2),0,PIcameraY/2-2])rotate([90,0,0])cylinder(r=3,h=8, center=true);
translate([-(PIcameraX/2-2),0,+(PIcameraY/2-2)-12.5])rotate([90,0,0])cylinder(r=3,h=8, center=true);
translate([(PIcameraX/2-2),0,+(PIcameraY/2-2)-12.5])rotate([90,0,0])cylinder(r=3,h=8, center=true);
translate([0,+2.5-4,0]){
    translate([0,0,(PIcameraY/2-2)-12.5])cube([(PIcameraX-2),5,5], center=true);
translate([0,0,(PIcameraY/2-2)])cube([(PIcameraX-2),5,5], center=true);
translate([PIcameraX/2-2.5,0,12.5/2])cube([5,5,(12.5)], center=true);
translate([-(PIcameraX/2-2.5),0,12.5/2])cube([5,5,(12.5)], center=true);
}

}


module servoHorn(type) {
        cube([servoHornThickness, servoHornWidth, servoHornLenght], center = true);
        if (type == "cross") rotate([90, 0, 0]) cube([servoHornThickness, servoHornWidth, servoHornLenght], center = true);
    }
    //-------------------------

module gimballPivot(tolerance) {
        rotate([0, 90, 0])
        difference() {
            cylinder(r = gimballPivotR - tolerance / 2, h = gimballPivotR / 2, center = true);
            cylinder(r = gimballPivotR - 3 + tolerance / 2, h = gimballPivotR / 2, center = true);
        }
    }
    //-------------------------

module support() {
    scaleFactor = (R + tolerance) / R;

    difference() {
        tiltSupport();

        translate([gimballWidth / 2 + servoHornThickness / 2, 0, 0]) rotate([45, 0, 0]) servoHorn("line");
        translate([gimballWidth / 2, 0, 0]) rotate([0, 90, 0]) cylinder(r = 3, h = 30);

    }

    //Need to cut holes in the base for servo and camera cables and the screws
    translate([0, 0, -supportBaseHeight / 2])
    difference() {

        {
            color("blue", 0.5) translate([0, 0, -supportZ - supportBaseHeight]) base(true);
            translate([0, 0, -supportZ - servoHornThickness]) rotate([0, 90, 0]) servoHorn("cross");
            SUB_cameracableDuct();
            translate([0, 0, +supportBaseHeight / 2]) mirror([1, 0, 0]) tiltSupport();
            SUB_mountedPillarScrewHoles();
            translate([-gimballWidth / 2 - supportX / 2, 0, 0]) rotate([0, 0, 180])
            SUB_servocableDuct();

        }

    }

}

module mountedPillar() {
    //Pillar for camera. This one needs to be mounted separately
    difference() {
        mirror([1, 0, 0]) tiltSupport();
        translate([-gimballWidth / 2, 0, 0]) gimballPivot(0);
        translate([-gimballWidth / 2, 0, 0]) gimballPivot(3); {
            SUB_cameracableDuct();
            SUB_mountedPillarScrewHoles();
            translate([-gimballWidth / 2 - supportX / 2, 0, -supportX / 2]) rotate([0, 0, 180])
            SUB_servocableDuct();
        }

    }


}


module SUB_screw(tolerance) {
    cylinder(r = screwDiam / 2 + tolerance, h = screwLenght);
    translate([0, 0, -3]) cylinder(r = 2 * screwDiam / 2 + screwTolerance, h = 4);
}

module SUB_mountedPillarScrewHoles() {
    color("blue", 0.5) translate([-R + supportX / 2 + 2, 0, -supportZ - screwLenght / 2]) {
        translate([0, 0.5 * panSupport, 0]) SUB_screw(-screwTolerance);
        mirror([0, 1, 0]) translate([0, 0.5 * panSupport, 0]) SUB_screw(-screwTolerance);
    }
}

module SUB_servocableDuct() {
    //Duct for servo cable
    {
        translate([0, 0, -supportZ + supportX]) cylinder(r = supportX / 3, h = supportZ + supportX / 2, center = true);
        translate([-supportX, 0, 0]) rotate([0, 120, 0]) cylinder(r = supportX / 3, h = supportX, center = false);
        translate([0, 0, -supportZ - supportX / 3]) rotate([0, 90, 180]) cylinder(r = supportX / 3, h = 0.6 * R, center = false);
    }

}

module SUB_cameracableDuct() {
        //Duct for camera connetion
        translate([-gimballWidth / 2 - 0.5 * supportX, 0, 0]) rotate([0, 0, 90]) {
            translate([0, 0, 0]) rotate([90, 0, 0]) cylinder(r = 26 / 2, h = 0.6 * supportX);
            translate([0, 0, -supportZ / 2]) cube([20, 3, supportZ + 1.1 * supportBaseHeight], center = true);
            translate([0, -R * 0.5 + 13, -supportZ - supportBaseHeight]) rotate([90, 0, 0]) cube([20, 5, R * 0.5], center = true);

        }
    }
    //---------------------------




module connectionSocket() {

    cylinder(r = 3, h = 5);
    translate([-9, -3 / 2, 0]) cube([10, 3, 5]);

}

module PiSupport() {
    difference() {
        translate([0,0,1])cube([4 + 3 / 2 - 0.4, 4 + 3 / 2 - 0.2, 8], center = true);
        cylinder(r = 3 / 2 - 0.2, h = 2 * Piheight + 8, $fs = 0.1);
    }

}



module case () {
    translate([0, 0, -boxHeight / 2 - supportZ - 2 * supportBaseHeight]) {
        difference() {
            minkowski() {
                box(boxLength, boxDepth, boxHeight, boxThickness, "PI");
                //sphere(r = mik);
                cylinder(r = mik, h = 2);
            }
            translate([R - 10, -Piwidth / 2, -boxHeight / 2 - 5 / 2]) connectionSocket();
            translate([-R + 10, -Piwidth / 2, -boxHeight / 2 - 5 / 2]) connectionSocket();
            translate([R - 10, Piwidth / 2, -boxHeight / 2 - 5 / 2]) connectionSocket();
            translate([-R + 10, Piwidth / 2, -boxHeight / 2 - 5 / 2]) connectionSocket();

            translate([0, 0, -boxHeight / 2 - 5 / 2]) cylinder(r = 3, h = 5);


translate([-Pilength / 2, -16, -boxHeight / 2 + 5 + shellThickness]) {
                rpi();
            }
//This is the power inlet. The +6 in z is half the z-lenght of the component
translate([-boxLength/2,-boxDepth/2+8,-boxHeight/2+shellThickness+2*mik+tolerance])cube([15+tolerance,9+tolerance,12], center=true);

        }
        translate([-Pilength / 2, -16, -boxHeight / 2 + 1 + shellThickness]) {
translate ([Pilength-3.5, Piwidth-3.5,-0.1]) PiSupport(); 
translate ([Pilength-3.5, -0+3.5,-0.1]) PiSupport();
translate ([Pilength-58-3.5, Piwidth-3.5,-0.1]) PiSupport(); 
translate ([Pilength-58, 0+3.5,-0.1]) PiSupport();
          //translate([25.5, 18, 0]) PiSupport();
            //translate([Pilength - 5, Piwidth - 12.5, 0]) PiSupport();

        }


    }
translate([-boxLength/2+15/2+mik,-boxDepth/2+8,-supportZ-boxHeight-4])rotate([0,0,180])SUB_Power();
  
}

module topLid() {
    tolerance = 0.02;

    difference() {
        difference() {
            {
                minkowski() {
                    translate([0, 0, -supportZ - supportBaseHeight - topCoverHeight / 2]) cube([boxLength + mik - 1, boxDepth + mik - 1, topCoverHeight], center = true);
                    sphere(r = mik); //cylinder(r = mik, h = 2);
                }
                translate([0, 0, -supportZ - supportBaseHeight]) {
                    scale([1 + tolerance, 1 + tolerance, 1]) base("false");
                    scale([0.9, 0.9, 30]) base("false");

                    //This is the grid an hole for mic.need to re-work the placement definition as it will not work for other box dimensions!!!
                    translate([boxLength / 2 - 5 - mik - boxThickness, -(boxDepth / 2 - 5 - mik - boxThickness), +14 - supportBaseHeight - topCoverHeight / 2]) rotate([0, 180, 0]) SUB_Mic();

                }
	
            }
	
        }
	



        scale([0.98,0.98,1])case ();

    }

//Need to explain the -1.4*supportBaseHeight
difference(){
translate([0,0,-supportZ-1.4*supportBaseHeight])rotate([0,-90,90])testSupport();
       case ();

}

}

module SUB_Mic() {
    translate([-7, 0, 0]) for (i = [1: 6]) {
        translate([i * 2, 0, 0]) cube([1, 10, 2], center = true);
    }
    cylinder(r = 5, h = 2 * topCoverHeight);

}

module SUB_Power(){
	difference(){	
		cube([15,9+3,12], center=true);
		translate([2,0,2])cube([15+tolerance,9+tolerance,12], center=true);
	}
}
module assembly(view) 
{

space = (view == "explode") ? 20 : 0;

translate([-space,0,0])cameraSupport();
translate([0,0,-space])support();
translate([-3*space,0,0])mountedPillar();
translate([0,0,-3*space])topLid();


//translate([0,0,-4*space-1.5*supportZ])panSupport();
translate([0,0,-6*space])case ();

}


//-------------------------------
module testSupport(xPos, Pos) {
        //Need to center the servo shaft, the seconf figure is the distance form border
        eccentricity = 22.2 / 2 - 5;
        servoBodySupport = 25;
        //Need to adjust the clearance to account for the Xpos
		armLenght = 1.4*(boxDepth/2);
       difference() {

            union() {

                difference() {
                    translate([-shellThickness / 2, 0, 15]) {
                        cube([shellThickness, servoBodySupport, armLenght], center = true);
                    }
					
                }

                translate([-servoBodySupport / 2, 0, eccentricity]) {
                    //This is the servo box
                    difference() {
                        cube([servoBodySupport, 12 + 1 + shellThickness, 22.2 + 1 + shellThickness], center = true);
                        cube([servoBodySupport, 12 + 1, 22.2 + 1], center = true);

                        //Servo cable slot
                        translate([0, 0, -2 * eccentricity]) cube([100, 4, 4], center = true);

                    }

                }
            }

            //This is the slot in the servo arm. Need to check why -15 in the translate is needed
translate([-(11)+(32.2/2+12/2+tolerance/2)-15, 0, eccentricity]) {

                cube([20 + tolerance, 12+tolerance/2, 32.2 + tolerance], center = true);
                translate([-31/2, 0, 0]) cube([31 + tolerance, 12+tolerance/2, 22.2 + tolerance], center = true);

            }
        


}	

//Dimensions are hardwired, should be parameters!!!
		translate([-10,0,+armLenght/2+15])rotate([270,0,0])linear_extrude(height = servoBodySupport, center = true, convexity = 10, twist = 0)
			//polygon([[0,0],[8,20],[10,0]], convexity = N);
 polygon([[0,0],[10,armLenght/3],[10,0]], convexity = N);
 	
}

//-------------------------


assembly("explode");
//case();
//topLid();
//SUB_Power();

//mountedPillar();

//servoTiltSupport(gimballWidth/2, "tilt");

//cameraSupport();
//support();
//camBolt();

    