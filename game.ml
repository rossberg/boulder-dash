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
}

exception Advance of int

let make () = {level = 0; difficulty = 1; lives = 3; score = 0; paused = false}


(* Extra life *)
let extra_life game =
  if game.lives < 9 then
  (
    game.lives <- game.lives + 1;
    Render.flicker ();
  )


(* Process keyboard commands, returns true if it is forcing a step *)
let input game (cave : Cave.cave) key : bool =
  let step = ref false in
  (match key with
  | 'W' | 'A' | 'S' | 'D' | 'Z' | 'Q' | 'X' -> step := true
  | 'K' when cave.rockford.presence = Present -> cave.time <- 0.0
  | 'U' -> cave.time <- 999.0; game.lives <- 9; Render.flicker ()
  | 'O' -> cave.diamonds <- cave.needed
  | 'P' -> game.paused <- not game.paused
  | ' ' | '\r' ->
    (match cave.rockford.presence with
    | Dead ->
      game.lives <- game.lives - 1;
      raise (Advance (if cave.intermission then 1 else 0))
    | Exited when cave.time <= 0.0 -> raise (Advance 1)
    | _ -> step := true
    )
  | '\t' -> raise (Advance (+1))
  | '\b' -> raise (Advance (-1))
  | '+' -> raise (Advance (+Levels.count))
  | '-' -> raise (Advance (-Levels.count))
  | '[' -> Render.rescale (-1)
  | ']' -> Render.rescale (+1)
  | 'F' -> Render.fullscreen ()
  | '\x1b' -> exit 0
  | _ -> ()
  );
  !step

(* Wait for key press *)
let rec wait_input () =
  match fst (Engine.get_key ()) with
  | '\x00' -> Unix.sleepf 0.05; wait_input ()
  | key -> key


(* Make a simulation turn *)
let turn game (cave : Cave.cave) =
  let key, shift = Engine.get_key () in
  cave.rockford.reach <- shift;
  if cave.rockford.presence = Present then
    cave.rockford.face <-
      (match key with
      | 'W' | 'Z' -> Some Up
      | 'A' | 'Q' -> Some Left
      | 'S' -> Some Down
      | 'D' -> Some Right
      | _ -> None
      );
  if input game cave key || not game.paused then Step.step cave


(* Make revelation step *)
let reveal game cave n revealed =
  for _ = 1 to min 3 !n do
    Array.iter (fun row ->
      let k = ref (Random.int !n) in
      Array.iteri (fun i b ->
        if not b then (if !k = 0 then row.(i) <- true; decr k)
      ) row
    ) revealed;
    decr n
  done;
  ignore (input game cave (fst (Engine.get_key ())))


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
        (fmt " CAVE %c/%d   LIVES %d " cave.name cave.difficulty game.lives)
  )
  else
  (
    Render.print White (0, 0) (fmt "%c/%d " cave.name cave.difficulty);
    let n = cave.needed - cave.diamonds in
    let s, v = if n > 0 then fmt "%02d" n, cave.value else "$$", cave.extra in
    Render.print Yellow (4, 0) s;
    Render.print White (6, 0) (fmt "$%02d " v);
    Render.print Yellow (10, 0) (fmt "%03.0f " (max 0.0 cave.time));
    Render.print White (14, 0) (fmt "%06d" cave.score);
  );

  (* Pause indicator *)
  let blink = game.paused && !frame mod 30 < 15 in
  Render.print Yellow (0, 1)
    (if blink then "   $$$ PAUSED $$$   " else "                    ");

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

    (* Check if it's time for advancing a turn *)
    turn_lag := !turn_lag +. lag;
    if !turn_lag >= turn_time then
    (
      turn_lag := !turn_lag -. turn_time;
      let old_score = cave.score in
      if !reveal_count > 0 then
        reveal game cave reveal_count revealed
      else
        turn game cave;
      if cave.score/500 > old_score/500 then extra_life game;
      if game.paused then turn_lag := 0.0;
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

    let pause = min (turn_time -. !turn_lag) (frame_time -. !frame_lag) in
    Unix.sleepf (max 0.0 pause)
  done


(* Play all levels of the game and reiterate after final screen *)
let rec play () =
  let game = make () in
  while game.lives > 0 && game.difficulty <= 5 do
    let cave = Levels.level game.level game.difficulty in
    if cave.intermission then extra_life game;
    cave.score <- game.score;
    (try
      play_cave game cave
    with Advance n ->
      let level' = game.level + n in
      game.level <- (level' +  Levels.count) mod Levels.count;
      if game.level <> level' then
        game.difficulty <- game.difficulty + (level' - game.level)/Levels.count;
      if game.difficulty = 0 then (game.level <- 0; game.difficulty <- 1)
    );
    game.score <- cave.score
  done;

  Render.clear ();
  Render.start ();
  if game.lives > 0 then
    Render.print Yellow (3, 12) "@$ YOU BEAT IT!"
  else
    Render.print White (6, 12) "GAME OVER";
  Render.finish ();
  if wait_input () = '\x1b' then exit 0;

  play ()
