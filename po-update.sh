#!/bin/bash
set -x

ls -1 src/*.tcl src/classes/*.tcl > po/POTFILES.in || exit 1

cd po || exit 1
intltool-update -g PDFPresenter -po || exit 1

for f in *.po
do test -f $f && intltool-update -g PDFPresenter ${f%.po}
test -f $f && msgfmt --tcl $f -l ${f%.po} -d ../src/locales
done

exit 0

