(* Sound Effects *)

module Make (_ : Api.S) :
sig
  type sound =
    | Music
    | Reveal
    | TimeSave
    | TimeOut of int (* <= 8 *)
    | Effect of Physics.event

  val play : sound -> unit
  val stop : sound -> unit
end
