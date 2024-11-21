(* Output Window *)

type window = unit

let open_window w h title =
  Graphics.open_graph "";
  Graphics.set_window_title title;
  Graphics.resize_window w h;  (* nop on Windows? *)
  Graphics.set_color Graphics.black;
  Graphics.fill_rect (-1) (-1) (Graphics.size_x () + 2) (Graphics.size_y () + 2);

  (* Since loading times are abysmal, show a splash screen *)
  Graphics.set_color (Graphics.rgb 0xbf 0xcd 0x7a);
  Graphics.set_text_size 40;  (* doesn't seem to do anything on Windows...? *)
  let s = "BOULDER DASH is loading..." in
  let w, _ = Graphics.text_size s in
  Graphics.moveto (Graphics.size_x () / 2 - w / 2) (Graphics.size_y () / 2);
  Graphics.draw_string s;

  Unix.sleepf 0.3  (* work around occasional crash on Windows *)

let close_window = Graphics.close_graph
let width_window = Graphics.size_x
let height_window = Graphics.size_y


let clear_window () color =
  Graphics.set_color color;
  Graphics.fill_rect (-1) (-1) (Graphics.size_x () + 2) (Graphics.size_y () + 2);
  Graphics.set_color Graphics.black;
  Graphics.synchronize ()

let fullscreen_window = ignore


(* Animation Frames *)

let start_frame () =
  Graphics.auto_synchronize false (* appears to get reset on window resizes? *)

let finish_frame () =
  Graphics.synchronize ()


(* Colors *)

type color = Graphics.color

let create_color = Graphics.rgb

let draw_color () color x y w h =
  Graphics.set_color color;
  Graphics.fill_rect x (Graphics.size_y () - y - h) w h


(* Images *)

type raw_image = Graphics.color array array
type prepared_image = {image : Graphics.image; h : int; scale : int}

let load_image = Bmp.load

let extract_image bmp x y w h =
  Array.init h (fun j -> Array.init w (fun i -> bmp.(y + j).(x + i)))

let scale_image bmp scale =
  let h = Array.length bmp in
  let w = if h = 0 then 0 else Array.length bmp.(0) in
  Array.init (h * scale) (fun j -> Array.init (w * scale)
    (fun i -> bmp.(j/scale).(i/scale)))

let recolor_image bmp src dst =
  Array.map (Array.map (fun c -> if c = src then dst else c)) bmp

let rec prepare_image () scale bmp =
  let bmp' = if scale = 1 then bmp else scale_image bmp scale in
  (* On Windows, fails when the user concurrently resizes the window. 8-} *)
  try {image = Graphics.make_image bmp'; h = Array.length bmp; scale}
  with Graphics.Graphic_failure _ -> prepare_image () scale bmp

let draw_image () img x y scale =
  assert (scale = img.scale);  (* don't support rescaling *)
  Graphics.draw_image img.image x (Graphics.size_y () - y - scale * img.h)

let can_scale_image = false


(* Keyboard *)

let get_key () =
  let key = ref '\x00' in
  while Graphics.key_pressed () do  (* get most recent reading *)
    key := Graphics.read_key ()
  done;
  let upper = Char.uppercase_ascii !key in
  upper, !key = upper
