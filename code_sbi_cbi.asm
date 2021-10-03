; Address alias table for ATtiny13. All addresses are port addresses. Use load/store only
.equ	TCCR0A, 0x25		; {COM0A[1:0], COM0B[1:0], 2'b00, WGM[1:0]}
.equ	TCCR0B, 0x33		; {FOC0A, FOC0B, 2'b0, WGM[2], CS[2:0]}
.equ	TCNT0 , 0x32		; TCNT0[7:0]
.equ	OCR0A , 0x36		; OCR0A[7:0]
.equ	TIMSK0, 0x39		; !PORT! ; {5'b0, OCIE0B, OCIE0A, TOIE0}
.equ	TIFR0 , 0x38		; {5'b0, OCF0B, OCF0A, TOV0}
.equ	MCUCR , 0x35
.equ	DDRB  , 0x17
.equ	PORTB , 0x18

; NOTES: Please be as willing to do the math as you are in making ASM loops.

.org	0x00
rjmp	reset
.org	0x0A
reset:
ldi		r18, 0x00
ldi		r19, 0x01

cli			; Reset vector: No interrupts.
init:
ldi		r16, 0xFF
ldi		r17, 0xFF

loop:
dec		r16
brne	loop
dec		r17
brne	loop

eor		r18, r19
sbi		DDRB,  4		; Setup pin4 for OUTPUT.
cbi		PORTB, 4		; make it LOW
brne	init
sbi		DDRB,  4		; Setup pin4 for OUTPUT.
sbi		PORTB, 4		; make it HIGH
rjmp	init