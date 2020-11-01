	#include <pic18_chip_select.inc>
	#include <xc.inc>
	
psect	code, abs
main:
	org 0x0
	goto	setup
	
	org 0x100		    ; Main code starts here at address 0x100

	; ******* Programme FLASH read Setup Code ****  
setup:	
	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	movlw	0xff
	movwf	TRISD, A	    ; set tristate D value to be all 1's therefore input pin
	movff	PORTD, 0x30	    ; move the value input at port D to address 0x30
	movlw 	0x0
	movwf	TRISC, A	    ; Port C all outputs
	clrf	LATC, A		    ; clears the output
	goto	start
	; ******* My data and where to put it in RAM *
myTable:
	db	0x00, 0x01, 0x03, 0x06, 0x0C
	db	0x88, 0xC0, 0x60, 0x40, 0x10	; data chosen to produce circling pattern of 2-bit 'snake'
	myArray EQU 0x400	; Address in RAM for data
	counter EQU 0x10	; Address of counter variable
	align	2		; ensure alignment of subsequent instructions 
	; ******* Main programme *********************
start:	
	lfsr	0, myArray	; Load FSR0 with address in RAM	
	movlw	low highword(myTable)	; address of data in PM
	movwf	TBLPTRU, A	; load upper bits to TBLPTRU
	movlw	high(myTable)	; address of data in PM
	movwf	TBLPTRH, A	; load high byte to TBLPTRH
	movlw	low(myTable)	; address of data in PM
	movwf	TBLPTRL, A	; load low byte to TBLPTRL
	movlw	10		; 10 bytes to read
	movwf 	counter, A	; our counter register
loop:
        tblrd*+			; move one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0	; move read data from TABLAT to (FSR0), increment FSR0	
	movff	POSTINC0, LATC	; move data from FSR0 to Latch C
	call	delay		; call delay subroutines so that LEDs can be seen
	decfsz	counter, A	; count down to zero
	bra	loop		; keep going until finished
	goto	0
delay:	
	movf	0x30, W, A
	movwf	0x05, A
	decfsz	0x05, A	; decrement until zero
	bra delay
	call delay2
	return
delay2:
	movf	0x30, W, A
	movwf	0x06, A
	decfsz	0x06, A	; decrement until zero
	bra delay2
	call delay3
	return
delay3:
	movf	0x30, W, A
	movwf	0x07, A
	decfsz	0x07, A	; decrement until zero
	bra delay3
	return
	
	end	main
