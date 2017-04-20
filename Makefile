sdx = build-deps/sdx.exe
#sdx = build-deps/sdx_64

.DEFAULT_GOAL:=run

-include local.mak

help:
	@echo "Usage: make <run|all|program|packages|clean|dist-clean>"

all: program packages

program: win32/PDFPresenter.exe
packages: packages/PDFPresenter_win32.zip packages/PDFPresenter_src.tar.gz

LANG_PO=$(wildcard po/*.po)
LANG_MSG=$(LANG_PO:po/%.po=src/locales/%.msg)

DEPENDENCIES=src/*.tcl src/icons/*.png src/classes/*.tcl $(LANG_MSG)

run: $(DEPENDENCIES)
	build-deps/tclkit-win32.exe \
		build-deps/PDFPresenter-win32/run.tcl \
		src/PDFPresenter.tcl --debug

win32/PDFPresenter.exe: $(DEPENDENCIES)
	rm -rf PDFPresenter.vfs
	$(sdx) qwrap src/PDFPresenter.tcl
	$(sdx) unwrap PDFPresenter.kit
	cp -r src/* PDFPresenter.vfs/lib/app-PDFPresenter
	cp -r build-deps/PDFPresenter-win32/* PDFPresenter.vfs/
	$(sdx) wrap PDFPresenter.exe -runtime build-deps/tclkit-win32.exe
	mkdir -p win32
	mv PDFPresenter.exe win32/PDFPresenter.exe

packages/PDFPresenter_src.tar.gz: $(DEPENDENCIES)
	mkdir -p packages
	tar czvf packages/PDFPresenter_src.tar.gz \
		build-deps/ Makefile src/ CHANGES.md \
		LICENSE.md licenses/
	
packages/PDFPresenter_win32.zip: win32/PDFPresenter.exe
	mkdir -p tmp/PDFPresenter
	cp win32/PDFPresenter.exe CHANGES.md tmp/PDFPresenter/
	cp -r LICENSE.md licenses/ tmp/PDFPresenter/
	cd tmp; zip -r PDFPresenter_win32.zip PDFPresenter/
	mkdir -p packages
	mv tmp/PDFPresenter_win32.zip packages/PDFPresenter_win32.zip
	rm -rf tmp

src/locales/%.msg: po/%.po
	mkdir -p src/locales
	msgfmt --tcl $< -l $(<:po/%.po=%) -d src/locales

clean:
	rm -rf tmp/ *.kit *.vfs src/locales
	
dist-clean: clean
	rm -rf win32/ packages/
	
