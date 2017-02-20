#!/bin/bash

set -e

cd "$(dirname "$0")/.."

echo "Updating POTFILES.in..."
find src/ -name '*.tcl' > po/POTFILES.in

echo "Updating POT template..."
cd po
intltool-update -pot -gettext-package=pdfpresenter

