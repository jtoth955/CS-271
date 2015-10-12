TITLE Program 1 

; Author: John R. Toth
; OSU Email: tothj@onid.oregonstate.edu
; CS 271-400
; Assignment #: 1
; Assignment due date: 4/12/2015
; Date: 4/4/2015
; Description: Multi-part assignment, I need to: Display my name and title on-screen, prompt user to enter two numbers,
; calculate the sum, difference, product, integer quotient and remainder of numbers, and display a terminating message 


INCLUDE Irvine32.inc

; (insert constant definitions here)

.data
char           BYTE      ?
intro_1		BYTE	"Hi, my name is John and I am a CS 271 student!",0
prompt_1	     BYTE	"Enter 2 numbers, I'll return the sum, difference, product, quotient & remainder. " ,0
prompt_2	     BYTE	"Enter your first number here: " ,0
prompt_3	     BYTE	"Now enter a second number that is less than your first: " ,0
error_1        BYTE "**EC: Your second value is greater than your first, did you do this on purpose? ",0
error_2        BYTE "**EC: Enter a 0 if it was a mistake, a 1 if it was intentional: ",0
numOne		DWORD	?	; integer value 1 to be entered by user
numTwo		DWORD	?	; integer value 2 to be entered by user
justChecking   DWORD     ?    ; integer value to be ensure a negative value was wanted
numSum		DWORD	?	; integer value from addition of numOne and numTwo
numDiff		DWORD	?	; integer value from subtraction of numOne and numTwo
numProduct	DWORD	?	; integer value from multiplying numOne and numTwo
numQuotient	DWORD	?	; integer value from dividing numOne and numTwo
numRemain	     DWORD	?	; integer remainder value from dividing numOne by numTwo 
result_Sum	BYTE	"The summation of your two numbers is: " ,0
result_Diff	BYTE	"Subtracting your first number from your second number gives us: " ,0
result_Prod	BYTE	"Multiplying your two numbers gives us: " ,0
result_Quo	BYTE	"Dividing your two numbers gives us: " ,0
result_rem	BYTE	" with a remainder of: " ,0 
go_Again       BYTE "**EC: Run the program again? If so, press a key within 5000MS!" ,0
goodBye		BYTE	"Time's up, good-bye " ,0  

.code
main PROC

; Introduce programmer
	mov		edx, OFFSET intro_1
	call	WriteString 
	call	CrLf

; Get the data from the user
L1:	
    
     mov		edx, OFFSET prompt_1
	call	     WriteString 
	call	     CrLf
	mov		edx, OFFSET prompt_2
	call	     WriteString
	mov		edx, OFFSET numOne
	call	     ReadInt
	mov		numOne, eax
	mov		edx, OFFSET prompt_3
	call	     WriteString 
	mov		edx, OFFSET numTwo
	call	     ReadInt 
	mov		numTwo, eax
         
L2:

; Ensure numTwo is less than numOne
     mov       ebx, numOne        ;numOne is stored in ebx
     CMP       ebx, eax
     ja        allClear           ;jump to allClear if numOne is > numTwo 
     jbe       Error              ;jump to Error if numTwo > numOne
    
Error: 
     call      CrLf
     mov       edx, OFFSET error_1
     call      WriteString
     mov       edx, OFFSET error_2
     call      WriteString
     mov       edx, OFFSET justChecking
     call      ReadInt
     mov       justChecking, eax
     mov       ebx, justChecking
     CMP       ebx, 0
     call      CrLf
     je        L1
     jne       allClear
     

allClear:
     mov       ebx, eax            ;move the eax register into the ebx register, to commence remainder of program

; Calculate the sum of the two values
	mov		eax, numOne
	add		eax, numTwo
	mov		numSum, eax

; Calculate the difference between the two values
	mov		eax, numOne
	mov		ebx, numTwo
	sub		eax, numTwo
	mov		numDiff, eax

; Calculate the product of the two values	
	mov		eax, numOne
	mov		ebx, numTwo
	mul		ebx
	mov		numProduct, eax
       
; Calculate the quotient between the two values
	mov		edx, 0			;pre-load edx with value of zero to guarantee value is < 32bits
	mov		eax, numOne
	mov		ebx, numTwo
	div		ebx
	mov		numQuotient, eax
	mov		numRemain, edx

; Display the results and closing: 
; Print results from calculating summation of numOne and numTwo	
	mov	     edx, OFFSET result_Sum
	call	     WriteString
	mov	     eax, numSum
	call	     WriteDec
	call	     CrLf
	
; Print results from calculating difference between numOne and numTwo
	mov	     edx, OFFSET result_Diff
	call	     WriteString 
	mov	     eax, numDiff
	call	     WriteInt
	call	     CrLf
	
; Print results from calculating product between numOne and numTwo
	mov	     edx, OFFSET result_Prod
	call	     WriteString 
	mov	     eax, numProduct  
	call	     WriteDec
	call	     CrLf

; Print results from calculating quotient of numOne and numTwo 
	mov	     edx, OFFSET result_Quo
	call	     WriteString
	mov	     eax, numQuotient
	call	     WriteDec
	mov	     edx, OFFSET result_Rem
	call	     WriteString
	mov	     eax, numRemain
	call	     WriteInt
	call	     CrLF
	
;Repeater fn, repeats program until user decides to quit    
;This section heavily referenced code found in the Irvine text, 7th ed. pg 205
     call      CrLf
     mov       edx, OFFSET go_Again
     call      WriteString            
     call      CrLf 
     call      Crlf
     mov       eax, 5000               ;create 5000ms delay to allow for user input
     call      Delay                   
     call      ReadKey                 ;check for user input                               
     jnz       L1                      ;repeat if user pushes inputs a keystroke
    

; Print "Goodbye" once user is finished	
     call	     CrLf
	mov	     edx, OFFSET goodBye
	call	     WriteString
	call	     CrLf


exit	; exit to operating system
main ENDP

END main