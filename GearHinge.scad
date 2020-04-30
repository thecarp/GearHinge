use <PolyGear/PolyGear.scad>
include <PolyGear/PolyGearBasics.scad>
use <PolyGear/shortcuts.scad>

chamfer=30;
axis_angle=0;
helix_angle = [ for (x=linspace(-1,1,11)) exp(-abs(x))*10*sign(x) ];

//helix_angle = constant(axis_angle/2);
//width = 100;
width=18;
N = 9;
// Force same number of teeth
N1=N;
N2=N;
Module=1.45;

ShaftD=4.5;
MeshD=Module*(N1+N2)/2;

SwingAdd = 1;
Swing = MeshD/2 + Module + SwingAdd;

// RefD = M*N ; Default M=1
tol=.2;
BackW=Swing+Module;
SideW=tol+BackW;

echo("Reference Diameter (MeshD): ", MeshD);
//rot=360/N1*$t;
// rot=90-90*$t;
rot=0;
//axis_angle = -50;
	
//meshed(rot=rot);

$fa = ($preview) ? 12 : .01;
$fs = ($preview) ?  2 : .01;

gear_hinge(rot=rot, box=true, box_top=true);
//translate([50,0,0]) gear_hinge(rot=rot, box=false, box_top=true);


module gear_sector() {
	CyS(r=MeshD, h=width, w1=215, w2=20);
	CyS(r=MeshD/2 - 2, h=width, w1=20, w2=90);
}

module gear_hinge(box=true, box_top=true, rot=0) {
	//offex=tol;
	offex=0;
	color("blue") translate([-MeshD/2 - offex,0]) rotate([0,0,rot]) blue_gear();
	color ("red") translate([offex + MeshD/2,0]) rotate([0,0,-rot]) red_gear();
	if (box) {
		color("green") box(full = true, top=box_top, tol=tol);
	}
}

module gear_track_block() {
		difference() {
			CyS(r=MeshD/2 + Module/2, h=width/2, w1=245, w2=250);
			CyS(r=ShaftD+1, h=width, w1=259, w2=271);
		}	
}

module blue_gear() {
	render() intersection() {
		spur_gear(n=N1, w=width, m=Module, chamfer=30, helix_angle = helix_angle );
			difference() {	
				gear_sector();
			
				// Shaft Hole
				cylinder(d=ShaftD, h=width+2, center=true);
	
				// Block limit - back
				translate([-BackW+2*tol,-MeshD/2,0]) cube([MeshD,MeshD,width], center=true);
				// Block limit - front
				translate([0,0,-width/2]) cube([1,MeshD/2,width]);
			}
		}
		// Rear Block
		gear_track_block();
		
		// leaf arm
		//translate([MeshD/2 - 2*Module,11,0]) cube([4,20,width+1], center=true);
		translate([MeshD/2 - 2*Module - .80,12.5,0]) rotate([0,0,0]) leaf_arm();
} 

module red_gear()
{ 
	render() difference() {
		union() {
		CyS(r=MeshD/2 - 2, h=width, w1=90, w2=160);
		intersection() {
			spur_gear(n=N2, w=width, m=Module, chamfer=30, helix_angle=-helix_angle);
			CyS(r=MeshD, h=width, w1=150, w2=-30);
		}
		
		// leaf arm
		translate([-MeshD/2 + 2*Module + .80,12.5,0]) leaf_arm();
		
	}
	// Shaft Hole
	cylinder(d=ShaftD, h=width+2, center=true);
	// Block limit -front
		translate([-Module/2,1,-width/2]) cube([Module,MeshD/2,width]);
	// Block limit
	translate([BackW-2*tol,-MeshD/2,0]) cube([MeshD,MeshD,width+1], center=true);
	}
}

module leaf_arm() {
	difference() {
			cube([4,20,width+1], center=true);
			rotate([0,90,0]) {
				for (i = [-1, 1]) {
					translate([i*(width/2-5.25),5,1.5]) cylinder(d=5.5, h=1, center=true);
					translate([i*(width/2-5.25),5,0]) cylinder(d=4.75, h=20, center=true);
				}
			}
		}
}

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