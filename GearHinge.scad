/* GearHinge.scad - Parametric geared hinge for FDM manufacturing
   Copyright (c) 2021 Stephen J. Carpenter <sjc@carpanet.net>
   
   License: MIT. See License.txt for details.
*/

use <PolyGear/PolyGear.scad>
include <PolyGear/PolyGearBasics.scad>
use <PolyGear/shortcuts.scad>

chamfer=30;
axis_angle=0;
//helix_angle = [ for (x=linspace(-1,1,11)) exp(-abs(x))*10*sign(x) ];
helix_turns = 3;
helix_steps = $preview ? 7 : 11;


helix_angle = [ for (x=linspace(-1,1,helix_steps)) exp(-abs(x))*10*sign(x) ];
//helix_angle = [ for (x=linspace(-helix_turns,helix_turns,helix_steps)) exp(-abs(x))*10*sign(x) ];


//helix_angle = constant(axis_angle/2);
//width = 10;
width=18; // width of the actual gears.
N = 9;    // Number of gear teeth.
// Force same number of teeth
N1=N;
N2=N;

Module=1.45;

ShaftD=4.2;
MeshD=Module*(N1+N2)/2;

SwingAdd = 1;
Swing = MeshD/2 + Module + SwingAdd;

// RefD = M*N ; Default M=1
tol=.2;
BackW=Swing+Module;
SideW=tol+BackW;

echo("Reference Diameter (MeshD): ", MeshD);
//rot=90*$t;
rot=3;

//meshed(rot=rot);

$fa = ($preview) ? 17 : .1;
$fs = ($preview) ?  3 : .1;
$incolor = true;

plate_print();
//plate_full_open();

//gear_hinge(rot=rot, box=false, rounded_case=true);
//translate([50,0,0]) gear_hinge(rot=rot, box=false, box_top=true);

module plate_full_open(rot=90) {
	rot = 90;
	gear_hinge(rot=rot, box=false, rounded_case=true);
}

module plate_print(rot=90-8, door=false) {
	gear_hinge(rot=rot, box=false, rounded_case=true, door=door);
}

module gear_hinge(
	box=true,
	rounded_case=false,
	box_top=true,
	box_color="green",
	left_gear_color="blue",
	right_gear_color="red",
	door = false,
	rot=0) {
	//offex=tol;
	bc  = $incolor ? box_color : undef;
	lgc = $incolor ? left_gear_color : undef;
	rgc = $incolor ? right_gear_color : undef;
	
	offex=0;
	color(lgc) translate([-MeshD/2 - offex,0]) rotate([0,0,rot]) blue_gear();
	color (rgc) translate([offex + MeshD/2,0]) rotate([0,0,-rot]) red_gear(door=door);
	if (box) {
		color(bc) box(full = true, top=box_top, tol=tol);
	} else if (rounded_case) {
		round_case(full=true, tol=tol);
	}
}

// gear_track_block - generates a bit of material to jam the gears at full
//         extention to ensure that the gears don't pop out. This is only 
//         added to one gear.

module gear_track_block() {
		difference() {
			CyS(r=MeshD/2 +.5, h=width/2, w1=275, w2=310);
			CyS(r=ShaftD+.5, h=width/2, w1=275, w2=310);
		}	
}


// gear_sector - Generates the shape of gear to be kept.
//         currently only used on the blue_gear. 
//         xxx: red_gear maybe should be refactored to use it?
module gear_sector(meshd, width) {
	CyS(r=meshd, h=width, w1=215, w2=15);
	CyS(r=meshd/2 - 1.6, h=width, w1=-1, w2=90);
}

// blue_gear - Gear on the left with the track block built into its back side.
module blue_gear() {
		intersection() {
			spur_gear(n=N1, w=width, m=Module, chamfer=chamfer, chamfer_shift=-2,helix_angle = helix_angle, add=-tol/4 );
				difference() {	
					gear_sector(meshd=MeshD, width=width);
			
					// Shaft Hole
					cylinder(d=ShaftD, h=width+2, center=true);
	
					// Block limit - side
					translate([-BackW+2*tol,-MeshD/2,0]) cube([MeshD,MeshD,width], center=true);
					// Block Limit - back

					translate([-MeshD,-1.5+tol, -(width+1)/2])
						cube([MeshD,1.5+tol,width+1]);

					// Block limit - front
					translate([0,0,-width/2]) cube([1,MeshD/2,width]);
				}
			}
		// leaf arm
		translate([2,11.6,0]) rotate([0,0,0]) leaf_arm(left=true, h=width+3.2);
} 

// Red Gear - Gear on the right.
module red_gear(door=false)
{ 
	difference() {
		union() {
		CyS(r=MeshD/2 - 2, h=width, w1=90, w2=190);
		intersection() {
			spur_gear(n=N2, w=width, m=Module, chamfer=chamfer, chamfer_shift=-2, helix_angle=-helix_angle, add=-tol/4);
			CyS(r=MeshD, h=width, w1=181, w2=-30);


		}
		
		// leaf arm
		translate([-2,11.6]) {
			if (door)  leaf_arm(left=false, h=width+3.2)
				translate([0,-4+tol])  { 
					translate([0,-1.6]) cube([4,5+2,width+3.2], center=true);
					difference() {
						translate([7,7]) cube([18,14,width+3.2], center=true);
						translate([10,7]) cube([14,6.5,width+4], center=true);
						translate([10,15]) rotate([90,0,0]) {
							cylinder(d=2.1, h=10);
							translate([0,0,5]) cylinder(d=2.8, h=12);
							translate([0,0,12]) cylinder(d=4, h=5);

						}
					}
				}
			else leaf_arm(left=false, h=width+3.2);
			}
		// Rear Block
		gear_track_block();
	}
	// Shaft Hole
	cylinder(d=ShaftD, h=width+2, center=true);
	// Block limit - side
	translate([BackW-2*tol,-MeshD/2,0]) cube([MeshD,MeshD,width+1], center=true);
	// Block limit - front
	translate([0,-1.5+tol, -(width+1)/2]) cube([MeshD,1.5+tol,width+1]);

	}

}

module leaf_arm(left=true, h, l, angle=false) {
	dx = 3;
	difference() {
			//cube([4,20,width+1], center=true);
			translate([0,-9.5+dx/2,0]) cube([4,dx,width], center=true);
			rot = left ? 270 : 90;
			rotate([0,rot,0]) {
				for (i = [-1, 1]) { // M2.5 insert
					$fn = 11;
					translate([i*(width/2-5.25),5,1.6])
						cylinder(d=5, h=1, center=true); // rim
					translate([i*(width/2-5.25),5,0])
						cylinder(d=3.8, h=20, center=true); // body
					
				}
			}
		}
		if ($children < 1) {
			translate([0,-6+tol,0]) cube([4,4,h], center=true);
		} else {
			children(0);
		}
}

module round_case_inner(meshd, shaftd, width, tol) {
	for (xi = [-1, 1] )
		translate([xi*meshd/2,0]) difference() {	
			cylinder(d=16.5, h=width+2*tol, center=true);
			cylinder(d=shaftd-2*tol, h=width+2*tol, center=true);
			translate([xi*12-8,-12,-(width/2 + 3)]) cube([16,12,width+6]);
	}
}

// round_case - generates the back shell of the hinge, which includes the axis 
//        posts of the hinges.
module round_case(
	d=ShaftD,
	tol=.25,
	top=true,
	MeshD=MeshD,
	Module=Module,
	SwingAdd=1,
	WallD=1.2,
	spine=false,
	full=true)
{

	Swing = MeshD/2 + Module + SwingAdd;
	BackW=WallD/2 + Swing+Module+1;
	SideW=tol + BackW-MeshD/2;
	
	difference() {
		intersection() {
			hull() {
				for (x = [-MeshD/2, MeshD/2] )
					translate([x,0])
						cylinder(d=18.5, h=width+3.2, center=true);
			}
			translate([-12,-12,-(width/2 + 3)]) cube([24,12,width+6]);
		}
		if (spine)
			round_case_inner(meshd=MeshD, shaftd=d, width=width, tol=tol);
		else {
			hull() round_case_inner(meshd=MeshD, shaftd=d, width=width, tol=tol);
		}

		if (full) {
			echo("full is true. Not splitting.");
		} else {
			echo("full is false. Splitting.");
			color($incolor ? "purple" : undef)
				translate([0,0,11]) cube([50,50,20], center=true);
		}
	}
	
	for (xi = [-1, 1]) {
		translate([xi*MeshD/2,0]) {
		// Shaft
		cylinder(d=d-2*tol, h=width+2, center=true);
		// Shaft Bottom/top
		for (s = [-1,1]) {
			translate([0,0,s*(width/2 + WallD/2 + 1.5*tol)])
				cylinder(d=d+4*tol, h=WallD+tol, center=true);
		}

		translate([xi*2.5,-WallD/2,0])
			cube([3+2*tol+Module+1,WallD,width+3.2], center=true);
		}
		translate([xi*11.5-.5,-MeshD/2,-(width + 3.2)/2]) cube([1,MeshD/2,width+3.2]);
	}
}


// Simple Square Box
// Lots of wasted space
// this was v1. Its ugly. Use rounded case.
module box(
	d=ShaftD,
	tol=.25,
	top=true,
	MeshD=MeshD,
	Module=Module,
	SwingAdd=1,
	WallD=1.5,
	full=true)
{

	Swing = MeshD/2 + Module + SwingAdd;
	BackW=WallD/2 + Swing+Module+1;
	SideW=tol -1 + BackW-MeshD/2;
	if (full == true) {
		mirror([1,0,0]) box(d=d, tol=tol, top=top, full=false);
	}
	
	translate([MeshD/2,0]) {
		// Shaft
		cylinder(d=d-2*tol, h=width+2, center=true);
		// Shaft Bottom/top
		for (s = [-1,1]) {
			translate([0,0,s*(width/2 + WallD/2 + 1.5*tol)])
				cylinder(d=d+3*tol, h=WallD+tol, center=true);
		}

		translate([BackW/2 - SideW +1,0]) cube([SideW+tol,WallD,width+1+2*tol], center=true);
		// Side Wall
		translate([SideW,-Swing/2]) cube([WallD,Swing+WallD,width+1+2*tol], center=true);
	}
	// Back Wall
	translate([BackW/2,-Swing,0]) cube([BackW,WallD,width+1+2*tol],center=true);
	// Bottom/Top
	if (top) { 
		translate([BackW/2,-(Swing)/2,+width/2 + WallD/2 + 2*tol]) 
			cube([BackW,Swing+WallD,WallD], center=true);
	}
	translate([BackW/2,-(Swing)/2,-width/2 - WallD/2 - 2*tol]) 
	difference() {
		cube([BackW,Swing+WallD,WallD], center=true);
	}

}
