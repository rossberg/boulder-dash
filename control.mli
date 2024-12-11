(* Input Handling *)

module Make (_ : Api.S) :
sig
  (** Recognised user inputs. *)
  type input =
    | Move of Cave.direction option * bool
    | Command of char

  val poll : unit -> unit
  (** Poll for user input; invoke frequently to avoid missing inputs. *)

  val get : unit -> input option
  (** Get user input since last time. *)
end
