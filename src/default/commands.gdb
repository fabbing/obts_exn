break *(&caml_start_program+65)
commands
silent
pipe output /x $r10 | ../latex.sh hex_var camlStackBegin
disable 1
continue
end

break *(&caml_start_program+80)
commands
silent
pipe output /x &((void**)$r10)[0] | ../latex.sh hex_var camlStackSpDwarfAt
pipe output /x ((void**)$r10)[0] | ../latex.sh hex_var camlStackSpDwarf
pipe output /x &((void**)$r10)[1] | ../latex.sh hex_var camlStackGcRegsAt
pipe output /x ((void**)$r10)[1] | ../latex.sh hex_var camlStackGcRegs
disable 2
continue
end

break *(&caml_start_program+106)
commands
silent
pipe output /x &((void**)$r10)[0] | ../latex.sh hex_var camlStackTrapNextAt
pipe output /x ((void**)$r10)[0] | ../latex.sh hex_var camlStackTrapNext
pipe output /x &((void**)$r10)[1] | ../latex.sh hex_var camlStackTrapHandlerAt
pipe output /a ((void**)$r10)[1] | ../latex.sh addr_var camlStackTrapHandler
disable 3
continue
end


break caml_program
commands
silent
pipe output /x &((void**)$rsp)[1] | ../latex.sh hex_var camlProgramBegin
pipe output /a ((void**)$rsp)[0] | ../latex.sh addr_var camlProgramRetaddr
continue
end

break *(&caml_program+18)
commands
silent
pipe output /x $rsp | ../latex.sh hex_var camlProgramEnd
continue
end


break camlDefault__entry
commands
silent
pipe output /x &((void**)$rsp)[1] | ../latex.sh hex_var frameEntryBegin
pipe output /a ((void**)$rsp)[0] | ../latex.sh addr_var frameEntryRetaddr
continue
end

break *(&camlDefault__entry+18)
commands
silent
pipe output /x $rsp | ../latex.sh hex_var frameEntryEnd
continue
end

break camlDefault__main_268
commands
silent
pipe output /x &((void**)$rsp)[1] | ../latex.sh hex_var frameMainBegin
pipe output /a ((void**)$rsp)[0] | ../latex.sh addr_var frameMainRetaddr
continue
end

break *(&camlDefault__main_268+18)
commands
silent
pipe output /x $rsp | ../latex.sh hex_var frameMainEnd
continue
end

break *(&camlDefault__main_268+22)
commands
silent
pipe output ((size_t*)$rsp)[0] | ../latex.sh var frameMainLocalOne
continue
end


break *(&camlDefault__main_268+98)
commands
silent
pipe output /x $rsp | ../latex.sh hex_var rspAfterRaiseMov
pipe output /x caml_state->exn_handler | ../latex.sh hex_var exnHandlerBeforeRaise
continue
end

break *(&camlDefault__main_268+102)
commands
silent
pipe output /x $rsp | ../latex.sh hex_var rspAfterRaiseFirstPop
pipe output /x caml_state->exn_handler | ../latex.sh hex_var exnHandlerAfterRaise
continue
end

break *(&camlDefault__main_268+104)
commands
silent
pipe output /x $rsp | ../latex.sh hex_var rspAfterRaiseSecondPop
continue
end
