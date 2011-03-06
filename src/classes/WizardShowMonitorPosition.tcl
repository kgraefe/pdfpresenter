class WizardShowMonitorPosition {
	inherit WizardFrame

	private variable lblPosTop
	private variable lblPosLeft
	private variable lblPosRight
	private variable lblPosBottom

	constructor {window parent} {WizardFrame::constructor $window $parent} {
		set w [$this getWidget]

		set lblHead [Window::combineWidgetPath $w lblHead]
		ttk::label $lblHead -text "Set up your desktop like this:" -font "-weight bold"
		pack $lblHead -side top

		set frmPosition [Window::combineWidgetPath $w frmPosition]
		ttk::frame $frmPosition
		pack $frmPosition -side top

		set lblPosTop [Window::combineWidgetPath $frmPosition lblPosTop]
		ttk::label $lblPosTop -image $::images(beamer_lightgray)
		grid $lblPosTop -sticky we -row 0 -column 1

		set lblPosLeft [Window::combineWidgetPath $frmPosition lblPosLeft]
		ttk::label $lblPosLeft -image $::images(beamer_lightgray)
		grid $lblPosLeft -sticky we -row 1 -column 0

		set lblLaptop [Window::combineWidgetPath $frmPosition lblLaptop]
		ttk::label $lblLaptop -image $::images(laptop)
		grid $lblLaptop -sticky we -row 1 -column 1

		set lblPosRight [Window::combineWidgetPath $frmPosition lblPosRight]
		ttk::label $lblPosRight -image $::images(beamer_lightgray)
		grid $lblPosRight -sticky we -row 1 -column 2

		set lblPosBottom [Window::combineWidgetPath $frmPosition lblPosBottom]
		ttk::label $lblPosBottom -image $::images(beamer_lightgray)
		grid $lblPosBottom -sticky we -row 2 -column 1

		$this setReady true
	}

	public method onDisplay {} {
		foreach w [list $lblPosTop $lblPosLeft $lblPosRight $lblPosBottom] {
			$w configure -image $::images(beamer_lightgray)
		}

		puts [[$this getWindow] getNotesPosition]
		switch [[$this getWindow] getNotesPosition] {
			bottom	{$lblPosTop	configure -image $::images(beamer)}
			right	{$lblPosLeft	configure -image $::images(beamer)}
			left	{$lblPosRight	configure -image $::images(beamer)}
			top	{$lblPosBottom	configure -image $::images(beamer)}
		}
	}
}


