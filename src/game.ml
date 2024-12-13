module Make (Api : Api.S) =
struct

module Render = Render.Make (Api)
module Sound = Sound.Make (Api)
module Control = Control.Make (Api)


(* Display Configuration *)

let fps = ref 30.0


(* Game loop *)

type game =
{
  mutable level : int;
  mutable difficulty : int;
  mutable lives : int;
  mutable score : int;
  mutable paused : bool;
  mutable help : bool;
}

exception Advance of int

let game () =
  {level = 0; difficulty = 1; lives = 3; score = 0; paused = false; help = false}


(* Extra life *)
let extra_life game =
  if game.lives < 9 then
  (
    game.lives <- game.lives + 1;
    Render.flicker ();
  )


(* Process keyboard commands, returns true if it is forcing a step *)
let command game (cave : Cave.cave) input : bool =
  if cave.rockford.presence = Present then cave.rockford.face <- None;
  match input with
  | None -> false
  | Some (Control.Move (dir, act)) ->
    if cave.rockford.presence = Present then
    (
      cave.rockford.face <- dir;
      cave.rockford.reach <- act
    ); true
  | Some (Control.Command char) ->
    (match char with
    | 'P' -> game.paused <- not game.paused
    | 'K' when cave.rockford.presence = Present -> cave.time <- 0.0
    | ' ' | '\r' ->
      (match cave.rockford.presence with
      | Dead ->
        game.lives <- game.lives - 1;
        raise (Advance (if cave.intermission then 1 else 0))
      | Exited when cave.time <= 0.0 -> raise (Advance 1)
      | _ -> ()
      )
    | 'U' -> cave.time <- 999.0; game.lives <- 9; Render.flicker ()
    | 'O' -> cave.diamonds <- cave.needed
    | '\t' -> raise (Advance (+1))
    | '\b' -> raise (Advance (-1))
    | '+' | '=' -> raise (Advance (+Levels.count))
    | '-' -> raise (Advance (-Levels.count))
    | '/' -> raise (Advance (+Levels.count/2))
    | '[' -> Render.rescale (-1)
    | ']' -> Render.rescale (+1)
    | 'F' -> Render.fullscreen ()
    | 'G' -> Render.redecorate ()
    | 'H' -> game.help <- not game.help
    | '\x1b' -> exit 0
    | _ -> ()
    ); char = 'K' || char = ' ' || char = '\r'


(* Make a game turn *)
let turn game (cave : Cave.cave) =
  if command game cave (Control.get ()) || not game.paused then
    List.map (fun ev -> Sound.Effect ev) (Physics.step cave)
  else []


(* Make revelation step *)
let reveal game cave n revealed =
  for _ = 1 to min 2 !n do
    Array.iter (fun row ->
      let k = ref (Random.int !n) in
      Array.iteri (fun i b ->
        if not b then (if !k = 0 then row.(i) <- true; decr k)
      ) row
    ) revealed;
    decr n
  done;
  ignore (command game cave (Control.get ()));
  [Sound.Reveal]


(* Render an animation frame *)
let render game cave frame revealed =
  incr frame;
  Render.start ();

  (* Map *)
  Render.scroll cave.Cave.rockford.pos;
  for y = 0 to Array.length cave.map - 1 do
    for x = 0 to Array.length cave.map.(y) - 1 do
      let cell = cave.map.(y).(x) in
      let tile = if revealed.(y).(x) then Some cell.tile else None in
      Render.render (x, y) tile ~frame: !frame ~face: cave.rockford.face
        ~won: (cave.rockford.presence = Exited) ~force: (cell.turn = cave.turn)
    done
  done;

  (* Info line *)
  let fmt = Printf.sprintf in
  if cave.rockford.presence = Arriving then
  (
    if cave.intermission then
      Render.print White (0, 0) "     BONUS LIFE     "
    else
      Render.print White (0, 0)
        (fmt "PT%c CAVE %c/%d LIVES %d"
          cave.name.[0] cave.name.[1] cave.difficulty game.lives)
  )
  else
  (
    Render.print White (0, 0) (fmt "%c/%d " cave.name.[1] cave.difficulty);
    let n = cave.needed - cave.diamonds in
    let s, v = if n > 0 then fmt "%02d" n, cave.value else "$$", cave.extra in
    Render.print Yellow (4, 0) s;
    Render.print White (6, 0) (fmt "$%02d " v);
    Render.print Yellow (10, 0) (fmt "%03.0f " (max 0.0 (cave.time +. 0.49)));
    Render.print White (14, 0) (fmt "%06d" cave.score);
  );

  (* Pause indicator *)
  let blink = game.paused && !frame mod 30 < 15 in
  Render.print Yellow (0, 1)
    (if blink then "   $$$ PAUSED $$$   " else "                    ");

  (* Help overlay *)
  if game.help then Render.help Help.text;

  Render.finish ()


(* Play one level *)
let play_cave game cave =
  (* Initialize display *)
  let turn_time = 1.0 /. cave.Cave.speed in
  let frame_time = 1.0 /. !fps in
  Render.reset Cave.(width cave, height cave) (turn_time /. frame_time);

  (* Initialize timers *)
  let time = ref (Unix.gettimeofday ()) in
  let turn_lag = ref 0.0 in
  let frame_lag = ref 0.0 in
  let frame = ref 0 in

  let reveal_count = ref (Cave.width cave) in
  let revealed = Array.init (Cave.height cave)
    (fun _ -> Array.init (Cave.width cave) (Fun.const false)) in

  (* Main loop, aborted only be Advance exception *)
  while true do
    let now = Unix.gettimeofday () in
    let lag = now -. !time in
    time := now;
    let old_diamonds = cave.diamonds in
    let old_time = int_of_float cave.time in

    (* Check for input events *)
    Control.poll ();

    (* Check if it's time for advancing a turn *)
    turn_lag := !turn_lag +. lag;
    if !turn_lag >= turn_time then
    (
      turn_lag := !turn_lag -. turn_time;
      let old_score = cave.score in
      let sounds =
        if !reveal_count > 0 then
          reveal game cave reveal_count revealed
        else
          turn game cave
      in
      if cave.score/500 > old_score/500 then extra_life game;
      if game.paused then turn_lag := 0.0;
      List.iter Sound.play sounds;
    );

    (* Check if it's time for drawing an animation frame *)
    frame_lag := !frame_lag +. lag;
    if cave.diamonds >= cave.needed && old_diamonds < cave.needed then
      Render.flash ()
    else if !frame_lag >= frame_time then
    (
      frame_lag := !frame_lag -. frame_time;
      render game cave frame revealed
    );

    (* Run down timer for score *)
    if cave.rockford.presence = Exited then
    (
      let left = min (if cave.time > 100.0 then 9.0 else 1.0) cave.time in
      cave.score <- cave.score + int_of_float left * cave.difficulty;
      cave.time <- cave.time -. left;
      Sound.(if cave.time > 0.0 then play else stop) Sound.TimeSave;
    );

    (* Play timeout sound *)
    let new_time = int_of_float cave.time in
    if new_time < old_time && new_time < 9 then Sound.(play (TimeOut new_time));

    (* Stop ambient sounds if necessary *)
    if !reveal_count = 0 then Sound.(stop Reveal);
    if not cave.mill.active then Sound.(stop (Effect Physics.MillActivity));
    if cave.amoeba.size = 0 then Sound.(stop (Effect Physics.AmoebaActivity));

    let pause = min (turn_time -. !turn_lag) (frame_time -. !frame_lag) in
    Unix.sleepf (max 0.001 (min pause (if Api.is_buffered_key then pause else 0.001)))
  done


(* Show splash screen with music *)
let splash color text =
  Render.clear ();
  Render.start ();
  Render.print color (10 - String.length text / 2, 12) text;
  Render.finish ();

  (* Wait for key press *)
  let wait = ref true in
  while !wait do
    Sound.(play Music);
    Control.poll ();
    match Control.get () with
    | Some (Command '\x1b') -> exit 0
    | Some (Command _) -> wait := false
    | _ -> Unix.sleepf 0.01
  done;
  Sound.(stop Music)


(* Play all levels of the game and reiterate after final screen *)
let rec play () =
  Render.fullscreen ();
  play' ()

and play' () =
  let game = game () in
  while game.lives > 0 && game.difficulty <= 5 do
    let cave, colors = Levels.level game.level game.difficulty in
    Render.recolor colors;
    if cave.intermission then extra_life game;
    cave.score <- game.score;
    (try
      play_cave game cave
    with Advance n ->
      Sound.(stop Reveal);
      Sound.(stop (Effect Physics.MillActivity));
      Sound.(stop (Effect Physics.AmoebaActivity));
      let level' = game.level + n in
      game.level <- (level' +  Levels.count) mod Levels.count;
      if game.level <> level' then
        game.difficulty <- game.difficulty + (level' - game.level)/Levels.count;
      if game.difficulty = 0 then (game.level <- 0; game.difficulty <- 1)
    );
    game.score <- cave.score
  done;

  if game.lives > 0 then
    splash Yellow "@$ YOU BEAT IT!"
  else
    splash White "GAME OVER";

  play' ()

end
