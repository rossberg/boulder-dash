open Tsdl


(* Result monad *)

let ( let* ) = Result.bind
let ok = Result.ok
let get_ok = Result.get_ok


(* Output Window *)

type window = Sdl.window * Sdl.renderer

let open_window w h title = get_ok @@
  let* () = Sdl.init Sdl.Init.everything in
  let* win = Sdl.create_window ~w ~h title Sdl.Window.(opengl + resizable) in
  let* ren = Sdl.create_renderer win ~flags: Sdl.Renderer.presentvsync in
  ok (win, ren)

let close_window (win, ren) =
  Sdl.destroy_renderer ren;
  Sdl.destroy_window win;
  Sdl.quit ()


let width_window (win, _) = fst (Sdl.get_window_size win)
let height_window (win, _) = snd (Sdl.get_window_size win)


let clear_window (_win, ren) (r, g, b) = get_ok @@
  let* () = Sdl.set_render_draw_color ren r g b 0 in
  let* () = Sdl.render_clear ren in
  let () = Sdl.render_present ren in
  ok ()

let fullscreen_window (win, _) = get_ok @@
  let flags = Sdl.get_window_flags win in
  let flags' = Sdl.Window.(if test flags fullscreen then windowed else fullscreen) in
  let* () = Sdl.set_window_fullscreen win flags' in
  ok ()


(* Animation Frames *)

let start_frame _ = ()
let finish_frame (_, ren) = Sdl.render_present ren


(* Colors *)

type color = int * int * int

let create_color r g b = (r, g, b)

let draw_color (_, ren) (r, g, b) x y w h = get_ok @@
  let* () = Sdl.set_render_draw_color ren r g b 0 in
  let* () = Sdl.render_fill_rect ren (Some (Sdl.Rect.create ~x ~y ~w ~h)) in
  ok ()


(* Images *)

type raw_image = Sdl.surface
type prepared_image = Sdl.texture

let load_image path = get_ok @@
  let* img = Sdl.load_bmp path in
  ok img

let extract_image img x y w h = get_ok @@
  let* img' = Sdl.create_rgb_surface ~w ~h ~depth: 32 0l 0l 0l 0l in
  let r = Sdl.Rect.create ~x ~y ~w ~h in
  let* () = Sdl.blit_surface ~src: img (Some r) ~dst: img' None in
  ok img'

let recolor_image img (r, g, b) (r', g', b') = get_ok @@
  let img' = Sdl.duplicate_surface img in
  assert (Sdl.get_surface_format_enum img' = Sdl.Pixel.format_rgb888);
  let* () = Sdl.lock_surface img' in
  let pixels = Sdl.get_surface_pixels img' Bigarray.Int8_unsigned in
  for i = 0 to Bigarray.Array1.dim pixels/4 - 1 do
    if pixels.{4*i} = b && pixels.{4*i + 1} = g && pixels.{4*i + 2} = r then
      (pixels.{4*i} <- b'; pixels.{4*i + 1} <- g'; pixels.{4*i + 2} <- r')
  done;
  let () = Sdl.unlock_surface img' in
  ok img'

let prepare_image (_, ren) _scale img = get_ok @@
  let* img' = Sdl.create_texture_from_surface ren img in
  ok img'

let draw_image (_, ren) img x y scale = get_ok @@
  let* _, _, (w, h) = Sdl.query_texture img in
  let dst = Sdl.Rect.create ~x ~y ~w: (w * scale) ~h: (h * scale) in
  let* () = Sdl.render_copy ren img ~dst in
  ok ()

let can_scale_image = true


(* Keyboard *)

let keys = let open Sdl.Scancode in
[
  (* Ordered such that horizontal movement takes precedence *)
  left, 'A'; right, 'D'; up, 'W'; down, 'S';
  kp_4, '4'; kp_6, '6'; kp_8, '8'; kp_2, '2'; kp_5, '5';
  a, 'A'; d, 'D'; w, 'W'; s, 'S'; x, 'X';
  k, 'K'; u, 'U'; o, 'O'; p, 'P';
  space, ' '; return, '\r'; kp_enter, '\r';
  tab, '\t'; backspace, '\b'; escape, '\x1b';
  minus, '-'; equals, '+';
  f, 'F'; leftbracket, '['; rightbracket, ']';
]

let last = ref Sdl.Scancode.unknown

let get_key () =
  let event = Sdl.Event.create () in
  if Sdl.poll_event (Some event) && Sdl.Event.(get event typ = quit) then exit 0;
  Sdl.pump_events ();
  let state = Sdl.get_keyboard_state () in
  let shift = Sdl.Scancode.(state.{lshift} = 1 || state.{rshift} = 1) in
  match List.find_opt (fun (code, _) -> state.{code} = 1) keys with
  | None -> last := Sdl.Scancode.unknown; '\x00', shift
  | Some (_, ('W'|'A'|'S'|'D'|'X' as c)) -> c, shift  (* allow repeat *)
  | Some (code, _) when code = !last -> '\x00', shift (* suppress repeat *)
  | Some (code, c) -> last := code; c, shift
