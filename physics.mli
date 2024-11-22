(* Core game logic *)

type event =
  | BoulderBump
  | DiamondBump
  | MillActivity
  | ExpanderActivity
  | AmoebaActivity
  | SlimeActivity
  | Exploding
  | RockfordWalk
  | RockfordDig
  | RockfordCollect
  | RockfordPush
  | RockfordEntry
  | ExitOpen

val step : Cave.cave -> event list
(** Advance the state of the cave by one tick. *)
