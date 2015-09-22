; This program counts down from 35 to 0
; in one-second increments from 35 to 10 
; in 1/10 second increments from 9.9 to 0 
; when it gets to 0, then an LED comes on 

; specify SFRs 
pcl 		equ 02 
status 		equ 03
porta 		equ 05 
trisa 		equ 05 
portb 		equ 06 
trisb 		equ 06 
; 
tensPointer 	equ 10 ; pointer for Tens digit  
onesPointer 	equ 11 ; pointer for Ones digit 
; 
delcntr1 	equ 12 ; nested delay loop counter
delcntr2 	equ 13 ; super delay loop counter 
; 
testingValue equ 14 ; include value for testing for branching 

org 00

; program starts here 
start	clrw 
	bsf status, 5 ; select memory bank 1 
	movlw 00 
	movwf trisb ; set port B to all output 
	movwf trisa ; set port A to all output 
	bcf status, 5 ; select memory bank 0 

	movlw B'00000110' ; set the tens pointer to point to 3 in the lookup table (offset 6)
	movwf tensPointer 

	movlw B'00000100' ; set the ones pointer to pont to 5 in the lookup table (offset 4)	
	movwf onesPointer 

initialize_35_10_loop
	movlw D'25' 
	movwf delcntr2 
	movlw D'255' 
	movwf delcntr1 

countdown_35_10_TensDigit_loop    
	clrw 	
	call callTensDigit ; enable the tens digit 
	movwf porta ; set port a output to enable tens digit 
	movfw tensPointer ; move pointer into the W register 
	call countdown_9_0_NoDP_PartOne ; get the first four parts of the LED
	movwf portb ; set port b output as the first half of the tens digit 
	clrw ; clear the W register for call 
	movwf portb ; null the display 
	movfw tensPointer ; move the tensPointer into the W register for call
	call countdown_9_0_NoDP_PartTwo ; get the second four parts of the LED 
	movwf portb ; set port b output as the second half of the tens digit 
	clrw ; clear the W register for call
	movwf portb ; null the display  

countdown_35_10_OnesDigit_loop 
	clrw 
	call callOnesDigit ; enable the ones digit 
	movwf porta ; set port a output to enable ones digit 
	movfw onesPointer ; set W register to be onesPointer
	call countdown_9_0_NoDP_PartOne ; get the first four parts of the LED 
	movwf portb ; set port b output as the first half of the ones digit 
	clrw ; clear the W register for call
	movwf portb ; null the display 
	movfw onesPointer ; move the onesPointer back into the W register for call
	call countdown_9_0_NoDP_PartTwo ; get the second half of the digits
	movwf portb ; set the display to be the second half of the ones digits
	clrw ; clear the W register for call
	movwf portb ; null the display 

	; delay loop wrapped in the cycle 
	decfsz delcntr1, 1 
	goto countdown_35_10_TensDigit_loop
	decfsz delcntr2, 1
	goto countdown_35_10_TensDigit_loop 
	; at this point, need to decrement a value; increment the onesPointer, or clear the onesPointer and increment the tensPointer, or goto the 9.9 to 0 counting loop 
branchingMethod
	incf onesPointer 
	; if at the end condition, getting the countdown_9_0_NoDP_PartTwo should result in '00000001' 
	call countdown_9_0_NoDP_PartTwo 
	movwf testingValue
	btfsc testingValue, 0 
	goto changeTensValue_35_10 ; if the output is '00000001' then goto changeTensValue
	movlw D'25' 
	movwf delcntr2 
	movlw D'255' 
	movwf delcntr1 
	goto countdown_35_10_TensDigit_loop 
	
	; use the decimal point as a delimiting factor (hardcoded to hardware unfortunately, but only need to check one bit)

changeTensValue_35_10 sleep 
	




; test table 2; set multiplexer for porta 
callTensDigit addwf pcl ; CLEAR THE W REGISTER FIRST!!!!!
	retlw B'00000010'  ; turns on the tens digit 

callOnesDigit addwf pcl ; CLEAR THE W REGISTER FIRST!!!!!
	retlw B'00000100' ; turns on the ones digit 

; checks whether the number moved into the W register is zero; if it is, then place 00000001 into the W register and return; if it isn't, place 00000000 into the W register and return 
checkIfZero 


; 9 to 0 countdown with decimal point; load in pointers correctly!!! 
countdown_9_0_DP_PartOne addwf pcl 
	retlw B'11100000' 
	retlw B'11110000' 
	retlw B'11100000' 
	retlw B'00110000' 
	retlw B'10110000' 
	retlw B'01100000' 
	retlw B'11110000' 
	retlw B'11010000' 
	retlw B'01100000' 
	retlw B'11110000' 
	retlw B'00000000' ; end condition: set the decimal point 

countdown_9_0_DP_PartTwo addwf pcl 
	retlw B'00000111' 
	retlw B'00001111' 
	retlw B'00000001' 
	retlw B'00001111' 
	retlw B'00000111' 
	retlw B'00000111' 
	retlw B'00000011' 
	retlw B'00001011' 
	retlw B'00000001' 
	retlw B'00001101' 
	retlw B'00000000' ; end condition: set the decimal point to zero!! CHECK ONE BIT ONLY!! 

; countdown from 9 to 0 with no decimal point; load in pointers correctly! 
countdown_9_0_NoDP_PartOne addwf pcl 
	retlw B'11100000' 
	retlw B'11110000' 
	retlw B'11100000' 
	retlw B'00110000' 
	retlw B'10110000' 
	retlw B'01100000'
	retlw B'11110000' 
	retlw B'11010000' 
	retlw B'01100000' 
	retlw B'11110000' 
	retlw B'00000000' 

countdown_9_0_NoDP_PartTwo addwf pcl 
	retlw B'00000110' 
	retlw B'00001110' 
	retlw B'00000000' 
	retlw B'00001110' 
	retlw B'00000110' 
	retlw B'00000110'  
	retlw B'00000010'
	retlw B'00001010' 
	retlw B'00000000' 
	retlw B'00001100' 
	retlw B'00000001' ; end condition: SET DECIMAL POINT TO ONE!! CHECK ONE BIT ONLY! 	

end