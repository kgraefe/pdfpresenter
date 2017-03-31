set savewd [pwd]
cd [file dirname [info script]]
set libdir [file join [pwd] "lib"]

set auto_path [linsert $auto_path 0 $libdir]

cd $savewd
unset libdir
unset savewd

if {$argc > 0} {
	set argv0 [lindex $argv 0]
	set argv [lrange $argv 1 end]
	incr argc -1
	source $argv0
}
