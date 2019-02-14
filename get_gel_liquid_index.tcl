### This script is used to get index from selections.
# It was created for index of (coexistence) lipid liquid and gel phase
# --By Xinjie
# section 1 for index is 1/4 left and right of a simulation box
# section 2 for the middle half of the box
# Last part for output save every 20 numbers a line to prevent GROMACS misreading.
# usage example:
# source get_gel_liquid_index.tcl
# ndxappend replicated_gel_centered.pdb gel_liquid.ndx P


proc ndxappend {infile ndxfile atom_name} {

  # Load input file (gro, pdb)
    set basemol [mol new $infile]

  #get boxsize
    set boxx [molinfo $basemol get a]

  # Create atom selections for 1/4 left and 3/4 in box
    set box_quater [expr $boxx/4]
    set box_last_quater [expr $boxx - $box_quater]

  #set selections for 1/4 left and 3/4 in box
    set sel_side_two_quaters [atomselect $basemol "same fragment as name $atom_name and (x<$box_quater or x>$box_last_quater)"]
    set sel_mid_half [atomselect $basemol "same fragment as name $atom_name and (x>=$box_quater and x<=$box_last_quater)"]


    set nside [$sel_side_two_quaters num]

    set nmid [$sel_mid_half num]


  # Indices for atoms in two selections
    set index_side_two_quaters [lsort -integer [$sel_side_two_quaters list]]

    set index_mid_half [lsort -integer [$sel_mid_half list]]


 # Add 1 to indices since GROMACS indices start at 1
    set i 0
    while {$i < $nside} {
        set index_side_two_quaters [lreplace $index_side_two_quaters $i $i [expr {[lindex $index_side_two_quaters $i] + 1}]]

        incr i
    }

   set j 0

   while {$j < $nmid} {
	set index_mid_half [lreplace $index_mid_half $j $j [expr {[lindex $index_mid_half $j] + 1}]]
        incr j
   }


  #open index file
    set fid [open $ndxfile a]

  # Append new index groups to index file for upper and lower selections

  	#section title and length of atom numbers
    puts $fid "\[ lipids_side_two_quaters \]"
    set length [llength $index_side_two_quaters]

	#write 20 number per line for GROMACS cannot buffer a long line
    for {set k 0} {$k<$length} {incr k 20} {
    set t [expr $k + 19 ]
    puts $fid [lrange $index_side_two_quaters $k $t]\n
    }

    	#same as above for the second section

    puts $fid "\[ lipids_mid_half \]"
    set length [llength $index_mid_half]

    for {set k 0} {$k<$length} {incr k 20} {
    set t [expr $k + 19 ]
    puts $fid [lrange $index_mid_half $k $t]\n
    }

    close $fid


}
