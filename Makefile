all:
	dune build
	ln -sf _build/default/main.exe boulderdash.exe

clean:
	dune clean
