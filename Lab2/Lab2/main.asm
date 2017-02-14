; Lab2.asm
;
; Created: 2/7/2017 7:00:08 PM
; Author : jwryan
;

.include "tn45def.inc"
.cseg
.org 0

; Configure PB0 as input; PB1 as output		
	sbi DDRB,1		; PB1 is now output
	;PB0 is configured as input by default 
	sbi PORTB,0		; Pull up resistor enabled in PB0 so switch can be read
	

	loop1: ;Infinite loop 
		loop2: ;Button loop
			rcall Delay_12us
			SBIC PINB, 0
			rjmp loop2
			rcall Delay_29ms
			rcall Delay_29ms
			rcall Delay_29ms
			rcall VCR_play
			rcall Delay_29ms
			rcall TV_vol
			rjmp loop1

	/*loop:
		sbi   PORTB,1     ; LED at PB1 off
		cbi   PORTB,2     ; LED at PB2 on 
		rcall delay_29  ; Wait
		nop
		nop
		cbi   PORTB,1     ; LED at PB1 on
		sbi   PORTB,2     ; LED at PB2 off  
		rcall delay_29 ; Wait
	    nop
	    nop
      rjmp   loop*/
			
	Logic_1:
		cbr r27,0
		sbi PORTB,1
		rcall Delay_889us
		ldi r27,32
	s1: cbi PORTB,1
		rcall Delay_69c
		sbi PORTB,1
		rcall Delay_69c
		rcall Delay_69c
		rcall Delay_69c
		dec r27
		brne s1
		cbi PORTB,1
		ret

	Logic_0:
		cbr r27,0
		sbi PORTB,1
		ldi r27,32
	s2: cbi PORTB,1
		rcall Delay_69c
		sbi PORTB,1
		rcall Delay_69c
		rcall Delay_69c
		rcall Delay_69c
		dec r27
		brne s2
		rcall Delay_889us
		cbi PORTB,1
		ret

	VCR_play:
		rcall Logic_1
		rcall Logic_1
		rcall Logic_1
		rcall Logic_0
		rcall Logic_0
		rcall Logic_1
		rcall Logic_1
		rcall Logic_0
		rcall Logic_1
		rcall Logic_1
		rcall Logic_0
		rcall Logic_1
		rcall Logic_0
		rcall Logic_1
		ret

	TV_vol:
		rcall Logic_1
		rcall Logic_1
		rcall Logic_0
		rcall Logic_0
		rcall Logic_0
		rcall Logic_0
		rcall Logic_0
		rcall Logic_1
		rcall Logic_0
		rcall Logic_0
		rcall Logic_1
		rcall Logic_1
		rcall Logic_0
		rcall Logic_1
		ret
		
	Delay_889us:	;Delays for 889 microseconds 
		CBR r18,0
		CBR r19,0
		ldi r18,16
	d4:	ldi r19,184
	d5:	dec r19
		brne d5
		dec r18
		brne d4
		ret

	Delay_69c:		;Delays for 69 cycles
		CBR r18,0	;Actually delays for 79, since in real testing results were better
		ldi r18, 20 ;
		d277: dec r18		
		brne d277
		ret

	Delay_12us:		;Small delay of 12 microseconds
		CBR R18,0
		ldi r18,3		
	d1:	ldi r19,12
	d2:	dec r19
		brne d2
		dec r18
		brne d1
		ret

	Delay_29ms:		;29 Millesecond Delay
		CBR r18,0
		CBR r19,0
		CBR r20,0
		ldi r18,3
	d7:	ldi r19,160
	d8:	ldi r20,202
	d9: dec r20
		brne d9
		dec r19
		brne d8
		dec r18
		brne d7
		rcall Delay_69c
		ret	
.exit
		