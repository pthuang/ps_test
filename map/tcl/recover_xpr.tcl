############################################
# path define 
############################################
set batDir [pwd]
set tclDir $batDir/tcl/ 

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


############################################
# read project name from "xprname.txt"
############################################
set fid [open $tclDir/xprname.txt r]
set xprName [read $fid]
close $fid
set xprDir $batDir/$xprName/


############################################
# read bd name from "listBd.txt"
############################################
set fid [open $tclDir/listBd.txt r]
set bdName [read $fid]
puts $bdName
close $fid
set xprDir $batDir/$bdName/

############################################
# recover bd file
############################################
cd $srcDir
foreach i_bd $bdName { 
    # puts [file dirname $i_bd]
    # puts [string range $i_bd [string length [file dirname $i_bd]]+1 end-3]
    set bdname [string range $i_bd [string length [file dirname $i_bd]]+1 end-3]
    puts ./bd/$bdname.tcl

    cd ./bd/
    if {[file isdirectory $bdname]} { 
        cd ..  
        puts "BD $bdname is exist!"
    } else {
        cd ..
        source ./bd/$bdname.tcl
        puts "BD $bdname is recovered!" 
    }
}

# close_bd_design 
foreach i_bd $bdName { 
    set bdname [string range $i_bd [string length [file dirname $i_bd]]+1 end-3]
    close_bd_design [get_bd_designs $bdname]
}

# close_project unused 
close_project 

# delete unused file 
file delete -force NA
file delete -force myproj
file delete -force .Xil


############################################
# recover xpr file
############################################
cd $batDir 
puts $xprName.tcl

if {[file isdirectory $xprName]} { 
    puts "Project $xprName is exist!"
} else { 
    source $xprName.tcl
    puts "Project $xprName is recovered!" 
}

# generate_target all [get_files  {D:/ZWT/temp/ps_test/src/bd/zynq/zynq.bd D:/ZWT/temp/ps_test/src/bd/mb_sys/mb_sys.bd}]


