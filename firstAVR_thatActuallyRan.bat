avr-as -mmcu=attiny13 code.S -o code.o
avr-ld code.o -o ldcode.o
avr-objcopy -O ihex ldcode.o code.hex
avr-objdump -mavr -D code.hex
avrdude -p ATtiny13 -c avrisp -P com3 -b 19200 -U flash:w:code.hex

:: Want to read fuses?
:: avrdude -c avrisp -p attiny13 -P com3 -b 19200 -v -F
avrdude -p ATtiny13 -c avrisp -P com3 -b 19200 -U flash:r:flash.hex:i
avr-objdump -mavr -D flash.hex
