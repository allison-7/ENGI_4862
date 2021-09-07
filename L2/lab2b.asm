; ************************************************
;	  Gun Fight at the STK600 Corral
;
; Based on program number 94 from Science Fair
; Microcomputer Trainer (Radio Shack). Revised 
; by Reza Shomalnasab and Lihong Zhang.
;
; After running the program, the middle LEDs (ie, LED3 and LED4) will
; rapidly blink on and off. When the lights stop
; blinking, the first player to fire (by pressing
; the push-button switch SW0 or SW7) will win. If
; you fire too soon, you will lose!
;
; Note that this program deliberately includes bugs.
;
; ************************************************

.INCLUDE "M32DEF.INC"

; Register =========>  Purpose
;  R16 			LED
;  R17 			SWITCHES
;  R18			temporary variable
;  R19			number of blinking times
;  R20			outer counter for time delay
;  R21 			inner counter for time delay
	
	LDI		R18, LOW(RAMEND)	; Initialize stack pointer
	OUT		SPL, R18
	LDI		R18, HIGH(RAMEND)
	OUT		SPH, R18

	SER		R18
	OUT		DDRD, R18	; Set PORTD as an output port (Note that PORTD is connected to LEDS) 
	OUT		PORTD, R18	; Light off LEDs
	MOV		R16, R18

	CLR		R18
	OUT		DDRB, R18	; Set PORTB as an input port (Note that PORTB is connected to SWITCHES)



REP2:	LDI		R20, 7F		
REP1:	IN		R17, PINB	; Read the current switches to see any misfire
	CPI		R17, 0XFF
	BRNE	MISFIRE

COUNT1:	SER 	REG21	; Delay a while (about 1/5 second)
COUNT2: DEC 	R21
	BRNE	COUNT2
	DECR 	R20			
	BRNE	REP1

	LDI		R18, 0B00011000	; Invert R16 for flashing effect
	EOR		R16, R18
	OUT		PORTD, R16	; Output to LEDs

	DEC		R19
	BRNE	REP2

	LDI		R16, 0B11100111
	OUT		PORTD, R16

REP3:	SER 	R21	; A very short delay
REP4: 	DEC 	R21
	BRNE	REP4

	INI		R17, PINB		
	CMP		R17, 0xFF		
	BREQ	REP3

	CPI		R17, 0B01111111
	BREQ	PLAYER1_WINS

PLAYER2_WINS:
	LDI		R16 0B11100110	
	RJMP	DONE

PLAYER1_WINS:
	LDI		R16, 0B01100111
	RJMP	DONE

MISFIRE						
	CPI		R17, 0B01111111
	BREQ	PLAYER1_LOSES

PLAYER2_LOSES:
	LDI		R16, 0B11111101
	RJMP	DONE

PLAYER1_LOSES:
	LDI		R16, 0B10111111
	RJMP	DONE

DONE:
	OUT		PORT_D, R16	
	RJMP	DON			
