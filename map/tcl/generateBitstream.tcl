############################################
# Generate & Backup Bitstream  
############################################
proc runToGenerateBit {} {
    reset_run synth_1
    launch_runs synth_1
    wait_on_run synth_1
    launch_runs impl_1 -to_step write_bitstream -jobs 12 
    wait_on_run impl_1
}

proc backupFiles {sourcePath DestPath args} {
    set files [glob -nocomplain -directory $sourcePath/ *]
    foreach i_file $files {
        if {[file isfile $i_file]} {
            set fileExtName [file extension $i_file] 
            foreach i_args $args {
                if {$fileExtName == $i_args} {
                    puts $i_file
                    file copy -force $i_file $DestPath
                }
            }
        } 
    }
}

set implStatus [get_property status [get_runs impl_1]]
puts $implStatus

if {[string equal $implStatus "write_bitstream Complete!"]} {
    if {[get_property NEEDS_REFRESH [get_runs impl_1]]} {
        runToGenerateBit
    } else { 
        backupFiles $bitDir $vitisDir ".bit" ".ltx"
        backupFiles $bitDir $bitBackupDir ".bit" ".ltx" 
    }
} else {
    runToGenerateBit
    backupFiles $bitDir $vitisDir ".bit" ".ltx"
    backupFiles $bitDir $bitBackupDir ".bit" ".ltx" 
}
