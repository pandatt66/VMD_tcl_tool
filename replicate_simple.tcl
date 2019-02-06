# This script is used to duplicate an exist structrue in x direction.

# It was used in building lipid bilayer for coexistence phase transition temperature.


proc replicate_to_coexist_lipids {infile outfile} {
 # load input file
    set basemol [mol new $infile]
    
    set repmol [::TopoTools::replicatemol $basemol 2 1 1]

    set boxx [molinfo $basemol get a]

    set boxx_new [expr {$boxx*2}]

    molinfo $repmol set "a" "$boxx_new"

    pbc wrap -compound res 

    animate write pdb $outfile $repmol
}
