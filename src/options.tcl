set ::debug false

proc printhelp {} {
	puts "PDF Presenter"
	puts ""
	puts "Usage:"
	puts "    $::argv0 --help"
	puts "    $::argv0 \[options\]"
	puts ""
	puts "Options:"
	puts "    -h,--help"
	puts "        Print this help and exit."
	puts "    -d,--debug"
	puts "        Enable debug logging."
}

for {set optind 0} {$optind < [llength $argv]} {incr optind} {
	switch -- [lindex $argv $optind] {
		-h -
		--help {
			printhelp
			exit 0
		}

		-d -
		--debug {
			set ::debug true
		}

		default {
			printhelp
			exit 1
		}
	}
}


