#!/bin/sh
# -*- tcl -*-
# The next line is executed by /bin/sh, but not tcl \
exec tclsh "$0" ${1+"$@"}

package require Ffidlrt
package require winapi
package require winapix
package require twapi

# das Verzeichnis, in dem das Script als aktuelles Verzeichnis wählen
cd [file dirname [info script]]

set hwndToplevel [::winapi::FindWindow "AcrobatSDIWindow" ""]
set hwndToolbar [::winapi::FindWindowEx $hwndToplevel 0 "" "AVUICommandWidget"]
set hwndZoom [::winapi::FindWindowEx $hwndToolbar 0 "Edit" ""]
set hwndEntry [::winapi::FindWindowEx $hwndToolbar $hwndZoom "Edit" ""]

proc _get_window_text_length {hWnd} {
	::winapi::SendMessage $hWnd WM_GETTEXTLENGTH 0 0
}

proc get_window_text {hWnd} {
	set length [_get_window_text_length $hWnd]
	set buf [::ffidl::malloc [expr {[incr length]*2}]]
	::winapi::SendMessage $hWnd WM_GETTEXT $length $buf
	set text [::ffidl::pointer-into-string $buf]
	::ffidl::free $buf
	return $text
}

set slide [expr [get_window_text $hwndEntry] + 1]

# working:
set oldfocus [::twapi::get_foreground_window]
::twapi::set_focus [list $hwndEntry HWND]
::twapi::send_keys "{DEL}{DEL}{DEL}{DEL}{DEL}$slide{ENTER}"
::twapi::set_foreground_window  $oldfocus

set slideNumber [get_window_text $hwndEntry]

puts $slideNumber



