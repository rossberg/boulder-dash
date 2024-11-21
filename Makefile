default: graphics

graphics:
	dune build main_$@.exe
	ln -sf _build/default/main_$@.exe boulderdash.exe

raylib:
	dune build main_$@.exe
	ln -sf _build/default/main_$@.exe boulderdash.exe

tsdl:
	dune build main_$@.exe
	ln -sf _build/default/main_$@.exe boulderdash.exe

clean:
	dune clean
