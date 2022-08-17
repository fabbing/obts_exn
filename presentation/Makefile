tex_source:=presentation.tex
presentation:=${tex_source:.tex=.pdf}

ocaml_dir:=../ocaml
sources_dir:=src
sources:=${sources_dir}/ocaml/domain_state.h ${sources_dir}/ocaml/domain_state_abbr.h


.PHONY: all
all: ${presentation}

${presentation}: ${tex_source} ${sources}
	pdflatex --shell-escape ${tex_source}

.PHONY: clean
clean:
	rm -vf ${tex_source:.tex=}.{pdf,log,aux,lof}

.PHONY: distclean
distclean: clean
	rm -vf ${sources}

.PHONY: re
re: | clean all

.PHONY: watch
watch:
	while true; do \
		inotifywait -qq -e move_self presentation.tex; \
		pdflatex --shell-escape -halt-on-error ${tex_source}; \
		sleep 1; \
	done


${sources_dir}/ocaml/domain_state.h:
	gcc -E -P ${ocaml_dir}/runtime/caml/domain_state.h \
		| sed -nf ${sources_dir}/domain_state.sed >$@

${sources_dir}/ocaml/domain_state_abbr.h: ${sources_dir}/ocaml/domain_state.h
	sed -nf ${sources_dir}/domain_state_abbr.sed >$@ <$<

