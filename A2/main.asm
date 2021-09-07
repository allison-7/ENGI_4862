;
; 2.asm
;
; Created: 6/12/2017 8:12:18 PM
; Author : Daniel
;

; Replace with your application code
.INCLUDE "M32DEF.INC"
;Question 3a
	/*LDI R16,0x1F
	LDI R17,0x25
	ADD R16, R17*/
;Question 3b
/*	LDI R18,0x73
	LDI R19,0xF9
	ADD R18, R19
*/
;Question 4a
/*CLR		R18
OUT		DDRB, R18	; Set PORTB as an input port 
IN		R15, PINB	; Get the status of PINB
OUT		0x2F, R15	; Is 0x2FF a typo?
*/
;Question 4b
/*CLR		R18
OUT		DDRB, R18	; Set PORTB as an input port 
LDS		R15, PINB	; Get the status of PINB
OUT		0x2F, R15	; Is 0x2FF a typo?
*/
;Question 5
/*.EQU AH = $100
.EQU AL = $101
.EQU BH = $102
.EQU BL = $100

LDS R16, AH
LDS R17, AL
LDS R18, BH
LDS R19, BL

ADD R17, R18	;Low byte
ADC R16, R19	;High byte

STS $200, R16
STS $201, R17
*/
;Question 7
;Loop to delay by 100000 clock cycles
/*LDI R17, $FF
LOOP1:	LDI R18, $FF
	LOOP2:	DEC R18
			BRNE LOOP2
			DEC R17
			BRNE LOOP1
;LOOP 65025 times
LDI R17, $FF
LOOP3:	LDI R19, 137
	LOOP4:	DEC R19
			BRNE LOOP4
			DEC R17
			BRNE LOOP3
;LOOP 34395 times
LDI R20, 80
LOOP5:
	DEC R20
	BRNE LOOP3
;LOOP 80 times
*/
;Question 8
/*LDI R18, $5F	; initialize the stack pointer
OUT SPL, R18
LDI R18, $08
OUT SPH, R18

LDI R20, 10
LDI R21, 30
LDI R22, 40
LDI R23, 50

PUSH R20
PUSH R22
POP R21
PUSH R23
POP R20*/


;Question 9
;Swap Program
/*PUSH R21
PUSH R22
MOV R21, R20	;Assuming R20 contains data
MOV R22, R19	;Assuming R19 contains data
MOV R20, R22
MOV R19, R21
POP R22
POP R21
*/
;Question 10

LDI R20, -0x08
