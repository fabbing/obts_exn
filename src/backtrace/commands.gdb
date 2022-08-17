break camlBacktrace__entry
commands
#silent
pipe output /x &((void**)$rsp)[1] | ../latex.sh hex_var frameEntryBegin
pipe output /a ((void**)$rsp)[0] | ../latex.sh addr_var frameEntryRetaddr
continue
end

break *(&camlBacktrace__entry+22)
commands
#silent
pipe output /x $rsp | ../latex.sh hex_var frameEntryEnd
continue
end

break camlBacktrace__main_392
commands
#silent
pipe output /x &((void**)$rsp)[1] | ../latex.sh hex_var frameMainBegin
pipe output /a ((void**)$rsp)[0] | ../latex.sh addr_var frameMainRetaddr
continue
end


break *(&camlBacktrace__main_392+26)
commands
#silent
pipe output /x $rsp | ../latex.sh hex_var frameMainEnd
pipe output ((size_t*)$rsp)[0] | ../latex.sh var frameMainLocalOne
continue
end

break *(&camlBacktrace__main_392+33)
commands
#silent
pipe output /x $rsp | ../latex.sh hex_var trapExnCBegin
pipe output /x caml_state->exn_handler | ../latex.sh hex_var exnHandlerBeforeExnCTrap
continue
end

break *(&camlBacktrace__main_392+43)
commands
#silent
pipe output /x ((void**)$rsp)[0] | ../latex.sh hex_var trapExnCNext
pipe output /a ((void**)$rsp)[1] | ../latex.sh addr_var trapExnCHandler

pipe output /x caml_state->exn_handler | ../latex.sh hex_var exnHandlerAfterExnCTrap

pipe output /x $rsp | ../latex.sh hex_var trapExnBBegin
continue
end

break *(&camlBacktrace__main_392+60)
commands
#silent
pipe output /x ((void**)$rsp)[0] | ../latex.sh hex_var trapExnBNext
pipe output /a ((void**)$rsp)[1] | ../latex.sh addr_var trapExnBHandler

pipe output /x caml_state->exn_handler | ../latex.sh hex_var exnHandlerAfterExnBTrap
continue
end


break camlBacktrace__maybe_raise_388
commands
#silent
pipe output /x &((void**)$rsp)[1] | ../latex.sh hex_var frameMaybeBegin
pipe output /a ((void**)$rsp)[0] | ../latex.sh addr_var frameMaybeRetaddr
continue
end

break *(&camlBacktrace__maybe_raise_388+22)
commands
#silent
pipe output /x $rsp | ../latex.sh hex_var frameMaybeEnd
pipe output ((size_t*)$rsp)[0] | ../latex.sh var frameMaybeLocalOne
continue
end


break camlBacktrace__probably_raise_351
commands
#silent
pipe output /x &((void**)$rsp)[1] | ../latex.sh hex_var frameProbablyBegin
pipe output /a ((void**)$rsp)[0] | ../latex.sh addr_var frameProbablyRetaddr
continue
end

break *(&camlBacktrace__probably_raise_351+26)
commands
#silent
pipe output /x $rsp | ../latex.sh hex_var frameProbablyEnd
pipe output ((size_t*)$rsp)[0] | ../latex.sh var frameProbablyLocalOne
continue
end

break *(&camlBacktrace__probably_raise_351+38)
commands
#silent
pipe output /x $rsp | ../latex.sh hex_var trapExnABegin
continue
end

break *(&camlBacktrace__probably_raise_351+48)
commands
#silent
pipe output /x ((void**)$rsp)[0] | ../latex.sh hex_var trapExnANext
pipe output /a ((void**)$rsp)[1] | ../latex.sh addr_var trapExnAHandler
pipe output /x caml_state->exn_handler | ../latex.sh hex_var exnHandlerAfterExnATrap
continue
end


break camlBacktrace__definitely_raise_347
commands
#silent
pipe output /x &((void**)$rsp)[1] | ../latex.sh hex_var frameDefinitelyBegin
pipe output /a ((void**)$rsp)[0] | ../latex.sh addr_var frameDefinitelyRetaddr
continue
end

break *(&camlBacktrace__definitely_raise_347+22)
commands
#silent
pipe output /x $rsp | ../latex.sh hex_var frameDefinitelyEnd
pipe output ((size_t*)$rsp)[0] | ../latex.sh var frameDefinitelyLocalOne
continue
end

break caml_raise_exn
commands
#silent
pipe output /x &((void**)$rsp)[1] | ../latex.sh hex_var frameCamlRaiseExnBegin
pipe output /a ((void**)$rsp)[0] | ../latex.sh addr_var frameCamlRaiseExnRetaddr
pipe output /x &((void**)$rsp)[0] | ../latex.sh hex_var frameCamlRaiseExnEnd
continue
end


define print_pc_with_counter
  printf "%d\n", $exn_counter
  output /a pc
end

define print_backtrace_pos_with_counter
  printf "%d\n", $exn_counter
  output domain_state->backtrace_pos
end

define print_backtrace_buffer_with_counter
  printf "%d\n", $exn_counter
  set $i = 0
  while $i < domain_state->backtrace_pos
    output /a ((frame_descr*)(domain_state->backtrace_buffer)[$i]).retaddr
    printf "\n"
    set $i += 1
  end
end

define print_reg_with_counter
  printf "%d\n", $exn_counter
  output /x $arg0
end

define print_addr_with_counter
  printf "%d\n", $exn_counter
  output /a $arg0
end


set $exn_counter = 1
break caml_stash_backtrace
commands
#silent
pipe print_pc_with_counter | ../latex.sh addr_var_version stashBacktraceArgPC
pipe printf "%d\n%p", $exn_counter, sp | ../latex.sh hex_var_version stashBacktraceArgSP
pipe printf "%d\n%p", $exn_counter, trapsp | ../latex.sh hex_var_version stashBacktraceArgTrapSP
continue
end


define print_pc_with_frame_descr_counter
  printf "%d\n", $frame_descr_counter
  output /a *pc
end

set $frame_descr_counter = 1
# caml_next_frame_descriptor
break runtime/backtrace_nat.c:50
commands
#silent
pipe printf "%d\n%p", $frame_descr_counter, *sp | ../latex.sh hex_var_version nextFrameDescrSP
pipe print_pc_with_frame_descr_counter | ../latex.sh addr_var_version nextFrameDescrPC
set $frame_descr_counter += 1
continue
end


break *(&caml_stash_backtrace+190)
commands
#silent
pipe print_backtrace_pos_with_counter | ../latex.sh var_version stashBacktraceBacktracePos
pipe print_backtrace_buffer_with_counter | ../latex.sh addr_array_version stashBacktraceBacktraceBuffer
continue
end


break *(&caml_raise_exn+72)
commands
#silent
pipe print_reg_with_counter $rsp | ../latex.sh hex_var_version rspAfterExnPopMove
continue
end

break *(&caml_raise_exn+79)
commands
#silent
pipe printf "%d\n%p\n", $exn_counter, caml_state->exn_handler | ../latex.sh hex_var_version exnHandlerAfterExnPopTrap
pipe print_reg_with_counter ($rsp+8) | ../latex.sh hex_var_version rspAfterExnPopReturn
set $exn_counter += 1
continue
end


break caml_reraise_exn
commands
#silent
pipe print_reg_with_counter &((void**)$rsp)[1] | ../latex.sh hex_var_version frameCamlReraiseExnBegin
pipe print_addr_with_counter ((void**)$rsp)[0] | ../latex.sh addr_var_version frameCamlReraiseExnRetaddr
pipe print_reg_with_counter &((void**)$rsp)[0] | ../latex.sh hex_var_version frameCamlReraiseExnEnd
continue
end
