# TODO: rename presentation
foreach icon [list \
		presentation \
		notes \
		notes_gray \
		notes_lightgray \
		laptop \
		beamer \
		beamer_lightgray \
		clock \
		clock_gray \
		clock_lightgray \
	] {
	set ::images($icon) [image create photo -file "icons/$icon.png"]
}
#set ::images(drag_empty)	[image create photo -width 32 -heiht 32]
set ::images(drag_empty)	[image create photo -file "icons/presentation_lightgray.png"]


# this is Windows-only
set cursorfile [file join $::env(TEMP) "presentation.cur"]
file copy -force icons/presentation.cur $cursorfile
set ::images(drag_cursor)	"@$cursorfile"

proc images_cleanup {} [list file delete $cursorfile]
