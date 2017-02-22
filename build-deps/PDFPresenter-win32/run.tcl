set savewd [pwd]
cd [file dirname [info script]]
set libdir [file join [pwd] "lib"]

set auto_path [linsert $auto_path 0 $libdir]

cd $savewd
unset libdir
unset savewd

source $argv
