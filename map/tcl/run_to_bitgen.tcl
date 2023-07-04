############################################
# path define 
############################################
set batDir [pwd]
set tclDir $batDir/tcl/

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
	set bitGenerated 0
	set files [glob -nocomplain -directory [pwd] *]
    foreach i_file $files {
        if {[file isfile $i_file]} {
            set fileExtName [file extension $i_file]   
            if {$fileExtName == ".bit"} {
                set bitGenerated 1
            } 
        } 
    } 
cd $batDir

puts $bitGenerated

if {$bitGenerated == 0} {
	launch_runs synth_1
	wait_on_run synth_1
	launch_runs impl_1 -to_step write_bitstream
	wait_on_run impl_1
}

cd $bitDir
	set files [glob -nocomplain -directory [pwd] *]
    foreach i_file $files {
        if {[file isfile $i_file]} {
            set fileExtName [file extension $i_file]   
            if {$fileExtName == ".bit" || $fileExtName == ".ltx"} {
                file copy -force $i_file $batDir/bit/
            } 
        } 
    }
cd $batDir



start_gui 
