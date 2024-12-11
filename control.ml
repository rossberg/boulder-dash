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

  let prev_key_cmd = ref None
  let prev_pad_cmd = ref None

  let dpad l h = if l then -1 else if h then +1 else 0
  let axis v = if v < -0.9 then -1 else if v > +0.9 then +1 else 0

  let poll () =
    let key_opt, shift = Api.poll_key control in
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
      let l, r, u, d, x1, y1, x2, y2, a, b, x, y = Api.poll_pad control in
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
