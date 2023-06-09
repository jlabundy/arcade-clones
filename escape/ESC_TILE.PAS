
{ Tile Data for ESCAPE by Jeff LaBundy }
{ This file was generated on 01-06-2002 at 17:17:09 }

unit ESC_TILE;


interface


 {Tile Data}

  type tiledata = array[0..91, 0..7, 0..7] of byte;

  const tile : tiledata = (

 { Transparent }

  (

  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255)

  ),


 { Boundary }

  (

  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255)

  ),


 { Single Brick }

  (

  (  30,  30,  30,  30,  30,  30,  30,  30),
  (  27,  30,  30,  30,  30,  30,  30,  25),
  (  27,  27,  19,  19,  19,  19,  25,  25),
  (  27,  27,  19,  19,  19,  19,  25,  25),
  (  27,  27,  19,  19,  19,  19,  25,  25),
  (  27,  27,  19,  19,  19,  19,  25,  25),
  (  27,  21,  21,  21,  21,  21,  21,  25),
  (  21,  21,  21,  21,  21,  21,  21,  21)

  ),


 { Double Brick - L }

  (

  (  30,  30,  30,  30,  30,  30,  30,  30),
  (  27,  30,  30,  30,  30,  30,  30,  30),
  (  27,  27,  19,  19,  19,  19,  19,  19),
  (  27,  27,  19,  19,  19,  19,  19,  19),
  (  27,  27,  19,  19,  19,  19,  19,  19),
  (  27,  27,  19,  19,  19,  19,  19,  19),
  (  27,  21,  21,  21,  21,  21,  21,  21),
  (  21,  21,  21,  21,  21,  21,  21,  21)

  ),


 { Double Brick - R }

  (

  (  30,  30,  30,  30,  30,  30,  30,  30),
  (  30,  30,  30,  30,  30,  30,  30,  25),
  (  19,  19,  19,  19,  19,  19,  25,  25),
  (  19,  19,  19,  19,  19,  19,  25,  25),
  (  19,  19,  19,  19,  19,  19,  25,  25),
  (  19,  19,  19,  19,  19,  19,  25,  25),
  (  21,  21,  21,  21,  21,  21,  21,  25),
  (  21,  21,  21,  21,  21,  21,  21,  21)

  ),


 { Robot 1 }

  (

  (  19,  19,  19,  19,  19,  19,  19,  21),
  (  19,  17,  17,  17,  17,  27,  19,  21),
  (  19,  17,  17,  17,   4,  27,  19,  21),
  (  19,  17,  27,  27,  27,  27,  19,  19),
  (  19,  19,  19,  19,  19,  19,  19,  19),
  (  19,  21,  21,  19,  27,  27,  27,  19),
  (  19,  21,  21,  19,  19,   4,  27,  19),
  (  19,  19,  19,  19,  19,  19,  19,  19)

  ),


 { Robot 2 }

  (

  (  19,  19,  19,  19,  19,  19,  19,  21),
  (  19,  17,  17,  17,  17,  27,  19,  21),
  (  19,  17,  17,  17,   4,  27,  19,  21),
  (  19,  17,  27,  27,  27,  27,  19,  19),
  (  19,  19,  19,  19,  19,  19,  19,  19),
  (  19,  21,  21,  19,  27,  27,  27,  19),
  (  19,  21,  21,  19,  19,  40,  27,  19),
  (  19,  19,  19,  19,  19,  19,  19,  19)

  ),


 { Robot 3 }

  (

  (  19,  19,  19,  19,  19,  19,  19,  21),
  (  19,  17,  17,  17,  17,  27,  19,  21),
  (  19,  17,  17,  17, 112,  27,  19,  21),
  (  19,  17,  27,  27,  27,  27,  19,  19),
  (  19,  19,  19,  19,  19,  19,  19,  19),
  (  19,  21,  21,  19,  27,  27,  27,  19),
  (  19,  21,  21,  19,  19,   4,  27,  19),
  (  19,  19,  19,  19,  19,  19,  19,  19)

  ),


 { Computer Chip }

  (

  ( 192,   2, 192, 192, 192,   2, 192, 192),
  (   2,   2, 192,  19,  19,  19,   2,   2),
  ( 192,   2, 192,  19,  19,  19, 192, 192),
  (   2,   2, 192, 192, 192,   2,   2,   2),
  ( 192, 192, 192, 192,   9,   2, 192, 192),
  ( 192, 192,  65, 192, 192,   2, 192, 192),
  ( 192, 192,   4,   2,   2,   2, 192, 192),
  ( 192,   2, 192, 192, 192,   2, 192, 192)

  ),


 { Brick }

  (

  (  40,  40,  40,  40, 184, 184, 184, 184),
  (  40,  40,  40,  40, 184, 184, 184, 184),
  (   4,   4, 112, 112, 112, 112,   4,   4),
  (   4,   4, 112, 112, 112, 112,   4,   4),
  (  40,  40,  40,  40, 184, 184, 184, 184),
  (  40,  40,  40,  40, 184, 184, 184, 184),
  (   4,   4, 112, 112, 112, 112,   4,   4),
  (   4,   4, 112, 112, 112, 112,   4,   4)

  ),


 { Blue }

  (

  ( 176, 176, 176, 176, 176, 176, 176, 176),
  ( 176, 104, 104, 104, 104, 104, 104, 176),
  ( 176, 104,   1,   1,   1,   1, 104, 176),
  ( 176, 104,   1,  32,  32,   1, 104, 176),
  ( 176, 104,   1,  32,  32,   1, 104, 176),
  ( 176, 104,   1,   1,   1,   1, 104, 176),
  ( 176, 104, 104, 104, 104, 104, 104, 176),
  ( 176, 176, 176, 176, 176, 176, 176, 176)

  ),


 { Fire }

  (

  (  40,  40,  40,  40,  40,  40,  40,  40),
  (  40,  41,  41,  41,  41,  41,  41,  40),
  (  40,  41,  42,  42,  42,  42,  41,  40),
  (  40,  41,  42,  43,  43,  42,  41,  40),
  (  40,  41,  42,  43,  43,  42,  41,  40),
  (  40,  41,  42,  42,  42,  42,  41,  40),
  (  40,  41,  41,  41,  41,  41,  41,  40),
  (  40,  40,  40,  40,  40,  40,  40,  40)

  ),


 { Pipeline }

  (

  (   0,   0,   2,   0,   0,   2,   0,   0),
  (   0,   0,   2,   0,   0,   2,   0,   0),
  (   2,   2,   2,   0,   0,   2,   2,   2),
  (   0,   0,   0,   2,   2,   0,   0,   0),
  (   0,   0,   0,   2,   2,   0,   0,   0),
  (   2,   2,   2,   0,   0,   2,   2,   2),
  (   0,   0,   2,   0,   0,   2,   0,   0),
  (   0,   0,   2,   0,   0,   2,   0,   0)

  ),


 { X G\R }

  (

  (  48, 184, 184, 184, 184, 184, 184,  48),
  ( 184,  48, 184, 184, 184, 184,  48, 184),
  ( 184, 184,  48, 184, 184,  48, 184, 184),
  ( 184, 184, 184,  48,  48, 184, 184, 184),
  ( 184, 184, 184,  48,  48, 184, 184, 184),
  ( 184, 184,  48, 184, 184,  48, 184, 184),
  ( 184,  48, 184, 184, 184, 184,  48, 184),
  (  48, 184, 184, 184, 184, 184, 184,  48)

  ),


 { X O\B }

  (

  (  43, 176, 176, 176, 176, 176, 176,  43),
  ( 176,  43, 176, 176, 176, 176,  43, 176),
  ( 176, 176,  43, 176, 176,  43, 176, 176),
  ( 176, 176, 176,  43,  43, 176, 176, 176),
  ( 176, 176, 176,  43,  43, 176, 176, 176),
  ( 176, 176,  43, 176, 176,  43, 176, 176),
  ( 176,  43, 176, 176, 176, 176,  43, 176),
  (  43, 176, 176, 176, 176, 176, 176,  43)

  ),


 { Circle O\B }

  (

  ( 176, 176, 176, 176, 176, 176, 176, 176),
  ( 176, 176, 176,  41,  41, 176, 176, 176),
  ( 176, 176,  41,  42,  42,  41, 176, 176),
  ( 176,  41,  42,  43,  43,  42,  41, 176),
  ( 176,  41,  42,  43,  43,  42,  41, 176),
  ( 176, 176,  41,  42,  42,  41, 176, 176),
  ( 176, 176, 176,  41,  41, 176, 176, 176),
  ( 176, 176, 176, 176, 176, 176, 176, 176)

  ),


 { Circle G\R }

  (

  ( 184, 184, 184, 184, 184, 184, 184, 184),
  ( 184, 184, 184, 120, 120, 184, 184, 184),
  ( 184, 184, 120,   2,   2, 120, 184, 184),
  ( 184, 120,   2,  48,  48,   2, 120, 184),
  ( 184, 120,   2,  48,  48,   2, 120, 184),
  ( 184, 184, 120,   2,   2, 120, 184, 184),
  ( 184, 184, 184, 120, 120, 184, 184, 184),
  ( 184, 184, 184, 184, 184, 184, 184, 184)

  ),


 { Circle Y\P }

  (

  ( 179, 179, 179, 179, 179, 179, 179, 179),
  ( 179, 179, 179, 116, 116, 179, 179, 179),
  ( 179, 179, 116,  44,  44, 116, 179, 179),
  ( 179, 116,  44,  44,  44,  44, 116, 179),
  ( 179, 116,  44,  44,  44,  44, 116, 179),
  ( 179, 179, 116,  44,  44, 116, 179, 179),
  ( 179, 179, 179, 116, 116, 179, 179, 179),
  ( 179, 179, 179, 179, 179, 179, 179, 179)

  ),


 { O\B }

  (

  (  42,  42,  42,  42,  42,  42,  42,  42),
  (  42,  42,  42,  42,  42,  42,  42, 104),
  (  42,  42,  42,  42,  42,  42, 104, 104),
  (  42,  42,  42,  42,  42, 104, 104, 104),
  (  42,  42,  42,  42, 104, 104, 104, 104),
  (  42,  42,  42, 104, 104, 104, 104, 104),
  (  42,  42, 104, 104, 104, 104, 104, 104),
  (  42, 104, 104, 104, 104, 104, 104, 104)

  ),


 { G\R }

  (

  (  48,  48,  48,  48,  48,  48,  48,  48),
  (  48,  48,  48,  48,  48,  48,  48, 112),
  (  48,  48,  48,  48,  48,  48, 112, 112),
  (  48,  48,  48,  48,  48, 112, 112, 112),
  (  48,  48,  48,  48, 112, 112, 112, 112),
  (  48,  48,  48, 112, 112, 112, 112, 112),
  (  48,  48, 112, 112, 112, 112, 112, 112),
  (  48, 112, 112, 112, 112, 112, 112, 112)

  ),


 { Y\R }

  (

  (  44,  44,  44,  44,  44,  44,  44,  44),
  (  44,  44,  44,  44,  44,  44,  44, 112),
  (  44,  44,  44,  44,  44,  44, 112, 112),
  (  44,  44,  44,  44,  44, 112, 112, 112),
  (  44,  44,  44,  44, 112, 112, 112, 112),
  (  44,  44,  44, 112, 112, 112, 112, 112),
  (  44,  44, 112, 112, 112, 112, 112, 112),
  (  44, 112, 112, 112, 112, 112, 112, 112)

  ),


 { Y\P }

  (

  (  44,  44,  44,  44,  44,  44,  44,  44),
  (  44,  44,  44,  44,  44,  44,  44, 179),
  (  44,  44,  44,  44,  44,  44, 179, 179),
  (  44,  44,  44,  44,  44, 179, 179, 179),
  (  44,  44,  44,  44, 179, 179, 179, 179),
  (  44,  44,  44, 179, 179, 179, 179, 179),
  (  44,  44, 179, 179, 179, 179, 179, 179),
  (  44, 179, 179, 179, 179, 179, 179, 179)

  ),


 { Red }

  (

  ( 184, 184, 184, 184, 184, 184, 184, 184),
  ( 184, 112, 112, 112, 112, 112, 112, 184),
  ( 184, 112,   4,   4,   4,   4, 112, 184),
  ( 184, 112,   4,  40,  40,   4, 112, 184),
  ( 184, 112,   4,  40,  40,   4, 112, 184),
  ( 184, 112,   4,   4,   4,   4, 112, 184),
  ( 184, 112, 112, 112, 112, 112, 112, 184),
  ( 184, 184, 184, 184, 184, 184, 184, 184)

  ),


 { Green }

  (

  ( 192, 192, 192, 192, 192, 192, 192, 192),
  ( 192, 120, 120, 120, 120, 120, 120, 192),
  ( 192, 120,   2,   2,   2,   2, 120, 192),
  ( 192, 120,   2,  48,  48,   2, 120, 192),
  ( 192, 120,   2,  48,  48,   2, 120, 192),
  ( 192, 120,   2,   2,   2,   2, 120, 192),
  ( 192, 120, 120, 120, 120, 120, 120, 192),
  ( 192, 192, 192, 192, 192, 192, 192, 192)

  ),


 { Purple }

  (

  ( 180, 180, 180, 180, 180, 180, 180, 180),
  ( 180, 108, 108, 108, 108, 108, 108, 180),
  ( 180, 108,   5,   5,   5,   5, 108, 180),
  ( 180, 108,   5,  36,  36,   5, 108, 180),
  ( 180, 108,   5,  36,  36,   5, 108, 180),
  ( 180, 108,   5,   5,   5,   5, 108, 180),
  ( 180, 108, 108, 108, 108, 108, 108, 180),
  ( 180, 180, 180, 180, 180, 180, 180, 180)

  ),


 { Digital Red }

  (

  (  23,  23,  23,  23,  23,  23,  23,  23),
  (  23,   0,   0,   0,   0,   0,  20,  23),
  (  23,   0,  40,  40,  40,   0,  20,  23),
  (  23,   0,  40,   0,  40,   0,  20,  23),
  (  23,   0,  40,  40,  40,   0,  20,  23),
  (  23,   0,   0,   0,   0,   0,  20,  23),
  (  23,  20,  20,  20,  20,  20,  20,  23),
  (  23,  23,  23,  23,  23,  23,  23,  23)

  ),


 { Digital Green }

  (

  (  23,  23,  23,  23,  23,  23,  23,  23),
  (  23,   0,   0,   0,   0,   0,  20,  23),
  (  23,   0,  48,  48,  48,   0,  20,  23),
  (  23,   0,  48,   0,  48,   0,  20,  23),
  (  23,   0,  48,  48,  48,   0,  20,  23),
  (  23,   0,   0,   0,   0,   0,  20,  23),
  (  23,  20,  20,  20,  20,  20,  20,  23),
  (  23,  23,  23,  23,  23,  23,  23,  23)

  ),


 { Digital Blue }

  (

  (  23,  23,  23,  23,  23,  23,  23,  23),
  (  23,   0,   0,   0,   0,   0,  20,  23),
  (  23,   0,  32,  32,  32,   0,  20,  23),
  (  23,   0,  32,   0,  32,   0,  20,  23),
  (  23,   0,  32,  32,  32,   0,  20,  23),
  (  23,   0,   0,   0,   0,   0,  20,  23),
  (  23,  20,  20,  20,  20,  20,  20,  23),
  (  23,  23,  23,  23,  23,  23,  23,  23)

  ),


 { Trap G\R }

  (

  (   0,   0,  48,   0,   0,  48,   0,   0),
  (   0,   0,  48,  48,  48,  48,   0,   0),
  (  48,  48, 112, 112, 112, 112,  48,  48),
  (   0,  48, 112, 112, 112, 112,  48,   0),
  (   0,  48, 112, 112, 112, 112,  48,   0),
  (  48,  48, 112, 112, 112, 112,  48,  48),
  (   0,   0,  48,  48,  48,  48,   0,   0),
  (   0,   0,  48,   0,   0,  48,   0,   0)

  ),


 { Trap O\B }

  (

  (   0,   0,  42,   0,   0,  42,   0,   0),
  (   0,   0,  42,  42,  42,  42,   0,   0),
  (  42,  42, 104, 104, 104, 104,  42,  42),
  (   0,  42, 104, 104, 104, 104,  42,   0),
  (   0,  42, 104, 104, 104, 104,  42,   0),
  (  42,  42, 104, 104, 104, 104,  42,  42),
  (   0,   0,  42,  42,  42,  42,   0,   0),
  (   0,   0,  42,   0,   0,  42,   0,   0)

  ),


 { Ball - Grey }

  (

  ( 255,  19,  21,  19, 255, 255, 255, 255),
  (  19,  21,  23,  21,  19, 255, 255, 255),
  (  21,  23,  26,  23,  21, 255, 255, 255),
  (  19,  21,  23,  21,  19, 255, 255, 255),
  ( 255,  19,  21,  19, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255)

  ),


 { Ball - Green }

  (

  ( 255, 192, 120, 192, 255, 255, 255, 255),
  ( 192, 120,   2, 120, 192, 255, 255, 255),
  ( 120,   2,  48,   2, 120, 255, 255, 255),
  ( 192, 120,   2, 120, 192, 255, 255, 255),
  ( 255, 192, 120, 192, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255)

  ),


 { Ball - Red }

  (

  ( 255, 184, 112, 184, 255, 255, 255, 255),
  ( 184, 112,   4, 112, 184, 255, 255, 255),
  ( 112,   4,  40,   4, 112, 255, 255, 255),
  ( 184, 112,   4, 112, 184, 255, 255, 255),
  ( 255, 184, 112, 184, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255)

  ),


 { Ball - Blue }

  (

  ( 255, 176, 104, 176, 255, 255, 255, 255),
  ( 176, 104,   1, 104, 176, 255, 255, 255),
  ( 104,   1,  32,   1, 104, 255, 255, 255),
  ( 176, 104,   1, 104, 176, 255, 255, 255),
  ( 255, 176, 104, 176, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255)

  ),


 { Ball - Purple }

  (

  ( 255, 180, 108, 180, 255, 255, 255, 255),
  ( 180, 108,   5, 108, 180, 255, 255, 255),
  ( 108,   5,  36,   5, 108, 255, 255, 255),
  ( 180, 108,   5, 108, 180, 255, 255, 255),
  ( 255, 180, 108, 180, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255)

  ),


 { Ball - Fire }

  (

  ( 255,  40,  41,  40, 255, 255, 255, 255),
  (  40,  41,  42,  41,  40, 255, 255, 255),
  (  41,  42,  43,  42,  41, 255, 255, 255),
  (  40,  41,  42,  41,  40, 255, 255, 255),
  ( 255,  40,  41,  40, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255)

  ),


 { Ball - Ice }

  (

  ( 255,  79,  78,  79, 255, 255, 255, 255),
  (  79,  78,  77,  78,  79, 255, 255, 255),
  (  78,  77,  76,  77,  78, 255, 255, 255),
  (  79,  78,  77,  78,  79, 255, 255, 255),
  ( 255,  79,  78,  79, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255)

  ),


 { Paddle I }

  (

  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255,  32,  32,  32,  32,  24,  24),
  ( 255,   1,   1,   1,   1,   1,  22,  22),
  ( 255, 104, 104, 104, 104, 104,  20,  20),
  ( 255, 255, 176, 176, 176, 176,  18,  18),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255)

  ),


 { Paddle II }

  (

  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  (  24,  24,  24,  24,  24,  24,  24,  24),
  (  22,  22,  22,  22,  22,  22,  22,  22),
  (  20,  20,  20,  20,  20,  20,  20,  20),
  (  18,  18,  18,  18,  18,  18,  18,  18),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255)

  ),


 { Paddle III }

  (

  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  (  24,  24,  24,  24,  24,  24,  24,  24),
  (  22,  22,  22,  22,  22,  22,  22,  22),
  (  20,  20,  20,  20,  20,  20,  20,  20),
  (  18,  18,  18,  18,  18,  18,  18,  18),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255)

  ),


 { Paddle IV }

  (

  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  (  24,  24,  32,  32,  32,  32, 255, 255),
  (  22,  22,   1,   1,   1,   1,   1, 255),
  (  20,  20, 104, 104, 104, 104, 104, 255),
  (  18,  18, 176, 176, 176, 176, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255)

  ),


 { Sparkle Tile - Color  17 }

  (

  (  17,  17,  17,  17,  17,  17,  17,  17),
  (  17,  17,  17,  17,  17,  17,  17,  17),
  (  17,  17,  17,  17,  17,  17,  17,  17),
  (  17,  17,  17,  17,  17,  17,  17,  17),
  (  17,  17,  17,  17,  17,  17,  17,  17),
  (  17,  17,  17,  17,  17,  17,  17,  17),
  (  17,  17,  17,  17,  17,  17,  17,  17),
  (  17,  17,  17,  17,  17,  17,  17,  17)

  ),


 { Sparkle Tile - Color  18 }

  (

  (  18,  18,  18,  18,  18,  18,  18,  18),
  (  18,  18,  18,  18,  18,  18,  18,  18),
  (  18,  18,  18,  18,  18,  18,  18,  18),
  (  18,  18,  18,  18,  18,  18,  18,  18),
  (  18,  18,  18,  18,  18,  18,  18,  18),
  (  18,  18,  18,  18,  18,  18,  18,  18),
  (  18,  18,  18,  18,  18,  18,  18,  18),
  (  18,  18,  18,  18,  18,  18,  18,  18)

  ),


 { Sparkle Tile - Color  19 }

  (

  (  19,  19,  19,  19,  19,  19,  19,  19),
  (  19,  19,  19,  19,  19,  19,  19,  19),
  (  19,  19,  19,  19,  19,  19,  19,  19),
  (  19,  19,  19,  19,  19,  19,  19,  19),
  (  19,  19,  19,  19,  19,  19,  19,  19),
  (  19,  19,  19,  19,  19,  19,  19,  19),
  (  19,  19,  19,  19,  19,  19,  19,  19),
  (  19,  19,  19,  19,  19,  19,  19,  19)

  ),


 { Sparkle Tile - Color  20 }

  (

  (  20,  20,  20,  20,  20,  20,  20,  20),
  (  20,  20,  20,  20,  20,  20,  20,  20),
  (  20,  20,  20,  20,  20,  20,  20,  20),
  (  20,  20,  20,  20,  20,  20,  20,  20),
  (  20,  20,  20,  20,  20,  20,  20,  20),
  (  20,  20,  20,  20,  20,  20,  20,  20),
  (  20,  20,  20,  20,  20,  20,  20,  20),
  (  20,  20,  20,  20,  20,  20,  20,  20)

  ),


 { Sparkle Tile - Color  21 }

  (

  (  21,  21,  21,  21,  21,  21,  21,  21),
  (  21,  21,  21,  21,  21,  21,  21,  21),
  (  21,  21,  21,  21,  21,  21,  21,  21),
  (  21,  21,  21,  21,  21,  21,  21,  21),
  (  21,  21,  21,  21,  21,  21,  21,  21),
  (  21,  21,  21,  21,  21,  21,  21,  21),
  (  21,  21,  21,  21,  21,  21,  21,  21),
  (  21,  21,  21,  21,  21,  21,  21,  21)

  ),


 { Sparkle Tile - Color  22 }

  (

  (  22,  22,  22,  22,  22,  22,  22,  22),
  (  22,  22,  22,  22,  22,  22,  22,  22),
  (  22,  22,  22,  22,  22,  22,  22,  22),
  (  22,  22,  22,  22,  22,  22,  22,  22),
  (  22,  22,  22,  22,  22,  22,  22,  22),
  (  22,  22,  22,  22,  22,  22,  22,  22),
  (  22,  22,  22,  22,  22,  22,  22,  22),
  (  22,  22,  22,  22,  22,  22,  22,  22)

  ),


 { Sparkle Tile - Color  23 }

  (

  (  23,  23,  23,  23,  23,  23,  23,  23),
  (  23,  23,  23,  23,  23,  23,  23,  23),
  (  23,  23,  23,  23,  23,  23,  23,  23),
  (  23,  23,  23,  23,  23,  23,  23,  23),
  (  23,  23,  23,  23,  23,  23,  23,  23),
  (  23,  23,  23,  23,  23,  23,  23,  23),
  (  23,  23,  23,  23,  23,  23,  23,  23),
  (  23,  23,  23,  23,  23,  23,  23,  23)

  ),


 { Sparkle Tile - Color  24 }

  (

  (  24,  24,  24,  24,  24,  24,  24,  24),
  (  24,  24,  24,  24,  24,  24,  24,  24),
  (  24,  24,  24,  24,  24,  24,  24,  24),
  (  24,  24,  24,  24,  24,  24,  24,  24),
  (  24,  24,  24,  24,  24,  24,  24,  24),
  (  24,  24,  24,  24,  24,  24,  24,  24),
  (  24,  24,  24,  24,  24,  24,  24,  24),
  (  24,  24,  24,  24,  24,  24,  24,  24)

  ),


 { Sparkle Tile - Color  25 }

  (

  (  25,  25,  25,  25,  25,  25,  25,  25),
  (  25,  25,  25,  25,  25,  25,  25,  25),
  (  25,  25,  25,  25,  25,  25,  25,  25),
  (  25,  25,  25,  25,  25,  25,  25,  25),
  (  25,  25,  25,  25,  25,  25,  25,  25),
  (  25,  25,  25,  25,  25,  25,  25,  25),
  (  25,  25,  25,  25,  25,  25,  25,  25),
  (  25,  25,  25,  25,  25,  25,  25,  25)

  ),


 { Sparkle Tile - Color  26 }

  (

  (  26,  26,  26,  26,  26,  26,  26,  26),
  (  26,  26,  26,  26,  26,  26,  26,  26),
  (  26,  26,  26,  26,  26,  26,  26,  26),
  (  26,  26,  26,  26,  26,  26,  26,  26),
  (  26,  26,  26,  26,  26,  26,  26,  26),
  (  26,  26,  26,  26,  26,  26,  26,  26),
  (  26,  26,  26,  26,  26,  26,  26,  26),
  (  26,  26,  26,  26,  26,  26,  26,  26)

  ),


 { Sparkle Tile - Color  27 }

  (

  (  27,  27,  27,  27,  27,  27,  27,  27),
  (  27,  27,  27,  27,  27,  27,  27,  27),
  (  27,  27,  27,  27,  27,  27,  27,  27),
  (  27,  27,  27,  27,  27,  27,  27,  27),
  (  27,  27,  27,  27,  27,  27,  27,  27),
  (  27,  27,  27,  27,  27,  27,  27,  27),
  (  27,  27,  27,  27,  27,  27,  27,  27),
  (  27,  27,  27,  27,  27,  27,  27,  27)

  ),


 { Sparkle Tile - Color  28 }

  (

  (  28,  28,  28,  28,  28,  28,  28,  28),
  (  28,  28,  28,  28,  28,  28,  28,  28),
  (  28,  28,  28,  28,  28,  28,  28,  28),
  (  28,  28,  28,  28,  28,  28,  28,  28),
  (  28,  28,  28,  28,  28,  28,  28,  28),
  (  28,  28,  28,  28,  28,  28,  28,  28),
  (  28,  28,  28,  28,  28,  28,  28,  28),
  (  28,  28,  28,  28,  28,  28,  28,  28)

  ),


 { Sparkle Tile - Color  29 }

  (

  (  29,  29,  29,  29,  29,  29,  29,  29),
  (  29,  29,  29,  29,  29,  29,  29,  29),
  (  29,  29,  29,  29,  29,  29,  29,  29),
  (  29,  29,  29,  29,  29,  29,  29,  29),
  (  29,  29,  29,  29,  29,  29,  29,  29),
  (  29,  29,  29,  29,  29,  29,  29,  29),
  (  29,  29,  29,  29,  29,  29,  29,  29),
  (  29,  29,  29,  29,  29,  29,  29,  29)

  ),


 { Sparkle Tile - Color  30 }

  (

  (  30,  30,  30,  30,  30,  30,  30,  30),
  (  30,  30,  30,  30,  30,  30,  30,  30),
  (  30,  30,  30,  30,  30,  30,  30,  30),
  (  30,  30,  30,  30,  30,  30,  30,  30),
  (  30,  30,  30,  30,  30,  30,  30,  30),
  (  30,  30,  30,  30,  30,  30,  30,  30),
  (  30,  30,  30,  30,  30,  30,  30,  30),
  (  30,  30,  30,  30,  30,  30,  30,  30)

  ),


 { Sparkle Tile - Color  31 }

  (

  (  31,  31,  31,  31,  31,  31,  31,  31),
  (  31,  31,  31,  31,  31,  31,  31,  31),
  (  31,  31,  31,  31,  31,  31,  31,  31),
  (  31,  31,  31,  31,  31,  31,  31,  31),
  (  31,  31,  31,  31,  31,  31,  31,  31),
  (  31,  31,  31,  31,  31,  31,  31,  31),
  (  31,  31,  31,  31,  31,  31,  31,  31),
  (  31,  31,  31,  31,  31,  31,  31,  31)

  ),


 { Logo Piece }

  (

  ( 112, 112,  42,  42,  42,  42,  42,  42),
  ( 112,  42,  42, 255, 255, 255, 255, 255),
  (  42, 255,  42,  42,  42,  42,  42,  42),
  (  42, 255, 255, 112, 112, 112, 112, 112),
  (  42, 255, 255, 112, 112, 112, 112, 112),
  (  42, 255, 255, 112, 112, 112, 112, 112),
  (  42, 255, 255, 112, 112, 112, 112,  41),
  (  42, 255, 255, 112, 112, 112, 112,  41)

  ),


 { Logo Piece }

  (

  (  42,  42,  42, 112,  42, 255, 255, 255),
  ( 255, 255,  42, 112,  42, 255, 255, 255),
  (  42, 112, 112, 112,  42, 255, 255, 255),
  ( 112, 112, 112, 112,  42, 255, 255,  41),
  ( 112, 112, 112, 112,  42, 255, 255,  42),
  ( 112, 112, 112, 112,  42, 255, 255,  42),
  ( 255, 255, 255, 255, 255, 255, 255,  42),
  ( 255, 255, 255, 255, 255, 255, 255,  42)

  ),


 { Logo Piece }

  (

  ( 255, 255,  41,  42,  42,  42,  42,  42),
  ( 255,  42,  42, 255, 255, 255, 255, 255),
  (  42,  41, 255,  41,  42,  42,  42,  42),
  (  41, 255,  41, 112, 112, 112, 112, 112),
  ( 255,  41, 112, 112, 112, 112, 112,  42),
  ( 255,  42, 112, 112, 112, 112, 112,  41),
  ( 255,  42, 112, 112, 112,  41, 255,  41),
  ( 255,  42, 112, 112, 112,  41, 255, 255)

  ),


 { Logo Piece }

  (

  (  42,  41, 255, 255, 255, 255, 255, 255),
  ( 255,  41,  42,  41, 255, 255, 255, 255),
  (  41,  41,  42, 112,  41, 255, 255, 255),
  ( 112, 112, 112, 112, 112, 255, 255, 255),
  (  41, 112, 112, 112, 112,  41, 255, 255),
  ( 255,  41, 112, 112, 112,  42, 255,  41),
  (  41,  42, 112, 112, 112,  42, 255,  41),
  (  42, 112, 112, 112, 112, 112, 255,  41)

  ),


 { Logo Piece }

  (

  ( 255, 255, 255,  41,  42,  42,  42,  42),
  ( 255, 255,  42,  42, 255, 255, 255, 255),
  ( 255,  42,  41, 255, 255,  42,  42,  42),
  (  41,  42, 255,  41, 112, 112, 112,  42),
  (  42, 255, 255, 112, 112, 112, 112,  41),
  (  42, 255,  41, 112, 112, 112, 112,  42),
  (  42, 255,  42, 112, 112, 112,  42, 255),
  (  41, 255,  42, 112, 112, 112,  41, 255)

  ),


 { Logo Piece }

  (

  (  42,  42,  41, 255, 255, 255, 255, 255),
  ( 255, 255, 255,  42,  41, 255, 255, 255),
  (  42,  41, 255,  42, 112,  41, 255, 255),
  ( 112, 112, 112, 112, 112,  42, 255, 255),
  ( 255,  41, 112, 112, 112, 112,  41, 255),
  (  42, 255,  41, 112, 112, 112,  42, 255),
  (  41,  42, 255,  42, 112, 112,  42, 255),
  ( 255,  42,  42, 112, 112, 112,  42, 255)

  ),


 { Logo Piece }

  (

  ( 255, 255, 255, 255, 255, 112,  42,  42),
  ( 255, 255, 255, 255,  41,  42,  42,  41),
  ( 255, 255, 255, 255,  41,  41,  41, 112),
  ( 255, 255, 255, 255,  42, 255,  42,  42),
  ( 255, 255, 255, 255,  42, 255,  42, 112),
  ( 255, 255, 255,  41,  42, 255, 112, 112),
  ( 255, 255, 255,  41,  41,  41, 112, 112),
  ( 255, 255, 255,  42,  41,  41, 112, 112)

  ),


 { Logo Piece }

  (

  (  42,  42,  42,  42, 112, 255, 255, 255),
  (  41,  41,  41,  42, 112,  41, 255, 255),
  ( 112, 112, 112, 112, 112,  42, 255, 255),
  ( 112, 112,  42, 112, 112,  42, 255, 255),
  ( 112, 112,  42, 112, 112, 112, 255, 255),
  ( 112,  42,  42, 112, 112, 112,  41, 255),
  ( 112,  41,  42, 112, 112, 112,  41, 255),
  ( 112,  41,  42, 112, 112, 112,  42, 255)

  ),


 { Logo Piece }

  (

  ( 255, 255, 255,  42,  42,  42,  42,  42),
  ( 255, 255, 255,  42,  42,  41, 255, 255),
  ( 255, 255, 255,  41,  41, 112,  42,  42),
  ( 255, 255, 255,  41, 255,  42,  42, 112),
  ( 255, 255, 255,  41, 255,  42, 112, 112),
  ( 255, 255, 255,  41, 255,  42, 112, 112),
  ( 255, 255, 255,  41, 255,  42,  42, 112),
  ( 255, 255, 255,  41, 255,  42,  42, 112)

  ),


 { Logo Piece }

  (

  (  42,  42,  42,  42,  42,  41, 255, 255),
  ( 255, 255, 255, 255, 255,  41,  42,  41),
  ( 112, 112,  42,  42,  41, 255, 255,  42),
  ( 112, 112, 112, 112, 112,  42,  41, 255),
  ( 112, 112, 112,  42,  41, 112,  42,  42),
  ( 112, 112,  42,  42, 255,  41,  42, 112),
  ( 112,  42, 255,  42, 255, 255,  42, 112),
  ( 112,  42, 255,  42, 255, 255,  42, 112)

  ),


 { Logo Piece }

  (

  ( 255, 255,  41, 112,  42,  42,  42,  42),
  ( 255, 255,  41, 112, 112,  41, 255, 255),
  (  41, 255, 255,  42,  41,  42,  42,  42),
  (  42, 255, 255,  42, 255,  41,  42, 112),
  (  42,  41, 255,  42, 255,  41, 112, 112),
  ( 112,  42, 255,  42, 255,  41, 112, 112),
  ( 112, 112, 255,  42, 255,  41, 112, 112),
  ( 112, 112, 255,  42, 255,  41, 112, 112)

  ),


 { Logo Piece }

  (

  (  42,  42,  42,  42,  42,  42, 112,  41),
  ( 255, 255, 255, 255,  41, 112, 112,  41),
  (  42,  42,  42,  42, 112, 112, 112,  41),
  ( 112, 112, 112, 112, 112, 112, 112,  42),
  ( 112, 112, 112, 112, 112, 112, 112,  42),
  ( 112, 112, 112, 112, 112, 112, 112,  41),
  ( 112, 112, 255, 255, 255, 255, 255, 255),
  ( 112, 112, 255, 255, 255, 255, 255, 255)

  ),


 { Logo Piece }

  (

  (  42, 255, 255, 112, 112, 112, 112,  41),
  (  42, 255, 255, 112, 112, 112, 112,  42),
  (  42, 255, 255, 112, 112, 112,  41,  41),
  (  42, 255, 255, 112, 112, 112,  42, 112),
  (  42, 255, 255,  42,  42, 112, 112, 112),
  (  42,  41, 255,  42, 112, 112, 112, 112),
  (  42,  41, 255, 112, 112, 112, 112,  42),
  (  42,  41, 255, 112, 112, 112, 112,  41)

  ),


 { Logo Piece }

  (

  (  41,  41, 255, 255, 255, 255, 255,  42),
  (  42, 112,  41, 255, 255, 255, 255,  42),
  ( 112, 112,  41, 255, 255, 255, 255,  41),
  ( 112, 112,  41, 255, 255, 255, 255, 255),
  ( 112, 112,  41, 255, 255, 255, 255, 255),
  ( 112, 112,  41, 255, 255, 255, 255, 255),
  (  41,  41, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255,  41,  42)

  ),


 { Logo Piece }

  (

  ( 255,  41, 112, 112,  41,  42,  42,  41),
  ( 255, 255, 112, 112,  41, 255,  41,  42),
  (  41, 255,  41, 112, 112,  42, 255, 255),
  (  42,  41, 112, 112, 112, 112, 112,  41),
  ( 255,  42, 112, 112, 112, 112, 112, 112),
  ( 255, 255,  41, 112, 112, 112, 112, 112),
  ( 255, 255, 255, 255,  41, 112, 112, 112),
  (  42,  42,  42,  42,  41, 255,  41, 112)

  ),


 { Logo Piece }

  (

  ( 255,  41,  41,  41,  41,  41, 255,  41),
  (  42,  41, 255, 255, 255, 255, 255,  41),
  (  41,  42,  42, 255, 255, 255, 255,  41),
  ( 255, 255,  41,  42,  41, 255, 255,  41),
  ( 112,  41, 255,  41,  42, 255, 255,  41),
  ( 112, 112,  42, 255,  41,  42, 255,  41),
  ( 112, 112, 112,  42,  42, 112, 255,  41),
  (  41, 255,  42, 112, 112, 112,  41,  41)

  ),


 { Logo Piece }

  (

  (  41, 255,  42, 112, 112, 112,  41, 255),
  (  41, 255,  42, 112, 112, 112,  41, 255),
  (  41, 255,  42, 112, 112, 112,  41, 255),
  (  41, 255,  42, 112, 112, 112,  41, 255),
  (  41, 255,  42, 112, 112, 112,  41, 255),
  (  41, 255,  42, 112, 112, 112,  41, 255),
  (  41, 255,  42, 112, 112, 112,  41, 255),
  (  41, 255,  42, 112, 112, 112,  41, 255)

  ),


 { Logo Piece }

  (

  ( 255, 112, 112, 112, 112, 112,  42, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255, 255, 255, 255, 255, 255, 255, 255),
  ( 255,  41,  41,  41,  41, 255, 255, 255),
  ( 255, 112,  42,  41,  42, 112,  42, 255),
  ( 255,  42,  42,  41,  41, 112,  42, 255)

  ),


 { Logo Piece }

  (

  ( 255, 255, 255,  42, 255,  42, 112, 112),
  ( 255, 255, 255,  42, 255, 112, 112, 112),
  ( 255, 255,  41,  41,  41, 112, 112, 112),
  ( 255, 255,  42,  41,  41, 112, 112, 112),
  ( 255, 255,  42, 255,  42, 112, 112, 112),
  ( 255, 255,  42, 255, 112, 112, 112,  42),
  ( 255,  41,  42,  41, 112, 112, 112,  42),
  ( 255,  41,  41,  41, 112, 112, 112,  41)

  ),


 { Logo Piece }

  (

  ( 112, 255,  41, 112, 112, 112,  42, 255),
  (  42, 255,  41, 112, 112, 112, 112, 255),
  (  42, 255, 255, 112, 112, 112, 112,  41),
  (  42, 255, 255,  42, 112, 112, 112,  41),
  ( 112, 255, 255,  42, 112, 112, 112,  42),
  (  42, 255, 255,  41, 112, 112, 112,  42),
  (  42,  41, 255,  41, 112, 112, 112, 112),
  (  41,  42,  42,  41, 112, 112, 112, 112)

  ),


 { Logo Piece }

  (

  ( 255, 255,  41,  41, 255,  42,  42, 112),
  ( 255, 255,  41,  41, 255,  42,  42, 112),
  ( 255, 255,  41,  41, 255,  42,  42, 112),
  ( 255, 255,  41,  41, 255,  42,  42, 112),
  ( 255, 255,  41,  41, 255,  42,  41,  42),
  ( 255, 255,  41,  41, 255,  42,  42, 112),
  ( 255, 255,  41,  41, 255,  42,  42, 112),
  (  41, 255,  41,  41, 255,  42, 112, 112)

  ),


 { Logo Piece }

  (

  ( 112,  42, 255,  42, 255, 255,  42, 112),
  ( 112, 112,  42,  42, 255,  41,  42, 112),
  (  42,  41, 255, 255, 255,  42,  42, 112),
  (  42,  42,  42,  42,  42,  42, 112, 112),
  ( 112, 112, 112, 112, 112, 112, 112, 112),
  ( 112, 112, 112, 112, 112, 112, 112,  42),
  ( 112, 112, 112, 112,  42,  42,  41, 255),
  ( 112,  42, 255, 255, 255, 255, 255, 255)

  ),


 { Logo Piece }

  (

  ( 112, 112, 255,  42, 255,  41, 112, 112),
  ( 112,  42, 255,  42, 255,  41, 112, 112),
  ( 112,  42, 255,  42, 255,  41, 112, 112),
  ( 112,  41, 255,  42, 255,  41, 112, 112),
  (  42, 255, 255,  42, 255,  41,  42,  42),
  ( 255, 255, 255,  42, 255,  41,  42, 112),
  ( 255, 255, 255,  42, 255,  41, 112, 112),
  ( 255, 255, 255,  42, 255,  41, 112, 112)

  ),


 { Logo Piece }

  (

  ( 112, 112,  41,  41,  41, 255, 255, 255),
  ( 112,  42,  41,  42, 112, 255, 255, 255),
  (  42,  41,  41, 112, 112, 255, 255, 255),
  ( 112,  42, 112, 112, 112, 255, 255, 255),
  ( 112, 112, 112, 112, 112, 255, 255, 255),
  ( 112, 112, 112, 112, 112, 255, 255, 255),
  ( 112, 112,  42,  41,  41, 255, 255, 255),
  ( 112, 112,  41, 255, 255, 255, 255, 255)

  ),


 { Logo Piece }

  (

  (  41,  41, 255, 112,  42, 112, 112,  42),
  (  41,  41, 255,  42,  42, 112, 112, 112),
  (  41,  41, 255,  42,  42, 112,  42, 255),
  (  41,  41, 255,  42,  42,  42,  41, 255),
  (  41,  41, 255,  42,  42,  42,  42, 112),
  (  41,  41,  41, 112, 112, 112, 112, 112),
  (  41, 112, 112, 112, 112, 112, 112, 112),
  (  41,  42,  42,  42,  42,  42,  42,  42)

  ),


 { Logo Piece }

  (

  ( 255, 255, 255, 255, 255, 255,  41,  42),
  (  42,  42,  42,  42,  42, 255,  41,  41),
  ( 255, 255, 255,  41, 112, 255, 255,  41),
  ( 255, 255,  41, 112, 112,  41, 255,  42),
  ( 112, 112, 112, 112, 112,  41, 255,  41),
  ( 112, 112, 112, 112, 112,  41, 255, 255),
  ( 112, 112, 112, 112, 112,  41, 255, 255),
  (  42,  42,  42,  42,  42,  41, 255, 255)

  ),


 { Logo Piece }

  (

  (  41, 255,  41,  42,  41, 255, 255,  42),
  (  42,  41,  42, 112,  42,  41,  41, 112),
  ( 255, 112, 112, 112, 112,  42,  42,  41),
  ( 255,  41, 112, 112,  42, 255, 255, 255),
  (  41, 255,  42, 112, 112,  42,  42, 112),
  (  42,  41,  42, 112, 112, 112, 112, 112),
  ( 255,  41,  42, 112, 112, 112, 112, 112),
  ( 255, 255, 255,  41,  41,  42,  42,  42)

  ),


 { Logo Piece }

  (

  (  41, 255,  42, 112, 112, 112,  41,  41),
  (  41, 255, 112, 112, 112, 112,  41,  41),
  ( 255,  41, 112, 112, 112, 112,  41, 255),
  (  41, 112, 112, 112, 112, 112, 255, 255),
  ( 112, 112, 112, 112, 112,  41, 255, 255),
  ( 112, 112, 112, 112,  42, 255, 255, 255),
  ( 112, 112, 112,  41, 255, 255, 255, 255),
  (  42,  41, 255, 255, 255, 255, 255, 255)

  ),


 { Logo Piece }

  (

  (  41, 255,  42, 112, 112, 112,  41, 255),
  (  41, 255,  42, 112, 112, 112,  42,  41),
  (  42, 255,  41, 112, 112, 112, 255, 255),
  (  42, 255, 255, 112, 112,  42,  41,  41),
  (  41,  42, 255,  41,  42, 112, 112, 112),
  ( 255,  42,  42, 255,  42, 112, 112, 112),
  ( 255, 255,  41,  42, 112, 112, 112, 112),
  ( 255, 255, 255, 255,  41,  41,  42,  42)

  ),


 { Logo Piece }

  (

  (  41,  41, 255, 112, 112, 112,  42, 255),
  (  41, 255,  41, 112, 112, 112,  41, 255),
  ( 255, 255,  42,  42, 112, 112,  41, 255),
  (  41,  42,  42, 112, 112, 112, 255, 255),
  ( 112, 112, 112, 112, 112,  42, 255, 255),
  ( 112, 112, 112, 112,  42, 255, 255, 255),
  ( 112, 112, 112,  42, 255, 255, 255, 255),
  (  42,  41,  41, 255, 255, 255, 255, 255)

  ),


 { Logo Piece }

  (

  ( 255,  42, 255,  42, 112, 112,  42,  41),
  ( 255,  42, 255,  42,  42, 112, 112, 112),
  (  41,  42, 255, 112, 112, 112, 112, 112),
  (  41,  41,  41, 112, 112, 112, 112,  42),
  (  42,  41,  42, 112, 112, 112,  41, 255),
  (  42,  41, 112, 112, 112, 112, 255, 255),
  ( 112, 112, 112, 112, 112, 112, 255, 255),
  (  41,  41,  41,  41,  41,  41, 255, 255)

  ),


 { Logo Piece }

  (

  (  41,  42,  42, 112, 112, 112, 112, 112),
  ( 112, 112, 112, 112, 112, 112, 112, 112),
  ( 112, 112, 112, 112,  42, 112, 112, 112),
  (  42, 112,  42, 255,  41, 112, 112, 112),
  ( 255,  41,  42, 255, 255, 112, 112, 112),
  ( 255, 255,  42, 255,  42, 112, 112, 112),
  ( 255, 255,  42,  42, 112, 112, 112, 112),
  ( 255, 255,  41,  41,  42,  42,  42,  42)

  ),


 { Logo Piece }

  (

  (  41, 255,  41,  41, 255,  42, 112, 112),
  (  42, 255,  41,  41, 255,  42, 112, 112),
  (  42, 255,  41,  41, 255,  42, 112, 112),
  ( 112, 255,  41,  41, 255,  42, 112, 112),
  ( 112,  41,  41,  41, 255,  42, 112, 112),
  ( 112,  41,  41,  41,  41, 112, 112, 112),
  ( 112,  42,  41,  42, 112, 112, 112, 112),
  (  42,  41, 255,  42,  42,  42,  42,  42)

  ),


 { Logo Piece }

  (

  ( 112,  42, 255, 255, 255, 255, 255, 255),
  ( 112,  42, 255, 255, 255, 255, 255, 255),
  ( 112,  42, 255, 255, 255, 255, 255, 255),
  ( 112,  42, 255, 255, 255, 255, 255, 255),
  ( 112,  42, 255, 255, 255, 255, 255, 255),
  ( 112,  42, 255, 255, 255, 255, 255, 255),
  ( 112,  42, 255, 255, 255, 255, 255, 255),
  (  42,  41, 255, 255, 255, 255, 255, 255)

  ),


 { Logo Piece }

  (

  ( 255, 255, 255,  42, 255,  41, 112, 112),
  ( 255, 255, 255,  42, 255, 255, 112, 112),
  ( 255, 255, 255,  42, 255, 255, 112, 112),
  ( 255, 255, 255,  42, 255, 255, 112, 112),
  ( 255, 255, 255,  42, 255, 255, 112,  42),
  ( 255, 255, 255,  42,  41,  42, 112, 112),
  ( 255, 255, 255,  42, 112, 112, 112, 112),
  ( 255, 255, 255,  41,  42,  42,  42,  42)

  ),


 { Logo Piece }

  (

  ( 112, 112,  41, 255, 255, 255, 255, 255),
  ( 112, 112,  42,  42,  42,  42,  42,  42),
  ( 112,  41, 255, 255, 255, 255,  42, 112),
  (  42, 255, 255, 255, 255,  42, 112, 112),
  (  42,  42, 112, 112, 112, 112, 112, 112),
  ( 112, 112, 112, 112, 112, 112, 112, 112),
  ( 112, 112, 112, 112, 112, 112, 112, 112),
  (  42,  42,  42,  42,  42,  42,  42,  42)

  )


  );


implementation

begin
end.
