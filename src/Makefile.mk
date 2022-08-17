ocaml:=${rootdir}/../ocaml
ocamlopt:=${ocaml}/ocamlopt.opt
gdb_cmd:=commands.gdb
gdb_output:=gdb.out
main_cmm:=${bin:.exe=.cmm}
main_linear:=${bin:.exe=.linear}

src_ml=$(filter %.ml,${src})
cmm:=$(addsuffix .cmm,${cmm})
linear:=$(addsuffix .linear,${linear})
dump:=$(addsuffix .objdump,${dump})

targets:=${bin} ${cmm} ${linear} ${dump}
ifneq ($(wildcard ${gdb_cmd}),) # wildcard tests if the file exists
targets+=${gdb_output}
endif

.PHONY: all
all: ${targets}

${bin}: ${src}
	${ocamlopt} -I ${ocaml}/stdlib ${ocflags} -S ${src} -o ${bin}

${main_cmm}: ${bin}
	${ocamlopt} -I ${ocaml}/stdlib ${ocflags} -dcmm ${src} -o /dev/null >$@ 2>&1

%.cmm: ${main_cmm}
	awk -v fn="$(basename $(notdir $@))" -f ${rootdir}/cmm_fn.awk >$@ <${main_cmm}

${main_linear}: ${bin}
	${ocamlopt} -I ${ocaml}/stdlib ${ocflags} -dlinear ${src} -o /dev/null >$@ 2>&1

%.linear: ${main_linear}
	awk -v fn="$(basename $(notdir $@))" -f ${rootdir}/linear_fn.awk >$@ <${main_linear}

%.objdump: ${bin}
	objdump --section=.text --wide --no-show-raw-insn --disassemble=${$(notdir @):.objdump=} ${bin} \
    | sed -n "/${@:.objdump=}/,$$ p" \
    | sed 's/[ ]* # \([[:xdigit:]]*\).*/ # \1/' >$@

.PHONY: record
record: ${bin} ${gdb_cmd}
	-OCAMLRUNPARAM="${ocamlrunparam}" rr record -- $(notdir ${bin})

.PHONY: replay
replay: ${bin} ${gdb_cmd}
	rr replay -q -x ${gdb_cmd} -- --batch -ex continue

${gdb_output}: ${gdb_cmd} | record replay

.PHONY: clean
clean:
	rm -vf ${bin} ${src_ml:.ml=.s}
	rm -vf ${main_cmm}
	rm -vf ${src_ml:.ml=.o} ${src_ml:.ml=.cm*}
ifneq (${cmm},)
	rm -vf ${cmm} ${main_cmm}
endif
ifneq (${linear},)
	rm -vf ${linear} ${main_linear}
endif
ifneq (${dump},)
	rm -vf ${dump}
endif
ifneq (${gdb_output},)
	rm -vf ${gdb_output}
endif

.PHONY: re
re: | clean all
