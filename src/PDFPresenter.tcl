#!/bin/sh
# -*- tcl -*-
# The next line is executed by /bin/sh, but not tcl \
exec tclsh "$0" ${1+"$@"}

set ::debug false

# das Verzeichnis, in dem das Script als aktuelles Verzeichnis wählen
cd [file dirname [info script]]

source packages.tcl
source classes.tcl
source functions.tcl
source images.tcl

if {$::debug} {
	if {[info exists starkit::topdir]} {
		set logfile [file join [file dirname $starkit::topdir] PDFPresenter.log]
		set fd [open $logfile "a"]
	} else {
		set fd stdout
	}

	::log::lvChannelForall $fd
	::log::lvSuppressLE emergency 0

	::log::log notice "Starting program at [clock format [clock seconds]]"
}

PDFPresenterStrg #auto

vwait forever
