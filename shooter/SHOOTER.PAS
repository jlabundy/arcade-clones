program spaceshooter;			{ Space Shooter                }
					{ By Jeff LaBundy   08\30\2001 }
uses FONT13H, _KBDHand, SS_DATA, CRT;

var

  DBuffer	: Pointer;
  Vaddr		: Word;

  rock_x,
  rock_y	: array[1..35] of real;
  rock_a	: array[1..35] of integer;
  rock_active	: array[1..35] of shortint;

  shipx, shipy,
  acc           : array[1..2] of real;

  shipa, acc_a	: array[1..2] of integer;

  sound_var,
  currb,
  shiptype,
  shipactive    : array[1..2] of shortint;

  bullet_x,
  bullet_y	: array[1..2, 0..2] of real;
  bullet_inc,
  bullet_a	: array[1..2, 0..2] of integer;
  bullet_active	: array[1..2, 0..2] of shortint;

  sint, cost	: array[0..359] of real;

  score_n,
  score_x,
  score_y,
  score_c,
  score_val,
  score_inc	: array[1..37] of integer;

  explosion_n	: array[1..37] of shortint;
  explosion_x,
  explosion_y	: array[1..37, 0..49] of real;
  explosion_c	: array[1..37, 0..49] of byte;
  explosion_a,
  explosion_inc	: array[1..37, 0..49] of integer;

  offs		: array[1..2, 0..62] of integer;

  star_in,
  star_out	: array[0..249] of byte;
  star_x,
  star_y	: array[0..249] of integer;

  detect,
  xindex,
  yindex,
  nindex,
  nindex2,
  nindex3,
  tempx, tempy	: integer;

  numrocks, lives,
  ident, select	: byte;

  sound_index,
  menu, sounda,
  rand	 	: shortint;

  score, top	: longint;


const pi = 3.141592654;


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

  if (x >= 0) and (x <= 319) and (y >= 0) and (y <= 199) then
  pick := mem[Vaddr:(y * 320) + x] else pick := 0;

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






{--SHIP-CHECK----------------------------------------------------------------}

  function shipcheck(check_x, check_y : real; check_a : integer) : shortint;

  var c_xindex, c_yindex, c_tempx, c_tempy, n : integer;

  begin

  n := 0;

  for c_xindex := -3 to 3 do
  for c_yindex := -4 to 4 do
  if (ship[0, c_yindex, c_xindex] <> 0) then begin

   c_tempx := trunc(check_x + (cost[check_a] * c_xindex - sint[check_a] * c_yindex));
   c_tempy := trunc(check_y + (sint[check_a] * c_xindex + cost[check_a] * c_yindex));

   if (c_tempx > 319) then c_tempx := c_tempx - 320;
   if (c_tempx < 0)   then c_tempx := c_tempx + 320;
   if (c_tempy > 199) then c_tempy := c_tempy - 200;
   if (c_tempy < 0)   then c_tempy := c_tempy + 200;

   if (pick(trunc(c_tempx), trunc(c_tempy)) > 0) then inc(n);

  end; {IF printable}

  if (n <> 0) then shipcheck := 1 else shipcheck := 0;

  end;

{----------------------------------------------------------------------------}






{--SHOOTING-TRIGGER----------------------------------------------------------}

  function shoot (player : shortint) : shortint;

  var n : shortint;

  begin

   n := 0;

   case player of
   1: if (key[kSPACE] = 1)      then n := 1;
   2: if (random(500) < 10) then n := 1;
   end;

   shoot := n;

  end;

{----------------------------------------------------------------------------}






{--EXPLOSION-----------------------------------------------------------------}

  procedure explode(exp_num : byte; set_x, set_y : real; set_c : byte);

  var c_nindex : byte;

  begin

  for c_nindex := 0 to 49 do begin

   explosion_n[exp_num] := 1;
   explosion_inc[exp_num, c_nindex] := 0;
   explosion_x[exp_num, c_nindex] := set_x;
   explosion_y[exp_num, c_nindex] := set_y;;
   explosion_a[exp_num, c_nindex] := random(360);

   case set_c of

   1: explosion_c[exp_num, c_nindex] := expl[random(5)];
   2: explosion_c[exp_num, c_nindex] := expl[random(5) + 5];
   3: explosion_c[exp_num, c_nindex] := expl[random(5) + 10];
   4: explosion_c[exp_num, c_nindex] := expl[shiptype[1] * 6 + 15 + random(6)];
   5: explosion_c[exp_num, c_nindex] := expl[shiptype[2] * 6 + 15 + random(6)];

   end;

  end;

  end;

{----------------------------------------------------------------------------}






{--GENERATE-ROCKS------------------------------------------------------------}

  procedure makerock(rk_num : byte; set_x, set_y : real);

  begin

   rock_active[rk_num] := 1;
   rock_x[rk_num] := set_x;
   rock_y[rk_num] := set_y;
   rock_a[rk_num] := random(360);

  end;

{----------------------------------------------------------------------------}






{--DRAW-ROCKS----------------------------------------------------------------}

  procedure drawrocks (n : byte);

  var c_nindex, c_xindex, c_yindex, c_select : byte;
      c_tempx, c_tempy			     : integer;

  begin

  for c_nindex := 1 to 35 do
  for c_xindex := 0 to 39 do
  for c_yindex := 0 to 39 do
  if (rock_active[c_nindex] = 1) then begin

   if ((c_nindex - 1) mod 7 = 0) then c_select := 0;	{Purple rock}
   if ((c_nindex - 2) mod 7 = 0)
   or ((c_nindex - 3) mod 7 = 0) then c_select := 1;	{Blue rock}
   if ((c_nindex - 4) mod 7 = 0)
   or ((c_nindex - 5) mod 7 = 0)
   or ((c_nindex - 6) mod 7 = 0)
   or ((c_nindex - 7) mod 7 = 0) then c_select := 2;	{Green rock}

   if (rock[c_select, c_yindex, c_xindex] <> 0) then begin

   c_tempx := trunc(rock_x[c_nindex]) + c_xindex;
   c_tempy := trunc(rock_y[c_nindex]) + c_yindex;

   if (c_tempx > 319) then c_tempx := c_tempx - 320;
   if (c_tempx < 0)   then c_tempx := c_tempx + 320;
   if (c_tempy > 199) then c_tempy := c_tempy - 200;
   if (c_tempy < 0)   then c_tempy := c_tempy + 200;

   case n of
   0: plot (c_tempx, c_tempy, c_nindex);
   1: plot (c_tempx, c_tempy, rock[c_select, c_yindex, c_xindex]);
   end;

   end; {IF <> 1}

  end; {IF active}

  end;

{----------------------------------------------------------------------------}






{--INIT-SHIP-----------------------------------------------------------------}

  procedure initship (n : byte);

  var c_nindex : byte;

  begin

  for c_nindex := 0 to 2 do bullet_active[n, c_nindex] := 0;
  shipactive[n] := 0;
  currb[n] := 0;

  case n of

  1: begin

     shipx[1]  := 159;
     shipy[1]  := 99;
     shipa[1]  := 0;
     acc[1]    := 0;
     acc_a[1]  := shipa[1];

     end;

  2: begin

     shipx[2] := 319 * random(2);
     shipy[2] := random(200);
     shipa[2] := 90 + (180 * random(2)) + (random(40) - 20);
     acc[2]   := 1.5;
     acc_a[2] := shipa[2];
     shiptype[2] := random(2) + 1;

     end;

  end;

  end;

{----------------------------------------------------------------------------}






{--ROCK-DEMO-----------------------------------------------------------------}

  procedure rockdemo;

  var c_nindex : byte;

  begin

   for c_nindex := 1 to 35 do rock_active[c_nindex] := 0;

   rock_active[1]  := 1;
   rock_active[9]  := 1;
   rock_active[17] := 1;
   rock_active[32] := 1;
   rock_active[33] := 1;
   rock_active[34] := 1;
   rock_active[35] := 1;

   for c_nindex := 1 to 35 do
   if (rock_active[c_nindex] = 1) then begin

   rock_x[c_nindex] := random(320);
   rock_y[c_nindex] := random(200);
   rock_a[c_nindex] := random(360);

   end;

  end;

{----------------------------------------------------------------------------}






{--CHECK-LEVEL-COMPLETE------------------------------------------------------}

  function complete : shortint;

  var c_nindex, n : byte;

  begin

   n := 0;
   for c_nindex := 1 to 35 do n := n + rock_active[c_nindex];
   if (n = 0) then complete := 1 else complete := 0;

  end;

{----------------------------------------------------------------------------}






{--GENERATE-ROCKS------------------------------------------------------------}

  procedure loadrocks (n : byte);

  var c_nindex : byte;

  begin

  for c_nindex := 1 to 35 do rock_active[c_nindex] := 0;
  for c_nindex := 1 to (n * 7) do begin

   if ((c_nindex - 1) mod 7 = 0) then begin

   rock_active[c_nindex] := 1;
   rock_x[c_nindex] := random(320);
   rock_y[c_nindex] := random(200);
   rock_a[c_nindex] := random(360);

   end;

  end;

  end;

{----------------------------------------------------------------------------}






{----------------------------------------------------------------------------}

 {MENU Legend       }
 {------------------}
 {0 : In-Game       }
 {1 : Title Screen  }
 {2 : Pause         }

  begin

 {Initialize}

  GetMem (DBuffer,64000);
  Vaddr := seg(DBuffer^);
  SetMCGA;
  Cls($a000,0);
  InitKBDHandler;
  Randomize;
  score	 := 0;
  top	 := 0;
  menu   := 1;
  sounda := 1;
  shiptype[1] := 0;
  sound_index := 0;
  for nindex := 1 to 2 do initship(nindex);
  rockdemo;

  for nindex := 1 to 37 do begin

   explosion_n[nindex] := 0;
   score_n[nindex] := 0;

  end;

 {Make tables}

  for nindex := 0 to 359 do begin

   sint[nindex] := sin(nindex * (pi / 180));
   cost[nindex] := cos(nindex * (pi / 180));

  end;

 {Generate stars}

  for nindex := 0 to 249 do begin

   star_x[nindex] := random(318) + 1;
   star_y[nindex] := random(198) + 1;

   star_in[nindex]  := 26 + random(6);
   star_out[nindex] := 18 + random(8);

  end;

{----------------------------------------------------------------------------}

  while (TRUE) do begin

{----------------------------------------------------------------------------}

 {Check level complete}

  if (complete = 1) and (menu = 0) then begin

   for nindex := 1 to 2 do initship(nindex);
   inc(numrocks);
   if (numrocks > 5) then numrocks := 5;
   loadrocks(numrocks);
   score := score + 750;

  end;

 {High Score - MENU ALL}

  if (score > top) then top := score;

 {Sound fluctuation - MENU ALL}

  if (sound_index > 0) then dec(sound_var[sound_index]);
  if (sound_var[sound_index] = 0) then sound_index := 0;

{----------------------------------------------------------------------------}

 {Keyboard input - MENU DEPENDENT}

  case menu of

  0: begin						{MENU 0}

     if (shipactive[1] = 1) then begin

     if (key[kLARROW] = 1) then shipa[1] := shipa[1] - 3;
     if (key[kRARROW] = 1) then shipa[1] := shipa[1] + 3;

     if (key[kUARROW] = 1) then begin

      acc[1]    := acc[1] + 0.02;
      acc_a[1]  := shipa[1];

     end else if (key[kDARROW] = 1) then begin

      acc[1]    := acc[1] - 0.02;
      acc_a[1]  := shipa[1];

     end;

     if (key[kENTER] = 1) then acc[1] := 0;

     if (key[kBACKSPACE] = 1) and (acc[1] < 3) then begin

      acc[1]    := 3;
      acc_a[1]  := shipa[1];

     end;

     end; {IF shipactive}

     if (key[kS] = 1) and (menu = 0) then begin		{Toggle Sound}

      nosound;
      sound_index := 0;
      repeat until (key[kS] = 0);
      sounda := -sounda;

     end;

     if (key[kP] = 1) then begin			{Pause}

      nosound;
      sound_index := 0;
      repeat until (key[kP] = 0);
      menu := 2;
      continue;

     end;
							{Cheats - change ship}
     if (key[kLEFTSHIFT] = 1) and (key[kRIGHTSHIFT] = 1) and (key[k1] = 1) then shiptype[1] := 0;
     if (key[kLEFTSHIFT] = 1) and (key[kRIGHTSHIFT] = 1) and (key[k2] = 1) then shiptype[1] := 1;
     if (key[kLEFTSHIFT] = 1) and (key[kRIGHTSHIFT] = 1) and (key[k3] = 1) then shiptype[1] := 2;

     if (key[kESC] = 1) then begin                      {Abort Mission}

      nosound;
      repeat until (key[kESC] = 0);

      for nindex := 1 to 35 do begin
      if (rock_active[nindex] = 1) then begin

       sound_index  := 2;
       sound_var[2] := 13;
       rock_active[nindex] := 0;

       if ((nindex - 1) mod 7 = 0) then	{blow up purple}
       explode (nindex, rock_x[nindex] + 20, rock_y[nindex] + 20, 1);

       if ((nindex - 2) mod 7 = 0) then	{blow up blue1}
       explode (nindex, rock_x[nindex] + 12, rock_y[nindex] + 12, 2);

       if ((nindex - 3) mod 7 = 0) then	{blow up blue2}
       explode (nindex, rock_x[nindex] + 12, rock_y[nindex] + 12, 2);

       if ((nindex - 4) mod 7 = 0)
       or ((nindex - 5) mod 7 = 0)
       or ((nindex - 6) mod 7 = 0)
       or ((nindex - 7) mod 7 = 0) then	{blow up green}
       explode (nindex, rock_x[nindex] + 8, rock_y[nindex] + 8, 3);

      end; {IF shipactive}
      end; {FOR nindex}
      					{blow up ships}
      for nindex := 1 to 2 do if (shipactive[nindex] = 1) then
      explode (nindex + 35, shipx[nindex], shipy[nindex], nindex + 3);

      for nindex := 1 to 2 do initship(nindex);
      rockdemo;
      menu := 1;
      continue;

     end; {IF ESC}

     end; {CASE menu = 0}

  1: begin						{MENU 1}

     if (key[kSPACE] = 1) then begin			{Start game}

      nosound;
      repeat until (key[kSPACE] = 0);
      numrocks := 1;
      loadrocks(numrocks);
      score := 0;
      lives := 5;
      menu := 0;
      continue;

     end;

     if (key[kESC] = 1) then begin

      nosound;
      repeat until (key[kESC] = 0);
      SetText;
      CloseKBDHandler;
      halt;

     end;

     end; {CASE menu = 1}

  2: begin						{MENU 2}

     if (key[kSPACE] = 1) then begin			{Unpause}

      nosound;
      repeat until (key[kSPACE] = 0);
      menu := 0;
      continue;

     end;

     end; {CASE menu = 2}

  end; {CASE menu}

{----------------------------------------------------------------------------}

 {Ship movement - MENU ALL (actual movement MENU NOT 2) }

  for nindex := 1 to 2 do begin

   if (acc[nindex] > 4)  then acc[nindex] :=  4;
   if (acc[nindex] < -4) then acc[nindex] := -4;

   if (shipa[nindex] > 359) then shipa[nindex] := shipa[nindex] - 360;
   if (shipa[nindex] < 0)   then shipa[nindex] := shipa[nindex] + 360;

   if (acc_a[nindex] > 359) then acc_a[nindex] := acc_a[nindex] - 360;
   if (acc_a[nindex] < 0)   then acc_a[nindex] := acc_a[nindex] + 360;

   if (menu <> 2) and (shipactive[nindex] = 1) then begin
   shipx[nindex] := shipx[nindex] + sint[acc_a[nindex]] * acc[nindex];
   shipy[nindex] := shipy[nindex] - cost[acc_a[nindex]] * acc[nindex];
   end;

   if (shipx[nindex] > 319) then shipx[nindex] := shipx[nindex] - 320;
   if (shipx[nindex] < 0)   then shipx[nindex] := shipx[nindex] + 320;
   if (shipy[nindex] > 199) then shipy[nindex] := shipy[nindex] - 200;
   if (shipy[nindex] < 0)   then shipy[nindex] := shipy[nindex] + 200;

  end; {FOR nindex}

{----------------------------------------------------------------------------}

 {Shoot - MENU 0}

  for nindex := 1 to 2 do
  if (shoot(nindex) = 1) and (bullet_active[nindex, currb[nindex]] = 0) and (menu = 0) and (shipactive[nindex] = 1) then begin

   sound_index  := 1;
   sound_var[1] := 10;
   bullet_active[nindex, currb[nindex]] := 1;

   bullet_x[nindex, currb[nindex]] := shipx[nindex] - sint[shipa[nindex]] * -5;
   bullet_y[nindex, currb[nindex]] := shipy[nindex] + cost[shipa[nindex]] * -5;
   bullet_a[nindex, currb[nindex]] := shipa[nindex];

   bullet_inc[nindex, currb[nindex]] := 0;

   inc(currb[nindex]);
   if (currb[nindex] > 2) then currb[nindex] := 0;

  end;

{----------------------------------------------------------------------------}

 {Move bullets - MENU NOT 2}

  for nindex  := 1 to 2 do
  for nindex2 := 0 to 2 do

  if (bullet_active[nindex, nindex2] = 1) and (menu <> 2) then begin

   bullet_x[nindex, nindex2] := bullet_x[nindex, nindex2] + sint[bullet_a[nindex, nindex2]] * 5;
   bullet_y[nindex, nindex2] := bullet_y[nindex, nindex2] - cost[bullet_a[nindex, nindex2]] * 5;

   if (bullet_x[nindex, nindex2] > 319) then bullet_x[nindex, nindex2] := bullet_x[nindex, nindex2] - 320;
   if (bullet_x[nindex, nindex2] < 0)   then bullet_x[nindex, nindex2] := bullet_x[nindex, nindex2] + 320;
   if (bullet_y[nindex, nindex2] > 199) then bullet_y[nindex, nindex2] := bullet_y[nindex, nindex2] - 200;
   if (bullet_y[nindex, nindex2] < 0)   then bullet_y[nindex, nindex2] := bullet_y[nindex, nindex2] + 200;

   inc(bullet_inc[nindex, nindex2]);

  end;

{----------------------------------------------------------------------------}

 {Kill stray bullets - MENU ALL}

  for nindex  := 1 to 2 do
  for nindex2 := 0 to 2 do
  if (bullet_active[nindex, nindex2] = 1) then
  if (bullet_inc[nindex, nindex2] > 10) then begin

   bullet_active[nindex, nindex2] := 0;
   sound_index := 0;

  end;

{----------------------------------------------------------------------------}

 {Move rocks - MENU NOT 2}

  if (menu <> 2) then begin

  for nindex := 1 to 35 do begin

  if (rock_active[nindex] = 1) then begin

   rock_x[nindex] := rock_x[nindex] + sint[rock_a[nindex]];
   rock_y[nindex] := rock_y[nindex] + cost[rock_a[nindex]];

   if (rock_x[nindex] > 319) then rock_x[nindex] := rock_x[nindex] - 320;
   if (rock_x[nindex] < 0)   then rock_x[nindex] := rock_x[nindex] + 320;
   if (rock_y[nindex] > 199) then rock_y[nindex] := rock_y[nindex] - 200;
   if (rock_y[nindex] < 0)   then rock_y[nindex] := rock_y[nindex] + 200;

  end; {IF active}

  end; {FOR nindex}

  end; {IF menu <> 2}

{----------------------------------------------------------------------------}

 {Explosions - MENU ALL}

  for nindex := 1 to 37 do

  if (explosion_n[nindex] = 1) then

  for nindex2 := 0 to 49 do begin

   explosion_x[nindex, nindex2] := explosion_x[nindex, nindex2] + sint[explosion_a[nindex, nindex2]];
   explosion_y[nindex, nindex2] := explosion_y[nindex, nindex2] + cost[explosion_a[nindex, nindex2]];

   if (explosion_x[nindex, nindex2] > 319) then explosion_x[nindex, nindex2] := explosion_x[nindex, nindex2] - 320;
   if (explosion_x[nindex, nindex2] < 0)   then explosion_x[nindex, nindex2] := explosion_x[nindex, nindex2] + 320;
   if (explosion_y[nindex, nindex2] > 199) then explosion_y[nindex, nindex2] := explosion_y[nindex, nindex2] - 200;
   if (explosion_y[nindex, nindex2] < 0)   then explosion_y[nindex, nindex2] := explosion_y[nindex, nindex2] + 200;

   inc(explosion_inc[nindex, nindex2]);
   if (explosion_inc[nindex, nindex2] > 350) then explosion_n[nindex] := 0;

  end;

 {Points - MENU ALL}

  for nindex := 1 to 37 do
  if (score_n[nindex] = 1) then begin

   inc(score_inc[nindex]);
   if (score_inc[nindex] > 75) then score_n[nindex] := 0;

  end;

{----------------------------------------------------------------------------}

 {Break rocks - MENU ALL}

  Cls(Vaddr,0);
  drawrocks(0);

  for nindex := 1 to 2 do begin

  for nindex2 := 0 to 2 do begin

  ident := pick(trunc(bullet_x[nindex, nindex2]), trunc(bullet_y[nindex, nindex2]));

  if (ident > 0) and (bullet_active[nindex, nindex2] = 1) and (rock_active[ident] = 1) then begin

   bullet_active[nindex, nindex2] := 0;
   sound_index  := 2;
   sound_var[2] := 13;
   rock_active[ident] := 0;

   if (nindex = 1) then begin

    score := score + 100;
    score_inc[ident] := 0;
    score_x[ident] := trunc(rock_x[ident]);
    score_y[ident] := trunc(rock_y[ident]);
    score_c[ident] := random(5) + 40;
    score_n[ident] := 1;
    if (score_x[ident] > 307) then score_x[ident] := 307;
    if (score_y[ident] > 195) then score_y[ident] := 195;

   end;

   if ((ident - 1) mod 7 = 0) then begin
   for nindex3 := 1 to 2 do makerock(ident + nindex3, rock_x[ident] + 8, rock_y[ident] + 8);
   explode (ident, rock_x[ident] + 20, rock_y[ident] + 20, 1);
   score_val[ident] := 100;
   end; {IF purple}

   if ((ident - 2) mod 7 = 0) then begin
   for nindex3 := 2 to 3 do makerock(ident + nindex3, rock_x[ident] + 4, rock_y[ident] + 4);
   if (nindex = 1) then score := score + 150;
   explode (ident, rock_x[ident] + 12, rock_y[ident] + 12, 2);
   score_val[ident] := 250;
   end; {IF blue1}

   if ((ident - 3) mod 7 = 0) then begin
   for nindex3 := 3 to 4 do makerock(ident + nindex3, rock_x[ident] + 4, rock_y[ident] + 4);
   if (nindex = 1) then score := score + 150;
   explode (ident, rock_x[ident] + 12, rock_y[ident] + 12, 2);
   score_val[ident] := 250;
   end; {IF blue2}

   if ((ident - 4) mod 7 = 0)
   or ((ident - 5) mod 7 = 0)
   or ((ident - 6) mod 7 = 0)
   or ((ident - 7) mod 7 = 0)
   then begin
   if (nindex = 1) then score := score + 400;
   explode (ident, rock_x[ident] + 8, rock_y[ident] + 8, 3);
   score_val[ident] := 500;
   end; {IF green}

  end; {IF ident & bullet active}

  end; {FOR nindex2 - bullet cycle}

  end; {FOR nindex  - ship cycle}

{----------------------------------------------------------------------------}

 {Temporarily put final rocks into buffer - MENU ALL}

  Cls(Vaddr,0);
  drawrocks(0);

 {Lay ships over buffer - MENU 0}

  for nindex := 1 to 2 do begin

  if (shipcheck(shipx[nindex], shipy[nindex], shipa[nindex]) = 1) and (shipactive[nindex] = 1) and (menu = 0) then begin

   sound_index  := 2;
   sound_var[2] := 12;
   explode (nindex + 35, shipx[nindex], shipy[nindex], nindex + 3);
   initship(nindex);

   if (nindex = 1) then begin
   if (lives > 0) then dec(lives) else begin
   nosound;
   repeat until (key[kSPACE] = 0);
   initship(2);
   rockdemo;
   menu := 1;
   end;
   end;

  end; {IF hit & menu}

  end; {FOR nindex}

{----------------------------------------------------------------------------}

 {Collision offset arrays - MENU 0}

  if (shipactive[2] = 1) and (menu = 0) then begin

  for nindex := 1 to 2 do begin

  for xindex := -3 to 3 do
  for yindex := -4 to 4 do begin

   tempx := trunc(shipx[nindex] + cost[shipa[nindex]] * xindex - sint[shipa[nindex]] * yindex);
   tempy := trunc(shipy[nindex] + sint[shipa[nindex]] * xindex + cost[shipa[nindex]] * yindex);

   if (tempx > 319) then tempx := tempx - 320;
   if (tempx < 0)   then tempx := tempx + 320;
   if (tempy > 199) then tempy := tempy - 200;
   if (tempy < 0)   then tempy := tempy + 200;

   if   (ship[0, yindex, xindex] <> 0)
   then offs[nindex, (yindex + 4) * 7 + (xindex + 3)] := tempy * 320 + tempx
   else offs[nindex, (yindex + 4) * 7 + (xindex + 3)] := -1;

  end; {FOR yindex}
  end; {FOR nindex}

 {Detect if ships touch eachother - MENU 0}

  detect := 0;

  for nindex := 0 to 62 do

  for nindex2 := 0 to 62 do
  if (offs[2, nindex2] <> -1) then
  if (offs[2, nindex2] = offs[1, nindex]) then inc(detect);

  if (detect <> 0) then begin

   sound_index  := 2;
   sound_var[2] := 12;

   for nindex := 1 to 2 do begin
   explode (nindex + 35, shipx[nindex], shipy[nindex], nindex + 3);
   initship(nindex);
   end; {FOR nindex}

   if (lives > 0) then dec(lives) else begin
   nosound;
   repeat until (key[kSPACE] = 0);
   rockdemo;
   menu := 1;
   continue;
   end;

  end; {IF detect}

  end; {IF shipactive & menu}

{----------------------------------------------------------------------------}

 {Detect if ship shoots UFO - MENU 0}

  if (shipactive[1] = 1) and (shipactive[2] = 1) and (menu = 0) then begin

   for nindex  := 0 to 2 do
   for nindex2 := 0 to 62 do
   if  (bullet_active[1, nindex] = 1)
   and (offs[2, nindex2] = trunc(bullet_y[1, nindex]) * 320 + trunc(bullet_x[1, nindex])) then begin

   bullet_active[1, nindex] := 0;
   score_val[37] := 800;
   score_inc[37] := 0;
   score_x[37] := trunc(shipx[2]);
   score_y[37] := trunc(shipy[2]);
   score_c[37] := random(5) + 40;
   score_n[37] := 1;
   if (score_x[37] > 307) then score_x[37] := 307;
   if (score_y[37] > 195) then score_y[37] := 195;

   explode (37, shipx[2], shipy[2], 5);
   initship(2);
   score := score + 800;

   end; {IF hit}

  end; {IF shipactive & menu}

 {Detect if UFO shoots ship - MENU 0}

  if (shipactive[1] = 1) and (shipactive[2] = 1) and (menu = 0) then begin

   for nindex  := 0 to 2 do
   for nindex2 := 0 to 62 do
   if  (bullet_active[2, nindex] = 1)
   and (offs[1, nindex2] = trunc(bullet_y[2, nindex]) * 320 + trunc(bullet_x[2, nindex])) then begin

   bullet_active[2, nindex] := 0;
   explode (36, shipx[1], shipy[1], 4);
   initship(1);

   if (lives > 0) then dec(lives) else begin
   nosound;
   repeat until (key[kSPACE] = 0);
   initship(2);
   rockdemo;
   menu := 1;
   continue;
   end;

   end; {IF hit}

  end; {IF shipactive & menu}

{----------------------------------------------------------------------------}

 {Trigger ships if innactive - MENU 0}

  for nindex := 1 to 2 do

  if (shipcheck(shipx[nindex], shipy[nindex], shipa[nindex]) = 0) and (shipactive[nindex] = 0) and (menu = 0) then begin

   case nindex of

   1: shipactive[1] := 1;
   2: if (random(5000) < 10) then begin
      shipactive[2] := 1;
      sound_index  := 2;
      sound_var[2] := 16;
      end;

   end; {CASE nindex}

  end; {IF ...}

{----------------------------------------------------------------------------}

 {Limit Score}

  if (score > 2000000000) then score := 2000000000;

 {Draw stars - MENU ALL}

  Cls(Vaddr,0);

  for nindex := 0 to 249 do begin

   repeat
   rand := random(3) - 1;
   until (star_in[nindex] + rand >= 26) and (star_in[nindex] + rand <= 31);
   star_in[nindex] := star_in[nindex] + rand;

   repeat
   rand := random(3) - 1;
   until (star_out[nindex] + rand >= 18) and (star_out[nindex] + rand <= 25);
   star_out[nindex] := star_out[nindex] + rand;

   plot (star_x[nindex], star_y[nindex], star_in[nindex]);
   plot (star_x[nindex] - 1, star_y[nindex], star_out[nindex]);
   plot (star_x[nindex] + 1, star_y[nindex], star_out[nindex]);
   plot (star_x[nindex], star_y[nindex] - 1, star_out[nindex]);
   plot (star_x[nindex], star_y[nindex] + 1, star_out[nindex]);

  end;

{----------------------------------------------------------------------------}

 {Draw rocks & explosions - MENU ALL}

  drawrocks(1);

  for nindex := 1 to 37 do
  if (explosion_n[nindex] = 1) then
  for nindex2 := 0 to 49 do
  plot (trunc(explosion_x[nindex, nindex2]), trunc(explosion_y[nindex, nindex2]), explosion_c[nindex, nindex2]);

{----------------------------------------------------------------------------}

 {Draw ship - MENU NOT 1}

  for nindex := 1 to 2 do begin
  if (menu <> 1) and (shipactive[nindex] = 1) then begin

  for xindex := -3 to 3 do
  for yindex := -4 to 4 do
  if (ship[0, yindex, xindex] <> 0) then begin

   tempx := trunc(shipx[nindex] + (cost[shipa[nindex]] * xindex - sint[shipa[nindex]] * yindex));
   tempy := trunc(shipy[nindex] + (sint[shipa[nindex]] * xindex + cost[shipa[nindex]] * yindex));

   if (tempx > 319) then tempx := tempx - 320;
   if (tempx < 0)   then tempx := tempx + 320;
   if (tempy > 199) then tempy := tempy - 200;
   if (tempy < 0)   then tempy := tempy + 200;

   plot(trunc(tempx), trunc(tempy), ship[shiptype[nindex], yindex, xindex]);

  end; {IF printable}

  end; {IF menu}
  end; {FOR nindex}

{----------------------------------------------------------------------------}

 {Draw bullets - MENU ALL}

  for nindex  := 1 to 2 do
  for nindex2 := 0 to 2 do
  if (bullet_active[nindex, nindex2] = 1) then
  plot (trunc(bullet_x[nindex, nindex2]), trunc(bullet_y[nindex, nindex2]), 40 + random(5));

 {Points - MENU 0}

  if (menu = 0) then for nindex := 1 to 37 do
  if (score_n[nindex] = 1) then spell (score_x[nindex], score_y[nindex], score_c[nindex], 0, tx(score_val[nindex]));

 {Status Bar - MENU NOT 1}

  case menu of

  0: begin

      spell (0,   0, 32, 1, 'Score: ' + tx(score));
      spell (282, 0, 32, 1, 'Lives: ' + tx(lives));
      if (shipactive[2] = 1) then spell (107, 0, 4 + (random(2) * 36), 0, 'Destroy the attacker!')

     end;

  2: spell (102, 0, 4 + (random(2) * 36), 0, 'Paused - Press Spacebar');

  end; {CASE menu}

{----------------------------------------------------------------------------}

 {Title screen - MENU 1}

  if (menu = 1) then begin

 {High Score}

   spell (159 - trunc((length('High Score: ' + tx(top)) * 5 - 2) / 2), 0, 32, 1, 'High Score: ' + tx(top));

 {Logo}

   for xindex := 0 to 149 do for yindex := 0 to 50 do if (logo[xindex, yindex] > 0) then
   plot (xindex + 5, yindex + 10, logo[xindex, yindex]);
   spell (43, 65, 40, 0, 'By Jeff LaBundy');

 {Ship labels}

   spell (4, 100, 112, 0, 'Your Ship     UFO 1     UFO 2');
   spell (5, 100, 40,  0, 'Your Ship     UFO 1     UFO 2');
   plot (3, 106, 112); plot (73, 106, 112); plot (123, 106, 112);
   for xindex := 4 to 48 do plot (xindex, 106, 40);
   for xindex := 74 to 97 do plot (xindex, 106, 40);
   for xindex := 124 to 148 do plot (xindex, 106, 40);

 {Your ship}

   for xindex := -3 to 3 do
   for yindex := -4 to 4 do
   if (ship[0, yindex, xindex] <> 0) then
   plot (xindex + 26, yindex + 115, ship[0, yindex, xindex]);

 {UFO 1}

   for xindex := -3 to 3 do
   for yindex := -4 to 4 do
   if (ship[0, yindex, xindex] <> 0) then
   plot (xindex + 86, yindex + 115, ship[1, yindex, xindex]);

 {UFO 2}

   for xindex := -3 to 3 do
   for yindex := -4 to 4 do
   if (ship[0, yindex, xindex] <> 0) then
   plot (xindex + 136, yindex + 115, ship[2, yindex, xindex]);

 {Instructions}

   spell (4, 132, 112, 0, 'Use your spaceship to break up');
   spell (4, 141, 112, 0, 'the spacerocks. If a UFO comes');
   spell (4, 150, 112, 0, 'at you, destroy it before it');
   spell (4, 159, 112, 0, 'destroys you!');

   spell (5, 132, 40, 0, 'Use your spaceship to break up');
   spell (5, 141, 40, 0, 'the spacerocks. If a UFO comes');
   spell (5, 150, 40, 0, 'at you, destroy it before it');
   spell (5, 159, 40, 0, 'destroys you!');

   spell (26, 185, 4 + (random(2) * 36), 0, '- Press the spacebar -');

 {Separator}

   for yindex := 11 to 188 do plot (158, yindex, 112);
   for yindex := 10 to 189 do plot (159, yindex, 40);

 {Key listings}

   spell (169, 10, 112, 0, 'Keys'); plot (168, 16, 112);

   spell (174, 22, 112, 0, 'Navigate:          Arrow Keys');
   spell (174, 32, 112, 0, 'Power Boost:       Backspace');
   spell (174, 42, 112, 0, 'Emergency Break:   Enter');
   spell (174, 52, 112, 0, 'Shoot:             Spacebar');
   spell (174, 62, 112, 0, 'Pause:             P Key');
   spell (174, 72, 112, 0, 'Toggle Sound:      S Key');
   spell (174, 82, 112, 0, 'Abort Mission:     ESC');

   spell (170, 10, 40, 0, 'Keys');
   for xindex := 169 to 188 do plot (xindex, 16, 40);

   spell (175, 22,  40, 0, 'Navigate:          Arrow Keys');
   spell (175, 32,  40, 0, 'Power Boost:       Backspace');
   spell (175, 42,  40, 0, 'Emergency Break:   Enter');
   spell (175, 52,  40, 0, 'Shoot:             Spacebar');
   spell (175, 62,  40, 0, 'Pause:             P Key');
   spell (175, 72,  40, 0, 'Toggle Sound:      S Key');
   spell (175, 82,  40, 0, 'Abort Mission:     ESC');

 {Scoring chart}

   spell (169, 100, 112, 0, 'Points'); plot (168, 106, 112);

   spell (174, 112, 112, 0, 'Purple Rock:       100 pts');
   spell (174, 122, 112, 0, 'Blue Rock:         250 pts');
   spell (174, 132, 112, 0, 'Green Rock:        500 pts');
   spell (174, 142, 112, 0, 'Finish Level:      750 pts');
   spell (174, 152, 112, 0, 'Destroy UFO:       800 pts');

   spell (170, 100, 40, 0, 'Points');
   for xindex := 169 to 198 do plot (xindex, 106, 40);

   spell (175, 112, 40, 0, 'Purple Rock:       100 pts');
   spell (175, 122, 40, 0, 'Blue Rock:         250 pts');
   spell (175, 132, 40, 0, 'Green Rock:        500 pts');
   spell (175, 142, 40, 0, 'Finish Level:      750 pts');
   spell (175, 152, 40, 0, 'Destroy UFO:       800 pts');

  {Windowed operation warning}

   spell (169, 178, 112, 0, 'If this is in a window, hit');
   spell (169, 185, 112, 0, 'Alt+Enter to go fullscreen.');

   spell (170, 178, 40, 0, 'If this is in a window, hit');
   spell (170, 185, 40, 0, 'Alt+Enter to go fullscreen.');

  end; {IF menu}

{----------------------------------------------------------------------------}

 {Blit screen - MENU ALL}

  WaitBorder;
  FlipScreen(Vaddr,$a000);

 {Sound effects - MENU ALL}

  if (sound_index > 0) and (sounda = 1) then sound(sound_var[sound_index] * 100) else nosound;

{----------------------------------------------------------------------------}

  end;

  end.