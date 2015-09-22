		org 00 
; program starts here 
		clrw			;clear W register
loop 	addlw 08 		;add the number 8 to W register 
		goto loop
		end				; show end of program with "end" directive