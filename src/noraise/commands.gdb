break camlNoraise__entry
commands
silent
pipe output /x &((void**)$rsp)[1] | ../latex.sh hex_var frameEntryBegin
pipe output /a ((void**)$rsp)[0] | ../latex.sh addr_var frameEntryRetaddr
continue
end

break *(&camlNoraise__entry+22)
commands
silent
pipe output /x $rsp | ../latex.sh hex_var frameEntryEnd
continue
end

break camlNoraise__main_273
commands
silent
pipe output /x &((void**)$rsp)[1] | ../latex.sh hex_var frameMainBegin
pipe output /a ((void**)$rsp)[0] | ../latex.sh addr_var frameMainRetaddr
continue
end

break *(&camlNoraise__main_273+18)
commands
silent
pipe output /x $rsp | ../latex.sh hex_var frameMainEnd
continue
end

break *(&camlNoraise__main_273+22)
commands
silent
pipe output ((size_t*)$rsp)[0] | ../latex.sh var frameMainLocalOne
continue
end

break *(&camlNoraise__main_273+29)
commands
silent
pipe output /x $rsp | ../latex.sh hex_var trapBegin
continue
end

break *(&camlNoraise__main_273+35)
commands
silent
pipe output /x caml_state->exn_handler | ../latex.sh hex_var exnHandlerBeforeTrap
pipe output /x ((void**)$rsp)[0] | ../latex.sh hex_var trapNext
pipe output /a ((void**)$rsp)[1] | ../latex.sh addr_var trapHandler
continue
end

break *(&camlNoraise__main_273+39)
commands
silent
pipe output /x caml_state->exn_handler | ../latex.sh hex_var exnHandlerAfterTrap
continue
end

break camlNoraise__maybe_raise_269
commands
silent
pipe output /x &((void**)$rsp)[1] | ../latex.sh hex_var frameMaybeBegin
pipe output /a ((void**)$rsp)[0] | ../latex.sh addr_var frameMaybeRetaddr
continue
end

break *(&camlNoraise__maybe_raise_269+22)
commands
silent
pipe output /x $rsp | ../latex.sh hex_var frameMaybeEnd
pipe output ((size_t*)$rsp)[0] | ../latex.sh var frameMaybeLocalOne
continue
end
