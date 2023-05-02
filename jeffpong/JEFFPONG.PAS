program Jeffpong;

uses SPRITES, FONT13H, _KBDHand, Dos;

Var
  DBuffer    : Pointer;
  Vaddr      : Word;
  XIndex     : integer;
  YIndex     : integer;
  LIndex     : integer;
  Closest    : array[1..2] of integer;
  Count      : integer;
  Ball_X, Ball_Y : array[1..50] of real;
  Ball_Angle : array[1..50] of integer;
  Paddle     : array[1..2] of real;
  A, B, C    : integer;
  Hold, Acc  : array[1..50] of real;
  Temp_X, Temp_Y : real;
  AI_Hit : array[1..2] of integer;
  Temp_Angle : integer;
  Line       : integer;
  Stars_Num, Ball_Index, Ball_Num : integer;
  Ball_Color, Menu, Mode, CurrMsg, CurrBNR, spot, TimeIndex, P_On : shortint;
  Stars_X, Stars_Y : array[1..980] of integer;
  Stars_I, Stars_O : array[1..980] of byte;
  Plane_X, Plane_Y : real;
  Plane_State, Plane_Angle : integer;
  Control, TA_On   : array[1..2] of shortint;
  r3 : real;
  StartTime, OldTime, MinLeft, SecLeft, TimeChange : integer;
  Do_AI, Ball_Done, Color_Index, Game_Done : shortint;
  Score : array[1..2] of integer;
  Main_R : integer;

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

Procedure Plot(x, y : integer; dot: byte);
  begin
  if (x >= 0) and (x <= 319) and (y >= 0) and (y <= 199) then
  mem[Vaddr:(y * 320) + x] := dot;
  end;

Function Pick(x, y: integer) : byte;
  begin
  Pick := mem[Vaddr:(y * 320) + x]
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

function Strng(I: Longint): String;
var S: string;
  begin
   Str(I, S);
   Strng := S;
  end;

Function TestBall (TestX, TestY : integer; TestC : byte) : integer;
  var r, TXIndex, TYIndex : integer;
  begin
   r := 0;
   for TYIndex := (TestY - 2) to (TestY + 2) do
   for TXIndex := (TestX - 2) to (TestX + 2) do
   if (Pick(TXIndex, TYIndex) = TestC) then inc(r);
   TestBall := r;
  end;

Function TestPaddle (p, Test_Y : integer) : integer;
  var r, TXIndex, TYIndex : integer;
  begin
   r := 0;
   for TYIndex := (Test_Y - 15) to (Test_Y + 15) do
   for TXIndex := p to (p + 6) do
   if (Pick(TXIndex, TYIndex) > 0) then inc(r);
   TestPaddle := r;
  end;

Function TestLine (NewLine : integer) : integer;
  var r : integer;
  begin
   r := 0;
   for YIndex := 1 to 198 do if (Pick(NewLine, Yindex) > 0) then inc(r);
   TestLine := r;
  end;

Function Seconds : integer;
  var h, m, s, hund : Word;
  begin
   GetTime(h,m,s,hund);
   Seconds := round(int(s));
  end;

Function Move(p : integer; Test_Y : real) : real;
  var r2 : real;
  begin
  r2 := 0;

    case p of

    1: begin

       case Control[p] of
       1: begin
          if (key[kUARROW] = 1) then r2 := -1;
          if (key[kDARROW] = 1) then r2 :=  1;
          end;

       2: begin
          if (round(int(Test_Y)) < round(int(Paddle[1]))) then r2 := -0.25;
          if (round(int(Test_Y)) > round(int(Paddle[1]))) then r2 :=  0.25;
          end;

       3: begin
          if (round(int(Test_Y)) < round(int(Paddle[1]))) then r2 := -0.5;
          if (round(int(Test_Y)) > round(int(Paddle[1]))) then r2 :=  0.5;
          end;

       4: begin
          if (round(int(Test_Y)) < round(int(Paddle[1]))) then r2 := -1;
          if (round(int(Test_Y)) > round(int(Paddle[1]))) then r2 :=  1;
          end;
       end;

       end;

    2: begin

       case Control[p] of
       1: begin
          if (key[kKEYPADMINUS] = 1) then r2 := -1;
          if (key[kKEYPADPLUS]  = 1) then r2 :=  1;
          end;

       2: begin
          if (round(int(Test_Y)) < round(int(Paddle[2]))) then r2 := -0.25;
          if (round(int(Test_Y)) > round(int(Paddle[2]))) then r2 :=  0.25;
          end;

       3: begin
          if (round(int(Test_Y)) < round(int(Paddle[2]))) then r2 := -0.5;
          if (round(int(Test_Y)) > round(int(Paddle[2]))) then r2 :=  0.5;
          end;

       4: begin
          if (round(int(Test_Y)) < round(int(Paddle[2]))) then r2 := -1;
          if (round(int(Test_Y)) > round(int(Paddle[2]))) then r2 :=  1;
          end;
       end;

       end;

    end;

  Move := r2;
  end;


procedure ResetBalls;
  var r, Reset_Index, RLIndex : integer;
      n : shortint;
  begin
  for Reset_Index := 1 to Ball_Num do begin
   Ball_X[Reset_Index] := 159;
   Ball_Y[Reset_Index] := 99;
   Acc[Reset_Index] := 1;

   n := random(2); if (n = 0) then n := -1;
   if (Ball_Num = 1) then Ball_Angle[Reset_Index] := (90 + (random(2) * 180)) + ((random(10) + 10 + (random(2) * 35)) * n)
   else begin
   repeat
    r := 0;
    Temp_Angle := (90 + (random(2) * 180)) + ((random(10) + 10 + (random(2) * 35)) * n);
    for RLIndex := 1 to (Reset_Index - 1) do if (Temp_Angle = Ball_Angle[RLIndex]) then inc(r);
   until (r = 0);
   Ball_Angle[Reset_Index] := Temp_Angle;
   end;

  end;
  Paddle[1] := 99; Paddle[2] := 99;
  Do_AI := 1;
  end;


procedure Config;
  var CLIndex : integer;
  begin
   Menu := 0;
   StartTime := Seconds;
   OldTime := 0;
   CurrMSG := 1;
   for CLIndex := 1 to 2 do Score[CLIndex] := 0;
   ResetBalls;
    case Color_Index of
    7: Ball_Color := random(4) + 1;
    8: Ball_Color := 4;
    else Ball_Color := Color_Index;
    end;
   TimeChange := Seconds;
   Game_Done := 0;

   case TimeIndex of
   2: begin
       MinLeft := 0;
       SecLeft := 30;
      end;
   3: begin
       MinLeft := 1;
       SecLeft := 0;
      end;
   4: begin
       MinLeft := 1;
       SecLeft := 30;
      end;
   5: begin
       MinLeft := 2;
       SecLeft := 0;
      end;
   6: begin
       MinLeft := 3;
       SecLeft := 0;
      end;
   7: begin
       MinLeft := 5;
       SecLeft := 0;
      end;
   8: begin
       MinLeft := 10;
       SecLeft := 0;
      end;
   9: begin
       MinLeft := 15;
       SecLeft := 0;
      end;
   10: begin
        MinLeft := 20;
        SecLeft := 0;
       end;
   end;
  end;


begin

  Randomize;
  Ball_Num := 1;
  Color_Index := 7;
  Mode := 1;
  Stars_Num := 250;
  Plane_State := 0;
  Menu := 1;
  spot := 1;
  TimeIndex := 1;
  P_On := 1;

  for LIndex := 1 to 2 do begin
   Control[LIndex] := 1;
   TA_On[LIndex] := -1;
  end;

  for LIndex := 1 to 980 do begin
    Stars_X[LIndex] := random(318) + 1;
    Stars_Y[LIndex] := random(198) + 1;
    Stars_I[LIndex] := random(5) + 27;
    Stars_O[LIndex] := random(5) + 20;
  end;

  GetMem (DBuffer,64000);
  Vaddr := seg(DBuffer^);
  SetMCGA;
  Cls($a000,0);
  Cls(Vaddr,0);
  InitKBDHandler;

while TRUE do begin


{----------------------------------------------------------------------------}
  {Adapt to Plane State}

  {Move Plane}
   if (Plane_State = 1) or (Plane_State = 3) then begin
     if (Menu = 3) and (Game_Done = 0) then Plane_X := Plane_X + 2 else Plane_X := Plane_X + 1;
     repeat
      Main_R := random(2) + 1;
      if (Main_R = 2) then Main_R := -1;
     until (Plane_Y + Main_R >= 10) and (Plane_Y + Main_R <= 49);
     if (random(1000) < 10) then Plane_Y := Plane_Y + Main_R;
     if (Plane_State = 1) and (round(int(Plane_X)) >= 339) then Plane_State := 0;
     if (Plane_State = 3) and (round(int(Plane_X)) >= 339
     + ((length(Banner[CurrBNR]) * 5) - 2) + 5) then Plane_State := 0;
   end;

  {Crash Plane}
   if (Plane_State = 2) then begin
    case round(int(Plane_X)) of
    -20..159: begin
              Plane_X := Plane_X + 1;
              repeat
               Main_R := random(2) + 1;
               if (Main_R = 2) then Main_R := -1;
              until (Plane_Y + Main_R >= 10) and (Plane_Y + Main_R <= 49);
              if (random(1000) < 10) then Plane_Y := Plane_Y + Main_R;
              end;
     else begin
          Plane_X := Plane_X + sin(Plane_Angle * (3.14 / 180));
          Plane_Y := Plane_Y + cos(Plane_Angle * (3.14 / 180));
          end;
    end;
    if (round(int(Plane_X)) >= 339)
    or (round(int(Plane_Y)) >= 205) then Plane_State := 0;
   end;

  {Try to Activate Plane if Innactive}
   if (Plane_State = 0) and (Menu <> 3) then begin
     Plane_X := -20;
     Plane_Y := 10 + random(40);
     Plane_Angle := random(45) + 10;
     if (random(10000) < 10) then Plane_State := random(3) + 1;
     CurrBNR := random(4) + 1;
   end;
{----------------------------------------------------------------------------}






{----------------------------------------------------------------------------}
  {Change Practice Message}

  {Increment Counter}
   if (Seconds <> StartTime) and (Menu = 0) then begin
     inc(OldTime);
     StartTime := Seconds;
   end;
  {Switch Message Every Five Seconds}
   if (OldTime = 5) then begin
     OldTime := 0;
     repeat
     Main_R := random(50) + 1;
     until (Main_R <> CurrMsg);
     CurrMsg := Main_R;
   end;
  {Maintain Ball Speed for Practice Mode Only}
   for Ball_Index := 1 to Ball_Num do if (Mode = 2) then Acc[Ball_Index] := 1;
{----------------------------------------------------------------------------}






{----------------------------------------------------------------------------}
  {Decrement Game Time Counter}

   if (Menu = 0) and (TimeIndex <> 1) and (Mode <> 2) then begin
   if (Seconds <> TimeChange) then begin
    TimeChange := Seconds;
    dec(SecLeft);
   if (SecLeft < 0) then begin
    SecLeft := 59;
    dec(MinLeft);
   end;
   end;

   if (MinLeft = 0) and (SecLeft = 0) then begin
    Menu := 3;
    Game_Done := 1;
    Plane_State := 3;
    Plane_X := -20;
    Plane_Y := 20;
    if (Score[1] > Score[2]) then CurrBNR := 7;
    if (Score[1] < Score[2]) then CurrBNR := 8;
    if (Score[1] = Score[2]) then CurrBNR := 9;
   end;

   end; {IF Timed Game}
{----------------------------------------------------------------------------}






{----------------------------------------------------------------------------}
  {Keyboard Control- Menu Operation\Paddle Movement & Placement Checking}

  {Create Boundaries}
   case Menu of
   0: begin
    Cls(Vaddr, 0);
    for XIndex := 0 to 319 do begin
    Plot (XIndex, 0,   1);
    Plot (XIndex, 199, 1);
    end;

  {Draw Ball}
   for Ball_Index := 1 to Ball_Num do begin
    for YIndex := -2 to 2 do
    for XIndex := -2 to 2 do
    Plot ((round(int(Ball_X[Ball_Index])) + XIndex), (round(int(Ball_Y[Ball_Index])) + YIndex), 1);
   end;

  {Move Paddle}
   case mode of
  {Normal Mode}
   1: begin
       r3 := Move(1, AI_Hit[1]);
       if (TestPaddle(0, round(int(Paddle[1] + r3))) = 0) then Paddle[1] := Paddle[1] + r3;
       r3 := Move(2, AI_Hit[2]);
       if (TestPaddle(313, round(int(Paddle[2] + r3))) = 0) then Paddle[2] := Paddle[2] + r3;
      end;
  {Practice Mode}
   2: begin
       r3 := Move(1, AI_Hit[1]);
       if (TestPaddle(0, round(int(Paddle[1] + r3))) = 0) then Paddle[1] := Paddle[1] + r3;
      end;
  {Soccer Mode}
   3: begin
       r3 := Move(1, AI_Hit[1]);
       if  (TestPaddle(0,   round(int(Paddle[1] + r3))) = 0)
       and (TestPaddle(213, round(int(Paddle[1] + r3))) = 0)
       then Paddle[1] := Paddle[1] + r3;
       r3 := Move(2, AI_Hit[2]);
       if  (TestPaddle(100,   round(int(Paddle[2] + r3))) = 0)
       and (TestPaddle(313, round(int(Paddle[2] + r3))) = 0)
       then Paddle[2] := Paddle[2] + r3;
      end;
   end;

  {Test Practice Line Placement}

  {Create Boundaries}
   for YIndex := 1 to 198 do begin
    Plot (6,   YIndex, 1);
    Plot (319, YIndex, 1);
   end;

  {Test for Movement}
   if (key[kLARROW] = 1) and (TestLine(Line - 1) = 0) then dec(Line);
   if (key[kRARROW] = 1) and (TestLine(Line + 1) = 0) then inc(Line);

  {Escape - Return to Menu}
   if (key[kESC] = 1) then begin
    repeat until (key[kESC] = 0);
    Menu := 1;
   end;

  {P Key - Pause Game}
   if (key[kP] = 1) then begin
    repeat until (key[kP] = 0);
    Menu := 2;
   end;
   end; {Case 0}

  {Accept Keyboard Control for Menu Operation}
   1: begin

  {Hold Paddle and Net}

   Paddle[1] := 99; Paddle[2] := 99; Line := 300;
  {Up Arrow - Navigate}
    if (key[kUARROW] = 1) then begin
     dec(spot);
     repeat until (key[kUARROW] = 0);
    end;

  {Down Arrow - Navigate}
    if (key[kDARROW] = 1) then begin
     inc(spot);
     repeat until (key[kDARROW] = 0);
    end;

  {Left Arrow - Toggle}
    if (key[kLARROW] = 1) then begin
     case spot of
     1: Config;
     2: dec(Control[1]);
     3: dec(Control[2]);
     4: dec(Mode);
     5: dec(TimeIndex);
     6: dec(Color_Index);
     7: dec(Ball_Num);
     8: Stars_Num := Stars_Num - 10;
     9: TA_On[1] := -TA_On[1];
     10: TA_On[2] := -TA_On[2];
     11: P_On := -P_On;
     12: begin
         repeat until (key[kLARROW] = 0);
         SetText;
         CloseKBDHandler;
         Halt;
         end;
     end;
     if (spot <> 8) then repeat until (key[kLARROW] = 0);
    end;

  {Right Arrow - Toggle}
    if (key[kRARROW] = 1) then begin
     case spot of
     1: Config;
     2: inc(Control[1]);
     3: inc(Control[2]);
     4: inc(Mode);
     5: inc(TimeIndex);
     6: inc(Color_Index);
     7: inc(Ball_Num);
     8: Stars_Num := Stars_Num + 10;
     9: TA_On[1] := -TA_On[1];
     10: TA_On[2] := -TA_On[2];
     11: P_On := -P_On;
     12: begin
         repeat until (key[kRARROW] = 0);
         SetText;
         CloseKBDHandler;
         Halt;
         end;
     end;
     if (spot <> 8) then repeat until (key[kRARROW] = 0);
    end;

  {Enter - Toggle}
    if (key[kENTER] = 1) then begin
     case spot of
     1: Config;
     2: inc(Control[1]);
     3: inc(Control[2]);
     4: inc(Mode);
     5: inc(TimeIndex);
     6: inc(Color_Index);
     7: inc(Ball_Num);
     8: Stars_Num := Stars_Num + 10;
     9: TA_On[1] := -TA_On[1];
     10: TA_On[2] := -TA_On[2];
     11: P_On := -P_On;
     12: begin
         repeat until (key[kENTER] = 0);
         SetText;
         CloseKBDHandler;
         Halt;
         end;
     end;
     repeat until (key[kENTER] = 0);
    end;

  {Escape - Exit}
    if (key[kESC] = 1) then begin
     repeat until (key[kESC] = 0);
     SetText;
     CloseKBDHandler;
     Halt;
    end;

  {Circle Parameters}
    if (spot <  1) then spot := 12;
    if (spot > 12) then spot := 1;
    if (Control[1] < 1) then Control[1] := 4;
    if (Control[1] > 4) then Control[1] := 1;
    if (Control[2] < 1) then Control[2] := 4;
    if (Control[2] > 4) then Control[2] := 1;
    if (Mode < 1) then Mode := 3;
    if (Mode > 3) then Mode := 1;
    if (TimeIndex < 1) then TimeIndex := 10;
    if (TimeIndex > 10) then TimeIndex := 1;
    if (Color_Index < 1) then Color_Index := 8;
    if (Color_Index > 8) then Color_Index := 1;
    if (Ball_Num < 1)  then Ball_Num := 1;
    if (Ball_Num > 50) then Ball_Num := 50;
    if (Stars_Num < 0) then Stars_Num := 0;
    if (Stars_Num > 980) then Stars_Num := 980;

   end; {Case 1}

  {Pause Menu}
   2 : begin
        if (key[kSPACE] = 1) then begin
        repeat until (key[kSPACE] = 0);
        Menu := 0;
        end;
       end; {Case 2}

  {Scoring}
   3: begin
      if (Plane_State = 0) then begin
       Menu := Game_Done;
       ResetBalls;
      end;
      end; {Case 3}

   end; {Case Menu of}
{----------------------------------------------------------------------------}






{----------------------------------------------------------------------------}
  {Create Boundaries for Ball Placement Testing}

  {Clear Buffer}
   Cls(Vaddr, 0);

  {Vertical Boundaries}
   for YIndex := 1 to 198 do begin
    Plot (0,   YIndex, 1);
    Plot (319, YIndex, 1);
    if (Mode = 2) then Plot (Line, Yindex, 1);
   end;

  {Vertical Paddle Sides}
   for YIndex := -14 to 14 do begin
  {Paddle 1}
    Plot (6, (round(int(Paddle[1])) + Yindex), 1);
  {Soccer Forwards}
    if (Mode = 3) then begin
     Plot (100, (round(int(Paddle[2])) + Yindex), 1);
     Plot (106, (round(int(Paddle[2])) + Yindex), 1);
     Plot (213, (round(int(Paddle[1])) + Yindex), 1);
     Plot (219, (round(int(Paddle[1])) + Yindex), 1);
    end;
  {Paddle 2}
    if (Mode <> 2 ) then Plot (313, (round(int(Paddle[2])) + Yindex), 1);
   end;

  {Horizontal Boundaires}
   for XIndex := 1 to 318 do begin
    Plot (XIndex, 0,   2);
    Plot (XIndex, 199, 2);
   end;

  {Horizontal Paddle Sides}
   for XIndex := 1 to 5 do begin
  {Paddle 2}
    Plot (Xindex, (round(int(Paddle[1])) - 15), 2);
    Plot (Xindex, (round(int(Paddle[1])) + 15), 2);
  {Soccer Paddles}
    if (Mode = 3) then begin
     Plot ((Xindex + 100), (round(int(Paddle[2])) - 15), 2);
     Plot ((Xindex + 100), (round(int(Paddle[2])) + 15), 2);
     Plot ((Xindex + 213), (round(int(Paddle[1])) - 15), 2);
     Plot ((Xindex + 213), (round(int(Paddle[1])) + 15), 2);
    end;
  {Paddle 2}
    if (Mode <> 2) then begin
     Plot ((Xindex + 313), (round(int(Paddle[2])) - 15), 2);
     Plot ((Xindex + 313), (round(int(Paddle[2])) + 15), 2);
    end;
   end;

  {Wall Corners, Paddle 1 Corners}
   Plot (0, 0, 3); Plot (319, 0, 3); Plot (0, 199, 3); Plot (319, 199, 3);
   Plot (0, (round(int(Paddle[1])) - 15), 3); Plot (6, (round(int(Paddle[1])) - 15), 3);
   Plot (0, (round(int(Paddle[1])) + 15), 3); Plot (6, (round(int(Paddle[1])) + 15), 3);
  {Practice Line Corners}
   if (Mode = 2) then Plot (Line, 0, 3);
   if (Mode = 2) then Plot (Line, 199, 3);
  {Soccer Paddle Corners}
   if (Mode = 3) then begin
    Plot (100, (round(int(Paddle[2])) - 15), 3); Plot (106, (round(int(Paddle[2])) - 15), 3);
    Plot (100, (round(int(Paddle[2])) + 15), 3); Plot (106, (round(int(Paddle[2])) + 15), 3);
    Plot (213, (round(int(Paddle[1])) - 15), 3); Plot (219, (round(int(Paddle[1])) - 15), 3);
    Plot (213, (round(int(Paddle[1])) + 15), 3); Plot (219, (round(int(Paddle[1])) + 15), 3);
   end;
  {Paddle 2 Corners}
   if (Mode <> 2) then begin
    Plot (313, (round(int(Paddle[2])) - 15), 3); Plot (319, (round(int(Paddle[2])) - 15), 3);
    Plot (313, (round(int(Paddle[2])) + 15), 3); Plot (319, (round(int(Paddle[2])) + 15), 3);
   end;
{----------------------------------------------------------------------------}






{----------------------------------------------------------------------------}
  {Change Ball Position}

   if (Menu = 0) then begin

  {Determine Closest Ball}
    Closest[1] := 1;
    if (Ball_Num > 1) then for Ball_Index := 1 to Ball_Num do
    for Count := 2 to Ball_Num do
    if (round(int(Ball_X[Count])) < round(int(Ball_X[Closest[1]])))
    then Closest[1] := Count;

    Closest[2] := 1;
    if (Ball_Num > 1) then for Ball_Index := 1 to Ball_Num do
    for Count := 2 to Ball_Num do
    if (round(int(Ball_X[Count])) > round(int(Ball_X[Closest[2]])))
    then Closest[2] := Count;

   for Ball_Index := 1 to Ball_Num do begin
    Hold[Ball_Index] := Acc[Ball_Index];
    for LIndex := 1 to round(int(Hold[Ball_Index])) do begin

  {Vertical Test}
    A := TestBall(round(int(Ball_X[Ball_Index] + sin(Ball_Angle[Ball_Index] * (3.14 / 180)))),
                  round(int(Ball_Y[Ball_Index] + cos(Ball_Angle[Ball_Index] * (3.14 / 180)))), 1);
  {Horizontal Test}
    B := TestBall(round(int(Ball_X[Ball_Index] + sin(Ball_Angle[Ball_Index] * (3.14 / 180)))),
                  round(int(Ball_Y[Ball_Index] + cos(Ball_Angle[Ball_Index] * (3.14 / 180)))), 2);
  {Corner Test}
    C := TestBall(round(int(Ball_X[Ball_Index] + sin(Ball_Angle[Ball_Index] * (3.14 / 180)))),
                  round(int(Ball_Y[Ball_Index] + cos(Ball_Angle[Ball_Index] * (3.14 / 180)))), 3);

  {If Test Clean, Increment Ball Position}
    if (A = 0) and (B = 0) and (C = 0) and (Menu = 0) then begin
     Ball_X[Ball_Index] := Ball_X[Ball_Index] + sin(Ball_Angle[Ball_Index] * (3.14 / 180));
     Ball_Y[Ball_Index] := Ball_Y[Ball_Index] + cos(Ball_Angle[Ball_Index] * (3.14 / 180));
    end;

  {Only Horizontal Failed}
    if (A = 0)  and (B <> 0) and (C = 0) then Ball_Angle[Ball_Index] := 180 - Ball_Angle[Ball_Index];
  {Only Vertical Failed}
    if (A <> 0) and (B =  0) and (C = 0) then Ball_Angle[Ball_Index] := 360 - Ball_Angle[Ball_Index];
  {At Least Corner Failed}
    if (C <> 0) then Ball_Angle[Ball_Index] := Ball_Angle[Ball_Index] + 180;
  {Circle Ball Angle}
    if Ball_Angle[Ball_Index] > 360 then Ball_Angle[Ball_Index] := Ball_Angle[Ball_Index] - 360;
    if Ball_Angle[Ball_Index] < 0   then Ball_Angle[Ball_Index] := Ball_Angle[Ball_Index] + 360;

  {Accelerate Ball, Calculate Scores, Trigger AI}
    if (A <> 0) or (B <> 0) or (C <> 0) then begin
     Acc[Ball_Index] := Acc[Ball_Index] + 0.15;
     if (Acc[Ball_Index] > 100) then Acc[Ball_Index] := 100;
     if (Ball_Index = Closest[1]) or (Ball_Index = Closest[2]) then Do_AI := 1;

    case Mode of

  {Normal & Soccer Modes Scoring}
    1, 3: begin
          if (round(int(Ball_X[Ball_Index])) = 3)   then begin
           inc(Score[2]);
           Menu := 3;
           Plane_State := 3;
           Plane_X := -20;
           Plane_Y := 20;
           if (Score[2] >= 10) and (TimeIndex = 1) then begin
            CurrBNR := 8;
            Game_Done := 1;
           end
           else CurrBNR := 6;
          end;
          if (round(int(Ball_X[Ball_Index])) = 316) then begin
           inc(Score[1]);
           Menu := 3;
           Plane_State := 3;
           Plane_X := -20;
           Plane_Y := 20;
           if (Score[1] >= 10) and (TimeIndex = 1) then begin
            CurrBNR := 7;
            Game_Done := 1;
           end
           else CurrBNR := 5;
          end;
          end; {Case 1, 3}

  {Practice Mode Scoring}
    2:    begin
          end; {Case 2}
    end; {Case Mode of}
    break;
    end;

   end; {FOR LIndex}
   end;  {FOR Ball_Index}
   end;  {IF Menu}
{----------------------------------------------------------------------------}






{----------------------------------------------------------------------------}
  {Artificailly Intelligent Engine}

  {Create Boundaires for AI Test}

   if (Do_AI <> 0) and (Menu = 0) then begin
   Cls(Vaddr, 0);

  {Vertical Boundaries}
   for YIndex := 1 to 198 do begin
    Plot (0,   YIndex, 1);
    Plot (319, YIndex, 1);
    if (Mode = 2) then Plot (Line, Yindex, 1);
   end;

  {Horizontal Boundaires}
   for XIndex := 1 to 318 do begin
    Plot (XIndex, 0,   2);
    Plot (XIndex, 199, 2);
   end;

  {Corners}
   Plot (0, 0, 3); Plot (319, 0, 3); Plot (0, 199, 3); Plot (319, 199, 3);

  {Practice Line Corners}
   if (Mode = 2) then Plot (Line, 0, 3);
   if (Mode = 2) then Plot (Line, 199, 3);

  {Begin Virtual Ball Movement}

   for LIndex := 1 to 2 do begin

   Temp_X := Ball_X[Closest[LIndex]]; Temp_Y := Ball_Y[Closest[LIndex]]; Temp_Angle := Ball_Angle[Closest[LIndex]];
   Ball_Done := 0;

   repeat

  {AI Vertical Test}
    A := TestBall(round(int(Temp_X + sin(Temp_Angle * (3.14 / 180)))),
                  round(int(Temp_Y + cos(Temp_Angle * (3.14 / 180)))), 1);
  {AI Horizontal Test}
    B := TestBall(round(int(Temp_X + sin(Temp_Angle * (3.14 / 180)))),
                  round(int(Temp_Y + cos(Temp_Angle * (3.14 / 180)))), 2);
  {AI Corner Test}
    C := TestBall(round(int(Temp_X + sin(Temp_Angle * (3.14 / 180)))),
                  round(int(Temp_Y + cos(Temp_Angle * (3.14 / 180)))), 3);

  {AI If Test Clean, Increment Ball Position}
    if (A = 0) and (B = 0) and (C = 0) then begin
     Temp_X := Temp_X + sin(Temp_Angle * (3.14 / 180));
     Temp_Y := Temp_Y + cos(Temp_Angle * (3.14 / 180));
    end;

  {AI Only Horizontal Failed}
    if (A = 0)  and (B <> 0) and (C = 0) then Temp_Angle := 180 - Temp_Angle;
  {AI Only Vertical Failed}
    if (A <> 0) and (B =  0) and (C = 0) then Temp_Angle := 360 - Temp_Angle;
  {AI At Least Corner Failed}
    if (C <> 0) then Temp_Angle := Temp_Angle + 180;
  {AI Circle Ball Angle}
    if Temp_Angle > 360 then Temp_Angle := Temp_Angle - 360;
    if Temp_Angle < 0   then Temp_Angle := Temp_Angle + 360;

    case LIndex of
    1: if (round(int(Temp_X)) <= 9)  then Ball_Done := 1;
    2: if (round(int(Temp_X)) >= 310) then Ball_Done := 1;
    end;

    if (Mode = 2) and (LIndex = 2) then Ball_Done := 1;

   until (Ball_Done <> 0) or (key[kESC] = 1);

   AI_Hit[LIndex] := round(int(Temp_Y));

   end; {FOR LIndex}
   Do_AI := 0;
   end; {IF Do_AI & Menu = 0}


{----------------------------------------------------------------------------}






{----------------------------------------------------------------------------}
  {Draw Background & Paddles}

  {Clear Buffer}
   Cls(Vaddr, 0);

  {Twinkle Stars}
   for LIndex := 1 to 980 do begin
    repeat
    Main_R := random(3);
    if (Main_R = 2) then Main_R := -1;
    until (Stars_I[LIndex] + Main_R >= 27) and (Stars_I[LIndex] + Main_R <= 31);
    Stars_I[LIndex] := Stars_I[LIndex] + Main_R;
    repeat
    Main_R := random(3);
    if (Main_R = 2) then Main_R := -1;
    until (Stars_O[LIndex] + Main_R >= 20) and (Stars_O[LIndex] + Main_R <= 24);
    Stars_O[LIndex] := Stars_O[LIndex] + Main_R;
   end;

  {Draw Stars}
   for LIndex := 1 to Stars_Num do begin
    Plot (Stars_X[LIndex], Stars_Y[LIndex], Stars_I[LIndex]);
    Plot ((Stars_X[LIndex] - 1), Stars_Y[LIndex], Stars_O[LIndex]);
    Plot ((Stars_X[LIndex] + 1), Stars_Y[LIndex], Stars_O[LIndex]);
    Plot (Stars_X[LIndex], (Stars_Y[LIndex] - 1), Stars_O[LIndex]);
    Plot (Stars_X[LIndex], (Stars_Y[LIndex] + 1), Stars_O[LIndex]);
   end;

  {Draw Plane and Add Fire}
   if (Plane_State <> 0) then begin
   if (P_On = 1) or (Menu = 3) then begin
    for XIndex := 1 to 40 do
    for YIndex := 1 to 13 do
    if (Plane[XIndex, YIndex] <> 1) then begin
     Main_R := Plane[XIndex, YIndex];
     if (random(200) < Plane_Y) and (Plane_State = 2)
     and (round(int(Plane_X)) > 159) then Main_R := random(4) + 40;
     Plot ((round(int(Plane_X)) - 20 + XIndex), (round(int(Plane_Y)) - 6 + YIndex), Main_R);
    end;

  {Draw Smoke Message}
    if (Plane_State = 3) then
    Spell ((round(int(Plane_X)) - (length(Banner[CurrBNR]) * 5) - 23), (round(int(Plane_Y)) + 1),
    (32 - length(Banner[CurrBNR])), 1, Banner[CurrBNR]);

   end; {IF P_On or Menu}
   end; {IF Plane_State}

  {Draw Paddle 1}
   for XIndex := 1 to 7 do for YIndex := (round(int(Paddle[1])) - 14)
   to (round(int(Paddle[1])) + 16) do Plot (XIndex, YIndex, 40);
   for XIndex := 0 to 6 do for YIndex := (round(int(Paddle[1])) - 15)
   to (round(int(Paddle[1])) + 15) do Plot (XIndex, YIndex, 31);

  {Draw Paddles 2 and 3}
   if (Mode = 3) then begin
    for XIndex := 101 to 107 do for YIndex := (round(int(Paddle[2])) - 14)
    to (round(int(Paddle[2])) + 16) do Plot (XIndex, YIndex, 32);
    for XIndex := 100 to 106 do for YIndex := (round(int(Paddle[2])) - 15)
    to (round(int(Paddle[2])) + 15) do Plot (XIndex, YIndex, 31);
    for XIndex := 212 to 218 do for YIndex := (round(int(Paddle[1])) - 14)
    to (round(int(Paddle[1])) + 16) do Plot (XIndex, YIndex, 40);
    for XIndex := 213 to 219 do for YIndex := (round(int(Paddle[1])) - 15)
    to (round(int(Paddle[1])) + 15) do Plot (XIndex, YIndex, 31);
   end;

  {Draw Paddle 4}
   if (Mode <> 2) then begin
    for XIndex := 312 to 318 do for YIndex := (round(int(Paddle[2])) - 14)
    to (round(int(Paddle[2])) + 16) do Plot (XIndex, YIndex, 32);
    for XIndex := 313 to 319 do for YIndex := (round(int(Paddle[2])) - 15)
    to (round(int(Paddle[2])) + 15) do Plot (XIndex, YIndex, 31);
   end;


  {Draw Practice Line}
   if (Mode = 2) then for YIndex := 0 to 199 do Plot (Line, Yindex, 31);
{----------------------------------------------------------------------------}






{----------------------------------------------------------------------------}
  {Draw In-Game Components (Menu = 0)}
   case Menu of
   0: begin

  {Draw P1 Training Arrows}
   if (TA_On[1] = 1) then begin
    if (AI_Hit[1] <= (round(int(Paddle[1])) - 14)) then begin
     Plot (1, (round(int(Paddle[1])) - 11), 0);
     Plot (2, (round(int(Paddle[1])) - 12), 0);
     Plot (3, (round(int(Paddle[1])) - 13), 0);
     Plot (4, (round(int(Paddle[1])) - 12), 0);
     Plot (5, (round(int(Paddle[1])) - 11), 0);
    end;
    if (AI_Hit[1] > (round(int(Paddle[1])) - 14)) and (AI_Hit[1] < (round(int(Paddle[1])) + 14))
    then Spell (2, (round(int(Paddle[1])) - 2), 0, 0, '=');
    if (AI_Hit[1] >= (round(int(Paddle[1])) + 14)) then begin
     Plot (1, (round(int(Paddle[1])) + 11), 0);
     Plot (2, (round(int(Paddle[1])) + 12), 0);
     Plot (3, (round(int(Paddle[1])) + 13), 0);
     Plot (4, (round(int(Paddle[1])) + 12), 0);
     Plot (5, (round(int(Paddle[1])) + 11), 0);
    end;
   end;

  {Draw P2 Training Arrows}
   if (TA_On[2] = 1) and (Mode <> 2) then begin
    if (AI_Hit[2] <= (round(int(Paddle[2])) - 14)) then begin
     Plot (314, (round(int(Paddle[2])) - 11), 0);
     Plot (315, (round(int(Paddle[2])) - 12), 0);
     Plot (316, (round(int(Paddle[2])) - 13), 0);
     Plot (317, (round(int(Paddle[2])) - 12), 0);
     Plot (318, (round(int(Paddle[2])) - 11), 0);
    end;
    if (AI_Hit[2] > (round(int(Paddle[2])) - 14)) and (AI_Hit[2] < (round(int(Paddle[2])) + 14))
    then Spell (315, (round(int(Paddle[2])) - 2), 0, 0, '=');
    if (AI_Hit[2] >= (round(int(Paddle[2])) + 14)) then begin
     Plot (314, (round(int(Paddle[2])) + 11), 0);
     Plot (315, (round(int(Paddle[2])) + 12), 0);
     Plot (316, (round(int(Paddle[2])) + 13), 0);
     Plot (317, (round(int(Paddle[2])) + 12), 0);
     Plot (318, (round(int(Paddle[2])) + 11), 0);
    end;
   end;

  {Change Ball Color for Posessive Mode}
   if (Color_Index = 8) then begin
    if (Score[1] > Score[2]) then Ball_Color := 2;
    if (Score[1] < Score[2]) then Ball_Color := 3;
    if (Score[1] = Score[2]) then Ball_Color := 4;
   end;

  {Draw Ball}
   for Ball_Index := 1 to Ball_Num do begin
    for YIndex := -2 to 2 do
    for XIndex := -2 to 2 do
    if (Ball[Ball_Color, (YIndex + 3), (XIndex + 3)] > 0) then Plot ((round(int(Ball_X[Ball_Index])) + XIndex),
    (round(int(Ball_Y[Ball_Index])) + YIndex), Ball[Ball_Color, (YIndex + 3), (XIndex + 3)]);
   end;

  {Draw Practice Message}
   if (Mode = 2) then
   Spell ((159 - (round(int((((length(Message[CurrMsg]) * 5) - 2) / 2))))), 190, 48, 0, Message[CurrMsg]);

  {Draw Score}
   case Mode of
   1, 3: begin
         Spell ((20   - (round(int((((length(Strng(Score[1])) * 5) - 2) / 2))))), 10, 40, 0, Strng(Score[1]));
         Spell ((299  - (round(int((((length(Strng(Score[2])) * 5) - 2) / 2))))), 10, 32, 0, Strng(Score[2]));
         end;
   2:    begin
         end;
   end;

  {Draw Game Time}
   if (TimeIndex <> 1) and (Mode <> 2) then begin
    case SecLeft of
    0..9: Spell (159 - round(((length(Strng(MinLeft) + ':0' + Strng(SecLeft)) * 5) - 2) / 2),
          10, 48, 0, Strng(MinLeft) + ':0' + Strng(SecLeft));
    else  Spell(159 - round(((length(Strng(MinLeft) + ':' + Strng(SecLeft)) * 5) - 2) / 2),
          10, 48, 0, Strng(MinLeft) + ':' + Strng(SecLeft));
    end; {Case SecLeft of}
   end;  {IF Time Left and Mode <> 2}

   end;  {Case 0}
{----------------------------------------------------------------------------}






{----------------------------------------------------------------------------}
  {Draw Menu (Menu = 1)}
   1: begin

  {Draw Logo}
    Spell (126, 30, 18, 0, 'Jeff-Pong');
    Spell (127, 31, 19, 0, 'Jeff-Pong');
    Spell (128, 32, 20, 0, 'Jeff-Pong');
    Spell (129, 33, 21, 0, 'Jeff-Pong');
    Spell (130, 34, 22, 0, 'Jeff-Pong');
    Spell (131, 35, 23, 0, 'Jeff-Pong');
    Spell (132, 36, 24, 0, 'Jeff-Pong');
    Spell (133, 37, 25, 0, 'Jeff-Pong');
    Spell (134, 38, 26, 0, 'Jeff-Pong');
    Spell (135, 39, 27, 0, 'Jeff-Pong');
    Spell (136, 38, 28, 0, 'Jeff-Pong');
    Spell (137, 37, 29, 0, 'Jeff-Pong');
    Spell (138, 36, 30, 0, 'Jeff-Pong');
    Spell (139, 35,104, 1, 'Jeff-Pong');
    Spell (140, 34, 32, 1, 'Jeff-Pong');

  {Draw Menu Items}
    Spell (100, 70, 55, 0, 'Start Game');
    Spell (100, 77, 55, 0, 'Change Player 1:');
    Spell (100, 84, 55, 0, 'Change Player 2:');
    Spell (100, 91, 55, 0, 'Game Mode:');
    Spell (100, 98, 55, 0, 'Game Time:');
    Spell (100,105, 55, 0, 'Ball Color:');
    Spell (100,112, 55, 0, 'Number of Balls:');
    Spell (100,119, 55, 0, 'Number of Stars:');
    Spell (100,126, 55, 0, 'Player 1 Training Arrows:');
    Spell (100,133, 55, 0, 'Player 2 Training Arrows:');
    Spell (100,140, 55, 0, 'In-Game Plane Animation:');
    Spell (100,147, 55, 0, 'Exit');

  {Draw Ball Number Scroll Bar}
    for XIndex := 181 to 238 do for YIndex := 112 to 116 do Plot (XIndex, YIndex, 23);
    for XIndex := 185 to 234 do for YIndex := 113 to 115 do Plot (XIndex, YIndex, 18);
    Spell (181, 112, 0, 0, '<');
    Spell (236, 112, 0, 0, '>');
    for YIndex := 113 to 115 do Plot ((184 + Ball_Num), YIndex, 31);

  {Draw Star Number Scroll Bar}
    for XIndex := 181 to 238 do for YIndex := 119 to 123 do Plot (XIndex, YIndex, 23);
    for XIndex := 185 to 234 do for YIndex := 120 to 122 do Plot (XIndex, YIndex, 18);
    Spell (181, 119, 0, 0, '<');
    Spell (236, 119, 0, 0, '>');
    for YIndex := 120 to 122 do Plot ((185 + round(Stars_Num / 20)), YIndex, 31);

  {Draw Player 1 Options}
    case Control[1] of
    1: Spell (180, 77, 43, 0, 'Human');
    2: Spell (180, 77, 43, 0, 'Beg. AI');
    3: Spell (180, 77, 43, 0, 'Med. AI');
    4: Spell (180, 77, 43, 0, 'Adv. AI');
    end;

  {Draw Player 2 Options}
    case Control[2] of
    1: Spell (180, 84, 43, 0, 'Human');
    2: Spell (180, 84, 43, 0, 'Beg. AI');
    3: Spell (180, 84, 43, 0, 'Med. AI');
    4: Spell (180, 84, 43, 0, 'Adv. AI');
    end;

  {Draw Game Mode Options}
    case Mode of
    1: Spell (150, 91, 43, 0, 'Normal');
    2: Spell (150, 91, 43, 0, 'Practice');
    3: Spell (150, 91, 43, 0, 'Soccer');
    end;

  {Draw Game Time Options}
    case TimeIndex of
    1: Spell (150, 98, 43, 0, 'Unlimited');
    2: Spell (150, 98, 43, 0, '0:30');
    3: Spell (150, 98, 43, 0, '1:00');
    4: Spell (150, 98, 43, 0, '1:30');
    5: Spell (150, 98, 43, 0, '2:00');
    6: Spell (150, 98, 43, 0, '3:00');
    7: Spell (150, 98, 43, 0, '5:00');
    8: Spell (150, 98, 43, 0, '10:00');
    9: Spell (150, 98, 43, 0, '15:00');
    10: Spell (150, 98, 43, 0, '20:00');
    end;

  {Draw Ball Color Options}
    case Color_Index of
    1: Spell (155, 105, 10, 0, 'Green');
    2: Spell (155, 105, 12, 0, 'Red');
    3: Spell (155, 105, 9, 0, 'Blue');
    4: Spell (155, 105, 13, 0, 'Purple');
    5: Spell (155, 105, 40, 1, 'Fire');
    6: Spell (155, 105, 79, -2, 'Ice');
    7: Spell (155, 105, 43, 0, 'Random');
    8: Spell (155, 105, 43, 0, 'Possessive');
    end;

  {Draw P1 Training Arrows On\Off}
    case TA_On[1] of
    -1: Spell (225, 126, 43, 0, 'Off');
     1: Spell (225, 126, 43, 0, 'On');
    end;

  {Draw P2 Training Arrows On\Off}
    case TA_On[2] of
    -1: Spell (225, 133, 43, 0, 'Off');
     1: Spell (225, 133, 43, 0, 'On');
    end;

  {Draw In-Game Plane Animation On\Off}
    case P_On of
    -1: Spell (220, 140, 43, 0, 'Off');
     1: Spell (220, 140, 43, 0, 'On');
    end;

  {Draw Player 1 Controls}
    Spell (1, 75, 40, 0, 'Player 1');
    if (Control[1] = 1) then begin
     Spell (1, 120, 40, 0, 'Up\Down');
     Spell (1, 127, 40, 0, 'Arrows');
    end
    else begin
     Spell (1, 120, 20, 0, 'Up\Down');
     Spell (1, 127, 20, 0, 'Arrows');
    end;

  {Draw Player 2 Controls}
    if (Mode <> 2) then begin
     Spell (281, 75, 32, 0, 'Player 2');
     if (Control[2] = 1) then begin
      Spell (291, 120, 32, 0, '+\- On');
      Spell (291, 127, 32, 0, 'NumPad');
     end
     else begin
      Spell (291, 120, 20, 0, '+\- On');
      Spell (291, 127, 20, 0, 'NumPad');
     end;
    end;

  {Draw Bottom Messages}
    Spell (57, 170, 48, 0, Message[45]);
    Spell (10, 185, 37, 0, Message[47]);
    Spell (85, 194, 38, 0, 'Copyright 2001 By Jeff LaBundy');

  {Draw Plane At Current Menu Item}
    for XIndex := 1 to 40 do
    for YIndex := 1 to 13 do
    if (Plane[XIndex, YIndex] <> 1) then
    Plot ((XIndex + 55), (YIndex + 54 + ((spot) * 7)), Plane[XIndex, YIndex]);

   end; {Case 1}
{----------------------------------------------------------------------------}






{----------------------------------------------------------------------------}
  {Draw Pause Screen or Score Screen}

  {Game Paused}
   2: begin
      for XIndex := 96 to 220 do for YIndex := 26 to 38 do Plot (XIndex, YIndex, (random(3) + 17));
      for XIndex := 96 to 220 do begin
       Plot (XIndex, 26, 31);
       Plot (XIndex, 38, 31);
      end;
      for YIndex := 26 to 38 do begin
       Plot (96, YIndex, 31);
       Plot (220, YIndex, 31);
      end;
      for XIndex := 97 to 219 do Plot (XIndex, 27, 23);
      for YIndex := 27 to 37 do Plot (97, YIndex, 23);
      Spell (103, 31, 104, 1, 'Paused - Press Spacebar');
      Spell (102, 30, 32, 1, 'Paused - Press Spacebar');
      end;

  {Player N Scores!}
   3: begin
  {Draw Ball}
      for Ball_Index := 1 to Ball_Num do begin
       for YIndex := -2 to 2 do
       for XIndex := -2 to 2 do
       if (Ball[Ball_Color, (YIndex + 3), (XIndex + 3)] > 0) then Plot ((round(int(Ball_X[Ball_Index])) + XIndex),
       (round(int(Ball_Y[Ball_Index])) + YIndex), Ball[Ball_Color, (YIndex + 3), (XIndex + 3)]);
      end;
  {Draw Score}
      Spell ((20   - (round(int((((length(Strng(Score[1])) * 5) - 2) / 2))))), 10, 40, 0, Strng(Score[1]));
      Spell ((299  - (round(int((((length(Strng(Score[2])) * 5) - 2) / 2))))), 10, 32, 0, Strng(Score[2]));
      end;

   end; {Case Menu of}
{----------------------------------------------------------------------------}

  {Blit Buffer}
   WaitBorder;
   FlipScreen(Vaddr,$a000);

{----------------------------------------------------------------------------}

end;

end.