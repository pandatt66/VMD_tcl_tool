
################# 
# This script could be used to change atom names, sort and rename resnames, and reorder the # index for atoms.
# -- By Xinjie
#
#This example was used to for monolignols pdb from ATB 
#
# index start from 0 to the number of atoms-1
# resname into two groups, resi1_cnt is the number of resname1
# new_list is the new atom name of current idx corresponding to what in the topology. 
# resi1_idx_list format {[list idx1 idx2 ... ]}            ***the last idx has to followed a space before the square bracket or it will be ignored***

proc rename { "new_list" "resi1_idx_list" atom_cnt resi1_cnt out_pdb new_resname1 new_resname2 rtp_atname_order} {

set sel [atomselect top all]
set sellist {}

#starts from index 0 to the last , new_list for their future name,loop to change all.

for {set i 0} {$i < $atom_cnt} {incr i} {
set atom1 [atomselect top "index $i"]
$atom1 set name [lindex $new_list $i]

#There are two residues in this example. So the resi1_idx_list is for the first residue group
if {$i in "$resi1_idx_list"} {
	$atom1 set resid 1
	$atom1 set resname $new_resname1
	} else {
	$atom1 set resid 2
	$atom1 set resname $new_resname2
	}
	lappend sellist $atom1


$atom1 delete

}


set mol [::TopoTools::selections2mol $sellist]
animate write pdb temp.pdb $mol

#reorder atoms by saving them one by one

mol delete all
mol new temp.pdb

set sellist2 {}
set l1 $rtp_atname_order
foreach atom_reordering $l1 {
	set atom_x1 [atomselect top "name $atom_reordering"]
	lappend sellist2 $atom_x1 }


set mol [::TopoTools::selections2mol $sellist2]
animate write pdb $out_pdb $mol



}
