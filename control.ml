module Make (Engine : Engine.S) =
struct

  (* Initialisation *)

  let db =
    let (/) = Filename.concat in
    let path = Filename.dirname Sys.argv.(0) / "assets" / "gamecontrollerdb.txt" in
    In_channel.(with_open_text path input_all)

  let control = Engine.open_control db
  let _ = at_exit (fun () -> Engine.close_control control)


  (* Input *)

  type input =
    | Move of Cave.direction option * bool
    | Command of char

  let last_key = ref None
  let last_pad = ref None

  let dpad l h = if l then -1 else if h then +1 else 0
  let axis v = if v < -0.5 then -1 else if v > +0.5 then +1 else 0

  let poll () =
    let last = !last_key in
    let key_opt, shift = Engine.poll_key control in
    last_key := key_opt;
    match key_opt with
    | Some key ->
      (match key with
      | Engine.(Arrow Up) | Char ('W' | 'Z' | '8') -> Some (Move (Some Up, shift))
      | Engine.(Arrow Left) | Char ('A' | 'Q' | '4') -> Some (Move (Some Left, shift))
      | Engine.(Arrow Down) | Char ('S' | '2') -> Some (Move (Some Down, shift))
      | Engine.(Arrow Right) | Char ('D' | '6') -> Some (Move (Some Right, shift))
      | Engine.Char ('X' | '5') -> Some (Move (None, shift))
      | Engine.Char c when Engine.is_buffered_key || last <> Some key ->
        Some (Command c)
      | _ -> None
      )
    | None ->
      let l, r, u, d, x1, y1, x2, y2, a, b, x, y = Engine.poll_pad control in
      let dx = compare (dpad l r + axis x1 + axis x2) 0 in
      let dy = compare (dpad u d + axis y1 + axis y2) 0 in
      match dx, dy with
      | -1, _ -> Some (Move (Some Left, a))
      | +1, _ -> Some (Move (Some Right, a))
      | _, -1 -> Some (Move (Some Up, a))
      | _, +1 -> Some (Move (Some Down, a))
      | _, _ when b && !last_pad <> Some ' ' -> last_pad := Some ' '; Some (Move (None, a))
      | _, _ when x && !last_pad <> Some 'P' -> last_pad := Some 'P'; Some (Command 'P')
      | _, _ when y && !last_pad <> Some 'K' -> last_pad := Some 'K'; Some (Command 'K')
      | _, _ when b || x || y -> None
      | _, _ -> last_pad := None; None

end
