program Jeffman;             { Jeff-Man by Jeff LaBundy, 07\29\2001 }

uses Dos, FONT13H, _KBDHand, JM_DATA, JM_LEVEL;

var

  DBuffer	: Pointer;
  Vaddr		: Word;

  bbuffer	: pointer;
  baddr		: word;

  stop, gnum,
  x_dir, y_dir,
  tempmap,
  currmap,
  starttime,
  ghoststate,
  gxdir, gydir,
  timeleft,
  sdir, menu	: shortint;

  xindex,
  yindex,
  xindex2,
  yindex2,
  blockx, posx,
  blocky, posy,
  spread	: integer;

  score,
  topscore	: longint;

  cheat		: array[0..2] of shortint;
  ghostactive	: array[0..3] of shortint;
  map		: array[0..13, 0..21] of shortint;
  ghost_x,
  ghost_y	: array[0..3] of integer;

  face		: real;


{--13H-ASM-------------------------------------------------------------------}

  Procedure SetMCGA;
  Begin;
   Asm
   mov        ax,0013h
   int        10h
   End;
  End;


  Procedure SetText;
  Begin;
   Asm
   mov        ax,0003h
   int        10h
   End;
  End;

{----------------------------------------------------------------------------}

  Procedure Cls (Where:word;Color : Byte); assembler;
  asm
   push    es
   mov     cx, 32000;
   mov     es,[where]
   xor     di,di
   mov     al,[color]
   mov     ah,al
   rep     stosw
   pop     es
  end;


  Procedure FlipScreen(source,destination:Word); assembler;
  Asm
   push    ds
   mov     ax, [destination]
   mov     es, ax
   mov     ax, [source]
   mov     ds, ax
   xor     si, si
   xor     di, di
   mov     cx, 32000
   rep     movsw
   pop     ds
  End;


  Procedure WaitBorder; assembler;
  label wb1,wb2;
  asm
        MOV DX,3dah
	wb1:    in al,dx
	        test al,8
	        jnz wb1
	wb2:    in al,dx
	        test al,8
	        jz wb2
  end;

{----------------------------------------------------------------------------}






{--PIXEL-PLOTTING------------------------------------------------------------}

  procedure plot(x, y : integer; dot: byte);

  begin

  if (x >= 0) and (x <= 319) and (y >= 0) and (y <= 199) then
  mem[Vaddr:(y * 320) + x] := dot;

  end;


  function pick(x, y: integer) : byte;

  begin

  pick := mem[Vaddr:(y * 320) + x]

  end;

{----------------------------------------------------------------------------}






{--INTEGER-TO-STRING-CONVERSION----------------------------------------------}

  function tx(i: longint): String;

  var s: string;

  begin
   str(i, s);
   tx := s;
  end;

{----------------------------------------------------------------------------}







{--TIMER-COUNTDOWN-----------------------------------------------------------}

  function tick : shortint;

  var h, m, s, hund : Word;

  begin

  GetTime(h,m,s,hund);
  tick := s;

  end;

{----------------------------------------------------------------------------}






{--TEXT-OUTPUT-PROCDURE------------------------------------------------------}

  procedure spell (spell_x, spell_y : integer; hue : byte; fade : shortint; txt : string);

  var sl_index, sx_index, sy_index : shortint;

  begin

  for sl_index := 1 to length(txt) do
  begin
    for sy_index := 1 to 5 do for sx_index := 1 to 3 do if (Font[ord(upcase(txt[sl_index])), sy_index, sx_index] = 1)
    then plot ((spell_x + (sx_index - 1)), (spell_y + (sy_index - 1)), hue);
    spell_x := spell_x + 5;
    hue := hue + fade;
  end;

  end;

{----------------------------------------------------------------------------}





{--VERIFY-JEFFMAN-CAN-MOVE---------------------------------------------------}

  function checkjeff(check_x, check_y : integer) : shortint;

  var n, c_xindex, c_yindex : integer;

  begin

  n := 0;

  for c_xindex := 0 to 14 do for c_yindex := 0 to 14 do

   if (jeff[0, c_xindex, c_yindex] <> 1) then
   if (mem[baddr:(c_yindex + check_y - 8) * 320 + (c_xindex + check_x - 8)] = 104) then inc(n);

   if (n <> 0) then checkjeff := 1 else checkjeff := 0;

  end;

{----------------------------------------------------------------------------}






{--VERIFY-GHOST-CAN-MOVE-----------------------------------------------------}

  function checkghost(check_x, check_y : integer) : shortint;

  var n, c_xindex, c_yindex : integer;

  begin

  n := 0;

  for c_xindex := 0 to 8 do for c_yindex := 0 to 9 do

   if (mem[baddr:(c_yindex + check_y - 4) * 320 + (c_xindex + check_x - 4)] = 104) then inc(n);

   if (n <> 0) then checkghost := 1 else checkghost := 0;

  end;

{----------------------------------------------------------------------------}






{--FACE-RENDERING-PROCEDURE--------------------------------------------------}

  procedure doface;
  begin

  face := face + 0.1;

  if (trunc(face) > 2) then face := 0;

  end;

{----------------------------------------------------------------------------}






{--JEFF-NUMBER-FUNCTION------------------------------------------------------}

  function jnum(jface : shortint) : shortint;

  var n : shortint;

  begin

  if (jface = 0) and (x_dir =  1) and (y_dir =  0) then n := 0;
  if (jface = 1) and (x_dir =  1) and (y_dir =  0) then n := 1;
  if (jface = 2) and (x_dir =  1) and (y_dir =  0) then n := 2;
  if (jface = 0) and (x_dir = -1) and (y_dir =  0) then n := 3;
  if (jface = 1) and (x_dir = -1) and (y_dir =  0) then n := 4;
  if (jface = 2) and (x_dir = -1) and (y_dir =  0) then n := 5;
  if (jface = 0) and (x_dir =  0) and (y_dir = -1) then n := 6;
  if (jface = 1) and (x_dir =  0) and (y_dir = -1) then n := 7;
  if (jface = 2) and (x_dir =  0) and (y_dir = -1) then n := 8;
  if (jface = 0) and (x_dir =  0) and (y_dir =  1) then n := 9;
  if (jface = 1) and (x_dir =  0) and (y_dir =  1) then n := 10;
  if (jface = 2) and (x_dir =  0) and (y_dir =  1) then n := 11;

  if (cheat[0] = 1) then n := 12;

  jnum := n;

  end;

{----------------------------------------------------------------------------}






{--CHECK-LEVEL-COMPLETE------------------------------------------------------}

  function complete : shortint;

  var n, c_xindex, c_yindex : integer;

  begin

   n := 0;

   for c_xindex := 0 to 21 do for c_yindex := 0 to 13 do
   if (map[c_yindex, c_xindex] > 16) then inc(n);

   if (n = 0) then complete := 1 else complete := 0;

  end;

{----------------------------------------------------------------------------}






{--LOAD-LEVEL-PROCEDURE------------------------------------------------------}

  procedure loadlevel(board : shortint);

  var c_xindex, c_xindex2,
      c_yindex, c_yindex2   : integer;

  begin

 {Copy present level to map buffer}

  for c_xindex := 0 to 21 do for c_yindex := 0 to 13 do

    case level[board, c_yindex, c_xindex] of

    0 ..20: map[c_yindex, c_xindex] := level[board, c_yindex, c_xindex];
    21    : map[c_yindex, c_xindex] := random(3) + 17;
    22..25: begin
            ghost_x[level[board, c_yindex, c_xindex] - 22] := c_xindex * 14 + 12;
            ghost_y[level[board, c_yindex, c_xindex] - 22] := c_yindex * 14 + 10;
            map[c_yindex, c_xindex] := 20;
            end;

    26    : begin
            posx  := c_xindex * 14 + 14;
            posy  := c_yindex * 14 + 12;
            x_dir := 0;
            y_dir := -1;
            map[c_yindex, c_xindex] := 16;
            end;

    27    : begin
            posx  := c_xindex * 14 + 14;
            posy  := c_yindex * 14 + 12;
            x_dir := 0;
            y_dir := 1;
            map[c_yindex, c_xindex] := 16;
            end;

    28    : begin
            posx  := c_xindex * 14 + 14;
            posy  := c_yindex * 14 + 12;
            x_dir := -1;
            y_dir := 0;
            map[c_yindex, c_xindex] := 16;
            end;

    29    : begin
            posx  := c_xindex * 14 + 14;
            posy  := c_yindex * 14 + 12;
            x_dir := 1;
            y_dir := 0;
            map[c_yindex, c_xindex] := 16;
            end;

    30    : map[c_yindex, c_xindex] := random(3) + 17;

    end;


 {Copy arena to bound buffer}

  Cls(baddr,0);
  for c_xindex := 0 to 21 do  for c_yindex := 0 to 13 do
  for c_xindex2 := 0 to 13 do for c_yindex2 := 0 to 13 do
  mem[baddr:(c_yindex * 14 + c_xindex2 + 4) * 320 + (c_xindex * 14 + c_yindex2 + 6)] :=
  tile[map[c_yindex, c_xindex], c_xindex2, c_yindex2];


 {Reset variables}

  face       := 1;
  stop       := 1;
  starttime  := tick;
  timeleft   := 0;
  ghoststate := 0;
  for c_yindex := 0 to 3 do ghostactive[c_yindex] := 1;

  end;

{----------------------------------------------------------------------------}






{--DRAW-LOGO-PROCEDURE-------------------------------------------------------}

  procedure drawlogo (x, y : integer; size : real);

  var c_xindex, c_yindex              : integer;
      tex_inc, tex_xindex, tex_yindex : real;

  begin

  tex_yindex := 0; c_yindex := 0;
  tex_inc := 151 / size;
  repeat

    c_xindex := 0; tex_xindex := 0;

    repeat

    plot (c_xindex + x, c_yindex + y, logo[trunc(tex_xindex), trunc(tex_yindex)]);
    tex_xindex := tex_xindex + tex_inc;
    inc(c_xindex);

    until (trunc(tex_xindex) >= 151);

    tex_yindex := tex_yindex + tex_inc;
    inc(c_yindex);

  until (trunc(tex_yindex) >= 32);

  end;


{----------------------------------------------------------------------------}






{----------------------------------------------------------------------------}

  begin

 {Initialize}

  GetMem (DBuffer,64000);
  Vaddr := seg(DBuffer^);

  GetMem (bbuffer,64000);
  baddr := seg(bbuffer^);

  SetMCGA;
  Cls($a000,0);
  InitKBDHandler;
  Randomize;

  score := 0; topscore := 0;
  loadlevel(0); menu := 1;

  for yindex := 0 to 1 do cheat[yindex] := -1;

  repeat

  Cls(Vaddr,0);

{----------------------------------------------------------------------------}

  if (score > topscore) then topscore := score;

  if (tick <> starttime) and (ghoststate > 0) and (menu = 0) then begin

    starttime := tick;
    dec(timeleft);

  end;

  if (timeleft = 0) and (ghoststate > 0) then ghoststate := 0;

  if (menu = 0) and (complete = 1) then begin

    menu := 3;
    spread := 1;
    sdir   := 2;
    score := score + 100;
    if (score > 2000000000) then score := 2000000000;
    continue;

  end;

  if (menu = 3) then begin

    spread := spread + sdir;

    if (spread = 201) then begin
     repeat
     tempmap := random(12) + 1;
     until (tempmap <> currmap);
    currmap := tempmap;
    loadlevel(currmap);
    sdir := -2;
    end;

    if (spread = 1) then begin
    sdir := 2;
    menu := 0;
    continue;
    end;

  end;

{----------------------------------------------------------------------------}

 {Keyboard input}

  case menu of

  0: begin

     if (key[kUARROW] = 1) then begin

        x_dir := 0;
        y_dir := -1;
        stop := 0;

     end else if (key[kDARROW] = 1) then begin

       	x_dir := 0;
        y_dir := 1;
        stop := 0;

     end else if (key[kLARROW] = 1) then begin

       	x_dir := -1;
        y_dir := 0;
        stop := 0;

     end else if (key[kRARROW] = 1) then begin

       	x_dir := 1;
        y_dir := 0;
        stop := 0;

     end;

     if (key[kLEFTSHIFT] = 1) and (key[kENTER] = 1) then begin

      	repeat until (key[kLEFTSHIFT] = 0) and (key[kENTER] = 0);
     	cheat[0] := -cheat[0];

     end;

     if (key[kRIGHTSHIFT] = 1) and (key[kENTER] = 1) then begin

      	repeat until (key[kRIGHTSHIFT] = 0) and (key[kENTER] = 0);
     	cheat[1] := -cheat[1];

     end;

     if (key[kP] = 1) then begin

     	repeat until (key[kP] = 0);
        menu := 2;
        continue;

     end;

     end;

  1: begin

     if (key[kSPACE] = 1) then begin
      repeat until (key[kSPACE] = 0);
      menu := 0;
      currmap := random(12) + 1;
      loadlevel(currmap);
      continue;
     end;

     end;

  2: begin

     if (key[kP] = 1) then begin

     	repeat until (key[kP] = 0);
        menu := 0;
        continue;

     end;

     end;

  end; {CASE menu}

{----------------------------------------------------------------------------}

 {Move Jeff-Man}

  if (menu = 0) then begin

    if (checkjeff(posx + x_dir, posy + y_dir) = 0) then begin

       if (stop = 0) then begin

       posx := posx + x_dir;
       posy := posy + y_dir;

       end;

    end else begin

       if (stop = 0) then begin

       doface;
       stop := 1;

       end;

    end;

  end; {IF menu}

{----------------------------------------------------------------------------}

 {Eat pills}

  if (menu = 0) then begin

    blockx := trunc((posx - 6) / 14);
    blocky := trunc((posy - 4) / 14);

    if (map[blocky, blockx] = 17) then map[blocky, blockx] := random(2) + 18;

    case map[blocky, blockx] of

    18: begin		{Ice Pill}
        ghoststate := 1;
        timeleft   := 5;
        starttime  := tick;
        end;

    19: begin		{Fire Pill}
        ghoststate := 2;
        timeleft   := 7;
        starttime  := tick;
        end;

    end;

    if  (map[blocky, blockx] > 17) then begin

  	map[blocky, blockx] := 16;
        inc(score);
        if (score > 2000000000) then score := 2000000000;

    end;

    if (stop = 0) then doface;

  end; {IF menu}

{----------------------------------------------------------------------------}

 {Figure ghost movement}

   if (menu = 0) then begin

   for yindex := 0 to 3 do begin

   	if (ghost_x[yindex] < posx) then gxdir :=  1;
	if (ghost_x[yindex] = posx) then gxdir :=  0;
   	if (ghost_x[yindex] > posx) then gxdir := -1;

   	if (ghost_y[yindex] < posy) then gydir :=  1;
   	if (ghost_y[yindex] = posy) then gydir :=  0;
   	if (ghost_y[yindex] > posy) then gydir := -1;

   	case ghoststate of

   	1: begin
      	   gxdir := 0;
      	   gydir := 0;
      	   end;

   	2: begin
           gxdir := -gxdir;
      	   gydir := -gydir;
           end;

   	end;


  	case random(2) of

   	0: if (checkghost(ghost_x[yindex] + gxdir, ghost_y[yindex]) = 0) then gydir := 0 else begin
      	   gxdir := 0;
      	   gydir := 0;
      	   end;

   	1: if (checkghost(ghost_x[yindex], ghost_y[yindex] + gydir) = 0) then gxdir := 0 else begin
      	   gxdir := 0;
      	   gydir := 0;
      	   end;

   	end;

        if (ghostactive[yindex] = 0) then begin

         gxdir := 0;
         gydir := 0;

        end;

   	ghost_x[yindex] := ghost_x[yindex] + gxdir;
   	ghost_y[yindex] := ghost_y[yindex] + gydir;

   end; {FOR}

   end; {IF menu}

{----------------------------------------------------------------------------}

 {Confrontation}

  for yindex := 0 to 3 do begin

   if  (blockx = trunc((ghost_x[yindex] - 6) / 14))
   and (blocky = trunc((ghost_y[yindex] - 4) / 14))
   and (menu = 0) and (ghostactive[yindex] = 1) then begin

   case ghoststate of

   0:    begin
         menu := 3;
         spread := 1;
         sdir   := 2;
         score  := 0;
         end;

   1..2: begin
         ghostactive[yindex] := 0;
         score := score + 10;
         if (score > 2000000000) then score := 2000000000;
         end;

   end;

   end;

  end;

{----------------------------------------------------------------------------}

 {Project map onto screen}

  for xindex := 0 to 21 do for yindex := 0 to 13 do
  for xindex2 := 0 to 13 do for yindex2 := 0 to 13 do
  plot (xindex * 14 + yindex2 + 6, yindex * 14 + xindex2 + 4,
  tile[map[yindex, xindex], xindex2, yindex2]);

 {Title Bar}

  case menu of

  0: begin

      spell (1, 1, 41, 0, 'Score: ' + tx(score));
      spell (2, 1, 44, 0, 'Score: ' + tx(score));
      spell (318 - (length('Top Score: ' + tx(topscore)) * 5 - 2), 1, 41, 0, 'Top Score: ' + tx(topscore));
      spell (319 - (length('Top Score: ' + tx(topscore)) * 5 - 2), 1, 44, 0, 'Top Score: ' + tx(topscore));
      spell (140, 1, 126, 0, 'Jeff-Man');
      spell (141, 1, 48,  0, 'Jeff-Man');

     end;

  1: begin

      drawlogo (85, 16, 151);

      spell (55,  65,  31, 0, 'Jeff-Man');
      spell (178, 65,  31, 0, 'The Ghosts');

      if (tick mod 3 <> 0) then spell (105, 78, 32, 0, '- Press the spacebar -')
      else spell (105, 78, 104, 0, '- Press the spacebar -');

      spell (29,  91,  44, 0, 'Keys');

      spell (34,  99,  31, 0, '- Use Arrows to move');
      spell (34,  107, 31, 0, '- Press P to pause\unpause');
      spell (34,  115, 31, 0, '- Press ESC to exit');

      spell (29,  128, 44, 0, 'Points');

      spell (34,  136, 31, 0, '- Eat Pill:     1   pt');
      spell (34,  144, 31, 0, '- Eat Ghost:    10  pts');
      spell (34,  152, 31, 0, '- Finish Level: 100 pts');


      spell (186, 91,  44, 0, 'Pills');

      spell (204, 104, 31, 0, 'Regular Pill');
      spell (205, 110, 27, 0, '-Has no effect');

      spell (204, 118, 31, 0, 'Fire Pill');
      spell (205, 124, 43, 0, '-Lets you eat ghosts');

      spell (204, 132, 31, 0, 'Ice Pill');
      spell (205, 138, 54, 0, '-Freezes ghosts');

      spell (204, 146, 31, 0, 'Surprise Gem');
      spell (205, 152, 48, 0, '-Can be ice or fire');

      spell (85, 172, 44, 0, 'Copyright 2001 by Jeff LaBundy');
      spell (25, 181, 42, 0, 'If this is in a window, hit Alt+Enter to go fullscreen.');

     end;


  2: begin

      spell (1, 1, 41, 0, 'Score: ' + tx(score));
      spell (2, 1, 44, 0, 'Score: ' + tx(score));
      spell (318 - (length('Top Score: ' + tx(topscore)) * 5 - 2), 1, 41, 0, 'Top Score: ' + tx(topscore));
      spell (319 - (length('Top Score: ' + tx(topscore)) * 5 - 2), 1, 44, 0, 'Top Score: ' + tx(topscore));
      spell (134, 1, 126, 0, '- Paused -');
      spell (135, 1, 48,  0, '- Paused -');

     end;

  end; {CASE menu}


 {Ghost state display}

  if (menu = 0) then begin

  case ghoststate of

  1: begin

      spell (89, 195, 54, 0, 'Ghosts are frozen! Eat them!');
      spell (90, 195, 31, 0, 'Ghosts are frozen! Eat them!');

     end;

  2: begin

      spell (99,  195, 40, 0, 'Hurry! Chase the ghosts!');
      spell (100, 195, 43, 0, 'Hurry! Chase the ghosts!');

     end;

  end; {CASE ghoststate}

  end; {IF menu}

 {Draw ghosts}

  gnum := 0;
  if (ghoststate = 1) and (random(5) < timeleft) then gnum := 2;
  if (cheat[1] = 1) then gnum := 1;

  for yindex  := 0 to 3 do
  for xindex2 := 0 to 8 do for yindex2 := 0 to 9 do begin

    case yindex of
    0: xindex := 55;
    1: xindex := 48;
    2: xindex := 62;
    3: xindex := 57;
    end;

    if (ghoststate = 2) and (random(7) < timeleft) then xindex := random(4) + 40;

    if (ghostactive[yindex] = 1) then
    if (ghost[gnum, yindex2, xindex2] <> 1) then
    if (ghost[gnum, yindex2, xindex2] =  2) then
    plot (ghost_x[yindex] + xindex2 - 4, ghost_y[yindex] + yindex2 - 4, xindex) else
    plot (ghost_x[yindex] + xindex2 - 4, ghost_y[yindex] + yindex2 - 4,
    ghost[gnum, yindex2, xindex2]);

  end;

 {Draw Jeff-Man}

  for xindex := 0 to 14 do for yindex := 0 to 14 do
  if (jeff[jnum(trunc(face)), yindex, xindex] <> 1) then
  plot (xindex + posx - 8, yindex + posy - 8,
  jeff[jnum(trunc(face)), yindex, xindex]);

 {Level Transition}

  if (menu = 3) then drawlogo (159 - trunc(spread / 2), 99 - trunc(spread / 151 * 32 / 2), spread);

{----------------------------------------------------------------------------}

 {Blit screen}

  WaitBorder;
  FlipScreen(Vaddr,$a000);

{----------------------------------------------------------------------------}

  until (key[kESC] = 1);
  repeat until (key[kESC] = 0);

  SetText;
  CloseKBDHandler;

  end.