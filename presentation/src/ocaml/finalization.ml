let temporarily_set_reference ref newval funct =
  let oldval = !ref in
  try
    ref := newval;
    let res = funct () in
    ref := oldval;
    res
  with x ->
    ref := oldval;
    raise x
