# pkgIndex.tcl - Copyright (C) 2004 Pat Thoyts <patthoyts@users.sf.net>
#
#
namespace eval ::platform {
    proc platform {} {
        global tcl_platform
        set plat [lindex $tcl_platform(os) 0]
        set mach $tcl_platform(machine)
        switch -glob -- $mach {
            sun4* { set mach sparc }
            intel -
            i*86* { set mach x86 }
            "Power Macintosh" { set mach ppc }
        }
        switch -- $plat {
          AIX   { set mach ppc }
          HP-UX { set mach hppa }
        }
        return "$plat-$mach"
    }
}

if {![package vsatisfies [package provide Tcl] 8.4]} { return }
package ifneeded tile 0.7.2 \
    "namespace eval ::tile { variable library \"$dir\" }
     load [file join \$::tile::library [::platform::platform] \
              tile072[info sharedlibextension]] tile"
