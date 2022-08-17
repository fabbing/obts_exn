break do_asm
commands
silent
pipe output /x &((void**)$rsp)[2] | ../latex.sh hex_var doAsmBegin
pipe output /a ((void**)$rsp)[1] | ../latex.sh addr_var doAsmRetaddr
pipe output /x &((void**)$rsp)[0] | ../latex.sh hex_var doAsmSavedRbp
continue
end

break *(&do_asm+8)
commands
silent
pipe output /x $rsp | ../latex.sh hex_var rspStepA
continue
end

break *(&do_asm+25)
commands
silent
pipe output ((size_t*)$rsp)[1] | ../latex.sh var doAsmLocalOne
pipe output ((size_t*)$rsp)[0] | ../latex.sh var doAsmLocalTwo
continue
end

break *(&do_asm+27)
commands
silent
pipe output /x $rsp | ../latex.sh hex_var rspStepB
pipe output ((size_t*)$rsp)[0] | ../latex.sh var doAsmLocalThree
continue
end

break *(&do_asm+28)
commands
silent
pipe output /x $rsp | ../latex.sh hex_var rspStepC
continue
end


break say_hello
commands
silent
pipe output /x $rsp | ../latex.sh hex_var rspStepD
pipe output /x &((void**)$rsp)[2] | ../latex.sh hex_var sayHelloBegin
pipe output /a ((void**)$rsp)[1] | ../latex.sh addr_var sayHelloRetaddr
pipe output /x &((void**)$rsp)[0] | ../latex.sh hex_var sayHelloEnd
continue
end


break *(&do_asm+33)
commands
silent
pipe output /x $rsp | ../latex.sh hex_var rspStepE
continue
end

break *(&do_asm+37)
commands
silent
pipe output /x $rsp | ../latex.sh hex_var rspStepF
continue
end
