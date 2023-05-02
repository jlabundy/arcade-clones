DECLARE SUB vsmouse (action$, a1%, a2%, a3%, a4%)
DECLARE FUNCTION vsINTERR% (ax%, bx%, cx%, dx%)

' DATADRAW Variables
' ------------------

  XSIZE% = 64
  YSIZE% = 64
  PATH$ = ""
  PALINIT% = 0

DIM mouse1(0 TO 45) AS INTEGER
DIM Red%(0 TO 255), Blue%(0 TO 255), Green%(0 TO 255)
DIM Pic%(0 TO 63, 0 TO 63)

RESTORE DataForMouse
DEF SEG = VARSEG(mouse1(0))
FOR i% = 0 TO 52
  READ Byte$
  POKE VARPTR(mouse1(0)) + i%, VAL("&H" + Byte$)
NEXT
DataForMouse:
DATA 55,8b,ec,56,57,8b,76,0c,8b,04,8b,76,0a,8b,1c,8b,76,08,8b,0c,8b,76,06,8b
DATA 14,cd,21,8b,76,0c,89,04,8b,76,0a,89,1c,8b,76,08,89,0c,8b,76,06,89,14,5f
DATA 5e,5d,ca,08,00

IF MID$(PATH$, LEN(PATH$), 1) <> "\" THEN PATH$ = PATH$ + "\"

'Initialize RGB Values
  SCREEN 13
 
  IF PALINIT% = 1 THEN
 
     OPEN "PALETTE.DAT" FOR INPUT AS #1
     FOR n% = 0 TO 255
     INPUT #1, Red%(n%), Green%(n%), Blue%(n%)
     PALETTE n%, 65536 * Blue%(n%) + 256 * Green%(n%) + Red%(n%)
     NEXT n%
     CLOSE #1

  END IF

'Setup Interface
 
'Drawing Board
  FOR x% = 0 TO 192
  FOR y% = 0 TO 192
  IF x% MOD 3 = 0 THEN PSET (x%, y%), 8
  IF y% MOD 3 = 0 THEN PSET (x%, y%), 8
  NEXT y%
  NEXT x%

'View
  FOR x% = 209 TO 274
  FOR y% = 0 TO 65
  IF x% = 209 OR x% = 274 THEN PSET (x%, y%), 8
  IF y% = 0 OR y% = 65 THEN PSET (x%, y%), 8
  NEXT y%
  NEXT x%

'RGB Switches
  LINE (209, 80)-(274, 86), 8, B
  LINE (209, 96)-(274, 102), 8, B
  LINE (209, 112)-(274, 118), 8, B
  LOCATE 11, 36: PRINT "R"; Red%(Index%)
  LOCATE 13, 36: PRINT "G"; Green%(Index%)
  LOCATE 15, 36: PRINT "B"; Blue%(Index%)
  LINE (210 + Red%(Index%), 81)-(210 + Red%(Index%), 85), 15
  LINE (210 + Green%(Index%), 97)-(210 + Green%(Index%), 101), 15
  LINE (210 + Blue%(Index%), 113)-(210 + Blue%(Index%), 117), 15

'Palette
  FOR y% = 177 TO 198
  FOR x% = 200 TO 296
  IF x% MOD 3 = 0 AND y% MOD 3 = 0 THEN LINE (x%, y%)-(x% + 1, y% + 1), num%, BF: num% = num% + 1
  NEXT x%
  NEXT y%
  
'Save Controls
  LINE (198, 128)-(206, 134), 8, B
  LINE (209, 128)-(217, 134), 8, B
  LINE (220, 128)-(228, 134), 8, B
  PSET (201, 131), 15
  PSET (202, 132), 15
  PSET (203, 131), 15
  PSET (204, 130), 15
  PSET (213, 130), 15: PSET (224, 132), 15
  PSET (212, 131), 15: PSET (223, 131), 15
  PSET (214, 131), 15: PSET (225, 131), 15
  PSET (211, 132), 15: PSET (222, 130), 15
  PSET (215, 132), 15: PSET (226, 130), 15
  LOCATE 17, 31: PRINT "Save"; Save%

'Load Controls
  LINE (198, 144)-(206, 150), 8, B
  LINE (209, 144)-(217, 150), 8, B
  LINE (220, 144)-(228, 150), 8, B
  PSET (201, 147), 15
  PSET (202, 148), 15
  PSET (203, 147), 15
  PSET (204, 146), 15
  PSET (213, 146), 15: PSET (224, 148), 15
  PSET (212, 147), 15: PSET (223, 147), 15
  PSET (214, 147), 15: PSET (225, 147), 15
  PSET (211, 148), 15: PSET (222, 146), 15
  PSET (215, 148), 15: PSET (226, 146), 15
  LOCATE 19, 31: PRINT "Load"; Load%

'Index Controls
  LINE (198, 160)-(206, 166), Index%, BF
  LINE (198, 160)-(206, 166), 8, B
  LINE (209, 160)-(217, 166), 8, B
  LINE (220, 160)-(228, 166), 8, B
  PSET (213, 162), 15: PSET (224, 164), 15
  PSET (212, 163), 15: PSET (223, 163), 15
  PSET (214, 163), 15: PSET (225, 163), 15
  PSET (211, 164), 15: PSET (222, 162), 15
  PSET (215, 164), 15: PSET (226, 162), 15
  LOCATE 21, 31: PRINT "Indx"; Index%

'Set Mouse Parameters
  vsmouse "area", 0, 640, 0, 200
  vsmouse "position", 320, 100, 0, 0
  vsmouse "show", 0, 0, 0, 0

  DO

   vsmouse "get", 0, 0, 0, 0

   'Change R- Palette
     IF mouseX% / 2 > 209 AND mouseX% / 2 < 274 AND mouseY% > 80 AND mouseY% < 86 AND mouseB% = 1 THEN
      vsmouse "area", 420, 546, 81, 85
      vsmouse "hide", 0, 0, 0, 0
      LINE (210 + Red%(Index%), 81)-(210 + Red%(Index%), 85), 0
      Red%(Index%) = mouseX% / 2 - 210
      LINE (210 + Red%(Index%), 81)-(210 + Red%(Index%), 85), 15
      LOCATE 11, 36: PRINT "R"; Red%(Index%)
      PALETTE Index%, 65536 * Blue%(Index%) + 256 * Green%(Index%) + Red%(Index%)
      vsmouse "show", 0, 0, 0, 0
      oldX% = mouseX%
      oldY% = mouseY%
      DO
      vsmouse "get", 0, 0, 0, 0
      LOOP WHILE (oldX% = mouseX%) AND (oldY% = mouseY%) AND mouseB% = 1
      vsmouse "area", 0, 640, 0, 200
     END IF

   'Change G- Palette
     IF mouseX% / 2 > 209 AND mouseX% / 2 < 274 AND mouseY% > 96 AND mouseY% < 102 AND mouseB% = 1 THEN
      vsmouse "area", 420, 546, 97, 101
      vsmouse "hide", 0, 0, 0, 0
      LINE (210 + Green%(Index%), 97)-(210 + Green%(Index%), 101), 0
      Green%(Index%) = mouseX% / 2 - 210
      LINE (210 + Green%(Index%), 97)-(210 + Green%(Index%), 101), 15
      PALETTE Index%, 65536 * Blue%(Index%) + 256 * Green%(Index%) + Red%(Index%)
      LOCATE 13, 36: PRINT "G"; Green%(Index%)
      vsmouse "show", 0, 0, 0, 0
      oldX% = mouseX%
      oldY% = mouseY%
      DO
      vsmouse "get", 0, 0, 0, 0
      LOOP WHILE (oldX% = mouseX%) AND (oldY% = mouseY%) AND mouseB% = 1
      vsmouse "area", 0, 640, 0, 200
     END IF
 
   'Change B- Palette
     IF mouseX% / 2 > 209 AND mouseX% / 2 < 274 AND mouseY% > 112 AND mouseY% < 118 AND mouseB% = 1 THEN
      vsmouse "area", 420, 546, 113, 117
      vsmouse "hide", 0, 0, 0, 0
      LINE (210 + Blue%(Index%), 113)-(210 + Blue%(Index%), 117), 0
      Blue%(Index%) = mouseX% / 2 - 210
      LINE (210 + Blue%(Index%), 113)-(210 + Blue%(Index%), 117), 15
      PALETTE Index%, 65536 * Blue%(Index%) + 256 * Green%(Index%) + Red%(Index%)
      LOCATE 15, 36: PRINT "B"; Blue%(Index%)
      vsmouse "show", 0, 0, 0, 0
      oldX% = mouseX%
      oldY% = mouseY%
      DO
      vsmouse "get", 0, 0, 0, 0
      LOOP WHILE (oldX% = mouseX%) AND (oldY% = mouseY%) AND mouseB% = 1
      vsmouse "area", 0, 640, 0, 200
     END IF
 
   'Draw
     IF mouseX% / 2 > 0 AND mouseX% / 2 < 192 AND mouseY% > 0 AND mouseY% < 192 AND mouseB% <> 0 THEN
      vsmouse "area", 2, 382, 1, 191
      vsmouse "hide", 0, 0, 0, 0
      tempX% = mouseX% / 2
      tempY% = mouseY%
      DO UNTIL tempX% MOD 3 = 0
      tempX% = tempX% - 1
      LOOP
      DO UNTIL tempY% MOD 3 = 0
      tempY% = tempY% - 1
      LOOP
      LINE (tempX% + 1, tempY% + 1)-(tempX% + 2, tempY% + 2), (ABS(mouseB% - 2) * Index%), BF
      Pic%(tempX% / 3, tempY% / 3) = (ABS(mouseB% - 2) * Index%)
      PSET (210 + (tempX% / 3), 1 + (tempY% / 3)), (ABS(mouseB% - 2) * Index%)
      vsmouse "show", 0, 0, 0, 0
      oldX% = mouseX%
      oldY% = mouseY%
      DO
      vsmouse "get", 0, 0, 0, 0
      LOOP WHILE (oldX% = mouseX%) AND (oldY% = mouseY%) AND mouseB% <> 0
      vsmouse "area", 0, 640, 0, 200
     END IF
 
   'Change Color
     IF mouseX% / 2 >= 200 AND mouseX% / 2 <= 296 AND mouseY% >= 177 AND mouseY% <= 198 AND mouseB% = 1 THEN
      vsmouse "hide", 0, 0, 0, 0
      LINE (210 + Red%(Index%), 81)-(210 + Red%(Index%), 85), 0
      LINE (210 + Green%(Index%), 97)-(210 + Green%(Index%), 101), 0
      LINE (210 + Blue%(Index%), 113)-(210 + Blue%(Index%), 117), 0
      Index% = POINT(mouseX% / 2, mouseY%)
      LINE (198, 160)-(206, 166), Index%, BF
      LINE (198, 160)-(206, 166), 8, B
      LOCATE 11, 36: PRINT "R"; Red%(Index%)
      LOCATE 13, 36: PRINT "G"; Green%(Index%)
      LOCATE 15, 36: PRINT "B"; Blue%(Index%)
      LINE (210 + Red%(Index%), 81)-(210 + Red%(Index%), 85), 15
      LINE (210 + Green%(Index%), 97)-(210 + Green%(Index%), 101), 15
      LINE (210 + Blue%(Index%), 113)-(210 + Blue%(Index%), 117), 15
      LOCATE 21, 31: PRINT "Indx"; Index%
      vsmouse "show", 0, 0, 0, 0
      oldX% = mouseX%
      oldY% = mouseY%
      DO
      vsmouse "get", 0, 0, 0, 0
      LOOP WHILE (oldX% = mouseX%) AND (oldY% = mouseY%) AND mouseB% = 1
     END IF

   'Increment Save
     IF mouseX% / 2 > 209 AND mouseX% / 2 < 217 AND mouseY% > 128 AND mouseY% < 134 AND mouseB% = 1 THEN
      Save% = Save% + 1
      LOCATE 17, 31: PRINT "Save"; Save%
      DO
      vsmouse "get", 0, 0, 0, 0
      LOOP WHILE mouseB% = 1
     END IF

   'Decrement Save
     IF mouseX% / 2 > 220 AND mouseX% / 2 < 228 AND mouseY% > 128 AND mouseY% < 134 AND mouseB% = 1 THEN
      Save% = Save% - 1
      LOCATE 17, 31: PRINT "Save"; Save%
      DO
      vsmouse "get", 0, 0, 0, 0
      LOOP WHILE mouseB% = 1
     END IF

   'Increment Load
     IF mouseX% / 2 > 209 AND mouseX% / 2 < 217 AND mouseY% > 144 AND mouseY% < 150 AND mouseB% = 1 THEN
      Load% = Load% + 1
      LOCATE 19, 31: PRINT "Load"; Load%
      DO
      vsmouse "get", 0, 0, 0, 0
      LOOP WHILE mouseB% = 1
     END IF

   'Decrement Load
     IF mouseX% / 2 > 220 AND mouseX% / 2 < 228 AND mouseY% > 144 AND mouseY% < 150 AND mouseB% = 1 THEN
      Load% = Load% - 1
      LOCATE 19, 31: PRINT "Load"; Load%
      DO
      vsmouse "get", 0, 0, 0, 0
      LOOP WHILE mouseB% = 1
     END IF
  
   'Save
     IF mouseX% / 2 > 198 AND mouseX% / 2 < 206 AND mouseY% > 128 AND mouseY% < 134 AND mouseB% = 1 THEN
      OPEN PATH$ + LTRIM$(RTRIM$(STR$(Save%))) + ".DDW" FOR OUTPUT AS #1
      FOR x% = 0 TO XSIZE% - 1
      FOR y% = 0 TO YSIZE% - 1
      PRINT #1, Pic%(x%, y%)
      NEXT y%
      NEXT x%
      CLOSE #1
      DO
      vsmouse "get", 0, 0, 0, 0
      LOOP WHILE mouseB% = 1
     END IF

   'Load
     IF mouseX% / 2 > 198 AND mouseX% / 2 < 206 AND mouseY% > 144 AND mouseY% < 150 AND mouseB% = 1 THEN
      OPEN PATH$ + LTRIM$(RTRIM$(STR$(Load%))) + ".DDW" FOR INPUT AS #1
      FOR x% = 0 TO XSIZE% - 1
      FOR y% = 0 TO YSIZE% - 1
      INPUT #1, Pic%(x%, y%)
      NEXT y%
      NEXT x%
      CLOSE #1
      FOR x% = 0 TO 189
      FOR y% = 0 TO 189
      IF x% MOD 3 = 0 AND y% MOD 3 = 0 THEN LINE (x% + 1, y% + 1)-(x% + 2, y% + 2), Pic%(x% / 3, y% / 3), BF
      NEXT y%
      NEXT x%
      FOR x% = 209 TO 272
      FOR y% = 0 TO 63
      PSET (x% + 1, y% + 1), Pic%(x% - 209, y%)
      NEXT y%
      NEXT x%
      DO
      vsmouse "get", 0, 0, 0, 0
      LOOP WHILE mouseB% = 1
     END IF
  
   'Increment Index
     IF mouseX% / 2 > 209 AND mouseX% / 2 < 217 AND mouseY% > 160 AND mouseY% < 166 AND mouseB% = 1 AND Index% <> 255 THEN
      vsmouse "hide", 0, 0, 0, 0
      LINE (210 + Red%(Index%), 81)-(210 + Red%(Index%), 85), 0
      LINE (210 + Green%(Index%), 97)-(210 + Green%(Index%), 101), 0
      LINE (210 + Blue%(Index%), 113)-(210 + Blue%(Index%), 117), 0
      Index% = Index% + 1
      LINE (198, 160)-(206, 166), Index%, BF
      LINE (198, 160)-(206, 166), 8, B
      LOCATE 11, 36: PRINT "R"; Red%(Index%)
      LOCATE 13, 36: PRINT "G"; Green%(Index%)
      LOCATE 15, 36: PRINT "B"; Blue%(Index%)
      LINE (210 + Red%(Index%), 81)-(210 + Red%(Index%), 85), 15
      LINE (210 + Green%(Index%), 97)-(210 + Green%(Index%), 101), 15
      LINE (210 + Blue%(Index%), 113)-(210 + Blue%(Index%), 117), 15
      LOCATE 21, 31: PRINT "Indx"; Index%
      vsmouse "show", 0, 0, 0, 0
      DO
      vsmouse "get", 0, 0, 0, 0
      LOOP WHILE mouseB% = 1
     END IF

   'Decrement Index
     IF mouseX% / 2 > 220 AND mouseX% / 2 < 228 AND mouseY% > 160 AND mouseY% < 166 AND mouseB% = 1 AND Index% <> 0 THEN
      vsmouse "hide", 0, 0, 0, 0
      LINE (210 + Red%(Index%), 81)-(210 + Red%(Index%), 85), 0
      LINE (210 + Green%(Index%), 97)-(210 + Green%(Index%), 101), 0
      LINE (210 + Blue%(Index%), 113)-(210 + Blue%(Index%), 117), 0
      Index% = Index% - 1
      LINE (198, 160)-(206, 166), Index%, BF
      LINE (198, 160)-(206, 166), 8, B
      LOCATE 11, 36: PRINT "R"; Red%(Index%)
      LOCATE 13, 36: PRINT "G"; Green%(Index%)
      LOCATE 15, 36: PRINT "B"; Blue%(Index%)
      LINE (210 + Red%(Index%), 81)-(210 + Red%(Index%), 85), 15
      LINE (210 + Green%(Index%), 97)-(210 + Green%(Index%), 101), 15
      LINE (210 + Blue%(Index%), 113)-(210 + Blue%(Index%), 117), 15
      LOCATE 21, 31: PRINT "Indx"; Index%
      vsmouse "show", 0, 0, 0, 0
      DO
      vsmouse "get", 0, 0, 0, 0
      LOOP WHILE mouseB% = 1
     END IF
 
   'Fill
     IF mouseX% / 2 > 198 AND mouseX% / 2 < 206 AND mouseY% > 160 AND mouseY% < 166 AND mouseB% <> 0 THEN
      FOR x% = 0 TO 63
      FOR y% = 0 TO 63
      Pic%(x%, y%) = (ABS(mouseB% - 2) * Index%)
      NEXT y%
      NEXT x%
      FOR x% = 0 TO 189
      FOR y% = 0 TO 189
      IF x% MOD 3 = 0 AND y% MOD 3 = 0 THEN LINE (x% + 1, y% + 1)-(x% + 2, y% + 2), Pic%(x% / 3, y% / 3), BF
      NEXT y%
      NEXT x%
      FOR x% = 209 TO 272
      FOR y% = 0 TO 63
      PSET (x% + 1, y% + 1), Pic%(x% - 209, y%)
      NEXT y%
      NEXT x%
      DO
      vsmouse "get", 0, 0, 0, 0
      LOOP WHILE mouseB% <> 0
     END IF
 
  LOOP UNTIL INKEY$ = CHR$(27)

'Save Palette
  IF PALINIT% = 1 THEN
 
     OPEN "PALETTE.DAT" FOR OUTPUT AS #1
     FOR n% = 0 TO 255
     PRINT #1, Red%(n%), Green%(n%), Blue%(n%)
     NEXT n%
     CLOSE #1

  END IF

FUNCTION vsINTERR% (a1%, a2%, a3%, a4%)

'----------------------------------------------------------------------------
SHARED mouse1() AS INTEGER

IF mouse1(0) <> 0 THEN
  a5% = VARPTR(mouse1%(0))
  DEF SEG = VARSEG(mouse1(0))
  POKE a5% + 26, &H33
  CALL ABSOLUTE(a1%, a2%, a3%, a4%, a5%)
  mouseInterr% = ax%
ELSE
  SCREEN 0
  PRINT : PRINT "Mouse error, program stopped"
  SYSTEM
END IF
'----------------------------------------------------------------------------

END FUNCTION

SUB vsmouse (action$, a1%, a2%, a3%, a4%)

'----------------------------------------------------------------------------
SHARED mouseX%, mouseY%, mouseB%

SELECT CASE action$
  CASE "get":      r% = vsINTERR%(3, mouseB%, mouseX%, mouseY%)
  CASE "show":     r% = vsINTERR%(1, bx%, cx%, dx%)
  CASE "hide":     r% = vsINTERR%(2, bx%, cx%, dx%)
  CASE "position": r% = vsINTERR%(4, bx%, a1%, a2%)
  CASE "area":     r% = vsINTERR%(7, 0, a1%, a2%)
                   r% = vsINTERR%(8, bx%, a3%, a4%)
  CASE "coord":    COLOR a3%
                   LOCATE a1%, a2%: PRINT "X"; mouseX%; "Y"; mouseY%; "    "
                   COLOR a4%
  CASE ELSE:       SCREEN 0
                   PRINT : PRINT "Error - Wrong mouse command"
                   SYSTEM
END SELECT
'----------------------------------------------------------------------------

END SUB

