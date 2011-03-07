class MainWindow {
	inherit Window

	private variable strg

	private variable sep
	private variable btnNext
	private variable btnBack
	private variable wizDragToStartPresentation
	private variable wizSelectNotePosition

	# WizardFrames
	private variable frames [list]
	private variable curFrameIdx -1

	constructor {_strg} {
		if {![itcl::is object $_strg -class PDFPresenterStrg]} {
			error "Fehler: Falscher Parameter!"
		}
		set strg $_strg

		set window [$this getWidget]

		$this hide
		$this setTitle "PDFPresenter"
		$this setResizable false
		$this setIcon $::images(presentation)
		wm attributes $window -topmost true


		set frmMain [::Window::combineWidgetPath $window frmMain]
		ttk::frame $frmMain -border 5
		pack $frmMain -side top -fill both -expand true

		set frmFrames [Window::combineWidgetPath $frmMain frmFrames]
		ttk::frame $frmFrames
		pack $frmFrames -side top -fill both -expand true

		set sep [Window::combineWidgetPath $frmMain sep]
		ttk::separator $sep -orient horizontal
		pack $sep -side top -fill x -pady 10

		set btnNext [Window::combineWidgetPath $frmMain btnNext]
		ttk::button $btnNext -text "Next >" -command [list $this nextFrame]
		pack $btnNext -side right

		set btnBack [Window::combineWidgetPath $frmMain btnBack]
		ttk::button $btnBack -text "< Back" -command [list $this prevFrame]
		pack $btnBack -side left

		set wizOpenPDF [WizardOpenPDF #auto $this $frmFrames]
		lappend frames $wizOpenPDF

		set wizSelectNotePosition [WizardSelectNotePosition #auto $this $frmFrames]
		lappend frames $wizSelectNotePosition

		set wizShowMonitorPosition [WizardShowMonitorPosition #auto $this $frmFrames]
		lappend frames $wizShowMonitorPosition

		set wizDragToStartPresentation [WizardDragToStartPresentation #auto $this $frmFrames]
		lappend frames $wizDragToStartPresentation


		update idletasks
		set maxwidth 0
		set maxheight 0
		for {set i 0} {$i < [llength $frames]} {incr i} {
			set f [[lindex $frames $i] getWidget]

			set width [winfo reqwidth $f]
			set height [winfo reqheight $f]

			if {$width > $maxwidth} {
				set maxwidth $width
			}
			if {$height > $maxheight} {
				set maxheight $height
			}
		}

		$frmFrames configure -width $maxwidth -height $maxheight
		pack propagate $frmFrames false

		showFrame 0

		$this center
		$this show
	}

	public method frameReady {{value true}} {
		if {$value} {
			$btnNext configure -state enabled

			if {$curFrameIdx == [llength $frames] - 1} {
				$strg startPresentation [$wizDragToStartPresentation getPDFWindow]
			}
		} else {
			$btnNext configure -state disabled
		}
		
	}

	public method nextFrame {} {
		showFrame [expr $curFrameIdx + 1]
	}

	public method prevFrame {} {
		showFrame [expr $curFrameIdx - 1]
	}

	private method showFrame {idx} {
		if {$curFrameIdx != -1} {
			pack forget [[lindex $frames $curFrameIdx] getWidget]
		}

		pack [[lindex $frames $idx] getWidget] \
			-side top \
			-expand true \
			-fill both
		set curFrameIdx $idx

		[lindex $frames $idx] onDisplay

		if {[[lindex $frames $idx] isReady]} {
			$btnNext configure -state enabled
		} else {
			$btnNext configure -state disabled
		}

		if {$idx == 0} {
			pack forget $btnBack
		} else {
			pack $btnBack -side left
		}

		if {$idx == [llength $frames] - 1} {
			pack forget $btnNext
		} else {
			pack $btnNext -side right
		}

		return [lindex $frames $idx]
	}

	public method getNotesPosition {} {
		return [$wizSelectNotePosition getPosition]
	}

	destructor {
		$strg window_destroyed $this
	}

}
