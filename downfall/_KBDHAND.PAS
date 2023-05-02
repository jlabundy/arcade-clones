{
  _KBDHAND.PAS Version 1.6  -  written by Ansgar Scherp, Joachim Gelhaus

  (c) vIRTUAL tECHNOLOGIES 1996

  Shareware-Version

  Distribition via any media is explicit allowed.

  DISCLAIMER:
  We give no warranty for this code, because it was firstly coded for us,
  and not for the public.
  But after lot of people asking us for releasing the source, we decided,
  to make it as unit available.
  But however, I really don't think that there is a bug in this unit.
  We use this handler in our own productions for years without
  any problems.

  for more information, questions and register contact us:

    Ansgar Scherp
    scherp.ansgar@informatik.uni-oldenburg.de

    Joachim Gelhaus
    j.gelhaus@flight.gun.de

    http://www.informatik.uni-oldenburg.de/~virtech/

    Hotline : + 49 (0) 4441 / 851717 (english, german)

  Please report any bugs and difficulties you have with these units,
  so that we can make this toolkit better.

}

unit _KBDHAND;

interface

uses dos;

var
  { tp get the key-statis, read out this array }
  key  : array[0..255] of byte;

const
  { Keys A - Z }
  kA           = $1E;
  kB           = $30;
  kC           = $2E;
  kD           = $20;
  kE           = $12;
  kF           = $21;
  kG           = $22;
  kH           = $23;
  kI           = $17;
  kJ           = $24;
  kK           = $25;
  kL           = $26;
  kM           = $32;
  kN           = $31;
  kO           = $18;
  kP           = $19;
  kQ           = $10;
  kR           = $13;
  kS           = $1F;
  kT           = $14;
  kU           = $16;
  kV           = $2F;
  kW           = $11;
  kX           = $2D;
  kY           = $15;
  kZ           = $2C;

  { Keys 0 - 9 }
  k0           = $0B;
  k1           = $02;
  k2           = $03;
  k3           = $04;
  k4           = $05;
  k5           = $06;
  k6           = $07;
  k7           = $08;
  k8           = $09;
  k9           = $0A;


  { Cursor - Keys }
  kLARROW      = $CB;
  kRARROW      = $CD;
  kUARROW      = $C8;
  kDARROW      = $D0;

  { Keypad 0 - 9 }
  kKEYPAD0     = $52;
  kKEYPAD1     = $4F;
  kKEYPAD2     = $50;
  kKEYPAD3     = $51;
  kKEYPAD4     = $4B;
  kKEYPAD5     = $4C;
  kKEYPAD6     = $4D;
  kKEYPAD7     = $47;
  kKEYPAD8     = $48;
  kKEYPAD9     = $49;

  { other Keypad - Keys }
  kKEYPADDEL   = $53;
  kKEYPADSTAR  = $37;
  kKEYPADMINUS = $4A;
  kKEYPADPLUS  = $4E;
  kKEYPADENTER = $9C;

  { Shift - Keys }
  kLEFTSHIFT   = $2A;
  kRIGHTSHIFT  = $36;

  { CTRL - Keys }
  kLEFTCTRL    = $1D;
  kRIGHTCTRL   = $9D;

  { ALT - Keys }
  kLEFTALT     = $38;
  kRIGHTALT    = $B8;

  { Textmanipulating - Keys }
  kSPACE       = $39;
  kENTER       = $1C;
  kBACKSPACE   = $0E;
  kESC         = $01;
  kTAB         = $0F;

  { Function - Keys }
  kF1          = $3B;
  kF2          = $3C;
  kF3          = $3D;
  kF4          = $3E;
  kF5          = $3F;
  kF6          = $40;
  kF7          = $41;
  kF8          = $42;
  kF9          = $43;
  kF10         = $44;
  kF11         = $57;
  kF12         = $58;

  { other keys }
  kPGUP        = $C9;
  kPGDN        = $D1;
  kINS         = $D2;
  kDEL         = $D3;
  kHOME        = $C7;
  kEND         = $CF;



  kMINUS       = $0C;
  kEQUAL       = $0D;
  kLBRACKET    = $1A;
  kRBRACKET    = $1B;
  kSEMICOLON   = $27;
  kTICK        = $28;
  kAPOSTROPHE  = $29;
  kBACKSLASH   = $2B;
  kCOMMA       = $33;
  kPERIOD      = $34;
  kSLASH       = $35;

  kCTRLPRTSC   = $B7;
  kSHIFTPRTSC  = $B7;

  kKEYPADSLASH = $B5;

  kSYSREQ      = $54;
  kCAPSLOCK    = $3A;
  kNUMLOCK     = $45;
  kSCROLLLOCK  = $46;

{ Supported procedures and functions }

{ use to initialize the Keyboard - Handler }
procedure InitKBDHandler;
{ use to deinstall the Keyboard - Handler }
procedure CloseKBDHandler;

{ get the Keyboard ScanCode }
function GetScanCode:byte;

{ checks if any key is pressed }
function KeyPressed:boolean;

{ waits for a key pressed and returns the character of the key
  Attention: This function ist NOT COMPATIBLE with the build in
             function ReadKey from Turbo/Borland Pascal }
function ReadKey:char;

implementation

const
  Copyright = '(c) vIRTUAL tECHNOLOGIES 1993-1996 - Ansgar Scherp, Joachim Gelhaus';

{ *** for more, please contact us *** }

var
  OldINT9 : pointer;
  e0flag  : byte;

{$f+}
procedure NewInt9; interrupt;
begin
  asm
    cli
    push    ds
    push    ax
    push    bx

    mov     ax,seg(Key)
    mov     ds,ax

    in      al,60h          { Get scan code in AL }

    cmp     al,0E0h         { was it an E0 key?   }
    jne     @setscancode

    { E0 key routine }
    mov     [e0flag],128
    mov     al,20h          { Send generic EOI to PIC                  }
    out     20h,al          { 001 00 000                               }
                            {  |   |  |                                }
                            {  |   |  +--- INT r=est level             }
                            {  |   +------ OCW2                        }
                            {  +---------- non-specific EOI command    }
    jmp @done
      @setscancode:
        mov     bl,al                   { Save scan code in BL}
        and     bl,01111111b
        add     bl,[e0flag]
        xor     bh,bh                   { clear for index use          }
        and     al,10000000b            { keep break bit, if set       }
        xor     al,10000000b            { flip bit - 1 means pressed}
                                        {          - 0 means released  }
        rol     al,1                    { put it in bit 0              }
        mov     [offset(Key) + bx],al   { set index for key            }
        mov     [e0flag],0

        mov     al,20h          { Send generic EOI to PIC               }
        out     20h,al          { 001 00 000                            }
                                {  |   |  |                             }
                                {  |   |  +--- INT request level        }
                                {  |   +------ OCW2                     }
                                {  +---------- non-specific EOI command }
  @done:
    pop     bx
    pop     ax
    pop     ds
    sti
  end;
end;
{$F-}

procedure SetNewInt9;
begin
  GetIntVec( 9, OldInt9 );
  asm cli end;
  SetIntVec( 9, @NewInt9 );
  asm sti end;
end;


procedure SetOldInt9;
begin
  asm cli end;
  SetIntVec( 9, OldInt9 );
  asm sti end;
end;

function GetScanCode:byte;
var z:byte;
begin
  z:=0;
  GetScanCode := 0;
  repeat
    inc(z);
    if Key[z] > 0 then GetScanCode:=z;
  until z = 0 ;
end;

function ReadScanCode:byte;
var z:byte;
begin
  z:=0;
  repeat
    inc(z);
  until Key[z]>0;
  ReadScanCode:=z;
end;

function KeyPressed:boolean;
var z:byte;
    p:boolean;
begin
  z:=0;
  p := false;
  repeat
    if (Key[z]>0) then p := true;
    inc(z);
  until (z=0) or (p=true);
  keypressed:=p;
end;

function ReadKey:Char;
  var code : byte;
      c : char;
begin
  repeat until GetScanCode=0;
  code := ReadScanCode;
  case code of
    kSYSREQ       : c := #0;
    kCAPSLOCK     : c := #0;
    kNUMLOCK      : c := #0;
    kSCROLLLOCK   : c := #0;
    kLEFTCTRL     : c := #0;
    kLEFTALT      : c := #0;
{    kLEFTSHIFT    : c := #0;}
    kRIGHTCTRL    : c := #0;
    kRIGHTALT     : c := #0;
{    kRIGHTSHIFT   : c := #0;}
    kESC          : c := #27;
    kBACKSPACE    : c := #8;
    kENTER        : c := #13;
    kSPACE        : c := ' ';
    kTAB          : c := #9;
    kF1           : c := #0;
    kF2           : c := #0;
    kF3           : c := #0;
    kF4           : c := #0;
    kF5           : c := #0;
    kF6           : c := #0;
    kF7           : c := #0;
    kF8           : c := #0;
    kF9           : c := #0;
    kF10          : c := #0;
    kF11          : c := #0;
    kF12          : c := #0;
    kA            : c := 'a';
    kB            : c := 'b';
    kC            : c := 'c';
    kD            : c := 'd';
    kE            : c := 'e';
    kF            : c := 'f';
    kG            : c := 'g';
    kH            : c := 'h';
    kI            : c := 'i';
    kJ            : c := 'j';
    kK            : c := 'k';
    kL            : c := 'l';
    kM            : c := 'm';
    kN            : c := 'n';
    kO            : c := 'o';
    kP            : c := 'p';
    kQ            : c := 'q';
    kR            : c := 'r';
    kS            : c := 's';
    kT            : c := 't';
    kU            : c := 'u';
    kV            : c := 'v';
    kW            : c := 'w';
    kX            : c := 'x';
    kY            : c := 'y';
    kZ            : c := 'z';
    k1            : c := '1';
    k2            : c := '2';
    k3            : c := '3';
    k4            : c := '4';
    k5            : c := '5';
    k6            : c := '6';
    k7            : c := '7';
    k8            : c := '8';
    k9            : c := '9';
    k0            : c := '0';
    kMINUS        : c := '-';
    kEQUAL        : c := '=';
    kLBRACKET     : c := '(';
    kRBRACKET     : c := ')';
    kSEMICOLON    : c := ';';
    kTICK         : c := #0;
    kAPOSTROPHE   : c := #0;
    kBACKSLASH    : c := '\';
    kCOMMA        : c := ',';
    kPERIOD       : c := #0;
    kSLASH        : c := '/';
    kINS          : c := #0;
    kDEL          : c := #8;
    kHOME         : c := #0;
    kEND          : c := #0;
    kPGUP         : c := #0;
    kPGDN         : c := #0;
    kLARROW       : c := #0;
    kRARROW       : c := #0;
    kUARROW       : c := #0;
    kDARROW       : c := #0;
    kKEYPAD0      : c := '0';
    kKEYPAD1      : c := '1';
    kKEYPAD2      : c := '2';
    kKEYPAD3      : c := '3';
    kKEYPAD4      : c := '4';
    kKEYPAD5      : c := '5';
    kKEYPAD6      : c := '6';
    kKEYPAD7      : c := '7';
    kKEYPAD8      : c := '8';
    kKEYPAD9      : c := '9';
    kKEYPADDEL    : c := #0;
    kKEYPADSTAR   : c := '*';
    kKEYPADMINUS  : c := '-';
    kKEYPADPLUS   : c := '+';
    kKEYPADENTER  : c := #13;
    kCTRLPRTSC    : c := #0;
    kSHIFTPRTSC   : c := #0;
    kKEYPADSLASH  : c := #0;
  end;
  Readkey := c;
end;

procedure InitKBDHandler;
begin
  SetNewINT9;
end;

procedure CloseKBDHandler;
begin
  SetOldINT9;
end;

var
  t : string;

begin
 t := copyright;
end.
