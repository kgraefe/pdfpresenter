class PDFPresenterStrg {
	private variable mainWindow
	private variable presentationWindow
	private variable presentation

	constructor {} {
		set mainWindow [MainWindow #auto $this]
		set presentationWindow [PresentationWindow #auto $this]
	}

	destructor {
		catch {delete object $mainWindow}
	}

	public method closeApplication {} {
		catch {delete object $mainWindow}
		catch {delete object $presentationWindow}
		catch {delete object $this}
		destroy .
		images_cleanup
		exit
	}

	public method window_destroyed {window} {
		closeApplication
	}

	public method startPresentation {toplevel} {
		if {![string equal [twapi::get_window_class $toplevel] "AcrobatSDIWindow"]} return

		# Already running presentation?
		if {[lsearch [twapi::get_window_style $toplevel] popup] != -1} return

		set presentation $toplevel


		set notesPos [$mainWindow getNotesPosition]
		
		set monitors [twapi::get_multiple_display_monitor_info]
		# TODO: check count!

		# TODO: check!
		array set screen0 [lindex $monitors 0]
		array set screen1 [lindex $monitors 1]
		if {$screen0(-primary)} {
			array set beamer [array get screen1]
		} else {
			array set beamer [array get screen0]
		}

		twapi::set_focus $toplevel
		twapi::send_keys {^l}

		twapi::show_window $toplevel -sync

		set beamer_width [expr [lindex $beamer(-workarea) 2] - [lindex $beamer(-workarea) 0]]
		set beamer_height [expr [lindex $beamer(-workarea) 3] - [lindex $beamer(-workarea) 1]]

		switch $notesPos {
			top {
				set target_width	$beamer_width
				set target_height	[expr $beamer_height * 2]

				set target_x		[lindex $beamer(-workarea) 0]
				set target_y		[expr [lindex $beamer(-workarea) 1] - $beamer_height]
			}
			bottom {
				set target_width	$beamer_width
				set target_height	[expr $beamer_height * 2]

				set target_x		[lindex $beamer(-workarea) 0]
				set target_y		[lindex $beamer(-workarea) 1]
			}
			left {
				set target_width	[expr $beamer_width * 2]
				set target_height	$beamer_height

				set target_x		[expr [lindex $beamer(-workarea) 0] - $beamer_width]
				set target_y		[lindex $beamer(-workarea) 1]
			}
			right {
				set target_width	[expr $beamer_width * 2]
				set target_height	$beamer_height

				set target_x		[lindex $beamer(-workarea) 0]
				set target_y		[lindex $beamer(-workarea) 1]
			}
		}

		twapi::resize_window $toplevel $target_width $target_height
		twapi::move_window $toplevel $target_x $target_y

		$mainWindow hide
		$presentationWindow show

		setFocusToPresentation

	}

	public method setFocusToPresentation {} {
		twapi::set_focus $presentation
	}
}
