class WizardDragToStartPresentation {
	inherit WizardFrame

	private variable window

	# dragging variables
	private variable dragging false
	private variable dragWidget {}
	private variable pdfwidget [list 0 HWND]
	private variable lasttoplevel [list 0 HWND]

	constructor {window parent} {WizardFrame::constructor $window $parent} {
		set w [$this getWidget]

		set lblHead [::Window::combineWidgetPath $w lblHead]
		ttk::label $lblHead \
			-text "Drag&Drop the icon to start the presentation!" \
			-font "-weight bold" \
			-justify center
		pack $lblHead -side top

		set lblDrag [::Window::combineWidgetPath $w  lblDrag]
		ttk::label $lblDrag -image $::images(drag_symbol) 
		pack $lblDrag \
			-side top \
			-padx 20 -pady 20 \
			-expand true

		# init drag (don't drop, it's not necessary)
		bind $lblDrag <ButtonPress-1>	[list $this drag start %W]
		bind $lblDrag <ButtonRelease-1>	[list $this drag stop %X %Y]
		bind $lblDrag <Motion>		[list $this drag motion %X %Y]

		set lblHint [Window::combineWidgetPath $w lblHint]
		ttk::label $lblHint \
			-text "Drop it to the CONTENT in your PDF Reader's window!" \
			-justify center
		pack $lblHint -side top

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
				$dragWidget configure -image $::images(drag_symbol)

				$window frameReady
			}

			motion {
				if {!$dragging} return

				set x [lindex $args 0]
				set y [lindex $args 1]

				set pdfwidget [twapi::get_window_at_location $x $y]
			}
		}
	}

	public method getPDFWidget {} {
		return $pdfwidget
	}
}
