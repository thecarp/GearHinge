use <PolyGear/PolyGear.scad>
use <PolyGear/shortcuts.scad>

width = 5;
N1 = 9;
N2 = 9;
axis_angle = -0;

// RefD = M/N ; Default M=1

MeshD=(N1+N2)/2;

echo("Reference Diameter (MeshD): ", MeshD);
//rot=360/N1*$t;
rot=90-5*$t;
//rot=90;
//axis_angle = -50;
color("blue") translate([-MeshD/2,0]) rotate([0,0,rot]) {
	render() intersection() {
		spur_gear(n=N1, w=width, helix_angle=constant(axis_angle/2));
	
		difference() {	
			CyS(r=MeshD, h=width, w1=215, w2=20);
			// Shaft Hole
			cylinder(d=4, h=12, center=true, $fn=16);
		}
	}
	
	// leaf arm
	translate([MeshD/2 - 1.75,4,0]) cube([1.25,8,5], center=true);
	
	// Block
	//difference() {
	//	translate([-MeshD/2 + 1.75,-3,0]) cube([1.25,3,5], center=true);
	//	translate([-4.125,-4.5,0]) rotate([0,0,45]) cube([1.5,3,6], center=true);
	//}

}

color ("red") translate([MeshD/2,0]) rotate([0,0,-rot]){
	render() { 
		difference() {
			union() {
			intersection() {
				spur_gear(n=N2, w=width, helix_angle=constant(axis_angle/2));
				CyS(r=MeshD, h=width, w1=150, w2=-30);
			}
			
			// leaf arm
			translate([-MeshD/2 + 1.75,4,0]) cube([1.25,8,5], center=true);
	
			// Block
			//translate([+MeshD/2 - 1,-1,0]) cube([1.5,6,5], center=true);
			//translate([3.5,-3.5,0]) rotate([0,0,-45]) cube([4,1.85,4], center=true);
			CyS(r=MeshD - 3, h=width, w1=-55, w2=-30);
		}
		// Shaft Hole
		cylinder(d=4, h=12, center=true, $fn=16);
		
		// Block limit
		translate([5.75,-3,0]) cube([5,5,5], center=true);
		}
	}
}

module box() {
	translate([MeshD/2,0]) {
		cylinder(d=4-.2, h=width+1,$fn=16, center=true);
		translate([2,0]) cube([5,1,width+1], center=true);
		translate([4.5,-3]) cube([1,7,width+1], center=true);
	}
	translate([-MeshD/2,0]) { 
		cylinder(d=4-.2, h=width+1,$fn=16, center=true);
		translate([-2,0]) cube([5,1,width+1], center=true);
		translate([-4.5,-3]) cube([1,7,width+1], center=true);
	}
	translate([0,-6.5,0]) cube([19,1,width+1],center=true);
	translate([0,-3.5,-width/2 - .75]) cube([19,6.5,1], center=true);
	translate([0,-3.5,width/2 + .75]) cube([19,6.5,1], center=true);
}

color("green") {
	//box();
}
