#!/bin/sh
# -*- tcl -*-
# The next line is executed by /bin/sh, but not tcl \
exec tclsh "$0" ${1+"$@"}

# das Verzeichnis, in dem das Script als aktuelles Verzeichnis wählen
cd [file dirname [info script]]

set cur [open "icons/32x32/x-office-presentation.cur" r+]
fconfigure $cur -encoding binary -translation binary
# this is the file position of the x coord of the hot spot:
seek $cur 10
# set x=16
puts -nonewline $cur [binary format c 16]
# dto. for the y coord of the hot spot:
seek $cur 12
# set y=16
puts -nonewline $cur [binary format c 16]
close $cur

