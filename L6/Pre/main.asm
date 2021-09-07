;
; Prelab.asm
;
; Created: 7/9/2017 8:20:02 PM
; Author : Daniel
;
.INCLUDE "M32DEF.INC"
JMP		LONG			;Toggle between SHORT, LONG, and COUNTER
;**********************************************************************
;Short Delay subroutine
;Make a square wave on PORTD.0 with a frequency of 5Hz
;For F=1MHz, T=1us (clock). Let's use a prescaler of 8
;For F=5Hz, T=0.2s. We must have a delay of 100ms
;100ms/8us = 12500 cycles
;Let's do 100 iterations of 125 cycles. TCNTO~256-125=131 
;**********************************************************************
SHORT:
LDI		R19, 0B00000001
SBI		DDRD, 0			;Make PORTD.0 an output port
;SBI	DDRA, 0			;Make PORTA.0 an output port
JMP		BEGIN5			;Toggle BEGIN5 & BEGIN1
CLR		R20
BEGIN5:
LDI		R16, 100
LOOP5:
LDI		R17, 132		;After some trial and error we need 132 cycles
OUT		TCNT0, R17		;Load Timer 0
LDI		R17, 0B00000010
OUT		TCCR0, R17		;Setup a prescaler of 8
AGAIN5:
IN		R17, TIFR		;Get input from the timer
SBRS	R17, TOV0		;If TOVO is set skip the next instruction
RJMP	AGAIN5
CLR		R17
OUT		TCCR0, R17		;Stop Timer0
LDI		R17, 0x01
OUT		TIFR, R17		;Clear TOV0 flag
DEC		R16
BRNE	LOOP5			;Keep looping 100 times
EOR		R20, R19		;Toggle D0 of R18
OUT		PORTD, R20
RJMP	BEGIN5
;**********************************************************************
;For the 1 KHz part
;For F=1KHz, T=1ms. We must have a delay of 500us
;500/1 = 500 cycles
;Let's do 5 iterations of 100 cycles. TCNT0~256-100=156 
;**********************************************************************
BEGIN1:
LDI		R16, 5
LOOP1:
LDI		R17, 175		;After some trial and error we need 175 cycles
OUT		TCNT0, R17		;Load Timer 0
LDI		R17, 0B00000001
OUT		TCCR0, R17		;Normal Mode
AGAIN1:
IN		R17, TIFR		;Get input from the timer
SBRS	R17, TOV0		;If TOVO is set skip the next instruction
RJMP	AGAIN1
CLR		R17
OUT		TCCR0, R17		;Stop Timer0
LDI		R17, 0x01
OUT		TIFR, R17		;Clear TOV0 flag
DEC		R16
BRNE	LOOP1			;Keep looping 100 times
EOR		R20, R19		;Toggle A0 of R18
OUT		PORTA, R20
RJMP	BEGIN1
;********************************************************************
;Long Delay subroutine
;For F=1MHz, T=1us (clock). Let's use a prescaler of 64
;For F=0.25Hz, T= 4s. We must have a delay of 2s
;2s/64us = 31250 cycles. TCNT1=65536-31250=34286=0x85EE
;********************************************************************
LONG:
LDI		R19, 0B00000001
CLR		R20
SBI		DDRD, 0			;Make PORTD.0 an output port
BEGIN:
LDI		R16, 0x85
OUT		TCNT1H, R16		;Setup the high byte
LDI		R16, 0xEE
OUT		TCNT1L, R16		;Setup the low byte
CLR		R16
;Check these instructions later
OUT		TCCR1A, R16		;Normal mode
LDI		R16, 0B00000011	
OUT		TCCR1B, R16		;Setup 1/64 prescaling
AGAIN:
IN		R17, TIFR		;Get input from the timer
SBRS	R17, TOV0		;If TOVO is set skip the next instruction
RJMP	AGAIN
CLR		R17
OUT		TCCR0, R17		;Stop Timer0
LDI		R17, 0x01
OUT		TIFR, R17		;Clear TOV0 flag
EOR		R20, R19		;Toggle D0 of R18
OUT		PORTD, R20
RJMP	BEGIN
;********************************************************************
;Counter subroutine
;PORTB.0 is input to the timer; it is connected to SW0
;PORTD is output to the LED
;********************************************************************
COUNTER:
CBI		DDRB, 0			;Make PINB.0 an input pin
SER		R16
OUT		DDRD, R16		;PORTD is an output port
LDI		R16, 0x06
OUT		TCCR0, R16		;Setup Timer0 in normal, falling edge mode
AGAIN_C:
IN		R20,TCNT0
OUT		PORTD,R20		;PORTD = TCNT0
IN		R16,TIFR
SBRS	R16,TOV0
RJMP	AGAIN_C			;keep doing it
LDI		R16,1<<TOV0
OUT		TIFR, R16
RJMP	AGAIN_C			;keep doing it
