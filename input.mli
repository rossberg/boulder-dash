val get : unit -> char * bool
(** Check input and returns respective character, '\x00' if none.
  The Boolean indicates the states of the fire button equivalent. *)

val wait : unit -> char
(** Wait until an input has been made. *)
