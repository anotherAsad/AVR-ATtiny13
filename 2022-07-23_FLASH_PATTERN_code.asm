; Address alias table for ATtiny13. All addresses are port addresses. Use load/store only
.equ	TCCR0A, 0x2F		; {COM0A[1:0], COM0B[1:0], 2'b00, WGM[1:0]}
.equ	TCCR0B, 0x33		; {FOC0A, FOC0B, 2'b0, WGM[2], CS[2:0]}
.equ	TCNT0 , 0x32		; TCNT0[7:0]
.equ	OCR0A , 0x36		; OCR0A[7:0]
.equ	TIMSK0, 0x39		; !PORT! ; {5'b0, OCIE0B, OCIE0A, TOIE0}
.equ	TIFR0 , 0x38		; {5'b0, OCF0B, OCF0A, TOV0}
.equ	MCUCR , 0x35
.equ	PINB  , 0x16
.equ	DDRB  , 0x17
.equ	PORTB , 0x18

; Interrupt vector follows
.org	0x00
rjmp	reset
rjmp	reset
rjmp	reset
rjmp	TIM0_OVF

; Reset routine follows
.org	0x0A
reset:
	cli
	sbi		DDRB, 0x04			; Set portB pin4 to output
	; Setup Timer0
	ldi		r16, 0x00
	out		TCCR0A, r16			; Set timer to normal mode
	ldi		r16, 0x05
	out		TCCR0B, r16			; set CS[2:0] = 3'b101. Prescaler is 1/1024.
	ldi		r16, 0x02
	out		TIMSK0, r16			; enable timer overflow interrup
	eor		r0, r0				; set r0 to 0
	eor		r1, r1				; set r1 to 0
	sei							; enable interrupts

mainLoop:
	rjmp	mainLoop

; TIM0OVF interrupt handler
TIM0_OVF:
	inc		r1
	sbrc	r1, 0x3				; skip pin toggle if second bit is high
	sbi		PINB, 0x04			; Toggle the PIN bit. Blinks the light.
	reti						; exit interrupt

; The above technique make for a nifty flash pattern based on single bit check.
; e.g. if the 3rd bit of r1 is 0, do not toggle. But if it is one, toggle the LED.