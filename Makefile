NAME = boulderdash
APPNAME = BoulderDash
VERSION = 2.0.4

default:
	@echo "Available build targets:"
	@echo
	@echo "make graphics   # Build with Graphics library (no sound, no gamepad)"
	@echo "make tsdl       # Build with TSDL library"
	@echo "make raylib     # Build with Raylib library"
	@echo
	@echo "make zip-{mac,win,linux}  # Package up (requires building exe first)"

all: graphics tsdl raylib


graphics tsdl raylib: %:
	dune build src/api-$@/main_$@.exe
	ln -f _build/default/src/api-$@/main_$@.exe $(NAME).exe


mac: $(NAME).exe
	mkdir -p $(APPNAME).app/Contents
	cp -rf platform/mac/* assets $(NAME).exe $(APPNAME).app/Contents

dir: $(NAME).exe
	mkdir $(APPNAME)
	cp -rf $(NAME).exe assets $(APPNAME)

zip-mac: mac
	zip -r $(APPNAME)-$(VERSION)-mac.zip $(APPNAME).app

zip-win: dir
	cp  `which libwinpthread-1.dll` $(APPNAME)
	zip -r $(APPNAME)-$(VERSION)-win.zip $(APPNAME)
	rm -rf $(NAME)

zip-linux: dir
	zip -r $(APPNAME)-$(VERSION)-linux.zip $(APPNAME)
	rm -rf $(NAME)


clean:
	dune clean

distclean: clean
	rm -rf *.exe *.zip *.app
