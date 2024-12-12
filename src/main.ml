(* Main Entry Point *)

module Make (Api : Api.S) =
struct
  let _main =
    try
      Printexc.record_backtrace true;
      let module Game = Game.Make (Api) in
      Game.play ()
    with exn ->
      Api.handler exn;
      prerr_endline ("internal error: " ^ Printexc.to_string exn);
      Printexc.print_backtrace stderr;
      exit 2
end
