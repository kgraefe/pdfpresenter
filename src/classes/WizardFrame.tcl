class WizardFrame {
	private variable widget
	
	private common count 0
	private variable instance

	private variable window
	private variable ready false
	
	constructor {_window parent} {
		if {![itcl::is object $_window -class MainWindow]} {
			error "ERROR: Wrong parameter!"
		}
		set window $_window

		set instance $count
		incr count


		
		set widget [::Window::combineWidgetPath $parent wizardFrame${instance}]
		ttk::frame $widget
	}
	
	destructor {}
	
	public method getWidget {} {
		return $widget
	}

	public method setReady {r} {
		set ready $r
		$window frameReadyStateChanged $this
	}

	public method isReady {} {
		return $ready
	}

	public method getWindow {} {
		return $window
	}

	public method onDisplay {} {}
}
