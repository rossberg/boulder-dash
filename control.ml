module Make (Api : Api.S) =
struct

  (* Initialisation *)

  let db =
    let (/) = Filename.concat in
    let path = Filename.dirname Sys.argv.(0) / "assets" / "gamecontrollerdb.txt" in
    In_channel.(with_open_text path input_all)

  let control = Api.open_control db
  let _ = at_exit (fun () -> Api.close_control control)


  (* Input *)

  type input =
    | Move of Cave.direction option * bool
    | Command of char

  let idle_key = None, false
  let idle_pad =
    false, false, false, false, 0.0, 0.0, 0.0, 0.0, false, false, false, false

  let last_key = ref idle_key
  let last_pad = ref idle_pad
  let prev_key = ref idle_key
  let prev_pad = ref idle_pad
  let prev_key_cmd = ref None
  let prev_pad_cmd = ref None

  let dpad l h = if l then -1 else if h then +1 else 0
  let axis v = if v < -0.9 then -1 else if v > +0.9 then +1 else 0

  let poll () =
    let key = if Api.is_buffered_key then idle_key else Api.poll_key control in
    let pad = Api.poll_pad control in
    (* Remember last activity when released, except when we already got it. *)
    if key <> idle_key || !last_key = !prev_key then last_key := key;
    if pad <> idle_pad || !last_pad = !prev_pad then last_pad := pad

  let get () =
    if Api.is_buffered_key then last_key := Api.poll_key control;
    prev_key := !last_key; last_key := idle_key;
    prev_pad := !last_pad; last_pad := idle_pad;
    let key_opt, shift = !prev_key in
    let prev_cmd = !prev_key_cmd in
    prev_key_cmd := key_opt;
    match key_opt with
    | Some key ->
      let open Api in
      (match key with
      | Arrow Up | Char ('W' | 'Z' | '8') -> Some (Move (Some Up, shift))
      | Arrow Left | Char ('A' | 'Q' | '4') -> Some (Move (Some Left, shift))
      | Arrow Down | Char ('S' | '2') -> Some (Move (Some Down, shift))
      | Arrow Right | Char ('D' | '6') -> Some (Move (Some Right, shift))
      | Char ('X' | '5') -> Some (Move (None, shift))
      | Char c when Api.is_buffered_key || prev_cmd <> Some key ->
        Some (Command c)
      | _ -> None
      )
    | None ->
      let l, r, u, d, x1, y1, x2, y2, a, b, x, y = !prev_pad in
      let dx = compare (dpad l r + axis x1 + axis x2) 0 in
      let dy = compare (dpad u d + axis y1 + axis y2) 0 in
      match dx, dy with
      | -1, _ -> Some (Move (Some Left, a))
      | +1, _ -> Some (Move (Some Right, a))
      | _, -1 -> Some (Move (Some Up, a))
      | _, +1 -> Some (Move (Some Down, a))
      | _, _ when b && !prev_pad_cmd <> Some ' ' ->
        prev_pad_cmd := Some ' '; Some (Move (None, a))
      | _, _ when x && !prev_pad_cmd <> Some 'P' ->
        prev_pad_cmd := Some 'P'; Some (Command 'P')
      | _, _ when y && !prev_pad_cmd <> Some 'K' ->
        prev_pad_cmd := Some 'K'; Some (Command 'K')
      | _, _ when b || x || y -> None
      | _, _ -> prev_pad_cmd := None; None

end
