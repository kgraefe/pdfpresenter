foreach c [list \
		PDFPresenterStrg \
		Window \
		MainWindow \
		WizardFrame \
		WizardOpenPDF \
		WizardDragToStartPresentation \
		WizardSelectNotePosition \
		WizardShowMonitorPosition \
		PresentationWindow \
	] {
	source classes/${c}.tcl
}
