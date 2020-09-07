#simple script deleting files from questa simulation
#questa should be closed

set files [glob *]
puts "$files"

foreach i $files {
    
    if {$i == "transcript" || $i == "vsim.wlf" || $i == "vsim_stacktrace.vstf" || $i == "vish_stacktrace.vstf"} {
        file delete -force $i
        puts "Deleting $i file"
    }

    if {$i == "work"} {
        file delete -force $i
        puts "Deleting $i dir"
    }
}