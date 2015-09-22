;specify SFRs
pcl		equ 02
status 	equ 03 
porta 	equ 05 
trisa 	equ 05
portb 	equ 06 
trisb 	equ 06
;
pointer equ 10  ;set a general purpose register for the pointer
; 
delcntr1 equ 11 ; store delay cycles 


; use the org directive to force program start at reset vector
	org 00 
; program starts here 
start clrw
	bsf status, 5 ;select memory bank 1
	movlw 00 ;set port B to all output
	movwf trisb 
	bcf status, 5;select memory bank 0 

; main program starts here 
	movlw 00 
	movwf pointer ; clear the pointer value

loop	call table ; call the table; retrieve the 7-segment display binary output for portB 
		movwf portb ; move to portb 
		incf pointer ; increment the pointer by 1
		call delay
		clrw 
		movfw pointer
	    call compareToZero 
		goto loop ; delay for one clock cycle 		

; delay subroutine; this is good 
delay movlw D'400' ; set a delay for 400 cycles 
	movwf delcntr1  
dell 	nop 
		decfsz delcntr1, 1
		goto dell 
		return

; puts the PIC into standby mode if the port is displaying zeroes 
compareToZero btfsc portb, 7
		return
		btfsc portb, 6
		return
		btfsc portb, 5 
		return 
		btfsc portb, 4 
		return 
		btfsc portb, 3 
		return 
		btfsc portb, 2 
		return 
		btfsc portb, 1 
		return 
		btfsc portb, 0 
		return 
		sleep 

; table subroutine; this is good as long as W register is set beforehand
table addwf pcl 
	retlw B'11111010' ;display for 9 on 7-segment display 
	retlw B'11111110' ;display for 8 on 7-segment display
	retlw B'11001000' ;display for 7 on 7-segment display...and so on
	retlw B'10111110' ;6
	retlw B'10111010' ;5 
	retlw B'01111000' ;4
	retlw B'11011010' ;3
	retlw B'11010110' ;2 
	retlw B'01001000' ;1 
	retlw B'11101110' ;0 
	retlw B'00000000' ;null

end
;



