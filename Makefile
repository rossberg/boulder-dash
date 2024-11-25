default: graphics

all: graphics tsdl raylib

graphics:
	dune build engine-$@/main_$@.exe
	ln -f _build/default/engine-$@/main_$@.exe boulderdash.exe

tsdl:
	dune build engine-$@/main_$@.exe
	ln -f _build/default/engine-$@/main_$@.exe boulderdash.exe

raylib:
	dune build engine-$@/main_$@.exe
	ln -f _build/default/engine-$@/main_$@.exe boulderdash.exe

clean:
	dune clean
