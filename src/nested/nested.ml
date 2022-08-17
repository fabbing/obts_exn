let [@inline never] do_nothing_with v =
  Sys.opaque_identity v;
  ()

exception ExnA
exception ExnB
exception ExnC

let [@inline never] definitely_raise v =
  do_nothing_with v;
  if Should.raise then
    raise ExnC;
  v + 1

let [@inline never] probably_raise v =
  do_nothing_with v;
  match definitely_raise (v + 1) with
  | w -> w + 1
  | exception ExnA -> print_endline "Caught an ExnA!"; -1

let [@inline never] maybe_raise v =
  do_nothing_with v;
  let w = probably_raise (v + 1) in
  w + 1

let main v =
  (try
    (try ignore @@ maybe_raise (v + 1) with
    | ExnB -> print_endline "Caught an ExnB!")
  with
  | ExnC -> print_endline "Caught an ExnC!");
  v + 1

let _ = main 42
