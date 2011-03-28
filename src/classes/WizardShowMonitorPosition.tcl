class WizardShowMonitorPosition {
	inherit WizardFrame

	private variable lblPosTop
	private variable lblPosLeft
	private variable lblPosRight
	private variable lblPosBottom

	private variable timerId ""

	constructor {window parent} {WizardFrame::constructor $window $parent} {
		set w [$this getWidget]

		set lblHead [Window::combineWidgetPath $w lblHead]
		ttk::label $lblHead -text [_ "Set up your desktop like this:"] -font "-weight bold"
		pack $lblHead -side top

		set frmPosition [Window::combineWidgetPath $w frmPosition]
		ttk::frame $frmPosition
		pack $frmPosition -side top

		set lblPosTop [Window::combineWidgetPath $frmPosition lblPosTop]
		ttk::label $lblPosTop -image $::images(beamer_lightgray)
		grid $lblPosTop -row 0 -column 1

		set lblPosLeft [Window::combineWidgetPath $frmPosition lblPosLeft]
		ttk::label $lblPosLeft -image $::images(beamer_lightgray)
		grid $lblPosLeft -row 1 -column 0

		set lblLaptop [Window::combineWidgetPath $frmPosition lblLaptop]
		ttk::label $lblLaptop -image $::images(laptop)
		grid $lblLaptop -row 1 -column 1 -padx 5 -pady 5

		set lblPosRight [Window::combineWidgetPath $frmPosition lblPosRight]
		ttk::label $lblPosRight -image $::images(beamer_lightgray)
		grid $lblPosRight -row 1 -column 2

		set lblPosBottom [Window::combineWidgetPath $frmPosition lblPosBottom]
		ttk::label $lblPosBottom -image $::images(beamer_lightgray)
		grid $lblPosBottom -row 2 -column 1

		set lblHint [Window::combineWidgetPath $w lblHint]
		ttk::label $lblHint \
			-text [_ "Make your laptop screen the primary screen!"] \
			-justify center
		pack $lblHint -side top
	}

	public method onDisplay {} {
		foreach w [list $lblPosTop $lblPosLeft $lblPosRight $lblPosBottom] {
			$w configure -image $::images(beamer_lightgray)
		}

		switch [[$this getWindow] getNotesPosition] {
			bottom	{$lblPosTop	configure -image $::images(beamer)}
			right	{$lblPosLeft	configure -image $::images(beamer)}
			left	{$lblPosRight	configure -image $::images(beamer)}
			top	{$lblPosBottom	configure -image $::images(beamer)}
		}

		checkMonitors
	}

	public method checkMonitors {} {
		set ret true
		after cancel $timerId
		set timerId [after 500 [list $this checkMonitors]]

		set monitors [twapi::get_multiple_display_monitor_info]

		if {[llength $monitors] != 2} {
			set ret false
		} else {
			array set screen0 [lindex $monitors 0]
			array set screen1 [lindex $monitors 1]
			if {$screen0(-primary)} {
				array set laptop [array get screen0]
				array set beamer [array get screen1]
			} else {
				array set beamer [array get screen0]
				array set laptop [array get screen1]
			}

			switch [[$this getWindow] getNotesPosition] {
				bottom	{set ret [expr [lindex $beamer(-workarea) 1] < [lindex $laptop(-workarea) 1]]}
				right	{set ret [expr [lindex $beamer(-workarea) 0] < [lindex $laptop(-workarea) 0]]}
				left	{set ret [expr [lindex $beamer(-workarea) 0] > [lindex $laptop(-workarea) 0]]}
				top	{set ret [expr [lindex $beamer(-workarea) 1] > [lindex $laptop(-workarea) 1]]}
			}
		}

		 

		$this setReady $ret
	}
}


