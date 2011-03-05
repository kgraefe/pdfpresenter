proc do {script arg2 {arg3 {}}} {
	#
	# Implements a "do <script> until <expression>" loop
	# The "until" keyword ist optional
	#
	# It is as fast as builtin "while" command for loops with
	# more than just a few iterations.
	#

	if {[string compare $arg3 {}]} {
		if {[string compare $arg2 until]} {
			return -code 1 "Error: do script ?until? expression"
		}
	} else {
		# copy the expression to arg3, if only
		# two arguments are supplied
		set arg3 $arg2
	}

	set ret [catch { uplevel $script } result]
	switch $ret {

		0 -
		4 {}
		3 {return}
		default {

			return -code $ret $result
		}
	}

	set ret [catch {uplevel [list while "!($arg3)" $script]} result]
	return -code $ret $result
}
