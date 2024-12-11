(* Backend for Raylib Library *)

type window = unit

let open_window w h title =
  Raylib.(set_trace_log_level TraceLogLevel.Error);
  Raylib.init_window w h title;
  Raylib.(set_window_state ConfigFlags.[Window_resizable; Vsync_hint]);
  Raylib.clear_background Raylib.Color.black;
  Raylib.init_audio_device ()

let close_window () =
  Raylib.close_audio_device ();
  Raylib.close_window ()


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

let fullscreen_window () =
  Raylib.toggle_fullscreen ();
  if Raylib.is_window_fullscreen () then
    Raylib.hide_cursor ()
  else
    Raylib.show_cursor ()


(* Animation Frames *)

let start_frame = Raylib.begin_drawing
let finish_frame = Raylib.end_drawing

let is_buffered_frame = true


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


(* Sound *)

type audio = unit
type sound = Raylib.Sound.t

let open_audio = ignore
let close_audio = ignore
let load_sound = Raylib.load_sound
let play_sound () = Raylib.play_sound
let stop_sound () = Raylib.stop_sound
let is_playing_sound () = Raylib.is_sound_playing


(* Controls *)

type control = int option

let open_control db =
  Raylib.(set_exit_key Key.Null);
  ignore (Raylib.set_gamepad_mappings db);
  Raylib.end_drawing ();  (* pump event loop to discover devices *)
  if Raylib.is_gamepad_available 0 then Some 0 else None

let close_control _control = ()


type dir = Left | Right | Up | Down
type key = Char of char | Arrow of dir

let is_buffered_key = false

let arrow_keys =
  Raylib.[Key.Left, Left; Key.Right, Right; Key.Up, Up; Key.Down, Down]
let ctrl_keys =  (* for some reason, Raylib remaps these keycodes *)
  Raylib.Key.[Escape, '\x1b'; Enter, '\r'; Tab, '\t'; Backspace, '\b']

let poll_key _ =
  if Raylib.window_should_close () then exit 0;
  Raylib.poll_input_events ();
  let shift =
    Raylib.(is_key_down Key.Left_shift || is_key_down Key.Right_shift) in
  let key = ref (Option.map (fun (_, dir) -> Arrow dir)
      (List.find_opt (fun (code, _) -> Raylib.is_key_down code) arrow_keys)) in
  if !key = None then
    key := Option.map (fun (_, c) -> Char c)
      (List.find_opt (fun (code, _) -> Raylib.is_key_down code) ctrl_keys);
  for code = 32 to 127 do
    try
      if !key = None && Raylib.is_key_down (Raylib.Key.of_int code) then
        key := Some (Char (Char.chr code))
    with Failure _ -> ()  (* ignore invalid key codes *)
  done;
  !key, shift


let poll_pad = function
  | None ->
    false, false, false, false, 0.0, 0.0, 0.0, 0.0, false, false, false, false
  | Some pad ->
    let open Raylib.GamepadButton in
    Raylib.is_gamepad_button_down pad Left_face_left,
    Raylib.is_gamepad_button_down pad Left_face_right,
    Raylib.is_gamepad_button_down pad Left_face_up,
    Raylib.is_gamepad_button_down pad Left_face_down,
    Raylib.get_gamepad_axis_movement pad Raylib.GamepadAxis.Left_x,
    Raylib.get_gamepad_axis_movement pad Raylib.GamepadAxis.Left_y,
    Raylib.get_gamepad_axis_movement pad Raylib.GamepadAxis.Right_x,
    Raylib.get_gamepad_axis_movement pad Raylib.GamepadAxis.Right_y,
    Raylib.is_gamepad_button_down pad Right_face_down,
    Raylib.is_gamepad_button_down pad Right_face_right,
    Raylib.is_gamepad_button_down pad Right_face_left,
    Raylib.is_gamepad_button_down pad Right_face_up
