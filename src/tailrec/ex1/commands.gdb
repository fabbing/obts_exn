break camlExample__entry
commands
#silent
pipe output /x &((void**)$rsp)[1] | ../../latex.sh hex_var frameEntryBegin
pipe output /a ((void**)$rsp)[0] | ../../latex.sh addr_var frameEntryRetaddr
continue
end

break *(&camlExample__entry+22)
commands
#silent
pipe output /x $rsp | ../../latex.sh hex_var frameEntryEnd
continue
end



set $loop = 1

define print_f_begin
  printf "%d\n", $loop
  output /x &((void**)$rsp)[1]
end

define print_f_retaddr
  printf "%d\n", $loop
  output /a ((void**)$rsp)[0]
end

break camlExample__f_272
commands
#silent
pipe print_f_begin | ../../latex.sh hex_var_version frameFBegin
pipe print_f_retaddr | ../../latex.sh addr_var_version frameFRetaddr
continue
end


define print_f_end
  printf "%d\n", $loop
  output /x $rsp
end

break *(&camlExample__f_272+18)
commands
#silent
pipe print_f_end | ../../latex.sh hex_var_version frameFEnd
continue
end


define print_f_local_one
  printf "%d\n", $loop
  output /d ((long*)$rsp)[0]
end

break *(&camlExample__f_272+40)
commands
#silent
pipe print_f_local_one | ../../latex.sh var_version frameFLocalOne
continue
end

define print_f_trap_begin
  printf "%d\n", $loop
  output /x $rsp
end

break *(&camlExample__f_272+47)
commands
#silent
pipe print_f_end | ../../latex.sh hex_var_version trapBegin
continue
end


define print_f_trap_next
  printf "%d\n", $loop
  output /x ((void**)$rsp)[0]
end

define print_f_trap_handler
  printf "%d\n", $loop
  output /a ((void**)$rsp)[1]
end

define print_f_trap_end
  printf "%d\n", $loop
  output /x $rsp
end

break *(&camlExample__f_272+53)
commands
#silent
pipe print_f_trap_next | ../../latex.sh hex_var_version trapNext
pipe print_f_trap_handler | ../../latex.sh addr_var_version trapHandler
pipe print_f_end | ../../latex.sh hex_var_version trapEnd
continue
end


break *(&camlExample__f_272+72)
commands
#silent
set $loop += 1
continue
end
