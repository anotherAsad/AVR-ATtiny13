.org	0x00

rjmp	0x0
ldi		r20, 0x20
ldi		r21, 0x00
out		0x04, r20		; set DDR-PORTB pin5.
out		0x05, r20		; set PORTB pin5.

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
brne 	loop
dec		r16
brne 	loop

out		0x05, r21		; clear PORTB pin5.
eor		r18, r19
breq 	init	; init
out		0x05, r20		; set PORTB pin5.

rjmp 	init	; init
