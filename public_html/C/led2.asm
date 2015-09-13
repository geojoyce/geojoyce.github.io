LIST P=16F877A
#INCLUDE P16F877A.INC

BCF STATUS,RP1
BSF STATUS,RP0

MOVLW 0XFF
MOVWF TRISB
MOVWF TRISC

MOVLW 0X00
MOVWF TRISD

BCF STATUS,RP0
BCF STATUS,RP1

BTFSS PORTC,7
GOTO LOOPA
GOTO LOOPB

LOOPA
BTFSS PORTB,6
GOTO LOOPC
GOTO LOOPD

LOOPC
BTFSC PORTC,5
CALL S1
BTFSS PORTC,5
CALL S2
CALL T1

LOOPD
BTFSC PORTC,5
CALL S3
BTFSS PORTC,5
CALL S4
CALL T1

LOOPB
BTFSS PORTB,6
GOTO LOOPE
GOTO LOOPF

LOOPE
BTFSC PORTC,5
CALL S5
BTFSS PORTC,5
CALL S6
CALL T1

LOOPF
BTFSC PORTC,5
CALL S7
BTFSS PORTC,5
CALL S8
CALL T1

S1

MOVF PORTB,W
MOVWF 0X20
MOVF PORTC,W
ADDWF 0X20,W
MOVWF PORTD 

RETURN

S2

MOVF PORTB,W
MOVWF 0X20
MOVF PORTC,W
SUBWF 0X20,W
MOVWF PORTD

RETURN

S3

MOVF PORTB,W
MOVWF 0X20
MOVLW 0X00
MOVWF 0X21
BCF PORTC,5
BCF PORTC,6
BCF PORTC,7
MOVF PORTC,W

MUL

ADDWF 0X21,F
DECFSZ 0X20
GOTO MUL

MOVF 0X21,W
MOVWF PORTD  

RETURN

S4

MOVLW 0X00
MOVWF 0X40

MOVF PORTB,W
MOVWF 0X20
BCF PORTC,5
BCF PORTC,6
BCF PORTC,7
MOVF PORTC,W

DIV

SUBWF 0X20,W
BTFSS PORTC,C
INCF 0x40
BTFSS PORTC,C
GOTO DIV

MOVF 0X40,W
MOVWF PORTD 

RETURN


S5

MOVF PORTB,W
MOVWF 0X20
MOVF PORTC,W
ANDWF 0X20,W
MOVWF PORTD 

RETURN

S6

MOVF PORTB,W
MOVWF 0X20
MOVF PORTC,W
IORWF 0X20,W
MOVWF PORTD 

RETURN

S7

MOVF PORTB,W
MOVWF 0X20
MOVF PORTC,W
XORWF 0X20,W
MOVWF PORTD 

RETURN

S8

MOVF PORTB,W
MOVLW 0X20
COMF 0X20
MOVF 0X20,W
MOVWF PORTD 

RETURN

T1
END
