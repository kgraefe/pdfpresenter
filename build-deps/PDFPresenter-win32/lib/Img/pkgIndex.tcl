package ifneeded zlibtcl 1.2.5.0.3  [list load [file join $dir zlibtcl[info sharedlibextension]]]
package ifneeded pngtcl 1.4.3  [list load [file join $dir pngtcl[info sharedlibextension]]]

package ifneeded img::base 1.4.0.4 [list load [file join $dir tkimg[info sharedlibextension]]]

package ifneeded Img 1.4 {
    package require img::png

    package provide Img 1.4
}

package ifneeded img::png 1.4.0.4  [list load [file join $dir tkimgpng[info sharedlibextension]]]
