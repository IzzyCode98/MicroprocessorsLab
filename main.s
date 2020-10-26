	#include <pic18_chip_select.inc>
	#include <xc.inc>

psect	code, abs
	
main:
	org	0x0	
	goto	start

	org	0x100		    ; Main code starts here at address 0x100
start:
	movlw	0xff
	movwf	TRISD, A	    ; set tristate D value to be all 1's therefore input pin
	movff	PORTD, 0x30	    ; move the value input at port D to address 0x30
	movlw 	0x0
	movwf	TRISC, A	    ; Port C all outputs
	clrf	LATC, A		    ; clears the output
	bra 	test
loop:
	movff 	0x06, PORTC
	incf 	0x06, W, A
test:
	movwf	0x06, A		    ; move W value into address 0x06
	movf	0x30, W, A	    ; move value in address 0x30 to W
	cpfsgt 	0x06, A		    ; compare PORTC value to PORTD value
	bra 	loop		    ; Not yet finished goto start of loop again
	goto 	0x0		    ; Re-run program from start

	end	main
