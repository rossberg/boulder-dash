(* Sound Effects *)

module Make (Engine : Engine.S) =
struct

  type sound =
    | Music
    | Reveal
    | TimeSave
    | TimeOut of int
    | Effect of Physics.event

  (* Initialisation *)

  let audio = Engine.open_audio ()
  let _ = at_exit (fun () -> Engine.close_audio audio)

  let load name =
    let (/) = Filename.concat in
    Engine.load_sound (Filename.dirname Sys.argv.(0) / "assets" / name ^ ".wav")

  let music = load "music"
  let reveal = load "reveal"
  let boulder = load "boulder"
  let diamonds = Array.init 8 (fun i -> load ("diamond" ^ string_of_int i))
  let mill = load "mill"
  let expand = load "expand"
  let amoeba = load "amoeba"
  let slime = load "slime"
  let explosion = load "explosion"
  let walk = load "walk"
  let dig = load "dig"
  let collect = load "collect"
  let push = load "boulder"
  let entry = load "entry"
  let exit = load "exit"
  let timeout = Array.init 9 (fun i -> load ("timeout" ^ string_of_int i))


  (* Playing a sound *)

  let sound = function
    | Music -> music
    | Reveal -> reveal
    | TimeSave -> exit
		| TimeOut n -> timeout.(8 - n)
    | Effect event ->
      match event with
		  | BoulderBump -> boulder
		  | DiamondBump -> diamonds.(Random.int 8)
		  | MillActivity -> mill
		  | ExpanderActivity -> expand
		  | AmoebaActivity -> amoeba
		  | SlimeActivity -> slime
		  | Exploding -> explosion
		  | RockfordWalk -> walk
		  | RockfordDig -> dig
		  | RockfordCollect -> collect
		  | RockfordPush -> push
		  | RockfordEntry -> entry
		  | ExitOpen -> entry

  let pred = function
    | TimeOut n when n < 8 -> sound (TimeOut (n + 1))
    | _ -> sound (TimeOut 8)

  let is_ambient = function
    | Music | Reveal | TimeSave | TimeOut _
    | Effect (MillActivity | AmoebaActivity) -> true
    | _ -> false

  let play s =
    let sound = sound s in
    Engine.stop_sound audio (pred s);
    if not (is_ambient s && Engine.is_playing_sound audio sound) then
      Engine.play_sound audio sound

  let stop s = Engine.stop_sound audio (sound s)

end
