.org	0x00

sbi		0x04, 5			; set DDR-PORTB pin5.
sbi		0x05, 5			; set PORTB pin5.

ldi		r18, 0x0
ldi		r19, 0x1

init:
ldi		r17, 0xFF
ldi		r16, 0xFF
; Average clever. Uses the DEC's change of Zero flag and 0xFF auto-loop-back.
loop:
nop
nop
dec		r17
brne 	loop	; loop
dec		r16
brne 	loop	; loop

cbi		0x05, 5
eor		r18, r19
breq 	init	; init
sbi		0x05, 5

rjmp 	init	; init
