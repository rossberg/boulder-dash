all:
	dune build
	ln -sf _build/default/main.exe boulder_dash.exe

clean:
	dune clean
