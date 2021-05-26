.org	0x00

ldi		r27, 0x00		; All accesses below first 256 SRAM bytes. X_HI always 0
ldi		r20, 0x20		; bit 5 HI

ldi		r26, 0x24		; save PORTB_DDR address in X_LO
st		X, r20			; set DDR-PORTB pin5.

ldi		r26, 0x25		; save PORTB_VAL address in X_LO
st		X, r20			; set VAL-PORTB pin5.

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

st		X, r27		; clear PORTB pin5.
eor		r18, r19
breq 	init
st		X, r20		; set PORTB pin5.

rjmp 	init
