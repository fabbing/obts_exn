
let [@inline never] maybe_raise () =
  if Should.raise () then
    raise (Failure "Oopsy");
  ()

let rec f count =
  if count == 0 then
    42
  else (
    try maybe_raise (); f (count - 1) with
    | _ -> -1
  )

let _ =
  let v = f 3 in
  Printf.printf "The answer to everything is %d\n" v
