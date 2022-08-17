
let [@inline never] maybe_raise () =
  if Should.raise () then
    raise (Failure "Oopsy");
  ()

let rec f count =
  if count == 0 then
    42
  else (
    match maybe_raise () with
    | _ -> f (count - 1)
    | exception _ -> f (count - 1)
  )

let _ = Printf.printf "The answer to everything is %d\n" (f 3)
