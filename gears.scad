use <PolyGear/PolyGear.scad>
use <PolyGear/shortcuts.scad>

width = 8;
N = 9;
// Force same number of teeth
N1=N;
N2=N;
axis_angle = 0;
Module=2;

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
rot=80;
//axis_angle = -50;


meshed(rot=rot);
//meshed(box=false);

//gear_sector();

module gear_sector() {
	CyS(r=MeshD, h=width, w1=215, w2=20);
	CyS(r=MeshD/2 - 2, h=width, w1=20, w2=90);
}

module meshed(box=true, rot=0) {
	//offex=tol;
	offex=0;
	color("blue") translate([-MeshD/2 - offex,0]) rotate([0,0,rot]) blue_gear();
	color ("red") translate([offex + MeshD/2,0]) rotate([0,0,-rot]) red_gear();
	if (box) {
		color("green") box(full = true, top=false, tol=tol, ShaftFN=21);
	}
}

module gear_track_block() {
		difference() {
			CyS(r=MeshD/2 - Module/2, h=width, w1=260, w2=270);
			CyS(r=ShaftD+1, h=width, w1=259, w2=271);
		}	
}

module blue_gear() {
	 render() intersection() {
		spur_gear(n=N1, w=width, m=Module,helix_angle=constant(axis_angle/2));
			difference() {	
				gear_sector();
			
				// Shaft Hole
				cylinder(d=ShaftD, h=12, center=true, $fn=21);
	
				// Block limit - back
				translate([-BackW+2*tol,-MeshD/2,0]) cube([MeshD,MeshD,width], center=true);
				// Block limit - front
				translate([0,0,-width/2]) cube([1,MeshD/2,width]);
			}
		}
		// Rear Block
		gear_track_block();
		
		// leaf arm
		translate([MeshD/2 - 2*Module,7,0]) cube([3,12,width+1], center=true);
} 

module red_gear()
{
	render() { 
		difference() {
			union() {
			CyS(r=MeshD/2 - 2, h=width, w1=90, w2=160);
			intersection() {
				spur_gear(n=N2, w=width, m=Module, helix_angle=constant(axis_angle/2));
				CyS(r=MeshD, h=width, w1=150, w2=-30);
			}
			
			// leaf arm
			translate([-MeshD/2 + 2*Module,7,0]) cube([3,12,width+1], center=true);
	
			
		}
		// Shaft Hole
		cylinder(d=ShaftD, h=12, center=true, $fn=21);
		// Block limit -front
			translate([-Module/2,1,-width/2]) cube([Module,MeshD/2,width]);
		// Block limit
		translate([BackW-2*tol,-MeshD/2,0]) cube([MeshD,MeshD,width+1], center=true);
		}
	}
}

module box(
	d=ShaftD,
	tol=.25,
	top=true,
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
		mirror([1,0,0]) box(d=d, tol=tol, ShaftFN=ShaftFN, top=top, full=false);
	}
	
	translate([MeshD/2,0]) {
		// Shaft
		cylinder(d=d-2*tol, h=width+2,$fn=ShaftFN, center=true);
		// Bottom
		translate([0,0,-width/2 - WallD/2 - tol])cylinder(d=d+2*tol, h=WallD,$fn=ShaftFN, center=true);
		// Front Wall
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
		translate([-Swing/2,Swing/4,0]) cube([BackW/1.25, Swing/3,4],center=true);
	}

}
