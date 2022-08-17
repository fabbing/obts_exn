let [@inline never] main v =
  if Should.raise () then
    raise (Failure "Oopsy");
  v + 1

let _ = ignore @@ (main 42)
