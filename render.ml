module Make (Engine : Engine.S) =
struct

(* Window state *)

type color = int * int * int
type grid_pos = int * int

let black = Engine.create_color 0x00 0x00 0x00
let white = Engine.create_color 0xff 0xff 0xff
let grey = Engine.create_color 0x50 0x50 0x50
let yellow = Engine.create_color 0xbf 0xcd 0x7a
let brown = Engine.create_color 0x7b 0x5b 0x2f
let color1 = brown
let color2 = grey
let color3 = white

let sprite_size = 16  (* size of sprite in graphics file *)
let letter_w = sprite_size  (* size of letter sprite *)
let letter_h = sprite_size/2

let scale = ref 4
let old_scale = ref (-1)  (* swapped when toggling fullscreen *)
let width = ref 1  (* in tiles *)
let height = ref 1
let frames_per_turn = ref 1.0

let view_w = ref 0  (* current window dimension in pixels *)
let view_h = ref 0  (* ...not including top info area *)
let view_x = ref 0  (* position of top left visible pixel *)
let view_y = ref 0
let target_x = ref 0  (* target position for scrolling *)
let target_y = ref 0

let dirty = ref true
let flickering = ref 0

let tile_size () = sprite_size * !scale
let char_w () = letter_w * !scale
let char_h () = letter_h * !scale
let info_w () = 20 * char_w ()
let info_h () = 2 * char_h ()


(* Initialisation *)

let _ = Arg.parse
  [ "--scale", Arg.Int (fun i -> scale := max 1 i), "scaling factor (default 4)"
  ; "-help", Arg.Unit ignore, "" ]
  ignore ""

let win = Engine.open_window (!scale * 320) (!scale * 200) "Boulder Dash"
let _ = at_exit (fun () -> Engine.close_window win)

let clear () =
  dirty := true;  (* invalidate all screen *)
  Engine.clear_window win black

let reset (w, h) fpt =
  width := w; height := h; frames_per_turn := fpt;
  let tile_size = tile_size () in
  view_w := Engine.width_window win;
  view_h := Engine.height_window win - info_h ();
  view_x := !width/2 * tile_size - !view_w/2;
  view_y := !height/2 * tile_size - !view_h/2;
  target_x := !view_x;
  target_y := !view_y;
  clear ()

let rescale delta =
  if Engine.can_scale_image then scale := max 1 (!scale + delta);
  dirty := true

let fullscreen () =
  let old_w = Engine.width_window win in
  Engine.fullscreen_window win;
  let new_w = Engine.width_window win in
  let new_scale =
    if !old_scale <> -1 then !old_scale else
    !scale * new_w / old_w  (* adjust for resolution change *)
  in
  old_scale := !scale;
  rescale (new_scale - !scale)


(* Initialise Tiles *)

let bmp =
  let (/) = Filename.concat in
  Engine.load_image (Filename.dirname Sys.argv.(0) / "assets" / "sprites.bmp")

type tile = {raw : Engine.raw_image; mutable prepared : Engine.prepared_image}

let all_tiles = ref []

let tile y x =
  let sz = sprite_size in
  let raw = Engine.extract_image bmp (sz * x) (sz * y) sz sz in
  let prepared = Engine.prepare_image win !scale raw in
  let tile = {raw; prepared} in
  all_tiles := tile :: !all_tiles;
  tile

let animation y x n hold = Array.init (n * hold) (fun i -> tile y (x + i/hold))

let character y x =
  Engine.extract_image bmp (letter_w * x) (letter_h * y) letter_w letter_h

let alphabet = Array.init 256 (fun i ->
  if i < 32 || i >= 96 then character 0 0 else character (i/8 - 4) (i mod 8))

let alphabet' = Array.map (fun img -> Engine.recolor_image img white yellow) alphabet

let alphabet_white = Array.map (Engine.prepare_image win !scale) alphabet
let alphabet_yellow = Array.map (Engine.prepare_image win !scale) alphabet'

let space = animation 4 0 1 1
let dirt = animation 4 1 1 1
let boulder = animation 4 2 1 1
let exit = animation 4 3 2 4
let steel = animation 4 4 1 1
let concealed = animation 4 4 4 1
let wall = animation 5 0 1 1
let mill = animation 5 1 4 1
let entry = animation 6 0 4 1  let _ = entry.(0) <- (animation 5 6 1 1).(0)
let explosion_space = animation 6 0 4 1
let explosion_diamond = animation 6 4 4 1
let diamond = animation 7 0 8 1
let firefly = animation 8 0 8 1
let butterfly = animation 9 0 8 1
let amoeba = animation 10 0 8 1
let slime = animation 11 0 8 1
let rockford_still = animation 5 6 1 1
let rockford_blink = animation 12 0 8 1
let rockford_tap = animation 13 0 8 1
let rockford_blink_tap = animation 14 0 8 1
let rockford_left = animation 15 0 8 1
let rockford_right = animation 16 0 8 1
let flickers = Array.init 8 (fun i -> animation 17 i 1 1)


(* Color Changes *)

let tmp_color = Engine.create_color 0xff 0x00 0xd0  (* screaming pink *)

let recolor ((r1, g1, b1), (r2, g2, b2), (r3, g3, b3)) =
  let color1' = Engine.create_color r1 g1 b1 in
  let color2' = Engine.create_color r2 g2 b2 in
  let color3' = Engine.create_color r3 g3 b3 in
  if Engine.can_scale_image then  (* skip recoloring when too slow *)
    List.iter (fun tile ->
      let raw0 = Engine.recolor_image tile.raw color2 tmp_color in
      let raw1 = Engine.recolor_image raw0 color1 color1' in
      let raw2 = Engine.recolor_image raw1 tmp_color color2' in
      let raw3 = Engine.recolor_image raw2 color3 color3' in
      tile.prepared <- Engine.prepare_image win !scale raw3
    ) !all_tiles


(* Tile Rendering *)

let animation = function
  | Cave.Space -> if !flickering > 0 then flickers.(Random.int 8) else space
  | Dirt -> dirt
  | Steel -> steel
  | Wall -> wall
  | Mill Inactive -> wall
  | Mill Active -> mill
  | Boulder _ -> boulder
  | Diamond _ -> diamond
  | Firefly _ -> firefly
  | Butterfly _ -> butterfly
  | Expander -> wall
  | Amoeba -> amoeba
  | Slime -> slime
  | Explosion (n, Diamond _) -> [|explosion_diamond.(3 - n)|]
  | Explosion (n, _) -> [|explosion_space.(3 - n)|]
  | Entry n when n >= 4 -> exit
  | Entry n -> [|entry.(n)|]
  | Exit Inactive -> steel
  | Exit Active -> exit
  | Rockford -> rockford_still

let last_rockford_walk = ref rockford_right
let last_rockford_idle = ref rockford_still

let rockford_animation ch face =
  let ani =
    match face with
    | Some Cave.Left -> rockford_left
    | Some Cave.Right -> rockford_right
    | Some _ -> !last_rockford_walk
    | None when ch -> !last_rockford_idle
    | None ->
      match Random.int 4, Random.int 16 with
      | 0, 0 -> rockford_blink_tap
      | 0, _ -> rockford_blink
      | _, 0 -> rockford_tap
      | _, _ -> rockford_still
  in
  (if face = None then last_rockford_idle else last_rockford_walk) := ani; ani

let draw tile x y =
  let size = tile_size () in
  let x' = x * size - !view_x in
  let y' = y * size - !view_y in
  if -size < x' && x' < !view_w
  && -size < y' && y' < !view_h then
    Engine.draw_image win tile.prepared x' (y' + info_h ()) !scale

let start () =
  let new_w = Engine.width_window win in
  let new_h = Engine.height_window win - info_h () in
  if new_w <> !view_w || new_h <> !view_h then  (* window was resized *)
  (
    view_w := new_w;
    view_h := new_h;
    clear ()
  );
  Engine.start_frame win

let render (x, y) tile_opt ~frame ~face ~won ~force =
  let ani =
    match tile_opt with
    | None -> concealed
    | Some tile when tile = Cave.Rockford || tile = Exit Active && won ->
      rockford_animation (frame mod 24 <> 0) face
    | Some tile -> animation tile
  in
  if Engine.is_buffered_frame || !dirty || Array.length ani > 1 || force then
    draw ani.(frame mod Array.length ani) x y

let finish () =
  let info_w = info_w () in
  let info_h = info_h () in
  let win_w = Engine.width_window win in
  if win_w > info_w then (* clear possibly dirty upper corners *)
  (
    let left = (win_w - info_w)/2 in
    let right = win_w - info_w - left in
    Engine.draw_color win black 0 0 left info_h;
    Engine.draw_color win black (left + info_w) 0 right info_h;
  );
  Engine.finish_frame win;
  dirty := !flickering = 1;
  if !flickering > 0 then decr flickering


(* Printing *)

type text_color = White | Yellow

let print alphabet (x, y) s =
  let char_w = char_w () in
  let char_h = char_h () in
  let offset = max 0 ((Engine.width_window win - info_w ())/2) in
  for i = 0 to String.length s - 1 do
    Engine.draw_image win alphabet.(Char.code s.[i])
      (offset + (x + i) * char_w) (y * char_h) !scale
  done

let print = function
  | White -> print alphabet_white
  | Yellow -> print alphabet_yellow


(* Special effects *)

let flicker () =
  flickering := 120  (* duration in frames *)

let flash () =
  Engine.clear_window win white;
  Unix.sleepf 0.05;
  clear ()


(* Scrolling, following player as in the original but with window resizing *)

let clamp lo hi x = max lo (min hi x)

let scroll (x, y) =  (* center on tile position x, y *)
  let tile_size = tile_size () in
  let info_h = info_h () in
  let map_w = !width * tile_size in
  let map_h = !height * tile_size in
  let new_view_w = Engine.width_window win in
  let new_view_h = Engine.height_window win - info_h in
  dirty := !dirty || new_view_w > !view_w || new_view_h > !view_h;
  view_w := new_view_w;
  view_h := new_view_h;

  (* Compute the new scroll target *)
  let new_x = x * tile_size + tile_size/2 - !view_w/2 in
  let new_y = y * tile_size + tile_size/2 - !view_h/2 in
  let min_x = - max 0 (!view_w - map_w) / 2 in
  let min_y = - max 0 (!view_h - map_h) / 2 in
  let max_x = max min_x (map_w - !view_w) in
  let max_y = max min_y (map_h - !view_h) in
  let new_x' = clamp min_x max_x new_x in
  let new_y' = clamp min_y max_y new_y in

  (* Scroll back to center, but only if we are close to the view's edge *)
  let slack_x = max 0 (!view_w/2 - 4 * tile_size) in
  let slack_y = max 0 (!view_h/2 - 4 * tile_size) in
  (* Compare unclamped values, so that we can reach the border! *)
  if new_x < !view_x - slack_x || new_x > !view_x + slack_x
  || min_x < 0 || max_x < !view_x then  (* window became wider *)
    target_x := new_x';
  if new_y < !view_y - slack_y || new_y > !view_y + slack_y
  || min_y < 0 || max_y < !view_y then  (* window became taller *)
    target_y := new_y';

  (* Take one smooth scrolling step, just wide enough to keep up *)
  let step = int_of_float (Float.ceil (float tile_size /. !frames_per_turn)) in
  let dx = min step (abs (!target_x - !view_x)) * compare !target_x !view_x in
  let dy = min step (abs (!target_y - !view_y)) * compare !target_y !view_y in

  if dx <> 0 || dy <> 0 || !view_x < 0 || !view_y < 0
  || map_w - !view_x < !view_w || map_w - !view_x < !view_w then
  (
    view_x := !view_x + dx;
    view_y := !view_y + dy;
    dirty := true;
    (* Clear borders if map smaller than window (may be dirty from resizing) *)
    if !view_x < 0 || map_w - !view_x < !view_w then
    (
      Engine.draw_color win black 0 info_h (max 0 (- !view_x)) !view_h;
      Engine.draw_color win black (map_w - !view_x) info_h
        (max 0 (!view_w - map_w + !view_x)) !view_h;
    );
    if !view_y < 0 || map_w - !view_x < !view_w then
    (
      Engine.draw_color win black 0 info_h !view_w (max 0 (- !view_y));
      Engine.draw_color win black 0 (map_h - !view_y + info_h)
        !view_w (max 0 (!view_h - map_h + !view_y));
    );
  )

end
