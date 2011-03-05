#!/bin/sh
# -*- tcl -*-
# The next line is executed by /bin/sh, but not tcl \
exec tclsh "$0" ${1+"$@"}

# das Verzeichnis, in dem das Script als aktuelles Verzeichnis wählen
cd [file dirname [info script]]

source packages.tcl
source classes.tcl
source functions.tcl

PDFPresenterStrg #auto

vwait forever
