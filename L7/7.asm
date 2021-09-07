;7.asm
/*************************************************************
*PORTB --> An input port that is connected to the switches
*PORTD --> An output port that is connected to the DAC
*
*R18 --> Holds the status of the switches on PORTB
*R19 --> The number that is outputed to the DAC
*************************************************************/
.INCLUDE "M32DEF.INC"
LDI		R18, LOW(RAMEND)	;Initialize stack pointer
OUT		SPL, R18
LDI		R18, HIGH(RAMEND)
OUT		SPH, R18

SER		R16			;R16=0xFF
OUT		DDRD, R16	;Make PORTD an output port

CBI		DDRB, 0		;Make SWO on PORTB an input switch
CLR		R17
PLUS:
IN		R18, PINB
COM		R18
CPI		R18, 1		;Active LOW
BREQ	STOP		;If SWO was pressed we are done
OUT		PORTD, R19
INC		R19
;To generate a triangle wave
CPI		R19, 0xFF
BREQ	MINUS
;To 1/2 the voltage
/*CPI		R19, 0x7F
BREQ	CLEAR*/
CALL	DELAY
JMP		PLUS
/*CLEAR:
CLR		R19
CALL	DELAY*/
JMP		PLUS
DELAY:
LDI		R16, 1		;A short delay; modify this to change the output frequency
LOOP:
DEC		R16
BRNE	LOOP
RET
STOP:
JMP		STOP		;Stay here forever
MINUS:
IN		R18, PORTA
CPI		R18, 0		;Active LOW
BREQ	STOP		;If SWO was pressed we are done
OUT		PORTD, R19
DEC		R19
CPI		R19, 0
BREQ	PLUS
CALL	DELAY
JMP		MINUS
