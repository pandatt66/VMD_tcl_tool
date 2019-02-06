#Xinjie - Jan-2017

#This code is used to calculate dihedrals in VMD over frames

# Outfile can be *.dat ; a1 a2 a3 a4(atoms names). 

# Usage example:
# First load .gro and .xtc or .trr (trajectory file) in VMD, then run tcl in VMD terminal
# EPD molecule has three sets of dihedral need to be tested
#     source get_EPD_dihedral.tcl
#     all_angles dihe1.dat C0Y C0X O0Q C0M   (d1)
#     all_angles dihe2.dat C0X O0Q C0M C0H   (d2)
#     all_angles dihe3.dat C0B C0M O0Q C0X   (d3) 

# Notice: In some cases need to add resnames 
#

proc all_angles { outfile a1 a2 a3 a4 } {

set file [open "$outfile" w]

#select molecule
set molid [molinfo top] 
set sel [atomselect $molid all]

#get the indexes for all the molecules 
set frag_cnt [llength [lsort -unique [$sel get fragment]]]
$sel delete


for {set f 0} {$f < $frag_cnt} {incr f} {
	label delete Dihedrals 0

#Get a-b-c-d atoms index
	set sel [atomselect $molid "fragment $f and name $a1"]
	set idx1 [$sel get index]
	$sel delete

	set sel [atomselect $molid "fragment $f and name $a2"]
	set idx2 [$sel get index]
	$sel delete

	set sel [atomselect $molid "fragment $f and name $a3"]
	set idx3 [$sel get index]
	$sel delete	

	set sel [atomselect $molid "fragment $f and name $a4"]
	set idx4 [$sel get index]

#Get dihedral for each frame
	label add Dihedrals $molid/$idx1 $molid/$idx2 $molid/$idx3 $molid/$idx4
	
#Save result in one file for each frame
	puts  $file "[label graph Dihedrals 0]"

}
close $file 
}
