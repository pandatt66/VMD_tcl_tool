### This script is used to replicate a system with pbc to a new one with double size in x and y direction
### ex: replicate_sys md_npt_52cfa_dimer_cmcial.gro 208cfa_dimer_cmcial_512dppc.pdb

package require topotools
package require pbctools

proc replicate_sys {infile outfile} {


# load molecule
set basemol [mol new $infile]

# get boxx and  boxy value
set boxx [molinfo $basemol get a]
set boxy [molinfo $basemol get b]


# set new box size which x and y are doubled
set boxx_new [expr {$boxx*2}]
set boxy_new [expr {$boxy*2}]

 
# do the magic
set newmol [::TopoTools::replicatemol $basemol 2 2 1 ]

# make selections to be ordered
set lipid_new_upper [atomselect $newmol "same residue as (name P and z >45)"]
set lipid_new_lower [atomselect $newmol "same residue as (name P and z <45)"]  

set water_new [atomselect $newmol "same residue as water"]
set lignin_new [atomselect $newmol "same residue as (not water and not resname DPPC)"]

set newmol [::TopoTools::selections2mol [list $lipid_new_upper $lipid_new_lower $water_new $lignin_new]]

# set sel [atomselect $newmol all]
# $sel set resid [$sel get residue]

set ext [lindex [split $outfile .] end]

molinfo $newmol set "a b" "$boxx_new $boxy_new"

pbc wrap -compound res

animate write $ext $outfile $newmol

}
