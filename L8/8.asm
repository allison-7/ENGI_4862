;***********************************************************
;*This program gets data from Channel 0 of the
;*ADC and displays the result on PORTB and PORTD
;*
;*PORTA-->Receives the input from the signal generator 
;*PORTB-->PORTB receives input from the switches
;*PORTD-->Display the the result on the LEDs
;*
;***********************************************************
.INCLUDE "M32DEF.INC"
SER		R16
OUT		DDRD, R16		;Make PORTD an output port
CLR		R16
OUT		DDRB, R16		;Make PORTB an input port
OUT		DDRA, R16		;Make PORTA an input port
LDI		R16, 0x87		;Enable ADC and select ck/128
OUT		ADCSRA, R16
LDI		R16, 0B00100000	;AREF=V_ref, ADC0 single ended, left justified
OUT		ADMUX, R16	
LDI		R18,0
READ_ADC:
SBI		ADCSRA, ADSC	;Start conversion
KEEP_POLLING:			;Wait for the end of the conversion
SBIS	ADCSRA, ADIF	;Is it the end of the conversion yet?
RJMP	KEEP_POLLING	;Keep polling for the end of the conversion
SBI		ADCSRA, ADIF	;Write 1 to clear the ADIF flag
IN		R16, ADCH		;Read ADCH
COM		R16
OUT		PORTD, R16		;Output the result to PORTD
IN		R17, PINB
CPI		R17, 0xFF		;Check if a switch was pressed
BRNE	DONE			;Stop the program if a switch was pressed

;Writing to EEPROM

WAIT:					;Wait for the last write to finish
SBIC	EECR, EEWE		;Check EEWE to see if the last write is finished
RJMP	WAIT
LDI		R17,0
OUT		EEARH, R17		;Load 0 into the high byte of the address
OUT		EEARL, R18		;Start at 0 for the low byte of the address
;IN		R16, ADCH		;Load the low byte of the ADC conversion into R16
OUT		EEDR, R16		;Load R16 to EEPPROM
SBI		EECR, EEMWE		;Set Master Write Enable to one
SBI		EECR, EEWE		;Set Write Enable to one
;Wait for 4 cycles
NOP
NOP
NOP
NOP
CPI		R18, 0xFF		;See if R18=0xFF
BREQ	DONE			;If the result is true we are done
;Else continue the program
INC		R18
RJMP	READ_ADC

;RJMP	READ_ADC		;Keep repeating
DONE:	
SER		R16
OUT		PORTD, R16
RJMP	DONE	;We are done
