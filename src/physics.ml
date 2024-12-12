open Cave


(* Events *)

type event =
  | BoulderBump
  | DiamondBump
  | MillActivity
  | ExpanderActivity
  | AmoebaActivity
  | SlimeActivity
  | Exploding
  | RockfordWalk
  | RockfordDig
  | RockfordCollect
  | RockfordPush
  | RockfordEntry
  | ExitOpen


(* Helpers *)

let up (x, y) = (x, y - 1)
let down (x, y) = (x, y + 1)
let left (x, y) = (x - 1, y)
let right (x, y) = (x + 1, y)
let down2 (x, y) = down (down (x, y))

let towards = function
  | Up -> up
  | Down -> down
  | Left -> left
  | Right -> right

let counter = function
  | Up -> Down
  | Down -> Up
  | Left -> Right
  | Right -> Left

let clockwise = function
  | Up -> Right
  | Down -> Left
  | Left -> Up
  | Right -> Down


(* Tile Properties *)

let rounded = function  (* objects roll off *)
  | Wall | Boulder Resting | Diamond Resting -> true
  | _ -> false

let explosive = function  (* explodes on impact, with leftover *)
  | Firefly _ | Rockford -> Some Space
  | Butterfly _ -> Some (Diamond Resting)
  | _ -> None

let indestructable = function  (* immune to explosions *)
  | Steel | Entry _ | Exit _ -> true
  | _ -> false


(* Step one Turn *)
let step cave : event list =
  let events = ref [] in

  (* Helper functions on current cave *)
  let event ev = events := ev :: !events in
  let turn (x, y) = cave.map.(y).(x).turn in
  let get (x, y) = cave.map.(y).(x).tile in

  let set (x, y) tile =
    let cell = cave.map.(y).(x) in
    cell.tile <- tile;
    cell.turn <- cave.turn
  in

  let move pos dir tile =
    set pos Space;
    set (dir pos) tile;
    if tile = Rockford then cave.rockford.pos <- pos
  in

  let adjacent pos tile =
    get (up pos) = tile || get (down pos) = tile ||
    get (left pos) = tile || get (right pos) = tile
  in

  (* Initiate an explosion *)
  let explode (x, y) leftover =
    event Exploding;
    for j = y - 1 to y + 1 do
      for i = x - 1 to x + 1 do
        if not (indestructable (get (i, j))) then
          set (i, j) (Explosion (3, leftover))
      done
    done
  in

  (* Move a boulder or diamond *)
  let item pos mv alter mill bump milled =
    match mv, get (down pos) with
    | _, Space ->
      if mv = Resting then event bump;
      move pos down (alter Falling)
    | _, below when rounded below ->
      if mv = Falling then event bump;
      if get (left pos) = Space && get (down (left pos)) = Space then
        move pos left (alter Falling)
      else if get (right pos) = Space && get (down (right pos)) = Space then
        move pos right (alter Falling)
      else
        set pos (alter Resting)
    | Resting, Slime ->
      if get (down2 pos) = Space
      && Random.int 256 land cave.slime.permeability = 0 then
        (move pos down2 (alter Falling); event SlimeActivity)
    | Resting, _ -> ()
    | Falling, Mill state ->
      set pos Space;
      if state = Active || cave.mill.time > 0.0 then
      (
        cave.mill.active <- true;
        if get (down2 pos) = Space then
          (set (down2 pos) (mill Falling); event milled)
      )
    | Falling, below ->
      match explosive below with
      | None -> set pos (alter Resting); event bump
      | Some leftover -> explode (down pos) leftover
  in

  (* Move a firefly or butterfly *)
  let fly pos dir prefdir alter leftover =
    if adjacent pos Rockford || adjacent pos Amoeba then
      explode pos leftover
    else if get (towards prefdir pos) = Space then
      move pos (towards prefdir) (alter prefdir)
    else if get (towards dir pos) = Space then
      move pos (towards dir) (alter dir)
    else
      set pos (alter (counter prefdir))
  in

  (* Score a diamond *)
  let collect () =
    event RockfordCollect;
    cave.diamonds <- cave.diamonds + 1;
    cave.score <- cave.score +
      (if cave.diamonds < cave.needed then cave.value else cave.extra)
  in

  (* Update one cell *)
  let update pos =
    if turn pos >= cave.turn then () else  (* already moved *)
    match get pos with
    | Space -> ()
    | Dirt -> ()
    | Steel -> ()
    | Wall -> ()
    | Slime -> ()

    | Boulder mv -> item pos mv boulder diamond BoulderBump DiamondBump
    | Diamond mv -> item pos mv diamond boulder DiamondBump BoulderBump

    | Firefly dir -> fly pos dir (counter (clockwise dir)) firefly Space
    | Butterfly dir -> fly pos dir (clockwise dir) butterfly (Diamond Resting)

    | Expander ->
      if get (left pos) = Space then
        (set (left pos) Expander; event ExpanderActivity);
      if get (right pos) = Space then
        (set (right pos) Expander; event ExpanderActivity);

    | Amoeba ->
      cave.amoeba'.size <- cave.amoeba'.size + 1;
      event AmoebaActivity;
      if adjacent pos Space || adjacent pos Dirt then
        cave.amoeba'.enclosed <- false;
      if cave.amoeba.enclosed then
        set pos (Diamond Resting)
      else if cave.amoeba.size >= 200 then
        set pos (Boulder Resting)
      else if Random.int (if cave.amoeba.time > 0.0 then 32 else 4) = 0 then
        let pos' = towards [|Up; Down; Left; Right|].(Random.int 4) pos in
        if get pos' = Space || get pos' = Dirt then
          set pos' Amoeba

    | Mill Inactive when cave.mill.active -> set pos (Mill Active)
    | Mill Active when not cave.mill.active -> set pos (Mill Inactive)
    | Mill _ -> if cave.mill.active then event MillActivity

    | Explosion (0, leftover) -> set pos leftover
    | Explosion (n, leftover) -> set pos (Explosion (n - 1, leftover))

    | Entry 0 -> set pos Rockford
    | Entry n ->
      cave.rockford.presence <- Arriving;
      cave.rockford.pos <- pos;
      set pos (Entry (n - 1));
      if n = 4 then event RockfordEntry

    | Exit Inactive when cave.diamonds >= cave.needed ->
      set pos (Exit Active); event ExitOpen
    | Exit _ -> ()

    | Rockford when cave.time <= 0.0 -> explode pos Space
    | Rockford ->
      cave.rockford.presence <- Present;
      cave.rockford.pos <- pos;
      match cave.rockford.face with
      | None -> ()
      | Some dir ->
        let next = towards dir in
        let pos' = next pos in
        match get pos' with
        | Space | Dirt when cave.rockford.reach -> set pos' Space
        | Space -> move pos next Rockford; event RockfordWalk
        | Dirt -> move pos next Rockford; event RockfordDig
        | Diamond _ when cave.rockford.reach ->
          collect ();
          set pos' Space
        | Diamond Resting ->
          collect ();
          move pos next Rockford
        | Boulder Resting when
            (dir = Left || dir = Right) &&
            get (next pos') = Space &&
            Random.int 4 = 0
          ->
          move pos' next (Boulder Resting);
          event RockfordPush;
          if not cave.rockford.reach then move pos next Rockford
        | Exit Active when not cave.rockford.reach ->
          cave.rockford.pos <- pos';
          cave.rockford.presence <- Exited;
          set pos Space
        | _ -> ()
  in

  (* Scan cave *)
  cave.turn <- cave.turn + 1;
  cave.amoeba' <- {cave.amoeba with size = 0; enclosed = true};
  if cave.rockford.presence = Present then cave.rockford.presence <- Dead;

  Array.iteri (fun y -> Array.iteri (fun x _ -> update (x, y))) cave.map;

  cave.amoeba <- cave.amoeba';
  let turn_time = 1.0 /. cave.speed in
  if cave.rockford.presence = Present then cave.time <- cave.time -. turn_time;
  cave.amoeba.time <- cave.amoeba.time -. turn_time;
  if cave.mill.active then cave.mill.time <- cave.mill.time -. turn_time;
  if cave.mill.time <= 0.0 then cave.mill.active <- false;

  !events
