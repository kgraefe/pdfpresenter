# When script is sourced, the variable ir must contain the
# full path name of this file's directory.
if {$::tcl_platform(os) eq "Windows NT" &&
    ($::tcl_platform(machine) eq "intel" ||
     $::tcl_platform(machine) eq "amd64") &&
    [string index $::tcl_platform(osVersion) 0] >= 5} {
    package ifneeded twapi 3.0.29 [list load [file join $dir [expr {$::tcl_platform(machine) eq "amd64" ? "twapi64.dll" : "twapi.dll"}]]]
}
