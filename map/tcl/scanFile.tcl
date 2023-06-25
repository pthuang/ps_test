# process 
source findFiles.tcl


#######################################
# scan source files 
#######################################
set srcFileName "./listSrc.txt"
set srcPath $hdlDir
set status [catch {set fid [open $srcFileName w+]} msg]
if {$status} { 
	puts $msg
}
findFiles $srcPath $fid ".v" ".vh" ".vhd" ".sv"
close $fid


#######################################
# scan simulation files 
#######################################
set simFileName "./listSim.txt"
set simPath $simDir
set status [catch {set fid [open $simFileName w+]} msg]
if {$status} { 
	puts $msg
}
findFiles $simPath $fid ".v" ".vh" ".vhd" ".sv"
close $fid

#######################################
# scan block design files 
#######################################
set bdFileName "./listBd.txt"
set bdPath $bdDir
set status [catch {set fid [open $bdFileName w+]} msg]
if {$status} { 
	puts $msg
}
findFiles $bdPath $fid ".bd"
close $fid

#######################################
# scan ip files 
#######################################
set ipFileName "./listIp.txt"
set ipPath $ipDir
set status [catch {set fid [open $ipFileName w+]} msg]
if {$status} { 
	puts $msg
}
findFiles $ipPath $fid ".xci"
close $fid


#######################################
# scan constrains files 
#######################################
set constrFileName "./listConstr.txt"
set constrPath $constrDir
set status [catch {set fid [open $constrFileName w+]} msg]
if {$status} { 
	puts $msg
}
findFiles $constrPath $fid ".xdc" ".ucf" 
close $fid