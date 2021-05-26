#include <stdint.h>
#include <avr/interrupt.h>

#define PORTB_DDR (uint16_t*)0x24
#define PORTB_VAL (uint16_t*)0x25

uint8_t ctr = 0;

int main(){
	*PORTB_DDR = 0x20;
	*PORTB_VAL = 0x20;
	while(1){
		ctr++;
		if(ctr == 0){
			if(*PORTB_VAL == 0x00)
				*PORTB_VAL = 0x20;
			else
				*PORTB_VAL = 0x20;
		}
	}
}


ISR(TIMER0_OVF_vect){       // interrupt service routine that wraps a user defined function supplied by attachInterrupt
	return;
}
