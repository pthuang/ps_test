############################################
# export platform file(.hdf or .xsa) 
############################################

proc getFileName {namePath ext} {
    set files [glob -nocomplain -directory $namePath *]
    foreach i_file $files {
        if {[file isfile $i_file]} {
            set fileExtName [file extension $i_file] 
            if {$fileExtName == $ext} {
                puts $i_file
                puts [string length $namePath]
                puts [string length $ext]
                puts [string range $i_file [string length $namePath]+1 end-[string length $ext]]
                set topName [string range $i_file [string length $namePath]+1 end-[string length $ext]]
            } 
        } 
    }
    return $topName
}

set topName [getFileName $bitBackupDir ".bit"]
puts $topName

write_hw_platform -fixed -force -file $vitisDir/$topName.xsa
# write_hw_platform -fixed -force -include_bit -file $vitisDir/$topName.xsa
