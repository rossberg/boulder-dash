let version = "2.0.5"
let title = "OCaml Boulder Dash " ^ version

let text =
{|
Movement
--------
ARROWS     move Rockford
8 4 2 6    move Rockford
W A S D    move Rockford
SHIFT      reach (with direction)
SPACE / 5  stand still
K          kill Rockford

Game
----
P          toggle pause
H          toggle help
TAB        skip current level (CHEATER!)
BACKSPACE  go back one level (REALLY?)
/          advance to Boulder Dash 2
+ -        change difficulty

Graphics
--------
F          toggle full-screen mode
[ ]        decrease/increase graphics scaling

Program
-------
ESC        quit

2024 by Andreas Rossberg, version |} ^ version
