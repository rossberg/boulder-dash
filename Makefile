all:
	dune build
	ln -f _build/default/main.exe boulderdash.exe

clean:
	dune clean
