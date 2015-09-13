;------------------------------------------------------------------------------
;Write a program to display "AMMA" on LCD and blink the cursor on the next line.
;Simple PIC 16F877X Program to drive a SERIAL LCD.
;------------------------------------------------------------------------------
;PIC 16F877a Processor clock speed :4MHZ and Baud rate : 9600
;MILFORD-2X16-BKP LCD processor clock speed :4MHZ and Baud rate : 9600
;------------------------------------------------------------------------------
;PORTC pin RC6/TX ---> RXD (LCD)
;VDD(LCD) - Power
;VSS(LCD) - Ground
;------------------------------------------------------------------------------

         processor 	16F877a 			; Define Microcontroller type
	 	 __config	0x3731 				; Processor Clock : 4MHz
;--------------------------------------------------------------------------------------
;Configuration Word Register : is a 14-bit register allows the user to set up the
;oscillator mode and enable or disable features such as the Watchdog Timer (WDT), 
;Code Protection, and Low Voltage Programming.
;--------------------------------------------------------------------------------------
		 #include	"P16F877a.INC" 		; include defaults

	   	 cblock 0x20					; general purpose registers defined on RAM
         LCDdata ,CMDreg,K,J
         endc

         org     0x00					; Startup vector: Starting address of the program memory ROM				
         goto    start					
          
ISR		 org     0x04					; Interrupt vector: Starting dddress of ISR on ROM
         goto    ISR				
		 org	 0x10					; Starting address of our program on ROM
;-------------------------------------------------------------------------------------
start  									; Begining of the main program 
;-------------------------------------------------------------------------------------   
       	banksel TRISC  					; Select bank 1 for TRISC, TXSTA and SPBRG
		movlw	B'10000000'
		movwf	TRISC					; Configure RC7/RX as input pin	and others as outputs

										; TXSTA :Transmit Status and Control Register
		bcf 	TXSTA,TX9				; Select 8-bit transmision
		bcf		TXSTA,SYNC 				; Asynchronous mode (there is no clock signal)
		bsf		TXSTA,BRGH 				; High baud rate
		bsf		TXSTA,TXEN 				; Enable transmitter

										; SPBRG :USART Baud Rate Generator Registor
		movlw	d'25'  					; Baud rate value.
		movwf 	SPBRG 					; 9600 baud (at 4MHz processor clock frequency)

										; Receive Status and Control Registor
		banksel RCSTA  					; Select bank 0
		bsf		RCSTA,SPEN 				; Enable serial port
		  
	   	movlw   0x80 		   			; 80(Hex)=128(Decimal), DDRAM address Reset display to 00
		call 	sendCMD					; i.e, which moves cursor to zeroth row zeroth column.		
		call    Delay					; Delay routine should be called 2 times. Let LCD settle down. 
		call	Delay					
	   
;---------------------------------------------------------------------------------------------------
;Text to be displayed on the LCD must be sent serially at either 2400 or 9600 baud, no parity, eight
;data bits and one stop bit.(In this program we used 9600 baud)

;Instructions(commands) to the LCD must be prefixed by the single byte 254(Decimal)/FE(Hex). Which 
;will put the LCD into Instruction mode(Command mode). The LCD automatically reverts to Display mode
;once an instruction is received.

;Note that LCDs require approximately 500ms to settle down after powering up and data/control codes 
;should not be sent to it during this period. Similarly a delay of 10ms should be needed after a 
;Clear Screen or Home command before other data is sent.
;---------------------------------------------------------------------------------------------------		   
        movlw   'P'             		; Transmit : 'P'.
	    call    SendToLCD                       
        movlw   'A'             		; Transmit : 'A'.
	    call    SendToLCD                      
        movlw   'D'             		; Transmit : 'D'.
	    call    SendToLCD                       
        movlw   'M'             		; Transmit : 'M'.
	    call    SendToLCD                       
		movlw   'A'             		; Transmit : 'A'.
	    call    SendToLCD    

	    movlw   0xC0 	           		; Move cursor to  First row, Zeroth column 
	    call    sendCMD					; DDRAM address:192(Decimal):C0(Hex)

	    movlw   0x0D 		   	   		; Show(turn-on) blinking cursor(0D:13), there are two types of cursors
	    call    sendCMD					; 1.Blinking cursor & 2.Under line cursor 
										; To turn on underline cursor move 0x0E(Hex)/14(Decimal)					
	         
hang    clrwdt                 			; Clear WDT in case it is enabled.
	    goto	 hang			
;---------------------------------------------------------------------------------------------------
;Apart from the data to be displayed on the screen, the LCD will accept some common control codes
;called as commands. To differentiate between control codes(commands) and normal characters(data),
;first the command-prefix code 254(Decimal)/FE(Hex) must be sent the LCD. Followed by the actual 
;command-code will be sent.

;Example :  To clear the LCD screen, first we need to send the prefiix-code, 254, and then the
;command code 01(for clearing LCD screen). SERIALOUT(254,1)

;Once the control code has been received by the LCD, it will revert back to normal operation (ie
;ready to receive a normal character). The other control codes you may need are as follows

;---------------------------------------------------------------------------------------------------
;Subroutine : sendCMD : to sent a command code to LCD
;---------------------------------------------------------------------------------------------------
sendCMD	movwf 	CMDreg    	  			; Store the command code in CMDreg    
	   	movlw	0xFE         			; Before send command to LCD, send prefix-code to LCD
	   	call 	SendToLCD
	   	movf 	CMDreg,W	          	; Then send the command-code
	   	goto 	SendToLCD
               
;---------------------------------------------------------------------------------------------------
;Subroutine : ReadRCREG :  To read data from RCREG and put it in W
;---------------------------------------------------------------------------------------------------
ReadRCREG	
		bcf     STATUS,RP1      		; Select Bank0( for PIR1, PIR2 and RCREG)
		bcf     STATUS,RP0

getcheck 
	 	btfss   PIR1,RCIF	    		; Is data received? i.e Is RCIF set?  
	   	goto    getcheck        		; No, Try again
	   	movf	RCREG,W      			; Yes, move data w
	   	bcf     PIR1,RCIF       		; Clear the RCinterrupt flag 
	   	return

;---------------------------------------------------------------------------------------------------
;Subroutine : putc :  To read data from RCREG and put it in W
;---------------------------------------------------------------------------------------------------
SendToLCD
	    bcf     STATUS,RP1      		; Select Bank0(For TXREG)
	    bcf     STATUS,RP0
        movwf   TXREG           		; Write it to TXREG! 
        bsf     STATUS,RP0      		; Select Bank1(For TXSTA and SPBRG)

putcheck
	    btfss   TXSTA,1    	  			 ; TRMT(Transmit Status Bit) If transmission is over TRMT would be HIGH								   								   		 
        goto    putcheck        		 ; No, let tansmission over   
        bcf     STATUS,RP0      		 ; Yes, Reselect Bank 0 and return.   
        return
;---------------------------------------------------------------------------------------------------
;Subroutine : Delay 
;---------------------------------------------------------------------------------------------------
Delay	bcf 	STATUS, RP1				; select bank0
		bcf 	STATUS, RP0	
		movlw 	d'250'			
		movwf 	J
Jloop:	movwf 	K
Kloop:	decfsz 	K,f
		goto 	Kloop
		decfsz 	J,f
		goto 	Jloop
		return
;---------------------------------------------------------------------------------------------------
		end								; end of the program	
;---------------------------------------------------------------------------------------------------
; Serial communication is very important for micro devices.
; Using the serial communication one can communicate with computers,
; peripheral devices, with some Ics, A/D converters, etc. (via COM port, USB, etc)

; Most PIC microcontrollers come with built in serial communication protocols
; such as USART, I2C and SPI. Just we need to configure it and start receive/transmit.
; Here we  are going to  use PC's COM port called as RS-232 (Recommended Standard 232)
; and built in USART module of PIC micro. 

; USART is the acronym of Universal Synchronous Asynchronous Receive Transmit.
; Standard COM port uses asynchronous receiver and transmitter.
; In this mode there are two signal lines Tx (transmit) and Rx (receive). 
; It can transmit and receive information at the same time.
; Because of this, it is called full-duplex communication. 
;---------------------------------------------------------------------------------------------------
;LCD Character DDRAM address map (16 characters x 2 rows display = 32 characters)

;Line-1 address	:	0      1      2      3    4  ......15
;DD address		:	128    129    130    131  132 .....143

;Line-2 address	:   0      1      2      3    4  ......15
;DD address 	:	192   193    194    195   196.....207

;Zeroth row, Zeroth column, character would be stored at address 128 on  LCD-DDRAM
;First row, zeroth column, character would be stored at address 192 on  LCD-DDRAM.
;To put a character at the 4th position on line1, wee need to send 132 and as command
;code, because, 128(the starting address of line1) +  4 (the desired position on line1)
; =  132(the address of the character to be put on)

;---------------------------------------------------------------------------------------------------
;Sending 40 characters to a 32-character display would display only the first 32 characters
;sent. The missing characters are stored in the LCDs RAM but not displayed. It would be
;necessary to scroll-left to see these missing characters. There is no automatic
;wrap-round to the second line(or subsequent lines). Once the end of a (physical) line is reached,
;the DDRAM address must be reset to the beginning of the next(physical) line. 
;---------------------------------------------------------------------------------------------------
;COMMAND 								CODE(in Decimal)
;Command-Perfix							254 
;Clear Screen 							01
;Scroll display one character left 		24
;Scroll display one character right 	28
;Home (and undo scrolling)				00
;Move  cursor one character left 		16
;Move cursor one character right 		20
;Turn on underline cursor				14
;Turn on blinking cursor 				13
;Turn off cursor 						12
;Blank the display (retaining data) 	08
;Restore the display (without cursor) 	12
;Set display (DD) RAM address 			128 + address
;---------------------------------------------------------------------------------------------------
