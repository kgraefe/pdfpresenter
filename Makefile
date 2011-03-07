sdx = build-deps/sdx.exe
#sdx = build-deps/sdx_64

help:
	@echo "Usage: make <all|program|packages|clean|dist-clean>"

all: program packages

program: win32/PDFPresenter.exe
packages: packages/PDFPresenter_win32.zip packages/PDFPresenter_src.tar.gz

DEPENDENCIES=src/*.tcl src/icons/*.png src/classes/*.tcl

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
	tar czvf packages/PDFPresenter_src.tar.gz build-deps/ Makefile src/ ChangeLog.txt
	
packages/PDFPresenter_win32.zip: win32/PDFPresenter.exe
	mkdir -p tmp/PDFPresenter
	cp win32/PDFPresenter.exe ChangeLog.txt tmp/PDFPresenter
	cd tmp; zip -r PDFPresenter_win32.zip PDFPresenter/
	mkdir -p packages
	mv tmp/PDFPresenter_win32.zip packages/PDFPresenter_win32.zip
	rm -rf tmp
	

clean:
	rm -rf tmp/ *.kit *.vfs
	
dist-clean: clean
	rm -rf win32/ packages/
	
