(* Main entry point *)

module Make (Engine : Engine.S) =
struct
	let _main =
	  try
	    Printexc.record_backtrace true;
	    let module Game = Game.Make (Engine) in
	    Game.play ()
	  with exn ->
	    prerr_endline ("internal error: " ^ Printexc.to_string exn);
	    Printexc.print_backtrace stderr;
	    Stdlib.exit 2
end
