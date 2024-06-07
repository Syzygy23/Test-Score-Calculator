;/////////////////////////////////////////////////////////
;//                         				//
;//      Input a 3 digit number         		//
;//  Converts to Decimal, and back to ASCII     	//
;//                         				//
;//       Requires MULT, DIV Subroutine     		//
;//                         				//
;/////////////////////////////////////////////////////////
.ORIG X3000

AND R0, R0, #0
AND R1, R1, #0
AND R2, R2, #0
AND R3, R3, #0
AND R4, R4, #0
AND R5, R5, #0
AND R6, R6, #0

;//Set initial MAX and MIN values
ST R5, MAX			;//Max will start at 0
ST R5, SUM			;//Sum will start at 0
ADD R5, R5, xF
add R5, R5, xF
ADD R5, R5, xF
ADD R5, R5, xF
ADD R5, R5, xF	
ADD R5, R5, xF
add R5, R5, xF
ADD R5, R5, xF
ADD R5, R5, xF
ADD R5, R5, xF	
ST R5, MIN			;//MIN will start at 100
AND R5, R5, #0	



;//Prompt user for five 3 digit test scores. If 1st input is 1, assume 100

LEA R0, PROMPT		
PUTS

INPUTLOOP
	ST R6, SAVER6		;//R6 will serve as counter. Store current count


	JSR ASCIITOHEX		;//Subroutine takes input and converts it to HEX
	ST R4, NUM		;//Store inputted number into NUM

	AND R0, R0, #0
	ADD R0, R0, #13		;//ASCII 13 is newline
	OUT
	AND R0, R0, #0


	;LEA R0, INMSG		
	;PUTS
	;JSR HEXTOASCII		;//Subroutine converts inputted number back to ASCII and displays it to user

	;//Increase SUM for the average
	LD R5, SUM
	ADD R5, R5, R4		;SUM += R4
	ST R5, SUM			
	AND R5, R5, #0



	CHECKMAX		;//Checks MAX value, replaces it if needed, then displays current MAX
	LD R5, MAX
	NOT R5, R5
	ADD R5, R5, #1	;//R5 = -MAX

	ADD R2, R4, R5	;//R2 = Input (HEX) - MAX
	BRnz NOTMAX	;//If MAX > Input, don't replace MAX

	ST R4, MAX	;//If MAX < Input, replace MAX

	NOTMAX

	;CHECKMIN
	LD R5, MIN
	NOT R5, R5
	ADD R5, R5, #1	;//R5 = -MIN

	ADD R2, R4, R5	;//R2 = Input (HEX) - MIN
	BRzp NOTMIN	;//If MIN < Input, don't replace MIN

	ST R4, MIN

	NOTMIN

	;//Clear used registers
	AND R0, R0, #0
	AND R1, R1, #0
	AND R2, R2, #0
	AND R3, R3, #0
	AND R4, R4, #0
	AND R5, R5, #0
	AND R6, R6, #0

	LD R6, SAVER6		;//Load R6 with current count
	ADD R6, R6, #1		;//Increment Count
	ADD R5, R6, #-5		;//Compare with 5 (total expected inputs)
BRn INPUTLOOP			;//If count has not reached 5, prompt user again

;//Calculate the average
LD R3, SUM
AND R2, R2, #0
ADD R2, R2, x5

JSR DIV				;//R3 / R2 = R4; R4 contains the average
ST R4, AVG

LEA R0, AVGMSG
PUTS
JSR HEXTOASCII

LD R4, MAX			;//Load R4 with current MAX
LEA R0, MAXMSG
PUTS
JSR HEXTOASCII			;//Display current MAX

LD R4, MIN
LEA R0, MINMSG
PUTS
JSR HEXTOASCII 			;//Display current MIN







HALT


;// Strings & Labels    //
PROMPT  .STRINGZ "Enter five 3 digit test scores (0-100). Entering a 1 assumes 100.\n"
;PROMPT1 .STRINGZ "Digit 1: "
;PROMPT2 .STRINGZ "Digit 2: "
;PROMPT3 .STRINGZ "Digit 3: "
;HUNDRED .STRINGZ "Assuming 100... "
ERROR   .STRINGZ "Error! Invalid Input."
;INMSG	.STRINGZ "\n\nYour number is: "
MAXMSG	.STRINGZ "Your best score is: "
MINMSG	.STRINGZ "Your worst number is: "
AVGMSG	.STRINGZ "\nYour class average is: "

HEX30   .FILL x0030
HEXN30  .FILL xFFD0

;//Could have 9 digits total: Min Digits, Max digits, Avg digits
;DIGIT1  .FILL X3300
;DIGIT2  .FILL X3301
;DIGIT3  .FILL X3302
MAX		.FILL X3303
MIN		.FILL X3304
SUM		.FILL x3305
AVG		.FILL x3306

SAVER0	.FILL x0
SAVER1	.FILL x0
SAVER2  .FILL x0
SAVER3  .FILL x0
SAVER4	.FILL x0
SAVER5	.FILL x0
SAVER6	.FILL x0
SAVER7	.FILL x0
NUM 	.FILL x0


;///////////////////////////////////
;/	SubRoutines		   /
;///////////////////////////////////

;//R1 * R2 = R3
MULT    
    ;//Save register values
    ;ST R1, SAVER1
    ;ST R2, SAVER2
    ;ST R3, SAVER3


    AND R3, R3, #0
    MLOOP
    ADD R3, R3, R1
    ADD R2, R2, #-1
    BRp MLOOP


    ;LD R1, SAVER1
    ;LD R2, SAVER2
    ;LD R3, SAVER3
    RET
;// R3 / R2 = R4, R3 % R2 = R5
DIV
    ST R2, SAVER2    
    ST R3, SAVER3
    AND R4, R4, x0
    NOT R2, R2
    ADD R2, R2, #1
   
    DLOOP
    AND R5, R5, x0
    ADD R4, R4, #1
    ADD R5, R3, x0
    ADD R3, R3, R2
    BRzp DLOOP
    ADD R4, R4, #-1
    RET
   



;//Expects full HEX number in R4
HEXTOASCII
	ST R7, SAVER7		;//Due to pointer issues, must save our calling address R7
	ST R4, SAVER4
	AND R2, R2, x0
	;//Convert Digit 1. If 1, assume other digits are 0
	;//ADD R5, R4, #0       ;//R5 holds full number for future use
	ADD R3, R4, x0      	;//R3 = Full Number
	ADD R2, R2, xF
	ADD R2, R2, xF
	ADD R2, R2, xF
	ADD R2, R2, xF
	ADD R2, R2, xF
	ADD R2, R2, xF
	ADD R2, R2, xF
	ADD R2, R2, xF
	ADD R2, R2, xF
	ADD R2, R2, xF      	;//R2 = 100


	JSR DIV             	;//R3 / R2 = R4, R3 saved into SAVER3
	LD R3, SAVER3       	;//R3 has full number again
	;ST R4, DIGIT1       	;//Digit1 now holds first digit in HEX
	LD R6, HEX30
	ADD R0, R4, R6		;//R0 contains 1st digit (ASCII)
	OUT			;//Display 1st digit


	;//Check if first digit is 1
	AND R2, R2, x0
	ADD R2, R2, x1
	NOT R2, R2
	ADD R2, R2, x1      	;//R2 = -1
	ADD R4, R4, R2      
	BRz SKIP1


	;//Convert Digit 2


	;//ADD R3, R5, #0       ;//R3 = Full Number
	AND R2, R2, x0      
	ADD R2, R2, xF          ;//R2 = 10


	JSR DIV         	;//R3 / R2 = R4. R5 holds remainder
	LD R3, SAVER3		;//R3 contains full number again
	ADD R0, R4, R6		;//R0 contains 2nd digit (ASCII)
	OUT
	ADD R0, R5, R6		;//R0 contains 3rd digit (ASCII)
	OUT

	AND R0, R0, #0
	ADD R0, R0, #13		;//ASCII #13 is enter key
	OUT
	AND R0, R0, #0

	LD R4, SAVER4
	LD R7, SAVER7		;//Restore calling address
	RET

	SKIP1			;//Output 0 twice
	LD R0, HEX30
	OUT
	OUT

	AND R0, R0, #0
	ADD R0, R0, #13		;//ASCII #13 is enter key
	OUT
	AND R0, R0, #0

	LD R4, SAVER4
	LD R7, SAVER7		;//Restore calling address
	RET
;//Accepts a triple digit input and converts it to HEX. If first input is 1, assumes 100
ASCIITOHEX
	ST R7, SAVER7
	AND R6, R6, #0		;//Set R6, which was the counter, to 0
	GETC			;//R0 contains Digit 1 (ASCII)
	OUT			;//Show what user just typed


	;//Convert ASCII to Decimal
	ADD R1, R0, X0      	;//R1 = Digit 1 (ASCII)
	LD R6, HEXN30
	ADD R1, R1, R6      	;//R1 = Digit1 (Hex)


	;//Verify; if digit1 - 1 is positive, then digit1 > 1
	ADD R2, R2, x1
	NOT R2, R2
	ADD R2, R2, x1	;R2 = -1

	ADD R2, R2, R1
	BRp ERROR
	;//If digit 1 was 1 (that is, if R2 = 1 - 1 = 0), assume input will be 100
	BRz SKIP


	;//Get Digit 2
	GETC
	OUT
	;//Convert ASCII to Decimal
	ADD R1, R0, X0      	;//R1 = Digit 2 (ASCII)
	ADD R1, R1, R6      	;//R1 = Digit 2 (Decimal)


	;//Multiply by 10, since Digit 2 is in ten's place
	AND R2, R2, x0
	ADD R2, R2, xF		;//R2 = 10
	JSR MULT            	;//R1 * R2 = R3
	ADD R4, R3, x0      	;//R4 = Digit2 * 10




	;//Get Digit 3
	GETC
	OUT
	;//Convert ASCII to Decimal
	ADD R1, R0, x0      	;//R1 = Digit 3 (ASCII)
	ADD R1, R1, R6      	;//R1 = Digit 3 (Decimal)

	;//Get full number by adding digit3 to R4
	ADD R4, R4, R1		;//R4 contains full number

	LD R7, SAVER7
	RET			;//Could replace with branching to max or min


	SKIP            
	;//Autofill input with '00
	LD R0, HEX30
	OUT
	OUT


	;//Multiply R1 by 100 
	AND R2, R2, x0
	ADD R2, R2, xF
	ADD R2, R2, xF
	ADD R2, R2, xF
	ADD R2, R2, xF
	ADD R2, R2, xF
	ADD R2, R2, xF
	ADD R2, R2, xF
	ADD R2, R2, xF
	ADD R2, R2, xF
	ADD R2, R2, xF
	JSR MULT            	;//R1 * R2 = R3, R3 is full number
	AND R4, R4, x0      
	ADD R4, R3, x0		;//R4 contains full number

	LD R7, SAVER7
	RET			;//Could replace with branching to max or min


.END
