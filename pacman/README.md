# A version of PacMan

To compile just do
```
fbc pman.bas
```
Or if you prefer the 2023 maze try
```
fbc -d v2023 pman.bas
```

This version differs from the original in several important ways
* The maze is different, though similar
* The ghost behavior is close, but not identical
   * The ghosts do not attack in waves
   * The ghosts depart the ghost house based on time, not dots eaten
* There is only one level, the game does not get harder as you play
* Fruit bonuses are not implemented

The maze is defined in the game as a simple ASCII string. You can easily change it or replace it entirely.

**[Update 2/1/2023]** Sound is now supported!
Sound is optional. To get sound you should compile with
```
fbc -d SOUND pman.bas
```
or
```
fbc -d SOUND -d v2023 pman.bas
```
Sound requires SDL2. On Linux you should install `libsdl2-dev` and `libsdl2-mixer-dev`. On windows you should download the SDL2 DLLs from [github](https://github.com/libsdl-org/SDL/releases/tag/release-2.26.2) and put them in the same directory as this source.

**[Update 2/2/2023]** INTRODUCING TECHMAN
Compile with
```
fbc -d VLAYOFFS -d SOUND pman.bas
```
or
```
fbc -d VLAYOFFS -d SOUND -d v2023 pman.bas
```
To try your luck at avoiding layoffs and retiring rich. 
Watch out for those managers!
