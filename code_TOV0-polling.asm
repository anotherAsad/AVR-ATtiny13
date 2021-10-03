.equ	TCCR0A, 0x24		; {COM0A[1:0], COM0B[1:0], 2'b00, WGM[1:0]}
.equ	TCCR0B, 0x25		; {FOC0A, FOC0B, 2'b0, WGM[2], CS[2:0]}
.equ	TCNT0 , 0x26		; TCNT0[7:0]
.equ	OCR0A , 0x27		; OCR0A[7:0]
.equ	OCR0B , 0x28		; OCR0B[7:0]
.equ	TIMSK0, 0x6E		; !PORT! ; {5'b0, OCIE0B, OCIE0A, TOIE0}
.equ	TIFR0 , 0x15		; {5'b0, OCF0B, OCF0A, TOV0}
.equ	MCUCR , 0x35
.equ	DDRB  , 0x24		; !PORT ADDRESS!
.equ	PORTB , 0x25		; !PORT ADDRESS!

; NOTES: Please be as willing to do the math as you are in making ASM loops.

.org	0x00
rjmp	0x40			; reset interrupt vector
.org	0x20
rjmp	ISR_TIM0OVF		; TIMER0_Overflow interrupt vector

.org	0x40
START:
clr		r0				; As in RISC-V, r0 will be our zero register
clr		r1
inc		r1				; r1 is the LSbit High register
ldi		r27, 0x00		; All accesses below first 256 SRAM bytes. X_HI always 0. Also serves an alias to zero register

; Setup TIMER0
out		TCCR0A, r0
ldi		r16, 0x04
out		TCCR0B, r16		; Write 3'b101 to CS[2:0] so prescalar 1/1024 is set
out		TCNT0, r0		; Init Val for TCNT
ldi		r26, TIMSK0
st		X, r1			; Enable Timer Overflow interrupt

; Setup PORTB_PIN5 (LED)
ldi		r16, 0x20		; bit 5 HI
ldi		r26, DDRB		; save PORTB_DDR address in X_LO
st		X, r16			; set DDR-PORTB pin5.
ldi		r26, PORTB		; save PORTB_VAL address in X_LO
st		X, r16			; set VAL-PORTB pin5.

cli
out		TIFR0, 0x1		; clear interrupt flag at init
; setup the XOR toggle control
ldi		r18, 0x00		; XOR result
ldi		r19, 0x20		; XOR toggle mask

main_loop:
; poll for interrupt
ldi		r16, 0x1
in		r2, TIFR0
and		r2, r16
; if equal, turn off LED
cp		r2, r1
brne	main_loop		; if unequal, repeat
call	ISR_TIM0OVF
rjmp	main_loop

ISR_TIM0OVF:
out		TIFR0, 0x01			; clear the interrupt
; Average clever. Uses the DEC's change of Zero flag and 0xFF auto-loop-back.
dec		r25					; if not zero
brne	ISR_TIM0OVF_l0		; r25 != 0 ? return : switch off LED
eor		r18, r19
st		X, r18				; LED_LO
ret
ISR_TIM0OVF_l0:
ret
