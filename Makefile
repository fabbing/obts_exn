source_dir:=src
source_makes:=$(wildcard ${source_dir}/*/Makefile ${source_dir}/*/*/Makefile)
presentation_dir:=presentation

# TODO git/ocaml
.PHONY: all
all: sources presentation


.PHONY: ocaml_git
ocaml_git:
	git submodule update --init --recursive

.PHONY: ocaml
ocaml: | ocaml_git
	cd ocaml && ./configure
	$(MAKE) -C ocaml


.PHONY: presentation
presentation:
	$(MAKE) -C ${presentation_dir}

.PHONY: clean-presentation
clean-presentation:
	$(MAKE) -C ${presentation_dir} clean


.PHONY: sources
sources:
	for mk in $(dir ${source_makes}); do \
		$(MAKE) -C $${mk}; \
	done

.PHONY: clean-sources
clean-sources:
	for mk in $(dir ${source_makes}); do \
		$(MAKE) -C $${mk} clean; \
	done


buildgraph.pdf: buildgraph.tex presentation/diagrams/buildgraph/buildgraph.tex
	pdflatex --shell-escape -halt-on-error $<

buildgraph.svg: buildgraph.pdf
	GS_OPTIONS=-dNEWPDF=false dvisvgm --libgs=/usr/lib/libgs.so --pdf $<


.PHONY: distclean
distclean: clean-presentation clean-sources

.PHONY: re
re: distclean sources presentation
