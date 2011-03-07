# TODO: rename drag_symbol
foreach icon [list \
		window_icon \
		drag_symbol \
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
set ::images(drag_empty)	[image create photo -file "icons/drag_symbol_lightgray.png"]

# this is Windows-only
set ::images(drag_cursor)	"@icons/drag_symbol.cur"
