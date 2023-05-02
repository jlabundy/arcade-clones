DIM pic%(0 TO 63, 0 TO 63)

NUM% = 0
XSIZE% = 64
YSIZE% = 64
SRCPATH$ = ""
UNITPATH$ = ""
TITLE$ = ""
UNITNAME$ = ""
ARRAYNAME$ = ""

d$ = DATE$
t$ = TIME$

IF MID$(SRCPATH$, LEN(SRCPATH$), 1) <> "\" THEN SRCPATH$ = SRCPATH$ + "\"

OPEN UNITPATH$ FOR OUTPUT AS #1

  PRINT #1,
  PRINT #1, "{ " + TITLE$ + " }"
  PRINT #1, "{ This file was generated on " + d$ + " at " + t$ + " }"
  PRINT #1,
  PRINT #1, "unit " + UNITNAME$ + ";"
  PRINT #1,
  PRINT #1,
  PRINT #1, "interface"
  PRINT #1,
  PRINT #1,
  PRINT #1, " {" + ARRAYNAME$ + " Data}"
  PRINT #1,
  PRINT #1, "  type " + ARRAYNAME$ + "data = array[0.." + LTRIM$(RTRIM$(STR$(NUM% - 1))) + ", 0.." + LTRIM$(RTRIM$(STR$(XSIZE% - 1))) + ", 0.." + LTRIM$(RTRIM$(STR$(YSIZE% - 1))) + "] of byte;"
  PRINT #1,
  PRINT #1, "  const " + ARRAYNAME$ + " : " + ARRAYNAME$ + "data = ("
 
  FOR load% = 0 TO NUM% - 1
   
    PRINT #1,
   
    SELECT CASE load%
    CASE ELSE: tile$ = ""
    END SELECT

    PRINT #1, " { " + tile$ + " }"
    PRINT #1,
    PRINT #1, "  ("
    PRINT #1,
   
    OPEN SRCPATH$ + LTRIM$(RTRIM$(STR$(load%))) + ".DDW" FOR INPUT AS #2
    FOR x% = 0 TO XSIZE% - 1
    FOR y% = 0 TO YSIZE% - 1
    INPUT #2, pic%(x%, y%)
    NEXT y%
    NEXT x%
    CLOSE #2
 
    FOR x% = 0 TO XSIZE% - 1
   
        feed$ = "  ("
   
        FOR y% = 0 TO YSIZE% - 1
     
        pixel$ = RTRIM$(LTRIM$(STR$(pic%(x%, y%))))
        pixel$ = STRING$(3 - LEN(pixel$), CHR$(32)) + pixel$

        feed$ = feed$ + pixel$
       
        IF x% = XSIZE% - 1 THEN
        IF (y% = YSIZE% - 1) THEN feed$ = feed$ + ")" ELSE feed$ = feed$ + ","
        ELSE
        IF (y% = YSIZE% - 1) THEN feed$ = feed$ + ")," ELSE feed$ = feed$ + ","
        END IF
       
        NEXT y%
        PRINT #1, feed$
   
    NEXT x%

    PRINT #1,
    IF load% = NUM% - 1 THEN PRINT #1, "  )" ELSE PRINT #1, "  ),"
    PRINT #1,
 
  NEXT load%
 
  PRINT #1,
  PRINT #1, ");"



  PRINT #1,
  PRINT #1,
  PRINT #1, "implementation"
  PRINT #1,
  PRINT #1, "begin"
  PRINT #1, "end."

  CLOSE #1

