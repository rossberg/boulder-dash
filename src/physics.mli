(* Core game logic *)

(** Events that might cause sound effects *)
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
