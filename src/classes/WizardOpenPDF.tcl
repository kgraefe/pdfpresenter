class WizardOpenPDF {
	inherit WizardFrame

	constructor {window parent} {WizardFrame::constructor $window $parent} {
		set w [$this getWidget]

		set lblHead [::Window::combineWidgetPath $w lblHead]
		ttk::label $lblHead -text [_ "Open PDF presentation please!"] -font "-weight bold"
		pack $lblHead -side top

		set lblHint [Window::combineWidgetPath $w lblHint]
		# Translators: "\u2192" represents a right arrow
		ttk::label $lblHint \
			-text [_ "\u2192 Use Adobe Reader X!\n\u2192 Move it to your laptop screen!"]
		pack $lblHint -side top -expand true

		$this setReady true
	}
}
