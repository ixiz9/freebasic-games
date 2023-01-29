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
* There is no sound
* Fruit bonuses are not implemented

The maze is defined in the game as a simple ASCII string. You can easily change it or replace it entirely.

