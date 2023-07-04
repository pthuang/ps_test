############################################
# path define 
############################################
set batDir [pwd]
set tclDir $batDir/tcl/
set bitDir $batDir/bit 


cd .. 
pwd 
set fpgaXprDir [pwd]
set simDir    $fpgaXprDir/sim 
set srcDir    $fpgaXprDir/src
set hdlDir    $srcDir/imports 
set constrDir $srcDir/constrs 
set ipDir     $srcDir/ip 
set bdDir     $srcDir/bd 
cd $batDir

############################################
# read project name from "xprname.txt"
############################################
set fid [open $tclDir/xprname.txt r]
set xprName [read $fid]
close $fid
set xprDir $batDir/$xprName/

############################################
# refresh filelist 
############################################
cd $tclDir
pwd 
source $tclDir/scanFile.tcl 
cd .. 

############################################
# update .gitignore depend on "listIp.txt"
############################################
cd $fpgaXprDir
source $tclDir/refreshGitIgnore.tcl
cd $batDir

# start_gui
