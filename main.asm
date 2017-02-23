;
; Lab 3.asm
;
; Created: 2/23/2017 3:36:13 PM
; Author : jwryan
;


; Replace with your application code
; Set inputs and outputs

.def c1temp1 = r16
.def c1temp2 = r17
.def count1 = r18
.def c2temp1 = r19
.def c2temp2 = r20
.def count2 = r21

sbi DDRB,2 //PB2 is and output
cbi DDRB,0 //PB0 is an input
cbi DDRB,1 //PB1 is an input
sbi PORTB,0 //pull up resistor in pb0 enabled
sbi PORTB,1 //pull up resistor in pb1 enabled

; Main infinite loop
Main:
	sbr count1,0xD9
	sbr c1temp1,0x03
	cbi PORTB,2 //turn on LED
	rcall delay_on
	sbi PORTB,2 //turn off LED
	rcall delay_on
	rjmp Main

delay_on:
	;stop timer
	ldi c1temp2,0x00
	out TCCR0B,c1temp2
	;clear over flow flag
	in c1temp2,TIFR
	sbr c1temp2,1<<TOV0
	out TIFR,c1temp2
	;start timer with new count
	out TCNT0,count1  ;load count	
	out TCCR0B,c1temp1 ;restart timers
wait_on:
	nop //this
	in c1temp2,TIFR
	sbrs c1temp2,TOV0 
	rjmp wait_on
 ret

	
	

	

    
