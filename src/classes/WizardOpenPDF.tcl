class WizardOpenPDF {
	inherit WizardFrame

	constructor {parent} {WizardFrame::constructor $parent} {
		set w [$this getWidget]

		set lblHead [::Window::combineWidgetPath $w lblHead]
		ttk::label $lblHead -text "Open PDF file" -font "-weight bold"
		pack $lblHead -side top
	}
}
