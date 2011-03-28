class PresentationWindow {
	inherit Window

	private variable strg

	private variable stopwatch -1
	private variable runnable true
	private variable running false

	private variable lblWatch
	private variable lblStopwatchImg
	private variable lblStopwatch

	# dragging variables
	private variable dragging false
	private variable dragWidget {}
	private variable pdfwidget [list 0 HWND]
	private variable pdftoplevel [list 0 HWND]

	constructor {_strg} {
		if {![itcl::is object $_strg -class PDFPresenterStrg]} {
			error "ERROR: wrong parameter!"
		}
		set strg $_strg

		set window [$this getWidget]

		$this hide
		$this setTitle [_ "PDF Presenter"]
		$this setResizable false
		$this setIcon $::images(presentation)
		wm attributes $window -topmost true

		bind $window <FocusIn> [list $strg setFocusToPresentation]


		set frmMain [::Window::combineWidgetPath $window frmMain]
		ttk::frame $frmMain -border 5
		pack $frmMain -side top -fill both -expand true

		set lblStopwatchImg [Window::combineWidgetPath $frmMain lblStopwatchImg]
		ttk::label $lblStopwatchImg -image $::images(clock_lightgray)
		pack $lblStopwatchImg -side left

		bind $lblStopwatchImg <Enter> {%W configure -image $::images(clock_gray)}
		bind $lblStopwatchImg <Leave> {%W configure -image $::images(clock_lightgray)}
		bind $lblStopwatchImg <Button-1> [list $this startStopWatch]
		bind $lblStopwatchImg <Double-Button-1> [list $this resetStopWatch]

		set lblStopwatch [Window::combineWidgetPath $frmMain lblStopwatch]
		# Translators: this is the initial value of the stop watch
		ttk::label $lblStopwatch -font "-weight bold -size -32" -text [_ "00:00:00"]
		pack $lblStopwatch -side left -expand true -fill x

		set sep [Window::combineWidgetPath $frmMain sep]
		ttk::separator $sep -orient vertical
		pack $sep -side left -fill y

		set lblDrag [::Window::combineWidgetPath $frmMain  lblDrag]
		ttk::label $lblDrag -image $::images(presentation) 
		pack $lblDrag -side left

		# init drag (don't drop, it's not necessary)
		bind $lblDrag <ButtonPress-1>	[list $this drag start %W]
		bind $lblDrag <ButtonRelease-1>	[list $this drag stop %X %Y]
		bind $lblDrag <Motion>		[list $this drag motion %X %Y]
		
		$this center
	}

	destructor {
		$strg window_destroyed $this
	}

	public method drag {command args} {
		switch $command {
			start {
				set w [lindex $args 0]

				set dragging true
				set dragWidget $w

				$w configure -cursor $::images(drag_cursor)
				$w configure -image $::images(drag_empty)
			}

			stop {
				if {!$dragging} return

				set x [lindex $args 0]
				set y [lindex $args 1]

				set dragging false
				$dragWidget configure -cursor {}
				$dragWidget configure -image $::images(presentation)

				$strg startPresentation $pdftoplevel
			}

			motion {
				if {!$dragging} return

				set x [lindex $args 0]
				set y [lindex $args 1]

				set pdfwidget [twapi::get_window_at_location $x $y]

				set pdftoplevel $pdfwidget
				set desktop [lindex [twapi::get_desktop_window] 0]
				while {[lindex [twapi::get_parent_window $pdftoplevel] 0] != $desktop} {
					set pdftoplevel [twapi::get_parent_window $pdftoplevel]
				}
			}
		}
	}

	public method startStopWatch {} {
		if {!$runnable} {return}

		bind $lblStopwatchImg <Enter> {}
		bind $lblStopwatchImg <Leave> {}
		bind $lblStopwatchImg <Button-1> [list $this pauseStopWatch]

		$lblStopwatchImg configure -image $::images(clock)

		set running true
		every 1000 [list $this updateStopWatch]
	}

	public method updateStopWatch {} {
		if {!$running} {
			set runnable true
			return false
		}

		incr stopwatch

		set seconds [expr $stopwatch % 60]
		set minutes [expr ($stopwatch - $seconds) / 60]
		set hours   [expr $minutes / 60]
		set minutes [expr $minutes - 60 * $hours]

		# Translators: hours:minutes:seconds
		$lblStopwatch configure -text [format [_ "%02d:%02d:%02d"] $hours $minutes $seconds]

		return true
	}

	public method pauseStopWatch {} {
		set runnable false
		set running false

		$lblStopwatchImg configure -image $::images(clock_gray)
		bind $lblStopwatchImg <Enter> {%W configure -image $::images(clock_gray)}
		bind $lblStopwatchImg <Leave> {%W configure -image $::images(clock_lightgray)}
		bind $lblStopwatchImg <Button-1> [list $this startStopWatch]
	}

	public method resetStopWatch {} {
		if {$running} {
			$this pauseStopWatch
		}

		set stopwatch -1
		$lblStopwatch configure -text [_ "00:00:00"]

	}
}
