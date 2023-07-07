############################################
# Xilinx Vivado Project Git Environment 
# Maintenance Flow Contrl. 
############################################
set batDir [pwd]
set tclDir $batDir/tcl
set vitisDir $batDir/vitis
set bitBackupDir $batDir/bit

cd .. 
pwd 
set fpgaXprDir [pwd]
set srcDir    $fpgaXprDir/src
set hdlDir    $srcDir/imports 
set constrDir $srcDir/constrs 
set ipDir     $srcDir/ip 
set bdDir     $srcDir/bd 
set simDir    $fpgaXprDir/sim 
cd $batDir

# read project name from "xprname.txt"
set fid [open $tclDir/xprname.txt r]
set xprName [read $fid]
close $fid
set xprDir $batDir/$xprName

set bitDir $xprDir/$xprName.runs/impl_1

# refresh git rules(.gitignore)
source $tclDir/updateGitRules.tcl

# open project 
cd $xprDir
source $tclDir/openXpr.tcl
cd ..

# generate and backup bit file 
source $tclDir/generateBitstream.tcl

# save project to .tcl file 
source $tclDir/writeXpr2Tcl.tcl

# export platform file(.hdf or .xsa) 
source $tclDir/exportPlatform.tcl


# open Vivado GUI 
start_gui
