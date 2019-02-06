################################################
#created by:Xinjie Tong

#This is used to reorder atoms in pdb file to be in consistent with topology

# res_cnt: the number of residues (or molecules)
# rtp_atname_order: the desired order list

# Usage example:

#rename 128 out.pdb {H00 O01 C02 C03 C04 O05 C06 O07 C08 C09 H0A C0B C0C H0D H0E H0F H0G C0H H0I H0J H0K C0M \
#      O0N H0O C0P O0Q H0R H0S O0T H0U H0V H0W C0X C0Y C0Z O10 C11 O12 C13 C14 H15 C16 C17 H18 H19 H1A H1B C1C \
#       H1D H1E H1F H1G H1H H1I}
################################################


proc rename { res_cnt out_pdb rtp_atname_order} {

#select all atoms at top level
set sel [atomselect top all]

#create an empty list
set sellist {}

#loop over residues
for {set i 0} {$i < $res_cnt} {incr i} {

set l1 $rtp_atname_order

foreach atom_reordering $l1 {
	set atom_x1 [atomselect top "residue $i and name $atom_reordering"]
	lappend sellist $atom_x1 }

}

#merge into one file
set mol [::TopoTools::selections2mol $sellist]

animate write pdb $out_pdb $mol

}
