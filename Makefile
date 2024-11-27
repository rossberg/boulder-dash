NAME = boulderdash

default:
	@echo "Available build targets:"
	@echo
	@echo "make graphics   # Build with Graphics library (no sound, no gamepad)"
	@echo "make tsdl       # Build with TSDL library"
	@echo "make raylib     # Build with Raylib library"

all: graphics tsdl raylib


graphics tsdl raylib: %:
	dune build api-$@/main_$@.exe
	ln -f _build/default/api-$@/main_$@.exe $(NAME).exe


zip-%: %
	zip -r $(NAME).zip $(NAME).exe assets


clean:
	dune clean

distclean: clean
	rm -f *.exe
