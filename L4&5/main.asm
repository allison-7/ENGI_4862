;***************************************************************
;*Lab 4 and 5 - Rat Basher
;*Daniel Power & Libin Wen
;*
;*R16 -->Score 
;*R17 -->Switches' status
;*R23 -->Random Seed
;*R27 -->Random Pin
;*R31 -->Pin to be lit
;*
;*PORTB -->Switches
;*PORTD -->LEDs
;*
;*HammerWait -->A simple 1s delay function
;*Random -->Generate a random number
;*Exponent -->Perform 2^R27
;*DisplayRat -->Light an LED
;*ScoreIncrement -->Increment the score if a switch was pressed
;*ShowScore -->Display the contents of R16 on the LEDs
;***************************************************************
.INCLUDE "M32DEF.INC"
	LDI		R18, LOW(RAMEND)	;Initialize stack pointer
	OUT		SPL, R18
	LDI		R18, HIGH(RAMEND)
	OUT		SPH, R18
	LDI		R27, 6				;Random Seed (must be less than m)
	LDI		R28, 8				;Number of rounds 
;Setup switches
	CLR		R16			;Set R16 to 0
	OUT		DDRB, R16	;Set PORTB as an input port
;Setup LEDs
	SER 	R17			;Set R17 to 0xFF
	OUT 	DDRD, R17	;Set PORTD as an output port
;Blink LEDs 3 times
	LDI		R20, 6
BLINK:
	LDI		R18, 0xFF	;The Delay period
;LOOP for about 1s 
WAIT:
	LDI 	R19, 0xFF
WAIT2:
	DEC		R19
	BRNE	WAIT2
	DEC		R18
	BRNE	WAIT
	OUT		PORTD, R16	;Blink the LEDs
	COM		R16			;Complement for blinking effect
	DEC		R20
	BRNE	BLINK
;Wait for another second before the game begins
	SER		R16
	OUT		PORTD, R16	;Turn off the LEDs
	CLR		R16 
	CALL	DisplayRat
	CALL	ShowScore
	JMP	DONE
;Loop for a second & check the switches' status
HammerWait:
	LDI		R18, 0xFF
LOOP1:
	LDI		R19, 0xFF
LOOP2:
	IN		R17, PINB 	;Get the status of the switches
	CPI		R17, 0xFF	;The switches are active low
	BRNE	DONELOOP	;Break if we get a value
	DEC		R19
	BRNE	LOOP2
	DEC		R18
	BRNE	LOOP1
DONELOOP:
	RET 
;Generate Random Number
;Linear congruential generator
;X_n+1 = (aX_n + c) mod m
Random: 
	LDI		R25, 3		;a
	LDI		R26, 1		;c
	MUL		R25, R27	;R27 is X_n
	ADD		R26, R0
	LDI		R29, 7		;m
	AND		R29, R26	;modulus
	MOV		R27, R29
	CALL	Exponent
	RET
;Perform 2^R27
Exponent:
	PUSH	R30
	LDI		R31, 0B0000001;Load 2^0
	MOV		R30, R27
L1:
	LSL		R31			;2^R27
	DEC		R30
	BRNE	L1
	POP		R30
	RET
DisplayRat:
	CLR		R30
	CALL	Random
	COM		R31
	OUT		PORTD, R31 	;Light a random LED 
	COM		R31
	CLR		R17
	CALL	HammerWait	;Wait 1 second & get the switches' status
	CALL 	HammerWait
	INC		R30			;Increment the round counter
	CP		R31, R17	;Check if the correct switch was pressed
	BREQ	ScoreIncrement;Increment the score if the switch was pressed 
HERE:
	DEC		R28			;Decrement the score counter
	BRNE	DisplayRat	;Keep looping until we are done
	RET
;Increment the score if a rat was hit
ScoreIncrement:
	PUSH	R15
	CLR		R15
	CP		R15, R30	;Check which round it is
	BREQ	S0			;If it round 0 then S0
	INC		R15 
	CP		R15, R30	;Check which round it is
	BREQ	S1			;If it round 1 then S1
	INC		R15
	CP		R15, R30	;Check which round it is 
	BREQ	S2			;If it round 2 then S2
	INC 	R15
	CP		R15, R30	;Check which round it is
	BREQ	S3			;If it round 3 then S3
	INC		R15
	CP		R15, R30	;Check which round it is 
	BREQ	S4			;If it round 4 then S4
	INC		R15 
	CP		R15, R30	;Check which round it is
	BREQ	S5			;If it round 5 then S5
	INC		R15 
	CP		R15, R30	;Check which round it is 
	BREQ	S6			;If it round 6 then S6
	INC		R15 
	CP		R15, R30	;Check which round it is 
	BREQ	S7			;If it round 7 then S7
EXIT: 					;Exit when we are done
	POP		R15 
	JMP		HERE
;Sn --> OR the current round with the score register
S0:
	ORI		R16, 0B00000001
	JMP 	EXIT
S1:
	ORI		R16, 0B00000010
	JMP 	EXIT
S2:
	ORI		R16, 0B00000100
	JMP 	EXIT
S3:
	ORI		R16, 0B00001000
	JMP 	EXIT
S4:
	ORI		R16, 0B00010000
	JMP 	EXIT
S5:
	ORI		R16, 0B00100000
	JMP 	EXIT
S6:
	ORI		R16, 0B01000000
	JMP 	EXIT
S7:
	ORI		R16, 0B10000000
	JMP 	EXIT
;Show the score when we are done
ShowScore:
	COM		R16
	OUT		PORTD, R16	;Display the score on the LEDs
	CALL	HammerWait	;Wait a moment
	SER		R17
	COM		R16
	CP		R17, R16
	BREQ 	Grand		;Do something interesting if the player hit all the rats
	RET
Grand:
	LDI		R20, 6
	LDI		R16, 0B01010101
	LDI		R17, 0B10101010
	;Strobe the LEDs
There:
	OUT		PORTD, R16
	LDI		R18, 0xFF
StrobeDelay1:
	LDI		R19, 0x2F
StrobeDelay2:
	DEC		R19
	BRNE	StrobeDelay2
	DEC		R18
	BRNE	StrobeDelay1
	OUT		PORTD, R17
	DEC		R20
	BRNE	There
	JMP	DONE
DONE:
	JMP DONE
