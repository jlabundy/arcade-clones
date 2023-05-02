program Downfall;       { Downfall                     }
                        { By Jeff LaBundy   06\17\2001 }

uses FONT13H, _KBDHand, Blocks, Dos, Tiledata, Layout;

var

  sumb : array[2..11, 0..18] of shortint;
  stat : array[1..4] of longint;
  x, y, side, ver, request, next, menu, sumx, sumy : shortint;
  xindex, yindex, start, xindex2, yindex2, sum : integer;
  lines, score : longint;
  DBuffer    : Pointer;
  Vaddr      : Word;


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
End;


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


Procedure Plot(px, py : integer; dot: byte);
  begin
  if (px >= 0) and (px <= 319) and (py >= 0) and (py <= 199) then
  mem[Vaddr:(py * 320) + px] := dot;
  end;


Function Pick(px, py: integer) : byte;
  begin
  Pick := mem[Vaddr:(py * 320) + px]
  end;


Procedure Spell (SpellX, SpellY : integer; hue : byte; fade : shortint; txt : string);
  var SLIndex, SXIndex, SYIndex : shortint;
  begin
  for SLIndex := 1 to length(txt) do
  begin
    for SYIndex := 1 to 5 do for SXIndex := 1 to 3 do if Font[ord(upcase(txt[SLIndex])), SYIndex, SXIndex] = 1
    then Plot ((SpellX + (SXIndex - 1)), (SpellY + (SYIndex - 1)), hue);
    SpellX := SpellX + 5;
    hue := hue + fade;
  end;
  end;



function check(cb, cd, cx, cy : shortint) : shortint;
  var xi, yi, n : shortint;
  begin

   n := 0;
   for xi := 0 to 3 do for yi := 0 to 3 do
   if (grid[cx + xi, cy + yi] <> 0) then
   if (block[cb, cd, xi, yi] <> -1) then inc(n);
   check := n;

  end;



function seconds : integer;
  var h, m, s, hund : Word;
  begin

   GetTime(h,m,s,hund);
   seconds := trunc(s);

  end;



function strng(i: longint): string;
  var s : string;
  begin
   Str(i, s);
   strng := s;
  end;



procedure clear;
  var xi, yi, xi2, yi2, n, extra : shortint;
  begin

   for yi := 18 downto 1 do begin


    extra := 0;
    n := 0;
    for xi := 2 to 11 do if (grid[xi, yi] <> 0) then inc(n);


    if (n = 10) then begin
    repeat

     for yi2 := yi downto 1 do
     for xi2 := 2 to 11 do grid[xi2, yi2] := grid[xi2, yi2 - 1];
     for xi2 := 2 to 11 do grid[xi2, 0] := 0;
     n := 0;
     for xi := 2 to 11 do if (grid[xi, yi] <> 0) then inc(n);
     inc(extra);
    until (n <> 10);
    end;
    lines := lines + extra;

    case extra of
    1: score := score + 100;
    2: score := score + 250;
    3: score := score + 500;
    4: score := score + 1000;
    end;

    inc(stat[extra]);

   end;

  end;



procedure resetvar;
  begin
   for yindex := 1 to 4 do stat[yindex] := 0;
   score := 0;
   lines := 0;
   x := 6;
   y := 0;
   ver := random(7) + 1;
   next := random(7) + 1;
   side := 1;
   start := seconds;
  end;



begin

  Randomize;
  GetMem (DBuffer,64000);
  Vaddr := seg(DBuffer^);
  SetMCGA;
  Cls($a000,0);
  Cls(Vaddr,0);
  InitKBDHandler;

  hazard := 0;
  menu := 1;
  resetvar;
  refresh;

  while TRUE do begin

{----------------------------------------------------------------------------}

  {Falling}

    if (start <> seconds) and (menu < 2) then begin
     start := seconds;
     if (check(ver, side, x, y + 1) = 0) then inc(y) else begin
      if (menu = 0) then
      for xindex := 0 to 3 do for yindex := 0 to 3 do
      if (block[ver, side, xindex, yindex] <> -1) then grid[xindex + x, yindex + y] := block[ver, side, xindex, yindex];
      clear;
      ver := next;
      side := 1;
      next := random(7) + 1;
      x := 6;
      y := 0;
      if (check(ver, side, x, y) <> 0) then begin
       for xindex := 0 to 3 do for yindex := 0 to 3 do
       if (block[ver, side, xindex, yindex] <> -1) then grid[xindex + x, yindex + y] := block[ver, side, xindex, yindex];
       for xindex := 2 to 11 do for yindex := 0 to 18 do sumb[xindex, yindex] := 0;
       menu := 3;
       continue;
      end;
     end;
    end else if (key[kDARROW] = 1) and (menu = 0) then begin
     if (check(ver, side, x, y + 1) = 0) then inc(y) else begin
      repeat until (key[kDARROW] = 0);
      for xindex := 0 to 3 do for yindex := 0 to 3 do
      if (block[ver, side, xindex, yindex] <> -1) then grid[xindex + x, yindex + y] := block[ver, side, xindex, yindex];
      clear;
      ver := next;
      side := 1;
      next := random(7) + 1;
      x := 6;
      y := 0;
      if (check(ver, side, x, y) <> 0) then begin
       for xindex := 0 to 3 do for yindex := 0 to 3 do
       if (block[ver, side, xindex, yindex] <> -1) then grid[xindex + x, yindex + y] := block[ver, side, xindex, yindex];
       for xindex := 2 to 11 do for yindex := 0 to 18 do sumb[xindex, yindex] := 0;
       menu := 3;
       continue;
      end;
     end;
    end;

{----------------------------------------------------------------------------}

  {Changing Sides}

   if (key[kUARROW] = 1) and (menu = 0) then begin
    repeat until (key[kUARROW] = 0);
    request := side + 1;
    if (request > 4) then request := 1;
    if (check(ver, request, x, y) = 0) then inc(side);
    if (side > 4) then side := 1;
   end;

{----------------------------------------------------------------------------}

  {Move Left}

   if (key[kLARROW] = 1) and (menu = 0) then begin
    repeat until (key[kLARROW] = 0);
    if (check(ver, side, x - 1, y) = 0) then dec(x);
   end;

{----------------------------------------------------------------------------}

  {Move Right}

   if (key[kRARROW] = 1) and (menu = 0) then begin
    repeat until (key[kRARROW] = 0);
    if (check(ver, side, x + 1, y) = 0) then inc(x);
   end;

{----------------------------------------------------------------------------}

  {Spacebar Options}

   if (key[kSPACE] = 1) and (menu <> 0) then begin

    repeat until (key[kSPACE] = 0);
    case menu of
    1: begin
        menu := 0;
        refresh;
        resetvar;
       end;
    2: menu := 0;
    3: begin
        menu := 1;
        refresh;
        resetvar;
       end;
    end;
    continue;

   end;

  {Hazard Options}

   if (key[kKEYPADPLUS] = 1) and (menu = 1) then begin

    repeat until (key[kKEYPADPLUS] = 0);
    inc(hazard);
    if (hazard > 12) then hazard := 12;
    refresh;
    resetvar;

   end;

   if (key[kKEYPADMINUS] = 1) and (menu = 1) then begin

    repeat until (key[kKEYPADMINUS] = 0);
    dec(hazard);
    if (hazard < 0) then hazard := 0;
    refresh;
    resetvar;

   end;

  {Escape Options}

   if (key[kESC] = 1) and (menu < 2) then begin

    repeat until (key[kESC] = 0);
    case menu of
    0: begin
       refresh;
       resetvar;
       menu := 1;
       end;

    1: begin
       CloseKBDHandler;
       SetText;
       halt;
       end;
    end;
    continue;

   end;

  {Pause}

   if (key[kP] = 1) and (menu = 0) then begin

    repeat until (key[kP] = 0);
    menu := 2;
    continue;

   end;

{----------------------------------------------------------------------------}

  {Score Limit}

   if (score > 2000000000) then score := 2000000000;
   if (lines > 2000000000) then lines := 2000000000;
   for yindex := 1 to 4 do
   if (stat[yindex] > 2000000000) then stat[yindex] := 2000000000;

  {Draw Background}

   for xindex := 0 to 31 do for yindex := 0 to 19 do
   for xindex2 := 0 to 9 do for yindex2 := 0 to 9 do
   Plot (xindex * 10 + xindex2, yindex * 10 + yindex2, tile[grid[xindex, yindex], xindex2, yindex2]);

  {Draw Currently Falling Block}

   if (menu <> 3) then
   for xindex := 0 to 3 do for yindex := 0 to 3 do
   for xindex2 := 0 to 9 do for yindex2 := 0 to 9 do
   if (block[ver, side, xindex, yindex] <> -1) then
   Plot (x * 10 + xindex * 10 + xindex2, y * 10 + yindex * 10 + yindex2,
   tile[block[ver, side, xindex, yindex], xindex2, yindex2]);

  {Draw Waiting Block}

   if (menu = 0) then
   for xindex := 0 to 3 do for yindex := 0 to 3 do
   for xindex2 := 0 to 9 do for yindex2 := 0 to 9 do
   if (block[next, 1, xindex, yindex] <> -1) then
   Plot (240 + xindex * 10 + xindex2, 120 + yindex * 10 + yindex2,
   tile[block[next, 1, xindex, yindex], xindex2, yindex2]);

  {Draw Player Stats}

   if (menu = 0) then begin
    Spell (236, 35, 11, 0, 'Lines:');
    Spell (241, 42, 11, 0, strng(lines));
    Spell (236, 54, 11, 0, 'Score:');
    Spell (241, 61, 11, 0, strng(score));
   end;

  {Draw Title Screen}

   if (menu = 1) then begin

    for yindex := 4 to 9 do Spell (25, yindex, yindex + 13, 0, 'Downfall');
    Spell (25, 10, 32, 0, 'D');
    Spell (30, 10, 48, 0, 'o');
    Spell (35, 10, 52, 0, 'w');
    Spell (40, 10, 40, 0, 'n');
    Spell (45, 10, 36, 0, 'f');
    Spell (50, 10, 64, 0, 'a');
    Spell (55, 10, 43, 0, 'l');
    Spell (60, 10,  9, 0, 'l');

    Spell (30, 20, 31, 0, 'By Jeff LaBundy');

    Spell (25, 35, 31, 0, 'Controls');
    Spell (30, 45, 31, 0, 'Left Arrow:');
    Spell (30, 52, 31, 0, 'Move Piece Left');
    Spell (30, 62, 31, 0, 'Right Arrow:');
    Spell (30, 69, 31, 0, 'Move Piece Right');
    Spell (30, 79, 31, 0, 'Down Arrow:');
    Spell (30, 86, 31, 0, 'Fall Faster');
    Spell (30, 96, 31, 0, 'Up Arrow:');
    Spell (30, 103, 31, 0, 'Flip Piece');

    Spell (25, 118, 31, 0, 'Scoring');
    Spell (30, 128, 31, 0, 'Single: 100 pts');
    Spell (30, 135, 31, 0, 'Double: 250 pts');
    Spell (30, 142, 31, 0, 'Triple: 500 pts');
    Spell (30, 149, 31, 0, 'Fallout: 1000 pts');

    Spell (25, 159, 13, 0, '-Use +\- on numpad');
    Spell (25, 166, 13, 0, ' right now to');
    Spell (25, 173, 13, 0, ' change hazard size');

   end;

  {Draw Game Over Screen}

   if (menu = 3) then begin

    sum := 0;
    for xindex := 2 to 11 do for yindex := 0 to 18 do sum := sum + sumb[xindex, yindex];

    if (sum < 190) then begin

     for xindex := 1 to 5 do begin
     repeat
      sumx := random(10) + 2;
      sumy := random(19);
     until (sumb[sumx, sumy] = 0);
     sumb[sumx, sumy] := 1;
     grid[sumx, sumy] := 10;
     end;

    end else begin

     Spell (49, 32, 15, 0, 'Game Over');
     Spell (30, 52, 15, 0, 'Statistics:');
     Spell (35, 62, 15, 0, 'Singles: ' + strng(stat[1]));
     Spell (35, 72, 15, 0, 'Doubles: ' + strng(stat[2]));
     Spell (35, 82, 15, 0, 'Triples: ' + strng(stat[3]));
     Spell (35, 92, 15, 0, 'Fallouts: ' + strng(stat[4]));
     Spell (30, 112, 15, 0, 'Total Lines:');
     Spell (35, 122, 15, 0, strng(lines));
     Spell (30, 142, 15, 0, 'Final Score:');
     Spell (35, 152, 15, 0, strng(score));

    end;

   end;

   if (menu = 2) then Spell (46, 80, 31, 0, '- Paused -');

   if (seconds mod 2 = 0) and (menu <> 0) then Spell (26, 182, 14, 0, 'Press the spacebar');

{----------------------------------------------------------------------------}

  {Blit Buffer}
   WaitBorder;
   FlipScreen(Vaddr,$a000);

{----------------------------------------------------------------------------}


  end;

end.