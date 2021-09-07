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

LOOP1:

	SER		R18
	OUT		DDRD, R18	; Set PORTD as an output port (Note that PORTD is connected to LEDS) 
	OUT		PORTD, R18	; Light off LEDs
	MOV		R16, R18

	CLR		R18
	OUT		DDRB, R18	; Set PORTB as an input port (Note that PORTB is connected to SWITCHES)

	IN		R17, PINB 	; Read from PINB which SWITCH was pressed
	OUT		PORTD,	R17	; OUTPUT the value in R17 to PORTD
	RJMP	LOOP1 		; Loop forever
