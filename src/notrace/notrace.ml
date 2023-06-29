module Array = struct
  let exists2 p a1 a2 =
    let n = Array.length a1 in
    if Array.length a2 <> n then invalid_arg "Misc.Stdlib.Array.exists2";
      let rec loop i =
        if i = n then false
        else if p (Array.unsafe_get a1 i) (Array.unsafe_get a2 i) then true
        else loop (succ i) in
      loop 0

  let for_alli p a =
    let n = Array.length a in
    let rec loop i =
      if i = n then true
        else if p i (Array.unsafe_get a i) then loop (succ i)
      else false in
    loop 0

  let all_somes a =
    try
      Some (Array.map (function None -> raise_notrace Exit | Some x -> x) a)
    with
      | Exit -> None
end
