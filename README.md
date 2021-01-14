# GearHinge

GearHinge is an openscad model of a geared hinge. This was developed as part 
of another project, but stands on its own as a part that could be re-used.

It is designed to be printed in place and without support materials. 
Printing is very sensitive to options, and slicing should be inspected to
ensure parts have not been connected internally.

Chamfer of 45 degrees with a profile shift of -2 has been enough to 
print this in PETG with a layer height of .15mm. These are the defaults.

Printing with a rotation higher than 92 degrees is likely to cause the
gears to be fused as the block tooth may make contact with its counterpart.

## Requirements

This model uses the PolyGear library https://github.com/dpellegr/PolyGear
in order to generate gears and slice them up.

## usage

```openscad
include <GearHinge.scad>

$incolor = true;

gear_hinge(width=18,rot=92, door=false);
```

## Status/Known Issues

Under development, should be vaguely usable.

1. Arms have no mounting holes for general use.
2. No functions/workflow exists for attaching arms to anything else.
4. Cannot be assembled or disassembled; must be printed in place.
5. Helix angle can only do a single "turn". Should be re-written to use sin.

## License

See License.txt file
