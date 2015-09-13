;--------------------------------------------------------------------------------------  
;The following program demonstrate USART operation by outputting a message "Namah
;Shivayah$"  on a virtual terminal. Then the program waits for reading a numerical
;input typed on the virtual terminal through keyborad, it coverts the input data into
;BCD code and display the code on Seven-segmant-BCD-display. At the same time the
;program echos the input data on the virtual terminal too.(i.e it sends/displays the 
;input data back to/on the virtual terminal).NOTE: Processor Clock Speed : 4MHz

;Connection:
;RD0 to RD3 --> Seven Segment BCD Display
;RC6/TX --->RXD (Virtual Terminal)
;RC7/RX --->TXD	(Virtual Terminal)
;--------------------------------------------------------------------------------------  
		LIST	 p=16F877a	    		; Type of  microcontroller chip we are using
		include "P16F877a.inc"  		; include the defaults for the chip
	

		cblock	0x20					; general purpose register on RAM
		endc
	
		DTpointer EQU 	020 			; Data Table Instruction Pointer		
 		Inchar 	  EQU 	021 	

		org		0x00		    		; Starting address of the program memory (ROM)			
		goto	start					 
	    org		0x10					; Starting address of our program on ROM	

;-------------------------------------------------------------------------------------- 
;Subroutine for writing message to terminal............................................
;--------------------------------------------------------------------------------------            
write           movlw   0x04
		call	SendtoVT				; Output on terminal (serial communiation)
		return						; yes, all done, return to main program
;-------------------------------------------------------------------------------------- 
;Subroutine name : ReadVT  : To read input numbers typed on terminal...............
;--------------------------------------------------------------------------------------  
ReadVT
	    bsf 	RCSTA,CREN 				; Enables continuous receive
wait1   btfss  	PIR1,RCIF 				; Character received? 
		goto	wait1 					; no - wait
		movf	RCREG,W 				; get input character
		movwf	Inchar 					; store input character
		movlw   0x30 					; ASCII number offset
		subwf   Inchar,W 				; Calculate number
		movwf	PORTD 					; display it
		return						; done
;-------------------------------------------------------------------------------------- 
;Subroutine name : SendtoVT : To transmit a character to Virtual Terminal...............
;--------------------------------------------------------------------------------------  
SendtoVT 
		movwf	 TXREG  				; load transmit register with the wreg data 
wait2 	btfss	 PIR1,TXIF 				; Is data sent to VT?
 		goto	 wait2					; no
 		return							; yes
;-------------------------------------------------------------------------------------- 


 start  						    	; begining of the program	
;-------------------------------------------------------------------------------------- 
		banksel TRISD  					; Select bank 1
		clrf 	TRISD 					; Configure PORTD as output port (BCD encode-Seven Segment)
		movlw	B'10000000'
		movwf	TRISC					; Configure RC7/RX as input pin	and others as outputs
		
										; TXTA :Transmit Status and Control Register
		bcf 	TXSTA,TX9				; Select 8-bit transmision
		bcf 	TXSTA,TXEN 				; Disable transmission 
		bcf		TXSTA,SYNC 				; Asynchronous mode (there is no clock signal)
		bsf		TXSTA,BRGH 				; High baud rate

										; SPBRG :USART Baud Rate Generator Registor
		movlw	D'25'  					; Baud rate value.
		movwf 	SPBRG 					; 9600 baud, 4MHz

		bsf		TXSTA,TXEN 				; Enable transmission
										; Receive Status and Control Registor
		banksel RCSTA  					; Select bank 0
		bsf		RCSTA,SPEN 				; Enable serial port

	
		call	write 					; Message on terminal
readin  call	ReadVT					; Read input from VT (Virtual Terminal)
		goto 	readin 					; Keep reading until reset
loop	goto	loop
;-------------------------------------------------------------------------------------- 
		end					  			; end of the program
;-------------------------------------------------------------------------------------

