(* Main entry point *)

let _main =
  try
    Printexc.record_backtrace true;
    Render.init ();
    at_exit Render.deinit;
    Game.play ();
  with
  (* swallow spurious errors when the user closes the window *)
  | Graphics.Graphic_failure _ -> ()
  | exn ->
    prerr_endline ("internal error: " ^ Printexc.to_string exn);
    Printexc.print_backtrace stderr;
    Stdlib.exit 2
