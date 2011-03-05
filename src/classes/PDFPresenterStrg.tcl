class PDFPresenterStrg {
	private variable ns

	private variable mode prepare

	private variable presentation
	private variable notes

	private variable prepareWindow
	private variable mainWindow

	constructor {} {
		set ns [namespace current]$this
		namespace eval $ns {}

		set prepareWindow [PrepareWindow ${ns}::#auto $this]
	}

	destructor {
		catch {delete object $prepareWindow}
	}

	public method closeApplication {} {
		catch {delete object $this}
		destroy .
		exit
	}

	public method window_destroyed {window} {
		if {[string equal $window $prepareWindow] && [string equal $mode prepare]} closeApplication
	}

	public method setFiles {presentationFile notesFile} {
		set mode presentation

		set presentation [AcrobatPDF #auto $presentationFile $this]
		set notes [AcrobatPDF #auto $notesFile $this]

		set mainWindow [MainWindow ${ns}::#auto $this]
	}

	public method slideChanged {slide} {
		$presentation changeSlide $slide
		$notes changeSlide $slide
	}
}
