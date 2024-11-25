### To Do

- Joystick support
- Control module?


# OCaml Boulder Dash

[Boulder Dash](https://en.wikipedia.org/wiki/Boulder_Dash_(video_game)) was my favourite computer game in the 8-bit era, first released on the Atari 400/800 in 1984. Though I never owned an 8-bit machine myself, I had friends that I annoyed enough to let me play it on theirs.

This is a homage to its 40th anniversary in form of a fairly faithful clone of the original game, implemented in just a few 100 lines of OCaml.

Version 2 also was an excuse to play with the OCaml bindings to popular graphics engines, and hence, it comes with 3 possible backends:

1. the homely bare OCaml [Graphics](https://github.com/ocaml/graphics) library,
2. the [TSDL](https://github.com/dbuenzli/tsdl) binding to the [SDL](https://www.libsdl.org) API,
3. the [Raylib](https://github.com/tjammer/raylib-ocaml) binding to the [Raylib](https://www.raylib.com/) game engine.

The above is in order of increasingly better user experience, for the price of a harder build experience. Some unfortunate [limitations](#limitations) apply to the Graphics library option in particular.

In theory, all versions should run on Windows, Mac, and Linux, though I was too lazy to test all combinations, and had trouble installing some of the dependencies on some of the systems.


### Features

* Faithful original physics, graphics, animations, sound, and music
* Authentic scrolling mechanics combined with dynamic resizing
* All 40 levels and 5 difficulties of Boulder Dash 1 & 2
* Pause-and-go mode for relaxed playing


### Building

There are 3 possible backends, resulting in 3 ways to build the program.

#### The Graphics build

To build the version of the game using the Graphics library, it should work to invoke
```
dune build main_graphics.exe
```
If you are old-school and lazy like me, you can also simply say
```
make
```
and as a bonus, get a link to the executable in the current directory.

Prerequisites:

- the Graphics library (`opam install graphics`)

When the graphics didn't work out of the box (e.g., the window cannot be opened on Mac), I found the recipes [here](https://cs51.io/handouts/setup/) here helpful.

If you have [Nix](https://github.com/DeterminateSystems/nix-installer) installed you, can build and run this version with `nix run github:rossberg/boulder-dash?dir=nix`

#### The TDSL build

To build a version of the game using the TSDL library, invoke
```
dune build main_tsdl.exe
```
Or simpler:
```
make tsdl
```

Prerequisites:

- the TSDL library (`opam install tsdl`)

#### The Raylib version

To build a version of the game using the Raylib library, invoke
```
dune build main_raylib.exe
```
Or simpler:
```
make raylib
```

Prerequisites:

- the Raylib library (`opam install raylib`)

Installing this library worked fine for me on MacOS, but I had trouble getting it to work on Windows, although it should run. Perhaps you are more lucky.


### Controls

Sorry, no joysticks. This game only works with your keyboard. The following keys are recognised:

Game controls:

- `W`, `A`, `S`, `D` - move in the respective direction (poor man's joystick)
- `Z`, `Q`, `S`, `D` - move in the respective direction if you're French
- `8`, `4`, `2`, `6` - move in the respective direction on number pad
- `↑`, `←`, `↓`, `→` - move in the respective direction on arrow keys (TSDL or Raylib engine only)
- `SHIFT` with the above - grab/reach out without moving (poor man's fire button)
- `SPACE`, `5` - do not move for one turn (useful in pause mode)
- `K` - kill Rockford (by setting timer to 0)
- `P` - pause/unpause game

Meta controls:

- `SPACE` - continue (after Rockford has died or exited)
- `TAB` - skip current level (cheater!)
- `BACKSPACE` - go back one level (really?)
- `+`, `-` - increase/decrease difficulty
- `/` - advance directly to Boulder Dash 2
- `F` - toggle full-screen mode (TSDL or Raylib engine only)
- `[`, `]` - decrease/increase graphics scaling factor (TSDL or Raylib engine only)
- `ESC` - quit game

When paused, you can still move with `W`, `A`, `S`, `D` and friends, or wait a turn using `SPACE`. That will effectively unpause the game for a single tick and then immediately pause again, using up a single time slice. If you are old and slow like me, or fed up up with the keybord lag (see below), that allows you to play it like a puzzler rather than a stressful action game.

There are also a couple of cheat codes, but I won't tell.

Beyond that, Boulder Dash is mostly a self-explanatory game. Figuring out the mechanics of some elements is part of the experience. We didn't have a manual in the olden days either.

Oh, and if you don't like the size of the sprites, you can scale the whole image by passing `--scale <int>` on the command line. The default is 4 (times the original 8-bit sprite sizes, which were designed for the fancy 320x200 displays of the times). In the TSDL or Raylib build, you can of course change this dynamically using the `[` and `]` keys.


### Implementation

I tried to keep the code simple. Unfortunately, it turned out fairly imperative, given the stateful nature of the game and of the graphics library.

The modules are:

- `Cave` - the representation of a game level
- `Levels` - the original binary levels data with a decoder
- `Physics` - the core game logic for transitioning a cave one tick
- `Game` - the main game loop (functorised over engine)
- `Render` - the graphics backend (functorised over engine)
- `Sound` - handling of sound effects (functorised over engine)
- `Main` - common main module (functorised over engine)
- `Engine` - unified signature for backend engines
- `engine-*/Engine_{graphics,tsdl,raylib}` - wrapper for respective backend library
- `main-*/Main_{graphics,tsdl,raylib}` - main entry point for respective build
- `engine-graphics/Bmp` - a simple decoder for .bmp files

Little surprising to say there, please look at the code for details. For what it's worth, the game logic was straightforward to hack down and worked almost on first try. By far the trickiest part was getting the scrolling logic correct for all edge cases — it mimics the original's famous follow-the-player behaviour, but with arbitrary window resizing thrown into the mix, and I wanted the two to interact smoothly.


### Limitations

Each of the 3 backends has its pros and cons. Needless to say that they all sport very imperative interfaces.

#### Graphics Library

On one hand, I was surprised and thrilled how easy it was to use the Graphics library, and how far I was able to push it with full screen animation and scrolling. I love that it has no external dependencies, making it much less of a headache to build than the alternatives.

On the other, it has a few shortcomings, being the excuse for some limitations to this build of this little game:

- Controls: Keyboard only and a bit sluggish, since the library only offers buffered keyboard input, no direct key events. For the best experience, set your system's key repeat *rate* to max and key repeat *delay* to zero. Also, cursor keys cannot be recognised, so you're stuck with WASD.

  *Hint: A particularly dangerous consequence of the key repeat delay is that standing under a rock and then trying to run downwards by holding the `S` key usually turns out fairly deadly, because the rock will have moved twice already before the key repeat kicks in. For such a maneuver to succeed, you have to press the key individually (and fast) for each step. Sorry about that!*

- Start-up time: When initialising, the program creates a mere 240 tiny images for sprites. Saying that the Graphics library's `make_image` function is dog-slow on Windows is a polite understatement, as it is literally taking multiple seconds for that, at least on my machine (even worse for larger scaling factors). I'm not sure what's going on there. Also, it raises an exception when the user dares resizes the window during this process, so we have to work around that.

- Colour schemes: Colour changes between levels as in the original are not implemented, since that would exacerbate the aforementioned image creation hold-up. Did I mention it's reeaallly slow on Windows?

- Flicker: Window resizing causes terrible flicker, especially because the window background color cannot be changed to something reasonable, like nice, cosy, neutral black. And the library's coordinate system with the origin in the lower left corner of the window is completely at odds with how window resizing works, which causes this coordinate system to be volatile and even racy.

- No sound: The Graphics library's `sound` function is a wee bit too lame to produce proper effects, especially since it appears to be blocking.

- Windows: On Windows, some of the API seems defunct, e.g., setting the window size or text size has no effect. Some draw commands are randomly ignored on occasion.

- Mac: On MacOs, the library requires X11, so you'll have to install XQuartz.

Finally, because the Graphics library is much more unhurried in general, rendering has to be optimised to only update tiles that either changed or are animated. In situations where a lot is happening or the entire screen changes due to scrolling, the game tends to become less fluid.

#### TSDL Library

Most of what I needed could easily be done with TSDL, although it is rather low-level, so lacks certain convenience, e.g., for manipulating images. But the only real limitation revolved around its sound subsystem:

- No sound mixing: Although SDL3 can freely mix multiple audio streams, TSDL currently only supports SDL2, which does not have that capability. Since I did not feel like implementing that myself, I hack around that by using all available audio devices as voices. Depending on the hardware, that could mean that some sound effects are swallowed in noisy situations.

- Only .wav: In addition, SDL only supports plain wave files, so I can't deploy the sound assets as smaller MP3s without introducing additional dependencies.

- Unsafe: When screwing up and using the API incorrectly, I believe I witnessed crashes in some cases, though I can't reproduce the details.

#### Raylib Library

Raylib is meant to be easy to use, so has more high-level functionality and is generally pleasent to use. I only ran into a couple of quirks:

- Fullscreen oddities: For some reason, Raylib decides to change the resolution when going to fullscreen, at least on Mac. And the one it picks isn't even a natural one for the screen. I had to work around this by adapting the current graphics scaling to the new resolution.

- Key bindings: For unknown reasons, Raylib's of cooked key press events is very unreliable, at least when doing direct key code checking at the same time. It swallows, like, more than half the key presses. Although this approach works fine for TSDL, I had to abandon it for Raylib. As a result, some of the game's meta controls will be mapped incorrectly for folks daring to not use an English keyboard.

- Unsafe: Its imperative interface does not prevent you from trying things like creating a texture before opening a window, which it doesn't like much and will respond to with a crash.


### Change History

Version 2 adds the following niceties:

- All Boulder Dash 2 levels
- Support for SDL and Raylib engines
- Original sound effects and music
- Original level color schemes
- Full screen mode
- Dynamic scaling adjustment
- Precise keyboard controls and control via arrow keys
- Fix expired mill wall


### Acknowledgements and Resources

* Peter Liepa and Chris Gray for making the [original](https://en.wikipedia.org/wiki/Boulder_Dash_(video_game)) [game](https://boulder-dash.com/retro-gamer-magazine/).

* Peter Broadribb for various [documents](https://www.elmerproductions.com/sp/peterb/) reverse-engineering internals of the original.

* Martijn Mooij for the old [Boulder Dash Fan site](http://www.bd-fans.com/) hosting lots of material (defunct, [mirror](https://www.artsoft.org/rocksndiamonds/levels/martijnmooij/2012-11-07/www.bd-fans.com/index.html)).

* Jake Gordon for his [JavaScript Boulder Dash](https://codeincomplete.com/articles/javascript-boulderdash/), which inspired me to do the same in a civilised programming language.

* Marek Roth for the [Boulder Dash Inside FAQ](http://www.gratissaugen.de/erbsen/BD-Inside-FAQ.html), which has all the details on the cave encodings of all relevant BD versions.

* Arno Weber for the [Boulder Dash Fansite](https://www.boulder-dash.nl), which has yet more material and an (active!) [forum](http://www.boulder-dash.nl/forum/).

* Stephen Hewitt for a [Boulder Dash Disassembly](http://www.retrointernals.org/boulder-dash/boulder-dash-disassembly).

* Dr Honz for the [Boulder Dashes ReM](csdb.dk/release/?id=145094), the complete reverse engineered source code of BD1, BD2, and BDCK.

* Czirkos Zoltan for the [GDash](https://github.com/meonwax/gdash) clone, from which I took the original's sound samples.

* "Boulder Dash" today is a trademark of [BBG Entertainment](https://boulder-dash.com/), after being owned by [First Star Software](https://en.wikipedia.org/wiki/First_Star_Software) until 2018.


### License

The source code in this repository is distributed under the Creative Commons Attribution/Non-commercial [CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/) license.
