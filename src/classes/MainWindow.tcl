class MainWindow {
	inherit Window

	private variable ns

	private variable strg

	private variable sep
	private variable btnNext
	private variable btnBack
	private variable wizDragToStartPresentation

	# WizardFrames
	private variable frames [list]
	private variable curFrameIdx -1

	constructor {_strg} {
		if {![itcl::is object $_strg -class PDFPresenterStrg]} {
			error "Fehler: Falscher Parameter!"
		}
		set strg $_strg

		set ns [namespace current]$this
		namespace eval $ns {}

		$this hide
		$this setTitle "PDFPresenter"
		$this setResizable false
		$this setIcon $::images(window_icon)

		set window [$this getWidget]

		set frmMain [::Window::combineWidgetPath $window frmMain]
		ttk::frame $frmMain -width 300 -height 300 -border 5
		pack $frmMain -side top -fill both -expand true

		set wizOpenPDF [WizardOpenPDF #auto $frmMain]
		lappend frames [$wizOpenPDF getWidget]

		set wizDragToStartPresentation [WizardDragToStartPresentation #auto $this $frmMain]
		lappend frames [$wizDragToStartPresentation getWidget]

		set sep [Window::combineWidgetPath $frmMain sep]
		ttk::separator $sep -orient horizontal
		pack $sep -side top -fill x -pady 10

		set btnNext [Window::combineWidgetPath $frmMain btnNext]
		ttk::button $btnNext -text "Next >" -command [list $this nextFrame]
		pack $btnNext -side right

		set btnBack [Window::combineWidgetPath $frmMain btnBack]
		ttk::button $btnBack -text "< Back" -command [list $this prevFrame]
		pack $btnBack -side left

		update idletasks
		set maxwidth 0
		set maxheight 0
		for {set i 0} {$i < [llength $frames]} {incr i} {
			set f [showFrame $i]
			update idletasks

			if {[$f cget -width] > $maxwidth} {
				set maxwidth [$f cget -width]
			}
			if {[$f cget -height] > $maxheight} {
				set maxheight [$f cget -height]
			}
		}


		pack propagate $frmMain false
		showFrame 0

		$this center
		$this show
	}

	public method frameReady {{value true}} {
		if {$value} {
			$btnNext configure -state enabled

			if {$curFrameIdx == [llength $frames] - 1} {
				$strg startPresentation [$wizDragToStartPresentation getPDFWidget]
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
			pack forget [lindex $frames $curFrameIdx]
		}

		pack [lindex $frames $idx] \
			-side top \
			-before $sep \
			-expand true
		set curFrameIdx $idx

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

	destructor {
		$strg window_destroyed $this
	}

}
