@echo off
cls
set ERR_TYPE=UNDEF

echo Attempt assembling
avr-as -mmcu=attiny13 code.asm -o code.o
if %errorlevel% NEQ 0 (
	set ERR_TYPE=Assembling
	GOTO EXIT_WITH_ERROR
)

echo Attempt Linking
avr-ld code.o -o ldcode.o
if %errorlevel% NEQ 0 (
	set ERR_TYPE=Linking
	GOTO EXIT_WITH_ERROR
)

echo Attempt objcopy
avr-objcopy -O ihex ldcode.o code.hex
avr-objdump -mavr -D code.hex
avrdude -p ATtiny13 -c avrisp -P com4 -b 19200 -U flash:w:code.hex
exit

:EXIT_WITH_ERROR
	echo .
	echo .
	echo .
	echo ERR: Error in %ERR_TYPE%!!!
	exit

REM Want to read fuses?
REM avrdude -c avrisp -p attiny13 -P com3 -b 19200 -v -F
REM avrdude -p ATtiny13 -c avrisp -P com3 -b 19200 -U flash:r:flash.hex:i
REM avr-objdump -mavr -D flash.hex
REM 8051?
REM C:\avr\bin\avrdude -C C:\AVR8051.conf -p 89s52 -c avrisp -P com3 -b 19200 -U flash:w:code.hex
