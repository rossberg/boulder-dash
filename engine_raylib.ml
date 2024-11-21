(* Output Window *)

type window = unit

let open_window w h title =
  Raylib.(set_trace_log_level TraceLogLevel.Error);
  Raylib.init_window w h title;
  Raylib.(set_window_state [ConfigFlags.Window_resizable]);
  Raylib.clear_background Raylib.Color.black

let close_window = Raylib.close_window


let width_window () =
  (* Screen width is off when in fullscreen mode *)
  if Raylib.is_window_fullscreen () then
    Raylib.(get_monitor_width (get_current_monitor ()))
  else
    Raylib.get_screen_width ()

let height_window () =
  (* Screen width is off when in fullscreen mode *)
  if Raylib.is_window_fullscreen () then
    Raylib.(get_monitor_height (get_current_monitor ()))
  else
    Raylib.get_screen_height ()


let clear_window () color =
  (* Clear both buffers *)
  Raylib.begin_drawing ();
  Raylib.clear_background color;
  Raylib.end_drawing ();
  Raylib.begin_drawing ();
  Raylib.clear_background color;
  Raylib.end_drawing ()

let fullscreen_window = Raylib.toggle_fullscreen


(* Animation Frames *)

let start_frame = Raylib.begin_drawing
let finish_frame = Raylib.end_drawing


(* Colors *)

type color = Raylib.Color.t

let create_color r g b =
  Raylib.Color.create r g b 0xff

let draw_color () color x y w h =
  Raylib.draw_rectangle x y w h color


(* Images *)

type raw_image = Raylib.Image.t
type prepared_image = Raylib.Texture2D.t

let load_image = Raylib.load_image

let extract_image img x y w h =
  Raylib.image_from_image img
    (Raylib.Rectangle.create (float x) (float y) (float w) (float h))

let recolor_image img src dst =
  let img' = Raylib.image_copy img in
  Raylib.image_color_replace (Raylib.addr img') src dst;
  img'

let prepare_image () _scale = Raylib.load_texture_from_image

let draw_image () img x y scale =
  let v = Raylib.Vector2.create (float x) (float y) in
  Raylib.draw_texture_ex img v 0.0 (float scale) Raylib.Color.white

let can_scale_image = true


(* Keyboard *)

let keys = let open Raylib.Key in
[
  (* Ordered such that horizontal movement takes precedence *)
  Left, 'A'; Right, 'D'; Up, 'W'; Down, 'S';
  Kp_4, '4'; Kp_6, '6'; Kp_8, '8'; Kp_2, '2'; Kp_5, '5';
  A, 'A'; D, 'D'; W, 'W'; S, 'S'; X, 'X';
  K, 'K'; U, 'U'; O, 'O'; P, 'P';
  Space, ' '; Enter, '\r'; Kp_enter, '\r';
  Tab, '\t'; Backspace, '\b'; Escape, '\x1b';
  Minus, '-'; Equal, '+';
  F, 'F'; Left_bracket, '['; Right_bracket, ']';
]

let last = ref Raylib.Key.Null

let get_key () =
  if Raylib.window_should_close () then exit 0;
  Raylib.poll_input_events ();
  let shift =
    Raylib.(is_key_down Key.Left_shift || is_key_down Key.Right_shift) in
  match List.find_opt (fun (key, _) -> Raylib.is_key_down key) keys with
  | None -> last := Raylib.Key.Null; '\x00', shift
  | Some (_, ('W'|'A'|'S'|'D'|'X' as c)) -> c, shift  (* allow repeat *)
  | Some (key, _) when key = !last -> '\x00', shift  (* suppress repeat *)
  | Some (key, c) -> last := key; c, shift
