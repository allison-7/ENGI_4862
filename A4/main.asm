;
; 4.asm
;
; Created: 7/8/2017 7:13:41 PM
; Author : Daniel
;
.INCLUDE "M32DEF.INC"
;1b
/*CALL	DELAY
DELAY :			;Delay (cycles)
	LDI 	R16, 250	;1
OUTER :
	LDI 	R17, 155	;1
INNER :
	DEC 	R17		;1
	BRNE 	INNER		;1 or 2
	DEC 	R16		;1
	BRNE 	OUTER		;1 or 2
	RET			;8*/
;2a
/*BEGIN:
LDI		R17, 136		
OUT		TCNT0, R17		;Load Timer 0
LDI		R17, 0B00000001
OUT		TCCR0, R17		;Setup a prescaler of 1
AGAIN:
IN		R17, TIFR		;Get input from the timer
SBRS	R17, TOV0		;If TOVO is set skip the next instruction
RJMP	AGAIN
CLR		R17
OUT		TCCR0, R17		;Stop Timer0
LDI		R17, 0x01
OUT		TIFR, R17		;Clear TOV0 flag
RJMP	BEGIN*/
;2b
/*LDI		R20, 99
OUT		OCR0,R20	;load timer0
BEGIN: 
LDI		R20,0x09
OUT		TCCR0,R20	;Timer0,CTC mode
AGAIN: 
IN		R20,TIFR	;read TIFR
SBRS	R20,OCF0	;if OCF0 is set skip next
RJMP	AGAIN
CLR		R20
OUT		TCCR0,R20	;stop Timer0
LDI		R20,0x02
OUT		TIFR,R20	;clear OCF0 flag
RJMP	BEGIN*/
;2c
/*LDI		R19, 0B1000000
SBI		DDRD, 7
CLR		R20
BEGIN:
LDI		R17, 5		
OUT		TCNT0, R17		;Load Timer 0
LDI		R17, 0B00000001
OUT		TCCR0, R17		;Setup a prescaler of 1
AGAIN:
IN		R17, TIFR		;Get input from the timer
SBRS	R17, TOV0		;If TOVO is set skip the next instruction
RJMP	AGAIN
CLR		R17
OUT		TCCR0, R17		;Stop Timer0
LDI		R17, 0x01
OUT		TIFR, R17		;Clear TOV0 flag
EOR		R20, R19
OUT		PORTD, R20
RJMP	BEGIN*/
;2d
/*SER		R16
OUT		DDRC, R16	;Make PORTC an output port
OUT		DDRD, R16	;Make PORTD an output port
;25000=0x61A8
LDI		R16,0x61
OUT		OCR1AH,R20
LDI		R20,0xA8
OUT		OCR1AL,R20 
AGAIN:
LDI		R20,0x0
OUT		TCCR1A,R20
LDI		R20,0x0E	;0b0000 1110
OUT		TCCR1B,R20	;CTC Mode (4), counter, falling edge
CLR		R21
CLR		R22
L1:
IN		R20,TIFR
INC		R21			;Lower byte
OUT		PORTD, R21
CPI		R21, 0xFF
BRNE	C			;If R21 is full
CLR		R21
INC		R22			;Higher byte
OUT		PORTC, R21
C:
SBRS	R20,OCF1A
RJMP	L1			;keep doing it
LDI		R20,1<<OCF1A ;clear OCF1A flag
OUT		TIFR, R20
LDI		R20, 0
CLR		R21
CLR		R22
OUT		TCCR1A, R20
OUT		TCCR1B, R20
RJMP AGAIN ;keep doing it*/
;3
.ORG 	0
LDI 	R16, HIGH (RAMEND)
OUT 	SPH, R16
LDI 	R16, LOW(RAMEND)
OUT 	SPL, R16
LDI 	R16, 0xFF
OUT 	DDRA, R16
CLR 	R16
OUT 	DDRB, R16

BACK:
	IN 	R24, PINB
	CALL 	DELAY
	OUT 	PORTA, R24
	CALL 	DELAY
	INC		R16
	LDI		R17, 1
	ADD		R16, R17
	CPI 	R16, 100
	BRNE 	BACK

.ORG 0X60
DELAY:
	PUSH 	R24
	LDI 	R24, 0XCE
AGAIN :
	DEC 	R24
	BRNE 	AGAIN
	POP 	R24
	RET
;4
/*.CSEG
.ORG 0x00
CLR		R18
LDI		ZL, LOW(SOURCE_STR<<1)	;Z stores the source string
LDI		ZH, HIGH(SOURCE_STR<<1)	
LDI		XL, LOW(DEST_STR)		;X stores the destination string
LDI		XH, HIGH(DEST_STR)
LDI		R16, 255				;Counter
LOOP:
LPM		R17, Z
CPI		R17, 0x41				;If less than 'A'
BRCS	OUTER1
CPI		R17, 0x7A				;If less than 'Z'
BRCS	OUTER1
CPI		R17, 0					;If we found a symbol
BRNE	OUTER2
CPI		R17,0
BREQ	ALMOSTDONE				;If we found '0'
OUTER1:
;Further symbol checking
CPI		R17, 0x5B				;If greater than '['
BRCC	OUTER2
CPI		R17, 0x60				;If less than 'accent'
BRCS	OUTER2
INC		R18						;If we found a letter than increment R18
OUTER2:
ST		X, R17
INC		ZL
INC		XL
DEC		R16
BRNE	LOOP
ALMOSTDONE:
CPI		R18, 0
BRNE	ZERO
DONE:
JMP		DONE
ZERO:
CLR		R20
STS		0x100, R20				;Store 0 in DEST_STR
JMP		DONE
.CSEG
.ORG 0x250
SOURCE_STR:
.DB "This is an example string that *should* be copied.", 0

.DSEG
.ORG 	0x100
DEST_STR: .BYTE 25*/

;5
/*.INCLUDE "M32DEF.INC"
.CSEG
.ORG	0x100
DATA1:	.DB "2468101214"
DATA2:	.DB "1357911130"

.DSEG
.ORG	0x100
RESULT:	.BYTE 11
DATA1_BUFFER:	.BYTE 11
DATA2_BUFFER:	.BYTE 11
;*************************
.CSEG
.ORG 0x0	;Start at the beginning of memory
;Setup the stack pointer
LDI		R16, LOW (RAMEND)
OUT		SPL, R16
LDI		R16, HIGH (RAMEND)
OUT		SPH, R16
;Begin loading DATA1
LDI		ZL, LOW (DATA1<<1)		;Setup a pointer to the first byte of DATA1
LDI		ZH, HIGH (DATA1<<1)
LDI		XL, LOW (DATA1_BUFFER)	;Setup a pointer to the buffer
LDI		XH, HIGH (DATA1_BUFFER)
LDI		R16, 11
MOV		R0, R16
CALL	COPY_BUFFER	;Copy the data from ROM to RAM
;Begin loading DATA2
LDI		ZL, LOW (DATA2<<1)		;Setup a pointer to the first byte of DATA2
LDI		ZH, HIGH (DATA2<<1)
LDI		XL, LOW (DATA2_BUFFER)	;Setup a pointer to the buffer
LDI		XH, HIGH (DATA2_BUFFER)
LDI		R16, 11
MOV		R0, R16
CALL	COPY_BUFFER	;Copy the data from ROM to RAM
;Setup pointers to the end of the buffers
LDI		XL, LOW (DATA1_BUFFER + 10)
LDI		XH, HIGH (DATA1_BUFFER + 10)
LDI		YL, LOW (DATA2_BUFFER + 10)
LDI		YH, HIGH (DATA2_BUFFER + 10)
LDI		ZL, LOW (RESULT + 10)
LDI		ZH, HIGH (RESULT + 10)
LDI		R16, 11
CLC								;Clear the carry flag
NEXT:
LD		R0, X
LD		R1, Y
CALL	ASCII_ADD				;Add the two numbers together
ST		Z, R0					;Store the result in the Z register
DEC		XL
DEC		YL
DEC		ZL
DEC		R16
BRNE	NEXT					;Keep looping until all the bytes have been added
DONE:
RJMP	DONE
;*********************************************************************************
;Copy the ASCII numbers from ROM to RAM
;Z points to the numbers in ROM
;X points to the numbers in RAM
;R0 is for iteration
COPY_BUFFER:
PUSH	R16
LOOP:
LPM		R16, Z+					;Load from program memory and post-increment z
ST		X+, R16					;Store R16 in RAM and post-increment X
DEC		R0
BRNE	LOOP					;Keep looping until all the numbers are stored in RAM
POP		R16
RET
;************************************************************************************
;Perfrom ASCII Addition
;For the ASCII adjustment (after regular additon ADC) the algorithm is
;a) if C=1, subtract 6 from the lower 4 bits of the result.
;b) make the upper nibble 0x30
ASCII_ADD:
PUSH	R16
PUSH	R17
ADC		R0, R1
IN		R17, SREG				;Restore the status register
MOV		R16, R0
BRCC	SKIP					;Branch if carry cleared
SUBI	R16, 0x06
SKIP:
ANDI	R16, 0x06
ORI		R16, 0x0F
MOV		R0, R16
OUT		SREG, R17				;Restore the status register
POP		R17
POP		R16
RET*/
