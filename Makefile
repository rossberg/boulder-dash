NAME = BoulderDash
VERSION = 2.0.5

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
	mkdir -p $(NAME).app/Contents
	cp -rf platform/mac/* assets $(NAME).exe $(NAME).app/Contents

dir: $(NAME).exe
	mkdir $(NAME)
	cp -rf $(NAME).exe assets $(NAME)

zip-mac: mac
	zip -r $(NAME)-$(VERSION)-mac.zip $(NAME).app

zip-win: dir
	cp  `which libwinpthread-1.dll` platform/win/folder.jpg $(NAME)
	zip -r $(NAME)-$(VERSION)-win.zip $(NAME)
	rm -rf $(NAME)

zip-linux: dir
	zip -r $(NAME)-$(VERSION)-linux.zip $(NAME)
	rm -rf $(NAME)


clean:
	dune clean

distclean: clean
	rm -rf *.exe *.zip *.app
