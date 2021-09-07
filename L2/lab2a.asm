.INCLUDE "M32DEF.INC"
LDI R17, LOW(RAMEND) ; Initialize stack pointer
OUT SPL, R17
LDI R17, HIGH(RAMEND)
OUT SPH, R17
SER R17 ; Set R17
OUT DDRD, R17 ; PORTD as output
MAIN: OUT PORTD, R17 ; Output R17 to PORTD
CALL DELAY ; Call DELAY subroutine
ROL R17 ; Rotate leftward R17
RJMP MAIN ; Relative-jump to MAIN
DELAY: LDI R18, 0XFF ; Delay subroutine
COUNT1: SER R19 ; Set R19
COUNT2: DEC R19 ; Decrement R19
BRNE COUNT2 ; If R19 is not equal to 0, jump to COUNT2
DEC R18 ; Decrement R18
BRNE COUNT1 ; If R18 is not equal to 0, jump to COUNT1
RET ; End of the subroutine
