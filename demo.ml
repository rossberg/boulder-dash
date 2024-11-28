(* scratch *)

    Render.print_yellow "$$$ BOULDER DASH $$$" 0 0
    for i = 0 to 19 do Render.draw Render.steel i 1 done;
    for i = 0 to 19 do Render.draw Render.steel i 12 done;
    for j = 2 to 11 do
      Render.draw Render.steel 0 j; Render.draw Render.steel 19 j;
      for i = 1 to 18 do Render.draw Render.dirt i j done
    done;
    let y = 6 in
    for i = 0 to 19 do Render.draw Render.space i y done;
    Render.draw Render.exit 1 2;
    let space = [7,5; 4,9; 16,8] in
    let boulder = [9,2; 11,3; 13,11] in
    let wall = [16,9; 17,9; 18,9] in
    List.iter (fun (x,y) -> Render.draw Render.space x y) space;
    List.iter (fun (x,y) -> Render.draw Render.boulder x y) boulder;
    List.iter (fun (x,y) -> Render.draw Render.wall x y) wall;
    let rockford = [1,3] in
    let diamond = [4,3; 10,9; 15,2] in
    let firefly = [8,2] in
    let butterfly = [8,10] in
    let amoeba = [18,10; 17,11; 18,11] in
    let delay = 4 in
    let i = ref 0 in
    while not Graphics.(button_down () || key_pressed ()) do
      if !i mod delay = 0 then begin
        Render.draw Render.space ((!i/delay - 1) mod 20) y;
        Render.draw Render.boulder ((!i/delay + 1) mod 20) y
      end;
      Render.draw Render.rockford_right.(!i mod Array.length Render.rockford_right) (!i/delay mod 20) y;
      incr i;
      List.iter (fun (x,y) -> Render.draw Render.rockford_blink_tap.(!i mod Array.length Render.rockford_blink_tap) x y) rockford;
      List.iter (fun (x,y) -> Render.draw Render.diamond.(!i mod Array.length Render.diamond) x y) diamond;
      List.iter (fun (x,y) -> Render.draw Render.firefly.(!i mod Array.length Render.firefly) x y) firefly;
      List.iter (fun (x,y) -> Render.draw Render.butterfly.(!i mod Array.length Render.butterfly) x y) butterfly;
      List.iter (fun (x,y) -> Render.draw Render.amoeba.(!i mod Array.length Render.amoeba) x y) amoeba;
      Unix.sleepf 0.05
    done
