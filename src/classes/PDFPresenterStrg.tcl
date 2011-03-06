class PDFPresenterStrg {
	private variable ns

	private variable mode prepare

	private variable presentation
	private variable notes

	private variable prepareWindow
	private variable mainWindow

	constructor {} {
		set ns [namespace current]$this
		namespace eval $ns {}

		set mainWindow [MainWindow ${ns}::#auto $this]
	}

	destructor {
		catch {delete object $mainWindow}
	}

	public method closeApplication {} {
		catch {delete object $this}
		destroy .
		exit
	}

	public method window_destroyed {window} {
		#if {[string equal $window $prepareWindow] && [string equal $mode prepare]} closeApplication
		closeApplication
	}

	public method startPresentation {pdfwidget} {
		# TODO make it idiot-prove!
		set toplevel $pdfwidget
		set desktop [lindex [twapi::get_desktop_window] 0]
		while {[lindex [twapi::get_parent_window $toplevel] 0] != $desktop} {
			set toplevel [twapi::get_parent_window $toplevel]
		}
		
		set monitors [twapi::get_multiple_display_monitor_info]
		# TODO: check count!

		# TODO: check!
		array set laptop [lindex $monitors 0]
		array set beamer [lindex $monitors 1]
		#array set beamer {-extent {1366 0 2390 768} -workarea {1366 0 2390 768} -primary 0 -name {\\.\DISPLAY2}}

		twapi::set_focus $toplevel
		twapi::send_keys {^l}

		twapi::show_window $toplevel -sync

		set beamer_width [expr [lindex $beamer(-workarea) 2] - [lindex $beamer(-workarea) 0]]
		set beamer_height [expr [lindex $beamer(-workarea) 3] - [lindex $beamer(-workarea) 1]]

		set pdf_coords [twapi::get_window_coordinates $pdfwidget]
		set toplevel_coords [twapi::get_window_coordinates $toplevel]

		set deltaX_left		[expr [lindex $pdf_coords 0] - [lindex $toplevel_coords 0]]
		set deltaY_top		[expr [lindex $pdf_coords 1] - [lindex $toplevel_coords 1]]
		set deltaX_right	[expr [lindex $toplevel_coords 2] - [lindex $pdf_coords 2]]
		set detlaY_bottom	[expr [lindex $toplevel_coords 3] - [lindex $pdf_coords 3]]

		# TODO: make more flexible
		set target_width	[expr $beamer_width * 2]
		set target_height	$beamer_height

		# let's assume that the content is the only resizing part of the toplevel
		set toplevel_width	[expr $target_width + $deltaX_left + $deltaX_right]
		set toplevel_height	[expr $target_height + $deltaY_top + $detlaY_bottom]
		set toplevel_x		[expr [lindex $beamer(-workarea) 2] - $target_width - $deltaX_left]
		set toplevel_y		-$deltaY_top

		twapi::resize_window $toplevel $toplevel_width $toplevel_height
		twapi::move_window $toplevel $toplevel_x $toplevel_y
	}
}
