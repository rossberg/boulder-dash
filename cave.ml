(* Cave constraints:
 * - must be at least size 1x1
 * - all rows have the same length
 * - all border tiles are Steel
 * - there is at most 1 Rockford tile
 *)

(* Cave Representation *)

type direction = Up | Down | Left | Right
type activity = Active | Inactive
type motion = Resting | Falling
type presence = Arriving | Present | Exited | Dead

type tile =
  | Space
  | Dirt
  | Steel
  | Wall
  | Mill of activity
  | Boulder of motion
  | Diamond of motion
  | Firefly of direction
  | Butterfly of direction
  | Expander
  | Amoeba
  | Slime
  | Explosion of int * tile (* phase and leftover *)
  | Entry of int (* phase *)
  | Exit of activity
  | Rockford

type cell = {mutable tile : tile; mutable turn : int}
type map = cell array array

type mill = {mutable time : float; mutable active : bool}
type amoeba = {mutable time : float; mutable size : int; mutable enclosed : bool}
type rockford =
{
  mutable face : direction option;
  mutable reach : bool;
  mutable presence : presence;
  mutable pos : int * int;
}

type cave =
{
  name : char;
  difficulty : int;
  intermission : bool;
  speed : float;  (* turns per second *)
  needed : int;
  value : int;
  extra : int;
  slime : int;
  map : map;
  mutable turn : int;
  mutable time : float; (* seconds *)
  mutable score : int;
  mutable diamonds : int;
  mutable mill : mill;
  mutable amoeba : amoeba;
  mutable amoeba' : amoeba;
  mutable rockford : rockford;
}


(* Constructor *)

let make w h name difficulty intermission speed needed value extra
    time mill_time amoeba_time slime =
  let map =
    Array.init h (fun _ -> Array.init w (fun _ -> {tile = Space; turn = 0})) in
  let mill =
    {time = mill_time; active = false} in
  let amoeba =
    {time = amoeba_time; size = 0; enclosed = false} in
  let rockford =
    {face = None; reach = false; presence = Arriving; pos = w/2, h/2} in
  { name; difficulty; intermission; speed; needed; value; extra; time; slime;
    turn = 0; score = 0; diamonds = 0;
    map; mill; amoeba; amoeba'= amoeba; rockford
  }


(* Helpers *)

let height cave = Array.length cave.map
let width cave = Array.length cave.map.(0)

let entry = Entry 24
let boulder mv = Boulder mv
let diamond mv = Diamond mv
let firefly dir = Firefly dir
let butterfly dir = Butterfly dir
