############################################
# path define 
############################################
set batDir [pwd]
set tclDir $batDir/tcl/
set vitisDir $batDir/vitis/

############################################
# read project name from "xprname.txt"
############################################
set fid [open $tclDir/xprname.txt r]
set xprName [read $fid]
close $fid
set xprDir $batDir/$xprName/


set bitDir $xprDir/$xprName.runs/impl_1/

cd $xprDir

# open project 
open_project $xprName.xpr

set_param general.maxthreads 16 

cd ..

cd $bitDir
	set files [glob -nocomplain -directory [pwd] *]
    foreach i_file $files {
        if {[file isfile $i_file]} {
            set fileExtName [file extension $i_file]   
            if {$fileExtName == ".bit"} {
                # puts $i_file
                # puts [string length $bitDir]
                # puts [string length ".bit"]
            	# puts [string range $i_file [string length $bitDir]-1 end-[string length ".bit"]]
                set topName [string range $i_file [string length $bitDir]-1 end-[string length ".bit"]]
            } 
        } 
    }
cd $batDir

write_hw_platform -fixed -force  -include_bit -file $vitisDir/$topName.xsa

# start_gui 
