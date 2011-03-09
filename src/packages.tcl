package require twapi

package require Tk
wm withdraw .   ;# Root-Fenster verstecken

package require tile
# Style umstellen
if {$::tcl_platform(platform) == "unix"} {
	catch {style theme use clam}
}
wm withdraw .   ;# Root-Fenster verstecken


package require Itcl
namespace import itcl::*

package require Img

package require msgcat
::msgcat::mcload locales/
proc _ {s} {::msgcat::mc $s}


