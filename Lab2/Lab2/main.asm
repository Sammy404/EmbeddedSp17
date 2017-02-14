; Lab2.asm
;
; Created: 2/7/2017 7:00:08 PM
; Authors : Jason Ryan, Sam Morgan
;

.include "tn45def.inc"
.cseg
.org 0

	; Configure PB0 as input; PB1 as output		
	sbi DDRB,1		; PB1 is now output
	; PB0 is configured as input by default 
	sbi PORTB,0		; Pull up resistor enabled in PB0 so switch can be read
	

	loop1: ; Infinite loop 
		loop2: ; Button loop
			rcall Delay_12us
			SBIC PINB, 0	; if button pressed exit loop2
			rjmp loop2
			rcall Delay_29ms
			rcall Delay_29ms
			rcall Delay_29ms
			rcall VCR_play	; send VCR signal
			rcall Delay_29ms
			rcall TV_vol	; send TV signal
			rjmp loop1
			
	; Subroutine for producing logic 1
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

	; Subroutine for producing logic 0
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

	; Subroutine for producing VCR signal
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
	
	; Subroutine for producing TV signal
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
		
	; Subroutine delays for 889 microseconds 
	Delay_889us:	
		CBR r18,0
		CBR r19,0
		ldi r18,16
	d4:	ldi r19,184
	d5:	dec r19
		brne d5
		dec r18
		brne d4
		ret

	; Delays for 69 cycles
	; Actually delays for 79, since in real testing results were better
	Delay_69c:		
		CBR r18,0	
		ldi r18, 20 
		d277: dec r18		
		brne d277
		ret

	; Small delay of 12 microseconds
	Delay_12us:		
		CBR R18,0
		ldi r18,3		
	d1:	ldi r19,12
	d2:	dec r19
		brne d2
		dec r18
		brne d1
		ret

	; 29 Millisecond Delay
	Delay_29ms:		
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
		