;
; 5_Assembly.asm
;
; Created: 7/26/2017 7:27:23 PM
; Author : Daniel
;
;.INCLUDE "M32DEF.INC"
;1
/*SER		R16
OUT		DDRC, R16		;Make PORTC an output port
OUT		DDRD, R16		;Make PORTD an output port
CLR		R16
OUT		DDRA, R16		;Make PORTA an input port
LDI		R16, 0B10000101
OUT		ADCSRA, R16		;Enable ADC and select ck/32
LDI		R16, 0B00100000	;AREF=V_ref, ADC0 single ended, left justified
OUT		ADMUX, R16
READ_ADC:
SBI		ADCSRA, ADSC	;Start conversion
KEEP_POLLING:			;Wait for the end of the conversion
SBIS	ADCSRA, ADIF	;Is it the end of the conversion yet?
RJMP	KEEP_POLLING	;Keep polling for the end of the conversion
SBI		ADCSRA, ADIF	;Write 1 to clear the ADIF flag
IN		R16, ADCL		;ADCL must be read first
OUT		PORTC, R16		;Give the low byte to PORTC
IN		R16, ADCH		;Get the high byte
OUT		PORTD, R16		;Give the high byte to PORTD
RJMP	READ_ADC		;Convert forever*/
;3
.INCLUDE "M32DEF.INC"
.ORG	0x0					;location for reset
		JMP		MAIN
.ORG	0x04				;location for external interrupt 1
		JMP		EX1_ISR		
.ORG	0x12				;location for Timer1 overflow
		JMP		T1_OV_ISR
.ORG	0x14				;location for Timer0 compare match
		JMP		T0_CM_ISR
;Main program for initialization
MAIN:
;Setup the stack pointer
LDI		R16, HIGH(RAMEND)
OUT		SPH, R16
LDI		R16, LOW(RAMEND)
OUT		SPL, R16
SER		R16
OUT		DDRC, R16			;Make PORTC an output port
CLR		R17					;Counter
LDI		R16, (1<<OCIE0) | (1<<TOIE1)
OUT		TIMSK, R16			;Enable Timer0 OC & Time1 OV interrupts
LDI		R16, 0B00001000
OUT		MCUCR, R20			;Make INT1 falling edge triggered
LDI		R16, 1<<INT1
OUT		GICR, R16			;Enable INT1
SEI							;Enable Interrupts globally
;Setup timers
LDI		R16, 99
OUT		OCR0, R16			;Load Timer0 with 99
LDI		R16, 0x09
OUT		TCCR0, R16			;Start Timer0 in CTC mode
LDI		R16, 0
;Load Timer1 with 0
OUT		TCNT1H, R16
OUT		TCNT1L, R16
OUT		TCCR1A, R16			;Normal mode
LDI		R16, 0x01
OUT		TCCR1B, R16			;No prescaling
LOOP:
MOV		R18, R17			;Copy the contents of R17 to R18
ANDI	R18, 0B00011111		;Get the lower 5 bits
OUT		PORTC, R18			;Output the lower 5 bits to PORTC
LDI		R16, 200
DELAY:		
DEC		R16
BRNE	DELAY				;DELAY for 200 cycles
INC		R17
RJMP	LOOP				;Loop forever
;Interrupt subroutines
EX1_ISR:
IN		R16, PORTC
LDI		R19, 0x80
EOR		R16, R19			;Toggle PORTC.7
OUT		PORTB, R16
RETI
T1_OV_ISR:
IN		R16, PORTC
LDI		R19, 0x40
EOR		R16, R19			;Toggle PORTC.6
OUT		PORTB, R16
RETI
T0_CM_ISR:
IN		R16, PORTC
LDI		R19, 0x20
EOR		R16, R19			;Toggle PORTC.5
OUT		PORTB, R16
RETI
