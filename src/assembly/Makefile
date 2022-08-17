rootdir:=..
src:=assembly.c
bin:=assembly.exe
dump:=do_asm

include ../Makefile.mk

${bin}: ${src}
	${CC} -Wall -Wextra -g -O0 $^ -o $@

