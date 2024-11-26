(* Unified Backend Engine Signature *)

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

  val is_buffered_frame : bool
  (** True if the engine uses double buffering. *)


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


  (* Sound *)

  type audio
  (** An intialized audio device *)

  type sound
  (** A sound sample. *)

  val open_audio : unit -> audio
  (** Initialise audio device. *)

  val close_audio : audio -> unit
  (** Close audio device. *)

  val load_sound : string -> sound
  (** Load a sound from a file. *)

  val play_sound : audio -> sound -> unit
  (** Play a sound. *)

  val stop_sound : audio -> sound -> unit
  (** Stop a sound. *)

  val is_playing_sound : audio -> sound -> bool
  (** Test whether the sound is currently playing. *)


  (* Controls *)

  type control
  (** The type of all used control devices, including keyboard. *)

  type dir = Left | Right | Up | Down
  type key = Char of char | Arrow of dir
  (** The type of keyboard keys. *)

  val open_control : string -> control
  (** Initialise control devices, taking an SDL controller mapping. *)

  val close_control : control -> unit
  (** Close control devices. *)

  val is_buffered_key : bool
  (** True when keyboard input is buffered. *)

  val poll_key : control -> key option * bool
  (** Checks input and returns respective key if pressed.
    The Boolean indicates the state of the shift modifier. *)

  val poll_pad : control ->
    bool * bool * bool * bool *
    float * float * float * float *
    bool * bool * bool * bool
  (** Checks game pad and returns left, right, up, down status of d-pad,
    x and y axis of the left and right stick, with values between -1.0 and +1.0,
    and the status of the A, B, X, and Y buttons. *)

end
