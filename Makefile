test:
	ocamlbuild -use-ocamlfind test.byte && ./test.byte

compile:
	ocamlbuild -use-ocamlfind state.cmo command.cmo

play:
	ocamlfind ocamlc -g -package lablgtk2 -linkpkg command.mli state.mli command.ml state.ml view.ml -o view && ./view

check:
	bash checkenv.sh && bash checktypes.sh

zip:
	zip final-project.zip *.ml* *.jpg* *.png* *.md* *Makefile* *.txt*

zipcheck:
	bash checkzip.sh

clean:
	ocamlbuild -clean
	rm -f final-project.zip
