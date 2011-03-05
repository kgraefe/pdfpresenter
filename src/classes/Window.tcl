class Window {
	private variable window
	
	private common count 0
	private variable instance
	
	constructor {} {
		set instance $count
		incr count
		
		set window ".window${instance}"
		toplevel $window
		
		bind $window <Destroy> [list if "\"$window\" == \"%W\"" "$this toplevelDestroyed"]
	}
	
	destructor {
		bind $window <Destroy> {}
		destroy $window
	}
	
	proc combineWidgetPath {parent widget} {
		if {[string compare $parent .]==0} {
			return .${widget}
		} else {
			return ${parent}.${widget}
		}
	}

	public method toplevelDestroyed {} {
		bind $window <Destroy> {}
		set window ""
		delete object $this
	}
	
	public method getWidget {} {
		return $window
	}
	
	public method getWindowId {} {
		return [winfo id $window]
	}
	
	public method setMinSize {width height} {
		wm minsize $window $width $height
	}
	
	public method setMaxSize {width height} {
		wm maxsize $window $width $height
	}
	
	public method hide {} {
		wm withdraw $window
	}
	
	public method show {} {
		wm deiconify $window
	}

	public method isVisible {} {
		if {[string equal [wm state $window] "normal"]} {return true}
		if {[string equal [wm state $window] "zoomed"]} {return true}
		return false
	}

	public method maximize {} {
		if {$::tcl_platform(platform) != "unix"} {
			wm state $window zoomed
		}
	}
	
	public method center {} {
		# alle wartenden Aktionen ausführen, da diese die Größe beeinflussen könnten
		update idletasks
		
		# mittige Bildschirmposition ausrechnen
		set x [expr {[winfo screenwidth $window]/2 - [winfo reqwidth $window]/2}]
		set y [expr {[winfo screenheight $window]/2 - [winfo reqheight $window]/2}]
		
		# Fenster verschieben
		wm geom $window +$x+$y
	}
	
	public method setResizable {resizable} {
		if {$resizable == true} {
			wm resizable $window 1 1
		} elseif {$resizable == false} {
			wm resizable $window 0 0
		} else {
			error "Wrong argument for resizable!"
		}
	}
	
	public method setTitle {title} {
		wm title $window $title
	}
	public method setIcon {photo} {
		wm iconphoto $window $photo
	}
}
