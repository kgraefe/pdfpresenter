class AcrobatPDF {
	common ArcoRd "C:/Program Files (x86)/Adobe/Reader 10.0/Reader/AcroRd32.exe"
	common timeout 200 ;# ms

	private variable slideEntry
	private variable slide

	private variable strg

	constructor {file _strg} {
		set strg $_strg

		set res [::twapi::create_process $::AcrobatPDF::ArcoRd -cmdline "/n [file nativename $file]"]

		set pid [lindex $res 0]

		after 1000

		set hwndToplevel [::winapi::FindWindow "AcrobatSDIWindow" "[file tail $file] - Adobe Reader"]
		set hwndToolbar [::winapi::FindWindowEx $hwndToplevel 0 "" "AVUICommandWidget"]
		set hwndZoom [::winapi::FindWindowEx $hwndToolbar 0 "Edit" ""]
		set slideEntry [::winapi::FindWindowEx $hwndToolbar $hwndZoom "Edit" ""]

		set slide [retrieveSlide]

		after $::AcrobatPDF::timeout [list $this checkSlide]


	}

	private method retrieveSlide {} {
		set length [::winapi::SendMessage $slideEntry WM_GETTEXTLENGTH 0 0]

		set buf [::ffidl::malloc [expr {[incr length]*2}]]
		::winapi::SendMessage $slideEntry WM_GETTEXT $length $buf
		set text [::ffidl::pointer-into-string $buf]
		::ffidl::free $buf

		return $text
	}

	public method checkSlide {} {
		set newSlide [$this retrieveSlide]

		if {![string equal $slide $newSlide]} {
			set slide $newSlide
			$strg slideChanged $newSlide
		}

		after $::AcrobatPDF::timeout [list $this checkSlide]
	}

	public method changeSlide {s} {
		if {![string equal $s $slide]} {
			set slide $s

			set oldfocus [::twapi::get_foreground_window]
			::twapi::set_focus [list $slideEntry HWND]
			::twapi::send_keys "{DEL}{DEL}{DEL}{DEL}{DEL}$s{ENTER}"
			::twapi::set_foreground_window  $oldfocus
		}
	}
}
