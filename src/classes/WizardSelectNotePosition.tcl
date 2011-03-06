class WizardSelectNotePosition {
	inherit WizardFrame

	private variable positionWidgets

	private variable position

	constructor {window parent} {WizardFrame::constructor $window $parent} {
		set w [$this getWidget]

		set lblHead [Window::combineWidgetPath $w lblHead]
		ttk::label $lblHead -text "Where are the notes in your PDF?" -font "-weight bold"
		pack $lblHead -side top

		set frmPosition [Window::combineWidgetPath $w frmPosition]
		ttk::frame $frmPosition
		pack $frmPosition -side top

		set lblPosTop [Window::combineWidgetPath $frmPosition lblPosTop]
		ttk::label $lblPosTop -image $::images(notes_lightgray)
		grid $lblPosTop -sticky we -row 0 -column 1

		set lblPosLeft [Window::combineWidgetPath $frmPosition lblPosLeft]
		ttk::label $lblPosLeft -image $::images(notes_lightgray)
		grid $lblPosLeft -sticky we -row 1 -column 0

		set lblPresentation [Window::combineWidgetPath $frmPosition lblPresentation]
		ttk::label $lblPresentation -image $::images(drag_symbol)
		grid $lblPresentation -sticky we -row 1 -column 1

		set lblPosRight [Window::combineWidgetPath $frmPosition lblPosRight]
		ttk::label $lblPosRight -image $::images(notes_lightgray)
		grid $lblPosRight -sticky we -row 1 -column 2

		set lblPosBottom [Window::combineWidgetPath $frmPosition lblPosBottom]
		ttk::label $lblPosBottom -image $::images(notes_lightgray)
		grid $lblPosBottom -sticky we -row 2 -column 1

		set positionWidgets [list $lblPosTop $lblPosLeft $lblPosRight $lblPosBottom]

		$this setPosition "" ""

		bind $lblPosTop <ButtonPress-1> [list $this setPosition %W top]
		bind $lblPosLeft <ButtonPress-1> [list $this setPosition %W left]
		bind $lblPosRight <ButtonPress-1> [list $this setPosition %W right]
		bind $lblPosBottom <ButtonPress-1> [list $this setPosition %W bottom]

	}

	public method setPosition {w pos} {
		foreach l $positionWidgets {
			$l configure -image $::images(notes_lightgray)

			bind $l <Enter> {%W configure -image $::images(notes_gray)}
			bind $l <Leave> {%W configure -image $::images(notes_lightgray)}
		}

		if {![string equal $w ""]} {
			$w configure -image $::images(notes)
			bind $w <Enter> {}
			bind $w <Leave> {}

			set position $pos

			$this setReady true
			[$this getWindow] frameReady
		}


	}

	public method getPosition {} {
		return $position
	}
}

