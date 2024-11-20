(* Keyboard management *)

let get () =
  let key = ref '\x00' in
  while Graphics.key_pressed () do  (* get most recent reading *)
    key := Graphics.read_key ()
  done;
  let upper = Char.uppercase_ascii !key in
  upper, !key = upper

let rec wait () =
  match fst (get ()) with
  | '\x00' -> Unix.sleepf 0.05; wait ()
  | key -> key
