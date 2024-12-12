(* Level Data *)

type color = int * int * int

val level : int -> int -> Cave.cave * (color * color * color)
(** [level i diff] returns the [i]-the cave, configured for difficulty level
   [diff], and the three replacement colors. *)

val count : int
(** The number of available caves. *)
