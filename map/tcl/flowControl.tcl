############################################
# Xilinx Vivado Project Git Environment 
# Maintenance Flow Contrl. 
############################################
set batDir [pwd]
set tclDir $batDir/tcl

# Environment configuration
source $tclDir/configEnvironment.tcl

# refresh git rules(.gitignore)
source $tclDir/updateGitRules.tcl

# open project 
cd $xprDir
source $tclDir/openXpr.tcl
cd ..

# save project to .tcl file 
source $tclDir/writeXpr2Tcl.tcl

# export platform file(.hdf or .xsa) 
source $tclDir/exportPlatform.tcl

# generate and backup bit file 
source $tclDir/generateBitstream.tcl

# open Vivado GUI 
start_gui
