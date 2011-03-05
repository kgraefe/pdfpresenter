class PrepareWindow {
	inherit Window

	private variable ns

	private variable strg

	private variable presentationFile
	private variable notesFile

	private variable btnOK

	constructor {_strg} {
		if {![itcl::is object $_strg -class PDFPresenterStrg]} {
			error "Fehler: Falscher Parameter!"
		}
		set strg $_strg

		set ns [namespace current]$this
		namespace eval $ns {}

		set presentationFile ${ns}::presentationFile
		set $presentationFile ""
		set notesFile ${ns}::notesFile
		set $notesFile ""

		$this hide
		$this setTitle "PDFPresenter"
		$this setResizable false

		set window [$this getWidget]

		set frmMain [::Window::combineWidgetPath $window frmMain]
		ttk::frame $frmMain -width 200 -height 200 -border 3
		pack $frmMain -side top -fill both -expand true

		set row 0

		set lblPresentationFile [::Window::combineWidgetPath $frmMain lblPresentationFile]
		ttk::label $lblPresentationFile -text "Presentation file:"
		grid $lblPresentationFile -sticky w -row $row -column 0

		set txtPresentationFile [::Window::combineWidgetPath $frmMain txtPresentationFile]
		ttk::entry $txtPresentationFile -textvariable $presentationFile -width 30 -state readonly
		grid $txtPresentationFile -sticky we -row $row -column 1

		set btnPresentationFile [::Window::combineWidgetPath $frmMain btnPresentationFile]
		ttk::button $btnPresentationFile -text "..." -width 3 -command [list $this chooseFile $presentationFile]
		grid $btnPresentationFile -sticky we -row $row -column 2

		incr row

		set lblNotesFile [::Window::combineWidgetPath $frmMain lblNotesFile]
		ttk::label $lblNotesFile -text "Notes file:"
		grid $lblNotesFile -sticky w -row $row -column 0

		set txtNotesFile [::Window::combineWidgetPath $frmMain txtNotesFile]
		ttk::entry $txtNotesFile -textvariable $notesFile -width 30 -state readonly
		grid $txtNotesFile -sticky we -row $row -column 1

		set btnNotesFile [::Window::combineWidgetPath $frmMain btnNotesFile]
		ttk::button $btnNotesFile -text "..." -width 3 -command [list $this chooseFile $notesFile]
		grid $btnNotesFile -sticky we -row $row -column 2

		set btnCancel [::Window::combineWidgetPath $window btnCancel]
		ttk::button $btnCancel -text Cancel -command [list delete object $this]
		pack $btnCancel -side left -fill both -expand true

		set btnOK [::Window::combineWidgetPath $window btnOK]
		ttk::button $btnOK -text OK -state disabled -command [list $this send]
		pack $btnOK -side right -fill both -expand true

		# Debug
		set $presentationFile "C:/Users/kgraefe/Documents/Studium/Master/CUDA/beamer/Vortrag.pdf"
		set $notesFile "C:/Users/kgraefe/Documents/Studium/Master/CUDA/beamer/notes.pdf"
		$btnOK configure -state enabled

		$this center
		$this show
	}

	destructor {
		$strg window_destroyed $this
	}

	public method chooseFile {var} {
		set types {{"PDF Files" {.pdf}}}
		set selcted_type "PDF Files"

		set file [tk_getOpenFile -filetypes $types -parent [$this getWidget] -typevariable selected_type]

		if {[string equal [file extension $file] ".pdf"] && [file isfile $file] && [file readable $file]} {
			# TODO: Ende zeigen
			# TODO: Windows-Dateipfade
			set $var $file
		}

		if {![string equal [set $presentationFile] ""] && ![string equal [set $notesFile] ""]} {
			$btnOK configure -state enable
		}
	}

	public method send {} {
		$strg setFiles [set $presentationFile] [set $notesFile]
		delete object $this
	}
}
