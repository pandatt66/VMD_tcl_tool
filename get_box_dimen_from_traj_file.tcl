#This script is for writting box dimensions into a file in VMD
#Input traj file can be .xtc or .trr 

#usage example:
#Load gro and xtc in VMD first,then run the following in VMD terminal
#  	source get_box_dimen_from_traj_file.tcl
#	get_unitcell_vmd dimen.dat

proc get_unitcell_vmd {outfile {molid top}} {


set file [open "$outfile" w]

# Loop over each trajectory frame

set f_cnts [molinfo $molid get numframes]

for {set f 0} {$f < $f_cnts} {incr f} {

	molinfo $molid set frame $f

	set xx [molinfo $molid get a]
	set yy [molinfo $molid get b]
	set zz [molinfo $molid get c]
	set alpha [molinfo $molid get alpha]
	set beta  [molinfo $molid get beta]
	set gamma [molinfo $molid get gamma]

puts $file "$xx $yy $zz $alpha $beta $gamma"

}

}


