class WizardFrame {
	private variable widget
	
	private common count 0
	private variable instance
	
	constructor {parent} {
		set instance $count
		incr count
		
		set widget [::Window::combineWidgetPath $parent wizardFrame${instance}]
		ttk::frame $widget
	}
	
	destructor {}
	
	public method getWidget {} {
		return $widget
	}
}
