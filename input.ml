(* Keyboard management *)

let keys = let open Raylib.Key in
[
  (* Ordered such that horizontal movement takes precedence *)
  Left, 'A'; Right, 'D'; Up, 'W'; Down, 'S';
  Kp_4, 'A'; Kp_6, 'D'; Kp_8, 'W'; Kp_2, 'S'; Kp_5, 'X';
  A, 'A'; D, 'D'; W, 'W'; S, 'S'; X, 'X';
  K, 'K'; U, 'U'; O, 'O'; P, 'P';
  Space, ' '; Enter, '\r'; Kp_enter, '\r';
  Tab, '\t'; Backspace, '\b'; Escape, '\x1b';
  Minus, '-'; Equal, '+';
  F, 'F'; Left_bracket, '['; Right_bracket, ']';
]

let last = ref Raylib.Key.Null

let get () =
  if Raylib.window_should_close () then Stdlib.exit 0;
  Raylib.poll_input_events ();
  let shift =
    Raylib.(is_key_down Key.Left_shift || is_key_down Key.Right_shift) in
  match List.find_opt (fun (key, _) -> Raylib.is_key_down key) keys with
  | None -> last := Raylib.Key.Null; '\x00', shift
  | Some (_, ('W'|'A'|'S'|'D'|'X' as c)) -> c, shift  (* allow repeat *)
  | Some (key, _) when key = !last -> '\x00', shift  (* suppress repeat *)
  | Some (key, c) -> last := key; c, shift

let rec wait () =
  match fst (get ()) with
  | '\x00' -> Unix.sleepf 0.05; wait ()
  | key -> key
