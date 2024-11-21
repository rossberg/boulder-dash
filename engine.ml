module type S =
sig
  (* Output Window *)

  type window
  (** An initialized graphics window. *)

  type color
  (** A screen color. *)

  val open_window : int -> int -> string -> window
  (** [init w h title] Initialize graphics window with width, height,
    and window or application title. Must only be called once. *)

  val close_window : window -> unit
  (** Close graphics. *)

  val width_window : window -> int
  (** Get current width of graphics area. *)

  val height_window : window -> int
  (** Get current height of graphics area. *)


  val clear_window : window -> color -> unit
  (** Clear window background. *)

  val fullscreen_window : window -> unit
  (** Toggle fullscreen mode if available, ignore otherwise. *)


  (* Animation Frames *)

  val start_frame : window -> unit
  (** Starts a new animation frame. *)

  val finish_frame : window -> unit
  (** Ends an animation frame. *)


  (* Colors *)

  val create_color : int -> int -> int -> color
  (** [create_color r g b] creates a color from 8-bit RGB values. *)


  val draw_color : window -> color -> int -> int -> int -> int -> unit
  (** [draw_rectangle win col x y w h] draws a rectangle. *)


  (* Images *)

  type raw_image
  (** Type of image usable for manipulation. *)

  type prepared_image
  (** Type of image usable for drawing. *)

  val load_image : string -> raw_image
  (** Load an image from a file. *)

  val extract_image : raw_image -> int -> int -> int -> int -> raw_image
  (** [extract_image x y w h] returns a sub image. *)

  val recolor_image : raw_image -> color -> color -> raw_image
  (** [recolor_image img src dst] exchanges color [src] for [dst] in [img]. *)

  val prepare_image : window -> int -> raw_image -> prepared_image
  (** Prepare image for drawing with a given scaling factor. Can only be used
    with open window. *)

  val draw_image : window -> prepared_image -> int -> int -> int -> unit
  (** [draw_image win img x y scale] draws an image, possibly scaled up. *)

  val can_scale_image : bool
  (** True if [draw_image] allows dynamic scaling, i.e., other scaling factors
    than the one previously used with [prepare_image]. *)


  (* Keyboard *)

  val get_key : unit -> char * bool
  (** Check input and returns respective character, '\x00' if none.
    The Boolean indicates the states of the fire button equivalent. *)
end
