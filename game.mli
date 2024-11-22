(* Main Game Loop *)

module Make (_ : Engine.S) :
sig
  val play : unit -> unit
  (** Starts the game and loops over all levels indefinitely. *)
end
