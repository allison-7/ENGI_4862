;*********************************
; 3.asm
;
; Created: 01/07/2017 14:23:43
; Author : danpo
;Assignment 3
;*********************************
.INCLUDE"M32DEF.INC"
;1
LDI R20, $53
LDI R16, $AC
DEC R16
SEC
ADC R20 , R16
ANDI R20 , $30
;2a
/*CLR		R16
OUT		DDRB, R16	;Make PORTB an input port
SER		R16
OUT		DDRC, R16	;Make PORTC an output port
LOOP:
IN		R16, PINB	;Get the contents of PORTB
MOV		R17, R16	;Copy the contents of R16 to R17
ANDI	R17, 0xF0	;Get the upper bits of R17
COM		R17			;Toggle the bits
ANDI	R16, 0x0F	;Get the lower bits
;Swap the upper and lower bits
;Shift the lower bits to the left 4 times
LSL		R16
LSL		R16
LSL		R16
LSL		R16
;Shift the upper bits to the right 4 times
LSR		R17
LSR		R17
LSR		R17
LSR		R17
EOR		R17, R16	;Put the results of shifting together
OUT		PORTC, R17	;Output the result to PORTC
JMP		LOOP		;Loop forever*/
;2b
/*CLR		R16
OUT		DDRD, R16	;Make PORTD an input port
LOOP:
IN		R16, PIND	;Get the contents of PIND
MOV		R17, R16	;Copy the contents of R16 to R17
ANDI	R17, 0x0F	;Get the lower bits
MOV		R18, R17	;Copy contents of R17 to R18
ANDI	R18, 0B00001010;Get the odd bits
ANDI	R17, 0B00000101;Get the even bits
COM		R18
COM		R17
EOR		R18, R17	;Put R18 and R17 back together
EOR		R16, R18	;Put R16 and R18 back together
JMP		LOOP		;Loop forever*/
;2c
/*CLR		R16
OUT		DDRA, R16	;Make PORTA an input port
SER		R16
OUT		DDRB, R16	;Make PORTB an output port
LOOP:
IN		R16, PINA	;Get the contents of PINA
SBRS	R16, 4		
JMP		LOOP		;Go back to LOOP if bit 4 is 1
CLR		R17		
OUT		PORTD, R17  ;Send a low pulse to PORTD
LDI		R17, 0B10000000
OUT		PORTD, R17	;Send a high pulse to PORTD.7
CLR		R17
OUT		PORTD, R17
JMP		LOOP*/
;3
/*;Store 0x400 in the X register
LDI		XH, 0x04
LDI		XL, 0x00
;Store 0x500 in the Y register
LDI		YH, 0x05
LDI		YL, 0x04
LDI		R16, 50		;The number of time times we must loop
CLR		R17
CLR		R18
CLR		R19
CLR		R20
LOOP:
LD		R17, X+		;Store the contents of register X into R17 and post-increment X
LD		R18, Y+		;Store the contents of register Y into R18 and post-increment Y
MUL		R17, R18	;Multiply the contents of R18
ADD		R19, R0		;Add the low byte to R19
ADC		R20, R1		;Add the high byte to R20
DEC		R16
BRNE	LOOP
STS		0x0300, R19	;Put the low byte in memory location 0x0300
STS		0x0301, R20	;Put the high byte in memory location 0x0301*/
;4
/*DIV:
SUB		R0, R1		;Perform R0-R1 and store the result in R0
BRSH	DIV			;If R0 >= R1 keep looping
RET*/
;7
/*LDI		R16, 123
LDI		R17, 3
ADD		R17, R16*/
/*LDI		R16, 113
LDI		R17, -113
ADD		R17, R16*/
/*LDI		R16, -100
LDI		R17, -30
ADD		R17, R16*/
/*LDI		R16, 100
LDI		R17, 120
ADD		R17, R16*/
/*LDI		R16, -125
LDI		R17, -0x30
ADD		R17, R16*/
;8
;Initialize the stack pointer
/*LDI		R16, HIGH (RAMEND)
OUT		SPH, R16
LDI		R16, LOW (RAMEND)
OUT		SPL, R16
CLR		R16
OUT		DDRC, R16	;Make PORTC an input port
IN		R16, PINB	;Read the values
MOV		R17, R16	;Copy the contents of R16 to R17
ANDI	R16, 0x0F	;Get the upper bits
CALL	CONVERT		;Convert R16 to ASCII
MOV		R30, R16	;Place the lower byte in R30
MOV		R16, R17
SWAP	R16			;Swap the high and low nibbles of R16
ANDI	R16, 0x0F	
CALL	CONVERT
MOV		R31, R16	;Place the higher byte in R31
DONE:
JMP		DONE		;We are done
CONVERT:
PUSH	R17
CPI		R16, 0x0A	;Check if R16 is above 9
BRSH	LETTER		;Do the ASCII conversion for a letter
LDI		R17, 0x30
ADD		R16, R17	;ASCII 0x30 to 0x39 are numbers
JMP		EXIT
LETTER:
LDI		R17, 0x37
ADD		R16, R17	;0x37+0x0A=0x41, ASCII 0x41 to 0x46 are 'A' to 'F'
EXIT:
POP		R17
RET*/
