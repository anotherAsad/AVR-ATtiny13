// ATmega's SPI put in Slave mode by a mysterious/forgotten guy on the internet.
// softSPImaster added by me.
#include <SPI.h>
volatile int i = 0;

#define  mSCK  7
#define  mMISO 6
#define  mMOSI 5
#define  mSS   4

#define  CLK_PULSE 16>>1

void writeBit(const byte bitVal){
	digitalWrite(mMOSI, bitVal);
	delay(CLK_PULSE);
	digitalWrite(mSCK, HIGH);
	delay(CLK_PULSE);
	digitalWrite(mSCK, LOW);
	return;
}

void writeByte(byte byteVal){
	for(unsigned char i=0; i<8; i++){
		writeBit(byteVal & 0x80);
		byteVal = byteVal << 1;
	}
}

void writeStr(char* str){
	while(*str != '\0')
		writeByte(*str++);
}

void setup(){
	// software SPI setup
	pinMode(mSCK, OUTPUT);
	pinMode(mMISO, INPUT);
	pinMode(mMOSI, OUTPUT);
	pinMode(mSS, OUTPUT);
	digitalWrite(mSS, HIGH);
	Serial.begin(9600);
	pinMode(SS, INPUT_PULLUP);
	pinMode(MOSI, OUTPUT);
	pinMode(SCK, INPUT);
	SPCR |= _BV(SPE);
	SPI.attachInterrupt();  //allows SPI interrupt
}

void loop(void){
	// Routine for Data Tx by fake slave.
	char txStr[] = "Hello World\n";
	// enable Slave
	digitalWrite(mSS, LOW);
	writeStr(txStr);
	/*
	writeBit(LOW);			// Write bit 7 LOW
	writeBit(HIGH);			// Write bit 6 HIGH
	writeBit(LOW);			// Write bit 5 LOW
	writeBit(HIGH);			// Write bit 4 HIGH
	writeBit(HIGH);			// Write bit 3 HIGH
	writeBit(LOW);			// Write bit 2 LOW
	writeBit(LOW);			// Write bit 1 LOW
	writeBit(HIGH);			// Write bit 0 HIGH
	*/
	digitalWrite(mSS, HIGH);
	// stuck: rjmp stuck
	while(1);
}

ISR(SPI_STC_vect){   // Interrupt routine function
	static char x;
	x = SPDR;
	Serial.print(x);
}
