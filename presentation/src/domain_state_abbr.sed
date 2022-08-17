1,/exn_handler/ {
  p
}

/caml_domain_state/ {
  s|.*|\t\/* ... */\n\0| p
}
