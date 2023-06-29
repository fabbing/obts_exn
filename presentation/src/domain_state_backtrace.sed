1,/exn_handler/ {
  p
}

/action_pending/ {
  s|.*|\t/* ... */| p
}


/backtrace_pos/, /backtrace_buffer/ {
 p
}

/caml_domain_state/ {
  s|.*|\t\/* ... */\n\0| p
}
