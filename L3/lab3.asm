;
; lab3.asm
;
; Created: 6/11/2017 8:59:40 PM
; Author : Daniel Power
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
MAIN:	
	IN		R17, PINA		; Read from PINA which number was inputed
	OUT		PORTB, R17		; Output the number from R17 to the external LEDs
	IN		R19, PINC		; Get the status of PORTC
	SBRC	R19, 0			; Skip the next instruction if SW0 was pressed
	RJMP	MAIN			; Jump back to MAIN if SW0 was not pressed
	MOV		R20, R17		; Move the number from the slide switches to a register if SW0 was pressed
	
CONTINUE:
	IN		R17, PINA		; Read from PINA which number was inputed
	OUT		PORTD, R17		; Output the number from R17 to the external LEDs
	IN		R19, PINC		; Get the status of PORTC
	SBRC	R19, 7			; Skip the next instruction if SW7 was pressed
	RJMP	CONTINUE		; Jump back to CONTINUE if SW7 was not pressed
	MOV		R21, R17		; Move the number from the slide switches to a register if the SW7 was pressed
	
	COM		R21				; Complement R21 (the LEDs are active LOW)
	COM 	R20				; Complement R20
	MUL		R21, R20		; Multiply the contents of R21 and R20 together
	
	COM		R0				; Complement R0
	COM		R1				; Complement R1
	OUT		PORTD, R1		; Display the high byte of the result on the bulit-in LEDs
	OUT		PORTB, R0		; Display the low byte of the result on the STK600 LEDs
DONE:
	RJMP	DONE			; The program must be reset			


