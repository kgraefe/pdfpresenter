package require Ffidlrt
package require winapix
package require twapi

package require tile
# Style umstellen
if {$::tcl_platform(platform) == "unix"} {
	catch {style theme use clam}
}
wm withdraw .   ;# Root-Fenster verstecken


package require Itcl
namespace import itcl::*


