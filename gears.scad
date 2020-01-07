use <PolyGear/PolyGear.scad>
use <PolyGear/shortcuts.scad>

width = 8;
N = 9;
// Force same number of teeth
N1=N;
N2=N;
axis_angle = 0;
Module=1.3;

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
//rot=90-90*$t;
rot=90;
//axis_angle = -50;
color("blue") translate([-MeshD/2,0]) rotate([0,0,rot]) {
	render() intersection() {
		spur_gear(n=N1, w=width, m=Module,helix_angle=constant(axis_angle/2));
	
		difference() {	
			CyS(r=MeshD, h=width, w1=215, w2=20);
			// Shaft Hole
			cylinder(d=ShaftD, h=12, center=true, $fn=16);
	
			// Block limit
			translate([-BackW+2*tol,-MeshD/2,0]) cube([MeshD,MeshD,width], center=true);
		}
	}
	
	// leaf arm
	translate([MeshD/2 - 2.5,4,0]) cube([2,8,5], center=true);

}

color ("red") translate([MeshD/2,0]) rotate([0,0,-rot]){
	render() { 
		difference() {
			union() {
			intersection() {
				spur_gear(n=N2, w=width, m=Module, helix_angle=constant(axis_angle/2));
				CyS(r=MeshD, h=width, w1=150, w2=-30);
			}
			
			// leaf arm
			translate([-MeshD/2 + 2.5,4,0]) cube([2,8,5], center=true);
	
			// Block
			//translate([+MeshD/2 - 1,-1,0]) cube([1.5,6,5], center=true);
			//translate([3.5,-3.5,0]) rotate([0,0,-45]) cube([4,1.85,4], center=true);
			CyS(r=MeshD - 3, h=width, w1=-55, w2=-30);
		}
		// Shaft Hole
		cylinder(d=ShaftD, h=12, center=true, $fn=16);
		
		// Block limit
		translate([BackW-2*tol,-MeshD/2,0]) cube([MeshD,MeshD,width+1], center=true);
		}
	}
}

module box(
	d=ShaftD,
	tol=.3,
	ShaftFN=$fn,
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
		mirror([1,0,0]) box(d=d, tol=tol, ShaftFN=ShaftFN, full=false);
	}
	
	translate([MeshD/2,0]) {
		// Shaft
		cylinder(d=d-tol, h=width+1,$fn=ShaftFN, center=true);
		// Front Wall
		translate([BackW/2 - SideW +1,0]) cube([SideW+tol,WallD,width+1], center=true);
		// Side Wall
		translate([SideW,-Swing/2]) cube([WallD,Swing+WallD,width+1], center=true);
	}
	// Back Wall
	translate([BackW/2,-Swing,0]) cube([BackW,WallD,width+1],center=true);
	// Bottom/Top
	translate([BackW/2,-(Swing)/2,-width/2 - WallD/2 - tol]) 
		cube([BackW,Swing+WallD,WallD], center=true);
	translate([BackW/2,-(Swing)/2,width/2 + WallD/2 + tol]) 
	difference() {
		cube([BackW,Swing+WallD,WallD], center=true);
		translate([-Swing/2,0,0]) cube([BackW/2, Swing/2,4],center=true);
	}

}

color("green") {
	box(full = true, ShaftFN=16);
}
