exception ExnA

let [@inline never] maybe_raise v =
  if Should.raise () then
    raise ExnA;
  v + 1

let [@inline never] main v =
  (try ignore @@ maybe_raise v with
  | ExnA -> print_endline "Caught an ExnA!");
  v + 1

let _ = ignore @@ (main 42)
