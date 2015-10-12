TITLE Program Template     (Assignment2.asm)

; Author:   John R Toth
; OSU Email: tothj@onid.oregonstate.edu
; CS 271-400
; Assignment #: 2
; Assignment due date: 4/19/15 
; Date: 4/13/15
; Description: Program that prompts user for an integer in the range of 1-46, validates, 
; calculates and displays Fibonacci numbers. 

INCLUDE Irvine32.inc

FIB_CONST = 46                            ;Fibonacci upper limit defined as a constant
TAB = 9                                   ; ASCII code for 'Tab'

.data

userName	  BYTE	 33    DUP(0)	 ;string to be entered by user
Prog_intro1 BYTE     "--Program Intro-- ",0
Prog_intro2 BYTE     "**EC: I displayed the Fibonacci numbers in columns ",0
Prog_intro3 BYTE     "**EC: I changed the colors of the output screen, incredible huh? ",0
prog_Title  BYTE     "This is a program that calculates Fibonnaci numbers. ",0
intro_1     BYTE	 "My name is John and we're going work with Fibonacci numbers. ",0
prompt_1	  BYTE     "What's your name? ",0 
intro_2     BYTE	 "Nice to meet you, ",0 
fibTerms    BYTE     "How many Fibonacci terms would you like to display? ",0
fibTerms2   BYTE     "Please enter a number between 1-46: ",0
error1      BYTE     "Your number is greater than 46! ",0
error2      BYTE     "Your number is less than 1! ",0
fibVal      BYTE     "Your Fibonacci sequence is: ",0
fibNum	  DWORD	 ?	           ; integer value 1-46 to be entered by user
numOne	  DWORD	 1	           ; integer value of 1 to begin Fibonacci sequence
numTwo	  DWORD	 0	           ; integer value of 1 to begin Fibonacci sequence
count       DWORD    ?              ; inner loop used to limit printing of 5 Fib's per line
outer       DWORD    ?              ; variable that holds outer loop count
goodBye1    BYTE     "That was fun, ",0
goodBye2    BYTE     "Thanks for doing this exercise with me ",0

.code
main PROC



; Introduction
    mov     eax, white + (red*16)
    call    SetTextColor
    mov     edx, OFFSET Prog_intro1
    call    WriteString
    call    CrLf
    mov     edx, OFFSET Prog_intro2
    call    WriteString
    call    CrLf
    mov     edx, OFFSET Prog_intro3
    call    WriteString
    call    CrLf
    call    CrLf
    mov     edx, OFFSET prog_Title
    call    WriteString
    call    CrLf
    call    CrLf
    mov     edx, OFFSET intro_1
    call    WriteString
    call    CrLf
    mov     edx, OFFSET prompt_1
    call    WriteString
    mov     edx, OFFSET userName
    mov     ecx, 32
    call    ReadString
    mov     edx, OFFSET intro_2
    call    WriteString
    mov     edx, OFFSET username
    call    WriteString
    call    CrLf

; userIntructions
  L1:
    mov     edx, OFFSET fibTerms
    call    WriteString
    call    CrLf
    mov     edx, OFFSET fibTerms2
    call    WriteString
    
; getUserData
    mov     edx, OFFSET fibNum
    call    ReadInt
    mov     fibNum, eax
    mov     eax, fibNum
    CMP     eax, FIB_CONST
    JBE     SoFarSoGood                   ;user value is 46 or less, jump to SoFarSoGood
    JA      improp1                       ;jump to improp1 if number if greater than 46

SoFarSoGood:
    CMP     eax, 1                        ;compare user number to ensure it is 1 or greater
    JB      improp2                       ;jump to improp2 if number is less than 1 
    JAE     allClear                      ;user value is between 1-46, as intended  

improp1:
    mov     edx, OFFSET error1            ;error message stating their value is > 46
    call    WriteString
    call    CrLf
    JMP     L1

improp2:
    mov     edx, OFFSET error2            ;error message stating their value is < 1
    call    WriteString
    call    CrLf
    JMP     L1

allClear:

; displayFibs
    call    CrLF
    mov     edx, OFFSET fibVal
    call    WriteString
    call    CrLF    
    mov     ebx, numOne                   ;initialize ebx register to value stored in numOne
    mov     edx, numTwo                   ;initialize edx register to value stored in numTwo
    mov     count, 5
    mov     ecx, fibNum                   ;initialize loop counter user input
Looper:                         
    
    mov     eax, ebx                      
    add     eax, edx
    mov     ebx, edx
    mov     edx, eax
    call    WriteDec                      ;print value from current Fibonacci iteration 
    JMP     printer
    

; **E.C. - use tab character to align output
printer: 
    mov     al, TAB                       ;according to research done on daniWeb and stackoverflow, the tab
    call    WriteChar                     ;character seems to be the easiest way to align numbers in columns
    dec     count
    CMP     count, 0                      
    JE      newLine                       ;once count = 0, jump to newLine to insert CrLf
    loop    Looper

newLine: 
    call    CrLf
    mov     count, 5                      ;reset count, then jump back to looper
    CMP     ecx, 0
    JE      closing
    loop    Looper

; goodBye
closing:       
    call    CrLf
    mov     edx, OFFSET goodBye1
    call    WriteString
    mov     edx, OFFSET username
    call    WriteString
    call    CrLf
    mov     edx, OFFSET goodBye2
    call    WriteString
    call    CrLF



	exit	; exit to operating system
main ENDP

; 
END main