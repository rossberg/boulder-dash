module C = Configurator.V1

let () =
  C.main ~name:"raylib" (fun c ->
    C.Flags.write_sexp "link_deps.sexp"
      (match C.ocaml_config_var c "system" with
      | Some "mingw64" -> [ "icon.res" ]
      | _ -> [ ]
    );
    C.Flags.write_sexp "link_flags.sexp"
      (match C.ocaml_config_var c "system" with
      | Some "mingw64" ->
          [
            "-cclib"; "-Wl,-static";
            "-cclib"; "-subsystem";  (* suppress console window *)
            "-cclib"; "windows";
            "-cclib"; "-Wl,-s";
            "-cclib"; "src/api-raylib/icon.res";
          ]
      | _ ->
          [ "-cclib"; "-s" ]
    )
  )
