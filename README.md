# OCaml Boulder Dash

[Boulder Dash](https://en.wikipedia.org/wiki/Boulder_Dash_(video_game)) was my favourite computer game in the 8-bit era, first released on the Atari 400/800 in 1984. Though I never owned an 8-bit machine myself, I had friends that I annoyed enough to let me play it on theirs.

This is a homage to its 40th anniversary in form of a fairly faithful clone of the original game, implemented in just a few 100 lines of bare OCaml, with nothing but the homely [Graphics](https://github.com/ocaml/graphics) library. It should run on Windows, Mac, and Linux, though I was too lazy to test the latter.


### Features

* Faithful original physics, graphics, and animations
* Authentic scrolling mechanics combined with dynamic window resizing
* All 20 levels, including intermissions, and 5 difficulties
* Pause-and-go mode for relaxed playing

The game engine can also handle the features from Boulder Dash 2, namely Expanding Walls and Slime, but currently includes no levels that use them.


### Building

It should work to invoke
```
dune build
```
If you are old-school and lazy like me, you can also simply say
```
make
```
and as a bonus, get a link to the executable in the current directory. Of course, that's assuming you're a real programmer working with some Unix-style shell.

Prerequisites:

- the Graphics library (`opam install graphics`)

When the graphics didn't work out of the box (e.g., the window cannot be opened on Mac), I found the recipes [here](https://cs51.io/handouts/setup/) here helpful.


### Controls

Sorry, no joysticks. This game only works with your keyboard. The following keys are recognised:

Game control:

- `W`, `A`, `S`, `D` - move in the respective direction (poor man's joystick)
- `Z`, `Q`, `S`, `D` - move in the respective direction if you're French
- `SHIFT` with the above - grab/reach out without moving (poor man's fire button)
- `X` - do not move for one turn (useful in pause mode)
- `K` - kill Rockford (by setting timer to 0)
- `P` - pause/unpause game

Meta control:

- `SPACE` - continue (after Rockford has died or exited)
- `TAB` - skip current level (cheater!)
- `BACKSPACE` - go back one level (really?)
- `+` - increase difficulty
- `-` - decrease difficulty
- `ESC` - quit game

When paused, you can still move with `W`, `A`, `S`, `D`, or wait a turn using `X`. That will effectively unpause the game for a single tick and then immediately pause again, using up a single time slice. If you are old and slow like me, or fed up up with the keybord lag (see below), that allows you to play it like a puzzler rather than a stressful action game.

There are also a couple of cheat codes, but I won't tell.

Beyond that, Boulder Dash is mostly a self-explanatory game. Figuring out the mechanics of some elements is part of the experience. We didn't have a manual in the olden days either.

Oh, and if you don't like the size of the sprites, you can scale the whole image by passing `--scale <int>` on the command line. The default is 4 (times the original 8-bit sprite sizes, which were designed for the fancy 320x200 displays of the times).


### Limitations

On one hand, I was surprised and thrilled how easy it was to use the Graphics library, and how far I was able to push it with full screen animation and scrolling. On the other, it has a few shortcomings, being the excuse for some limitations of this little game:

- Controls: Keyboard only and a bit sluggish, since the library only offers buffered keyboard input, no direct key events. For the best experience, set your system's key repeat *rate* to max and key repeat *delay* to zero. Also, cursor keys cannot be recognised, so you're stuck with WASD.

  *Hint: A particularly dangerous consequence of the key repeat delay is that standing under a rock and then trying to run downwards by holding the `S` key usually turns out fairly deadly, because the rock will have moved twice already before the key repeat kicks in. For such a maneuver to succeed, you have to press the key individually (and fast) for each step. Sorry about that!*

- Start-up time: When initialising, the program creates a mere 240 tiny images for sprites. Saying that the Graphics library's `make_image` function is dog-slow on Windows is a polite understatement, as it is literally taking multiple seconds for that, at least on my machine (even worse for larger scaling factors). I'm not sure what's going on there. Also, it raises an exception when the user dares resizes the window during this process, so we have to work around that.

- Colour schemes: Colour changes between levels as in the original are not implemented, since that would exacerbate the aforementioned image creation hold-up. Did I mention it's reeaallly slow on Windows?

- Flicker: Window resizing causes terrible flicker, especially because the window background color cannot be changed to something reasonable, like nice, cosy, neutral black. And the library's coordinate system with the origin in the lower left corner of the window is completely at odds with how window resizing works, which causes this coordinate system to be volatile and even racy.

- No sound: The Graphics library's `sound` function is a wee bit too lame to produce proper effects, especially since it appears to be blocking.

- Windows: On Windows, some of the API seems defunct, e.g., setting the window size or text size has no effect. Some draw commands are randomly ignored on occasion.

When I have time and leisure, I may consider porting the program to a more real graphics engine.


### Implementation

I tried to keep the code simple. Unfortunately, it turned out fairly imperative, given the stateful nature of the game and of the graphics library.

The modules are:

- `Cave` - the representation of a game level
- `Step` - the core game logic for transitioning a cave one tick
- `Game` - the main game loop
- `Render` - the graphics backend
- `Levels` - the original binary levels data with a decoder
- `Bmp` - a simple decoder for .bmp files
- `Main` - main entry point

Little surprising to say there, please look at the code for details. For what it's worth, the game logic was straightforward to hack down and worked almost on first try. By far the trickiest part was getting the scrolling logic correct for all edge cases — it mimics the original's famous follow-the-player behaviour, but with arbitrary window resizing thrown into the mix, and I wanted the two to interact smoothly.


### Acknowledgements

* Peter Liepa and Chris Gray for making the [original](https://en.wikipedia.org/wiki/Boulder_Dash_(video_game)) [game](https://boulder-dash.com/retro-gamer-magazine/).

* Peter Broadribb for various [documents](https://www.artsoft.org/rocksndiamonds/levels/martijnmooij/2012-11-07/www.bd-fans.com/FanStuff.html#Programming) reverse-engineering internals of the original.

* Martijn Mooij for the [Boulder Dash Fan site](http://www.bd-fans.com/) hosting lots of material (defunct, [mirror](https://www.artsoft.org/rocksndiamonds/levels/martijnmooij/2012-11-07/www.bd-fans.com/index.html)).

* Jake Gordon for his [JavaScript Boulder Dash](https://codeincomplete.com/articles/javascript-boulderdash/), which inspired me to do the same in a civilised programming language and with some improvements (more faithful physics, difficulty levels, scrolling, reveal animation, ...).

* "Boulder Dash" today is a trademark of [BBG Entertainment](https://boulder-dash.com/), after being owned by [First Star Software](https://en.wikipedia.org/wiki/First_Star_Software) until 2018.


### License

The source code in this repository is distributed under the Creative Commons Attribution/Non-commercial [CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/) license.
