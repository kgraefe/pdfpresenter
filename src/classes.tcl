foreach c [list \
		PDFPresenterStrg \
		Window \
		MainWindow \
		WizardFrame \
		WizardOpenPDF \
		WizardDragToStartPresentation \
		WizardSelectNotePosition \
		WizardShowMonitorPosition \
	] {
	source classes/${c}.tcl
}
