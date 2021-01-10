# GearHinge

GearHinge is an openscad model of a geared hinge. This was developed as part 
of another project, but stands on its own as a part that could be re-used.

It is designed to be printed in place and without support materials. Gears
should be rotates into the case (rot = 0) for printing.

## Requirements

This model uses the PolyGear library https://github.com/dpellegr/PolyGear
in order to generate gears and slice them up.

## usage

```openscad
include <GearHinge.scad>

$incolor = true;

gear_hinge(rot=rot, box=false, rounded_case=true);
```

## Status/Known Issues

Under development, not ready for the unadventurous.

1. Arms have no mounting holes for general use.
2. No functions/workflow exists for attaching arms to anything else.
3. Module is 1.45; it should be parametric. Hard coded values must go.
4. Cannot be assembled or disassembled; must be printed in place.
5. Helix angle can only do a single "turn". Should be re-written to use sin.

## License

See License.txt file
