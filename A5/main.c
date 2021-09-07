/*
 * 5_C.c
 *
 * Created: 7/26/2017 7:51:46 PM
 * Author : Daniel
 */ 

#include <avr/io.h>
void _delay (unsigned int d)
{
	unsigned int i;
	for (i = 0; i < d; i++); //Delay "d" times
}

int main(void)
{
    DDRA = 0; //Make PORTA an input port
	DDRB = 0xFF; //Make PORTB an output port
	PORTB = 0xFF; //Turn off the LEDs (Active Low)
	unsigned int count = 0;
	unsigned char b; 
	while (count != 10000)
	{
		//Read from PINA5
		if((b=PINA) & 0x20) 
		{
			count++;
			_delay(1000);
		}
		else
			_delay(1000);
	}
	PORTB = 0; //When we are done turn on the LEDs
}



