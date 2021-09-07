;
; Prelab.asm
;
; Created: 6/10/2017 7:55:40 PM
; Author : Daniel
;
;************************************************
;PORTA gets the input from the slide Switches
;PORTB controls the external LEDs
;PORTC gets the input from the onboard switchs
;PORTD controls the STK600 Built-in LEDS
;
;R17 -->Stores the number from the slide switches
;R20 -->First Operand of Multiplication
;R21 -->Second Operand of Multiplication
;************************************************
.INCLUDE "M32DEF.INC"
	LDI		R18, LOW(RAMEND); Initialize stack pointer
	OUT		SPL, R18
	LDI		R18, HIGH(RAMEND)
	OUT		SPH, R18
	CLR		R20				; Initialize R20 to 0
	CLR		R21				; Initialize R21 to 0
MAIN:
	;Setup output ports
	SER		R18
	OUT		DDRD, R18		; Set PORTD as an output port
	OUT		PORTD, R18		; Light off LEDs
	OUT		DDRB, R18		; Set PORTB as an output port
	OUT		PORTB, R18		; Light off LEDs
	;Setup input ports
	CLR		R18
	OUT		DDRC, R18		; Set PORTC as an input port
	OUT		DDRA, R18		; Set PORTA as an input port
	
	IN		R17, PINA		; Read from PINA which number was inputed
	OUT		PORTB, R17		; Output the number from R17 to the external LEDs
	CPI		R20, 0x00		; Check if something is in R20
	BRNE	CONTINUE		; If R20 is not equal to 0 goto CONTINUE
	LDI		R19, PORTC		; Get the status of PORTC
	CPI		R19, 0B00000001	; See if SWO was pressed
	BRNE	MAIN			; If SWO was pressed go to OUTNUM1
	MOV		R20, R17		; Move the number from the slide switches to a register if SW0 was pressed
CONTINUE:
	CPI		R20, 0x00		; Check if something is in R20
	BREQ	MAIN			; Go back to the beginning if nothing is in R20
	IN		R17, PINA		; Read from PINA which number was inputed
	OUT		PORTB, R17		; Output the number from R17 to the external LEDs
	LDI		R19, PORTC		; Get the status of PORTC
	CPI		R19, 0B10000000 ; See of SW7 was pressed
	BRNE	 MAIN			; If SW7 was not pressed go back to the beginning
	MOV		R21, R17		; Move the number from the slide switches to a register if the SW7 was pressed
	MUL		R21, R20		; Multiply the contents of R21 and R20 together
	OUT		PORTD, R1		; Display the high byte of the result on the bulit-in LEDs
	OUT		PORTB, R0		; Display the low byte of the result on the STK600 LEDs
DONE:
	RJMP	DONE			; The program must be reset			


