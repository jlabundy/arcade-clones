program Escape;                 { Escape -------------------- }
                                { By Jeff LaBundy  01\06\2002 }

uses FONT13H, MOUSE, _KBDHand, ESC_TILE, ESC_LEVL, DOS, CRT;

var

  DBuffer	        : Pointer;
  Vaddr		        : Word;

  xindex, xindex2,
  yindex, yindex2,
  nindex, nindex2       : integer;

  ball_x, ball_y,
  acc                   : array[0..49] of real;

  ball_active, disp     : array[0..49] of integer;

  speed                 : integer;

  sound_index           : byte;
  sound_time            : word;

  oldtime               : word;

  ball_n, ball_c, tick  : byte;

  layer_c,
  layer_x, layer_y      : array[0..49, 0..4, 0..4] of byte;

  sound_a, lives,
  broken, menu          : shortint;

  pass                  : array[0..92] of shortint;

  x_inc, y_inc          : array[0..49] of real;

  temp_r,
  old_x, old_y          : real;

  x_solve, px, py       : integer;

  map                   : array[0..41, 0..26] of byte;

  temp_c, temp,
  temp_x, temp_y        : integer;

  minleft, secleft,
  minplyd, secplyd      : integer;

  timestring            : string;

  start, hold           : shortint;

  sparkle_n,
  sparkle_x,
  sparkle_y             : array[0..19] of shortint;

  data                  : text;

  best_min,
  best_sec,
  last_mon,
  last_dat,
  last_day,
  last_yr,
  complete              : array[0..24] of word;

  item, acc_index,
  time_index            : shortint;
  curr                  : byte;
  new_time              : shortint;

  lvl_clr               : array[0..24] of byte;

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

  if ((x >= 0) and (x <= 319) and (y >= 0) and (y <= 199) and (dot < 255)) then
  mem[Vaddr:(y * 320) + x] := dot;

  end;


  function pick(x, y: integer) : byte;

  begin

  if ((x >= 0) and (x <= 319) and (y >= 0) and (y <= 199)) then
  pick := mem[Vaddr:(y * 320) + x] else pick := 0;

  end;

{----------------------------------------------------------------------------}






{--INTEGER-TO-STRING-CONVERSION----------------------------------------------}

  function tx(i: longint): string;

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






{--CHECK-BRICK-COLLISION-----------------------------------------------------}

  function hit_tile(num : shortint; pix_x, pix_y : integer) : shortint;

  var c_xindex, c_yindex, n : shortint;
      element_x, element_y  : byte;

  begin

    n := 0;

    pix_x := pix_x + 8;
    pix_y := pix_y + 8;

    for c_xindex := 0 to 4 do
    for c_yindex := 0 to 4 do begin

     element_x := (pix_x + c_xindex) shr 3;
     element_y := (pix_y + c_yindex) shr 3;
     if (pass[map[element_x, element_y]] > 1) then inc(n);

     layer_c[num, c_xindex, c_yindex] := map[element_x, element_y];
     layer_x[num, c_xindex, c_yindex] := element_x;
     layer_y[num, c_xindex, c_yindex] := element_y;

    end;

    hit_tile := n;

  end;

{----------------------------------------------------------------------------}






{--PADDLE-OVER-BRICK---------------------------------------------------------}

  function slide_tile(paddlex, paddley : integer) : integer;

  var c_xindex, c_yindex, n : integer;

  begin

    paddlex := paddlex + 8;
    paddley := paddley + 8;

    n := 0;

    for c_xindex := 0 to 31 do for c_yindex := 0 to 7 do
    if (pass[map[(c_xindex + paddlex) shr 3, (c_yindex + paddley) shr 3]] > 1) then inc(n);

    slide_tile := n;

  end;

{----------------------------------------------------------------------------}






{--CHECK-COLLISION-----------------------------------------------------------}

  function collision(paddlex, paddley, bxcoord, bycoord : integer) : integer;

  var c_xindex, c_yindex, c_xindex2, c_yindex2, p_xcoord, p_ycoord, n : integer;

  begin

    n := 0;

    for c_xindex := 0 to 31 do
    for c_yindex := 0 to 7 do begin

        p_xcoord := paddlex + c_xindex;
        p_ycoord := paddley + c_yindex;

        for c_xindex2 := 0 to 4 do
        for c_yindex2 := 0 to 4 do
        if  ((bxcoord + c_xindex2 = p_xcoord) and (bycoord + c_yindex2 = p_ycoord)) then inc(n);

    end; {FOR c_yindex}

    collision := n;

  end;

{----------------------------------------------------------------------------}






{--RETURN-SECONDS------------------------------------------------------------}

  function sec : word;

  var h, m, s, hund : word;

  begin

   GetTime (h, m, s, hund);
   sec := s;

  end;

{----------------------------------------------------------------------------}






{--SPARKLE-MAP---------------------------------------------------------------}

  procedure sparkle;

  var c_nindex, c_xindex, c_yindex : shortint;

  begin


    for c_nindex := 0 to 19 do
    if (sparkle_n[c_nindex] = 0) then begin

     repeat

      c_xindex := random(40) + 1;
      c_yindex := random(25) + 1;

     until (map[c_xindex, c_yindex] = 0);

     map[c_xindex, c_yindex] := random(15) + 41;

     sparkle_n[c_nindex] := 1;
     sparkle_x[c_nindex] := c_xindex;
     sparkle_y[c_nindex] := c_yindex;

    end; {IF sparkle_n}

  end;

{----------------------------------------------------------------------------}






{--COPY-MAP------------------------------------------------------------------}

  procedure copymap(num : byte);

  var c_xindex, c_yindex : byte;

  begin

    for c_xindex := 0 to 41 do
    for c_yindex := 0 to 26 do

    if (level[num, c_xindex, c_yindex] = 92) then begin

       px := c_xindex shl 3 - 8;
       py := c_yindex shl 3;
       SetMousePosition(px shl 1, py);
       map[c_xindex, c_yindex] := 0;

    end else map[c_xindex, c_yindex] := level[num, c_xindex, c_yindex];

  end;

{----------------------------------------------------------------------------}






{--BOX-----------------------------------------------------------------------}

  procedure box (box_x1, box_y1, box_x2, box_y2 : integer);

  var c_xindex, c_yindex : integer;

  begin

        for c_xindex := box_x1 to box_x2 do plot (c_xindex, box_y1, 30);
        for c_xindex := box_x1+1 to box_x2-1 do plot (c_xindex, box_y1+1, 30);

        for c_yindex := box_y1+1 to box_y2 do plot (box_x1, c_yindex, 28);
        for c_yindex := box_y1+2 to box_y2-1 do plot (box_x1+1, c_yindex, 28);

        for c_yindex := box_y1+1 to box_y2 do plot (box_x2, c_yindex, 23);
        for c_yindex := box_y1+2 to box_y2-1 do plot (box_x2-1, c_yindex, 23);

        for c_xindex := box_x1+1 to box_x2-1 do plot (c_xindex, box_y2, 20);
        for c_xindex := box_x1 to box_x2 do plot (c_xindex, box_y2+1, 20);

        for c_xindex := box_x1+3 to box_x2-3 do plot (c_xindex, box_y2-2, 30);
        for c_xindex := box_x1+2 to box_x2-2 do plot (c_xindex, box_y2-1, 30);

        for c_xindex := box_x1+2 to box_x2-2 do plot (c_xindex, box_y1+2, 20);
        for c_xindex := box_x1+3 to box_x2-3 do plot (c_xindex, box_y1+3, 20);

        for c_yindex := box_y1+2 to box_y2-1 do plot (box_x1+2, c_yindex, 23);
        for c_yindex := box_y1+3 to box_y2-2 do plot (box_x1+3, c_yindex, 23);

        for c_yindex := box_y1+3 to box_y2-2 do plot (box_x2-2, c_yindex, 28);
        for c_yindex := box_y1+4 to box_y2-3 do plot (box_x2-3, c_yindex, 28);

  end;

{----------------------------------------------------------------------------}






{--BALL-INIT-----------------------------------------------------------------}

  procedure initball (num : integer);

  var c_nindex, n : integer;

  begin

       for c_nindex := 0 to num do begin

           n := random(120) + 210;

           x_inc[c_nindex] := cos(n * pi / 180);
           y_inc[c_nindex] := sin(n * pi / 180);

           if (acc_index = 4) then acc[c_nindex] := 1 else acc[c_nindex] := acc_index;
           disp[c_nindex] := 0;

           ball_active[c_nindex] := 1;

       end;

  end;

{----------------------------------------------------------------------------}






{--GENERATE-CLOCK------------------------------------------------------------}

  function clock(min, sec : integer) : string;

  begin

  if (sec<10) then clock := tx(min)+':0'+tx(sec) else clock := tx(min)+':'+tx(sec);

  end;

{----------------------------------------------------------------------------}






{--PROGRESS-(0..25)----------------------------------------------------------}

  function progress : shortint;

  var c_nindex, n : shortint;

  begin

    n := 0;
    for c_nindex := 0 to 24 do n := n + complete[c_nindex];
    progress := n;

  end;

{----------------------------------------------------------------------------}


  begin

 {Load Data File}

  assign (data, 'ESC_DATA.DAT');

  {$I-}

  reset (data);
  for nindex := 0 to 24 do begin

      readln (data, best_sec[nindex]);
      readln (data, best_min[nindex]);
      readln (data, last_mon[nindex]);
      readln (data, last_dat[nindex]);
      readln (data, last_day[nindex]);
      readln (data, last_yr [nindex]);
      readln (data, complete[nindex]);

  end; {FOR nindex}
  close (data);

  {$I+}

  if (IOResult <> 0) then begin

  for nindex := 0 to 24 do begin

      best_sec[nindex] := 0;
      best_min[nindex] := 60;
      last_mon[nindex] := 65535;
      last_dat[nindex] := 65535;
      last_day[nindex] := 65535;
      last_yr [nindex] := 65535;
      complete[nindex] := 0;

  end; {FOR nindex}

  end; {IF IOResult}

 {Initialize}

  GetMem (DBuffer,64000);
  Vaddr := seg(DBuffer^);
  Cls($a000,0);

  SetMCGA;
  InitKBDHandler;
  InitMouse;
  Randomize;

 {Set barriers}

  pass[0] := 0;
  pass[1] := 4;
  pass[2] := 3;
  pass[3] := 3;
  pass[4] := 3;
  for nindex := 5  to 36 do pass[nindex] := 2;
  for nindex := 41 to 55 do pass[nindex] := 1;
  for nindex := 56 to 92 do pass[nindex] := 0;

  {PASS Barrier Key      }
  {----------------------}
  {0: Passable           }
  {1: Sparkle (Passable) }
  {2: Normal Barrier     }
  {3: Break Barrier      }
  {4: Game over Barrier  }

  ball_n      := 0;
  sound_index := 0;
  sound_a     := 1;

  acc_index   := 2;
  time_index  := 0;
  ball_c      := random(7);

  case progress of
  25:  SetMouseArea(0, 0, 0, 47);
  else SetMouseArea(0, 0, 0, 39);
  end; {CASE progress}

  SetMousePosition(0, 0);
  copymap(25);
  menu := 2;

{----------------------------------------------------------------------------}

  {Menu Switching Key}
  {------------------}
  {0 : in-game       }
  {1 : pause         }
  {2 : title screen  }
  {3 : level complete}
  {4 : level select  }

  while TRUE do begin

{----------------------------------------------------------------------------}

  {Check Complete\Check Game Over - MENU 0}

   if (menu = 0) then begin

      temp := 0; for xindex := 0 to 41 do for yindex := 0 to 26 do if (pass[map[xindex, yindex]] = 3) then inc(temp);

      if (temp = 0) then begin

           if ((minplyd * 60 + secplyd) < (best_min[curr] * 60 + best_sec[curr])) then begin

                best_min[curr] := minplyd;
                best_sec[curr] := secplyd;
                new_time       := 1;

           end; {IF new time}

           complete[curr] := 1;

           menu := 3;
           copymap(25);
           continue;

      end; {IF complete}

      temp := 0; for nindex := 0 to ball_n do temp := temp + ball_active[nindex];

      if (temp = 0) then begin

         if (MouseButtons <> 0) then nosound;
         repeat
         ReadMouse;
         until (MouseButtons = 0);

         dec(lives);
         hold := 1;
         initball(ball_n);

      end; {IF loselife}

      if (lives = 0) then begin

         case progress of
         25:  SetMouseArea(0, 0, 0, 47);
         else SetMouseArea(0, 0, 0, 39);
         end; {CASE progress}

         SetMousePosition(0, 0);
         copymap(25);
         menu := 2;
         continue;

      end; {IF gameover}

   end; {IF menu}

  {Timer - MENU 0}

   if ((sec <> oldtime) and (menu = 0) and (hold = 0)) then begin

      if (time_index > 0) then begin {Countdown}

         if (secleft = 0) then begin

         dec(minleft);
         secleft := 59;

         end else dec(secleft);

         if ((minleft = 0) and (secleft = 0)) then begin

            nosound;
            repeat
            ReadMouse;
            until (MouseButtons = 0);

            case progress of
            25:  SetMouseArea(0, 0, 0, 47);
            else SetMouseArea(0, 0, 0, 39);
            end; {CASE progress}

            SetMousePosition(0, 0);
            copymap(25);
            menu := 2;
            continue;

         end; {IF time up}

      end; {IF time_index}

      if (secplyd = 59) then begin   {Countup}

         if (minplyd < 32767) then inc(minplyd);
         secplyd := 0;

      end else inc(secplyd);

      oldtime := sec;

   end; {IF sec}

  {Sparkle - MENU ALL}

   for nindex := 0 to 19 do
   if (sparkle_n[nindex] = 1) then begin

     if   (pass[map[sparkle_x[nindex], sparkle_y[nindex]]] = 1) then begin

          if   (map[sparkle_x[nindex], sparkle_y[nindex]] > 41)
          then dec(map[sparkle_x[nindex], sparkle_y[nindex]])
          else begin

               map[sparkle_x[nindex], sparkle_y[nindex]] := 0;
               sparkle_n[nindex] := 0;

          end; {IF <= 41}

     end else sparkle_n[nindex] := 0;

   end; {IF sparkle_n}

{----------------------------------------------------------------------------}

  {Sound fluctuation - MENU ALL}

   if (sound_index > 0) then begin

    dec(sound_time);
    if (sound_time = 0) then sound_index := 0;

   end; {IF sound_index}

  {Refresh - MENU ALL}

   Cls(Vaddr,0);
   ReadMouse;

{----------------------------------------------------------------------------}

  {Keyboard\Mouse Input - MENU DEPENDENT}

   case menu of

   0: begin

           if ((MouseButtons <> 0) and (hold = 1)) then hold := 0;

           while (px <> MouseX shr 1) do begin

                 if (MouseX shr 1 < px) then temp_x := -1;
                 if (MouseX shr 1 > px) then temp_x := 1;

                 temp := 0;
                 for nindex := 0 to ball_n do temp := temp+collision(px+temp_x,py,trunc(ball_x[nindex]),trunc(ball_y[nindex]));

                 if ((temp = 0) and (slide_tile(px + temp_x, py) = 0)) then px := px + temp_x else begin

                    SetMousePosition(px shl 1, 0);
                    ReadMouse;

                 end; {IF collision}

           end; {WHILE px}

           if (key[kESC] = 1) then begin

              nosound;
              repeat
              ReadMouse;
              until (MouseButtons = 0);
              repeat until (key[kESC] = 0);

              case progress of
              25:  SetMouseArea(0, 0, 0, 47);
              else SetMouseArea(0, 0, 0, 39);
              end; {CASE progress}

              SetMousePosition(0, 0);
              copymap(25);
              menu := 2;
              continue;

           end; {IF kESC}

           if (key[kS] = 1) then begin
           nosound;
           repeat until (key[kS] = 0);
           sound_a := -sound_a;
           end; {IF kS}

           if (key[kP] = 1) then begin
           nosound;
           repeat until (key[kP] = 0);
           menu := 1;
           continue;
           end; {IF kP}

      end; {CASE 0}

   1: begin

           if (key[kSPACE] = 1) then begin
           nosound;
           repeat until (key[kSPACE] = 0);
           menu := 0;
           continue;
           end; {IF kSPACE}

      end; {CASE 1}

   2: begin

        item := mouseY shr 3;

        case progress of
        25:   for nindex := 10 to 16 do map[14, nindex] := 0;
        else  for nindex := 10 to 15 do map[14, nindex] := 0;
        end; {CASE progress}

        map[14, item + 10] := ball_c + 30;

        if (MouseButtons <> 0) then begin

           nosound;

           repeat
           ReadMouse;
           until (MouseButtons = 0);

           case item of

           0: begin
              menu := 4;
              copymap(25);
              SetMouseArea(0, 0, 0, 24);
              SetMousePosition(0, 0);
              continue;
              end; {CASE 0}

           1: begin
              inc(ball_c); if (ball_c > 6) then ball_c := 0;
              end; {CASE 1}

           2: begin
              inc(time_index); if (time_index > 40) then time_index := 0;
              end; {CASE 2}

           3: begin
              inc(acc_index); if (acc_index > 4) then acc_index := 1;
              end; {CASE 3}

           4: begin
              nosound;
              SetText;
              CloseKBDHandler;

              {$I-}

              rewrite (data);
              for nindex := 0 to 24 do begin

                  writeln (data, best_sec[nindex]);
                  writeln (data, best_min[nindex]);
                  writeln (data, last_mon[nindex]);
                  writeln (data, last_dat[nindex]);
                  writeln (data, last_day[nindex]);
                  writeln (data, last_yr [nindex]);
                  writeln (data, complete[nindex]);

              end; {FOR nindex}
              close (data);

              {$I+}

              if (IOResult <> 0) then begin

                 clrscr;
                 writeln ('Error writing data file.');

              end; {IF IOResult}

              halt;
              end; {CASE 4}

           5: begin
              inc(ball_n); if (ball_n > 49) then ball_n := 0;
              end; {CASE 5}

           end; {CASE item}

        end; {IF MouseButtons}

        minleft := time_index shr 1;
        secleft := time_index mod 2 * 30;

      end; {CASE 2}

   3: begin

           if (key[kSPACE] = 1) then begin
           nosound;
           repeat until (key[kSPACE] = 0);
           menu := 2;

           case progress of
           25:  SetMouseArea(0, 0, 0, 47);
           else SetMouseArea(0, 0, 0, 39);
           end; {CASE progress}

           repeat
           ReadMouse;
           until (MouseButtons = 0);

           SetMousePosition(0, 0);
           continue;
           end; {IF kSPACE}

      end; {CASE 3}

   4: begin

           curr := MouseY;

           lvl_clr[curr] := 31;

           if (curr > 0) then for yindex := 0 to (curr - 1) do
           lvl_clr[yindex] := 17 + trunc(yindex / curr * 5);

           if (curr < 24) then for yindex := (curr + 1) to 24 do
           lvl_clr[yindex] := 21 - trunc((yindex - curr - 1) / (25 - curr) * 5);

           if (MouseButtons <> 0) then begin

             nosound;

             repeat
             ReadMouse;
             until (MouseButtons = 0);

             SetMouseArea(0, 0, 639, 0);
             copymap(curr);
             initball(ball_n);
             menu := 0;

             oldtime  := sec;
             minplyd  := 0;
             secplyd  := 0;

             new_time := 0;
             lives    := 5;
             hold     := 1;

             GetDate(last_yr[curr], last_mon[curr], last_dat[curr], last_day[curr]);

             continue;

           end; {IF MouseButtons}

      end; {CASE 4}

   end; {CASE menu}

{----------------------------------------------------------------------------}

  {Ball Movement - MENU 0}

   if (menu = 0) then begin
   if (hold = 1) then begin

      for nindex := 0 to ball_n do begin

          ball_x[nindex] := px + 14;
          ball_y[nindex] := py - 6;

      end; {FOR nindex}

   end else begin

      for nindex := 0 to ball_n do
      if (ball_active[nindex] = 1) then begin

         speed := trunc(acc[nindex] + disp[nindex]);

         for nindex2 := 1 to speed do begin {Acceleration}



             { Test Paddle Hit }
             if (collision(px, py, trunc(ball_x[nindex]+x_inc[nindex]), trunc(ball_y[nindex]+y_inc[nindex])) <> 0) then begin

                sound_index := 1;
                sound_time  := 2;

                temp_r := (ball_x[nindex] + 1 - px) / 30;

                if (temp_r < 0) then temp_r := 0;
                if (temp_r > 1) then temp_r := 1;

                if (y_inc[nindex] >= 0) then x_solve := 210 + trunc(temp_r * 120);
                if (y_inc[nindex] <  0) then x_solve := 150 - trunc(temp_r * 120);

                x_inc[nindex] := cos(x_solve * pi / 180);
                y_inc[nindex] := sin(x_solve * pi / 180);
                disp [nindex] := abs(2 - trunc(temp_r * 4));

                break; {Kill loop, ball moves no more}

             end; {IF Paddle Hit}



             { Test Brick Hit }
             if (hit_tile(nindex,trunc(ball_x[nindex]+x_inc[nindex]),trunc(ball_y[nindex]+y_inc[nindex]))>0) then begin

                if (disp[nindex] > 0) then dec(disp[nindex]);
                if ((acc_index = 4) and (acc[nindex] <= 10)) then acc[nindex] := acc[nindex] + 0.1;

                sound_index := 1;
                sound_time  := 2;

                {Original Hitting Direction}
                old_x := x_inc[nindex];
                old_y := y_inc[nindex];

                {Change X}
                if      (hit_tile(nindex,trunc(ball_x[nindex]-x_inc[nindex]),trunc(ball_y[nindex]+y_inc[nindex]))=0)
                then x_inc[nindex] := -x_inc[nindex]

                {Change Y}
                else if (hit_tile(nindex,trunc(ball_x[nindex]+x_inc[nindex]),trunc(ball_y[nindex]-y_inc[nindex]))=0)
                then y_inc[nindex] := -y_inc[nindex]

                {Change X & Y}
                else if (hit_tile(nindex,trunc(ball_x[nindex]-x_inc[nindex]),trunc(ball_y[nindex]-y_inc[nindex]))=0) then begin

                     x_inc[nindex] := -x_inc[nindex];
                     y_inc[nindex] := -y_inc[nindex];

                end;

                {Break bricks}

                {Buffer Original Hitting Position}
                temp   := hit_tile(nindex, trunc(ball_x[nindex] + old_x), trunc(ball_y[nindex] + old_y));
                broken := 0;

                for xindex := 0 to 4 do
                for yindex := 0 to 4 do begin

                    {Found breakable brick and none broken}
                    if ((pass[layer_c[nindex, xindex, yindex]] = 3) and (broken = 0)) then begin

                       {Erase Brick}
                       map[layer_x[nindex, xindex, yindex], layer_y[nindex, xindex, yindex]] := 0;
                       inc(broken);

                       {Sound Effect}
                       case layer_c[nindex, xindex, yindex] of
                       2: sound_index := 3;
                       3: sound_index := 2;
                       4: sound_index := 2;
                       end;

                       {Long Brick}
                       case layer_c[nindex, xindex, yindex] of
                       3: map[layer_x[nindex, xindex, yindex] + 1, layer_y[nindex, xindex, yindex]] := 0;
                       4: map[layer_x[nindex, xindex, yindex] - 1, layer_y[nindex, xindex, yindex]] := 0;
                       end;

                    end; {IF break}

                    {Found game over brick}
                    if (pass[layer_c[nindex, xindex, yindex]] = 4) then begin

                       ball_active[nindex] := 0;      {Kill ball}
                       if (lives <> 1) then sparkle;  {Sparkle}
                       sound_index := 4;              {Sound Effect}

                    end; {IF escape}

                end; {FOR buffer loop}

                break; {Kill loop, ball moves no more}

             end; {IF Tile Hit}

             {Move Ball}
             ball_x[nindex] := ball_x[nindex] + x_inc[nindex];
             ball_y[nindex] := ball_y[nindex] + y_inc[nindex];

         end; {FOR nindex2 (acceleration loop)}

      end; {IF ball_active}

   end; {IF hold}
   end; {IF menu}

{----------------------------------------------------------------------------}

  {Static - MENU > 1}

   if (menu > 1) then for nindex := 0 to 249 do plot (random(320), random(200), random(6) + 17);

  {Display Level - MENU ALL}

   for xindex  := 1 to 40 do for yindex := 1 to 25 do begin

     temp_x := (xindex - 1) shl 3;
     temp_y := (yindex - 1) shl 3;
     temp_c := map[xindex, yindex];

     for xindex2 := 0 to 7 do for yindex2 := 0 to 7  do
     plot (temp_x + xindex2, temp_y + yindex2, tile[temp_c, yindex2, xindex2]);

   end; {FOR yindex}

  {Display Paddle - MENU 0}

   if (menu = 0) then
   for nindex := 0 to 3 do begin

     temp_x := nindex shl 3 + px;
     temp_c := nindex + 37;

     for xindex := 0 to 7 do
     for yindex := 0 to 7 do
     plot (xindex + temp_x, yindex + py, tile[temp_c, yindex, xindex]);

   end; {FOR nindex}

  {Display Balls - MENU 0}

   temp_c := 30 + ball_c;
   for nindex := 0 to ball_n do
   if (menu = 0) and (ball_active[nindex] = 1) then begin

     temp_x := trunc(ball_x[nindex]);
     temp_y := trunc(ball_y[nindex]);

     for xindex := 0 to 4 do for yindex := 0 to 4 do
     plot (temp_x + xindex, temp_y + yindex, tile[temp_c, yindex, xindex]);

   end; {IF menu & ball_active}

  {Misc}

   case menu of

   0: begin  {MENU 0 - Lives\Game Timer}

        for nindex := 1 to lives do
        for xindex := 0 to 7 do
        for yindex := 0 to 4 do begin

            case hold of
            0: if (lives <> nindex) then plot ((nindex - 1) shl 3 + xindex + 2, yindex + 2, tile[ball_c + 30, xindex, yindex]);
            1: if (lives <> nindex) then plot ((nindex - 1) shl 3 + xindex + 2, yindex + 2, tile[ball_c + 30, xindex, yindex])
               else if (sec mod 2 = 0) then plot ((nindex-1) shl 3 +xindex+2, yindex + 2, tile[ball_c + 30, xindex, yindex]);
            end; {CASE hold}

        end; {FOR yindex}

        if (time_index > 0) then begin

           temp   := length(clock(minleft, secleft)) * 5 - 2;
           temp_x := 160 - temp shr 1;

           for xindex := temp_x - 3 to temp_x + temp + 2 do begin
           plot (xindex, 0, 31);
           plot (xindex, 8, 31);
           end; {FOR xindex}

           for yindex := 1 to 7 do begin
           plot (temp_x - 3, yindex, 31);
           plot (temp_x + temp + 2, yindex, 31);
           end; {FOR yindex}

           for xindex := temp_x - 2 to temp_x + temp + 1 do
           for yindex := 1 to 7 do plot (xindex, yindex, 0);

           spell (temp_x, 2, 31, 0, clock(minleft, secleft));

        end; {IF time_index}

      end; {CASE 0}

   1: begin  {MENU 1 - Pause Header}

        temp := (length('Game Paused: ' + clock(minplyd, secplyd) + ' - Press Spacebar') * 5 - 2) shr 1;

        for nindex := 2 downto 0 do
        for xindex := 156 - temp - nindex to 164 + temp + nindex do
        for yindex := 10  - nindex to 20  + nindex do
        plot (xindex, yindex, nindex * 7 + 16);

        spell (160 - temp, 13, 31, 0, 'Game Paused: ' + clock(minplyd, secplyd) + ' - Press Spacebar');

      end; {CASE 1}

   2: begin  {MENU 2 - Title Screen}

        spell (142, 33, 41, 0, 'Copyright 2002 by Jeff LaBundy');

        if (progress = 25) then box (95, 64, 239, 123) else box (95, 64, 239, 115);

        spell (115, 72, 31, 0, 'Start Game');

        case ball_c of
        0: timestring := 'Grey';
        1: timestring := 'Green';
        2: timestring := 'Red';
        3: timestring := 'Blue';
        4: timestring := 'Purple';
        5: timestring := 'Fire';
        6: timestring := 'Ice';
        end; {CASE ball_c}

        spell (115, 80, 29, 0, 'Ball Color:    ' + timestring);

        if (time_index = 0) then timestring := 'Untimed' else timestring := clock(minleft, secleft);
        spell (115, 88, 27, 0, 'Game Time:     ' + timestring);

        case acc_index of
        1: timestring := 'Slow';
        2: timestring := 'Normal';
        3: timestring := 'Fast';
        4: timestring := 'Speed Up';
        end; {CASE acc_index}

        spell (115, 96,  25, 0, 'Ball Speed:    ' + timestring);
        spell (115, 104, 23, 0, 'Exit');

        if (progress = 25) then spell (115, 112, 21, 0, 'Ball Number:   ' + tx(ball_n+1));

        if (progress = 25) then spell (46, 130, 26, 0, 'Use the mouse to select, click to change items')
                           else spell (46, 122, 26, 0, 'Use the mouse to select, click to change items');

        spell (121, 150, 31, 0, 'In-Game Controls');
        for xindex := 119 to 200 do plot (xindex, 156, 31);

        spell (94, 160, 29, 0, '- Use mouse to move paddle');
        spell (94, 167, 27, 0, '- Click to release ball');
        spell (94, 174, 25, 0, '- Press P to pause game');
        spell (94, 181, 23, 0, '- Press S to toggle sound');

      end; {CASE 2}

   3: begin  {MENU 3 - Level Complete}

        spell (175, 33, 31, 0, 'Level ' + tx(curr+1) + ' Complete');

        spell (24, 90,  31, 0, 'Time Played:  ' + clock(minplyd, secplyd));

        timestring := clock(best_min[curr], best_sec[curr]);
        if (new_time = 1) then timestring := timestring + ' - New Record';

        spell (24, 100, 31 + (new_time * 9), 0, 'Time to Beat: ' + timestring);

        if (time_index > 0) then spell (24, 110, 31, 0, 'Time Left:    ' + clock(minleft, secleft));

        spell (86, 160, (sec mod 2) * 31, 0, 'Press the spacebar to continue');

      end; {CASE 3}

   4: begin  {MENU 4 - Level Select}

        if (progress > 0) then for xindex := 0 to trunc(progress / 25 * 77) do
        for yindex := 0 to 5 do plot (xindex + 24, yindex + 120, 40);

        for xindex := 23 to 102 do begin
        plot (xindex, 119, 31);
        plot (xindex, 126, 31);
        end; {FOR xindex}

        for yindex := 120 to 125 do begin
        plot (23,  yindex, 31);
        plot (102, yindex, 31);
        end; {FOR yindex}

        spell (24, 113, 31, 0, 'Progress: ' + tx(trunc(progress / 25 * 100)) + '%');

        box (130, 24, 187, 176);

        if (curr < 20) then start := 0 else start := curr - 19;

        for yindex := 0 to 19 do spell (140, yindex * 7 + 32, lvl_clr[start+yindex], 0, 'Level ' + tx(start + yindex + 1));

        box (208, 24, 295, 80);

        for xindex  := 1 to 40 do for yindex :=  1 to 25 do if (level[curr, xindex, yindex] < 92) then
        for xindex2 := 0 to 1  do for yindex2 := 0 to 1  do
        plot (xindex shl 1 +210+xindex2,yindex shl 1 +26+yindex2,tile[level[curr,xindex,yindex],xindex2+2,yindex2+1]);


        box (208, 90, 295, 176);

        spell (215, 97, 31, 0, 'Level:');
        spell (291 - length(tx(curr+1)) * 5, 104, 27, 0, tx(curr+1));

        spell (215, 117, 31, 0, 'Status:');
        if (complete[curr] = 1) then timestring := 'Complete' else timestring := 'Incomplete';
        spell (291 - length(timestring) * 5, 124, 27, 0, timestring);

        spell (215, 137, 31, 0, 'Time to Beat:');
        spell (291 - length(clock(best_min[curr], best_sec[curr])) * 5, 144, 27, 0, clock(best_min[curr], best_sec[curr]));

        if (last_yr[curr] = 65535) then timestring := '---' else begin

          case last_day[curr] of
          0: timestring := 'Sun';
          1: timestring := 'Mon';
          2: timestring := 'Tue';
          3: timestring := 'Wed';
          4: timestring := 'Thu';
          5: timestring := 'Fri';
          6: timestring := 'Sat';
          end; {CASE last_day}

          timestring := timestring + ' ' + tx(last_mon[curr]) + '-' + tx(last_dat[curr]) + '-' + tx(last_yr[curr]);

        end; {IF played}

        spell (215, 157, 31, 0, 'Last Played:');
        spell (291 - length(timestring) * 5, 164, 27, 0, timestring);

      end; {CASE 5}

   end; {CASE menu}

  {Sound Output - MENU ALL}

   if (sound_index > 0) and (sound_time > 0) and (sound_a = 1) then begin

    case sound_index of
    1: sound (200);
    2: sound (500);
    3: sound (750);
    4: sound (100);
    end; {CASE sound_index}

   end else nosound;

  {Blit Screen - MENU ALL}

   WaitBorder;
   FlipScreen(Vaddr,$a000);

  end; {WHILE TRUE}

  end.