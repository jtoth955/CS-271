TITLE Program Template     (Assignment3.asm)

; Author:   John R Toth
; OSU Email: tothj@onid.oregonstate.edu
; CS 271-400
; Assignment #: 3
; Assignment due date: 5/3/15 
; Date: 4/27/15
; Description: Program that prompts user for an integer in the range of -1, through -100, validates, 
; accumulates and displays users numbers until a non-negative number is input. 

INCLUDE Irvine32.inc

LowL_CONST = -100                           ;Lower limit defined as a constant
COLORVAL = 4 

.data
BlueTextOnGray       =  blue + (lightGray *16)
DefaultColor         =  lightGray + (black *16)
userName	  BYTE	 33    DUP(0)	 ;string to be entered by user
Prog_intro1 BYTE     "  --Program Intro-- ",0
EC_intro    BYTE     "  ***EC: Number the lines during user input",0
EC_intro2   BYTE     "  ***EC: Do something astoundingly creative (blue text on gray screen)", 0 
prog_Title  BYTE     "  This is a program that accumulates negative numbers. ",0
intro_1     BYTE	 "  My name is John and we're going to work with negative numbers. ",0
prompt_1	  BYTE     "  What's your name? ",0 
intro_2     BYTE	 "  Nice to meet you, ",0 
negTerms    BYTE     "  Please enter a negative number between -1 and -100: ",0
negTerms1   BYTE     "  Enter number: ",0 
error1      BYTE     "  Your number is greater than 46! ",0
error2      BYTE     "  Your number is less than -100! ",0
accumNum1   BYTE     "  You have entered ",0
accumNum2   BYTE     " valid numbers. ",0 
sum         BYTE     "  The sum of your negative numbers is: ",0
avgNum      BYTE     "  The average of your negative numbers is: ",0
negNum	  DWORD	 ?	           ; integer value between -1 and -100 to be entered by user
numSum      DWORD    ?              ; sum value of user input integers
numAvg      DWORD    ?              ; avg of user input values
numRemain   DWORD    ?              ; decimal remainder of avg
count       DWORD    ?              ; sum of loop counter
TxtEdit     DWORD    ?              ; **E.C. counter for each line
goodBye1    BYTE     "  That was fun, ",0
goodBye2    BYTE     "  Thanks for doing this exercise with me ",0
goodBye3    BYTE     "  Sorry to see you go so soon, ",0

.code
main PROC

; Something astoundingly creative
    mov     eax, BlueTextOnGray
    call    SetTextColor
    call    Clrscr

; Introduction
    mov     TxtEdit, 0                    ;**EC insert numbers on each line   
    inc     TxtEdit
    mov     eax, TxtEdit 
    call    WriteDec
    mov     edx, OFFSET Prog_intro1
    call    WriteString
    call    CrLf
    inc     TxtEdit
    mov     eax, TxtEdit 
    call    WriteDec
    mov     edx, OFFSET EC_intro          ; introduce extra credit performed
    call    WriteString
    call    CrLf
    inc     TxtEdit
    mov     eax, TxtEdit 
    call    WriteDec
    mov     edx, OFFSET EC_intro2
    call    WriteString
    call    CrLf
    inc     TxtEdit
    mov     eax, TxtEdit 
    call    WriteDec
    call    CrLf
    inc     TxtEdit
    mov     eax, TxtEdit 
    call    WriteDec
    mov     edx, OFFSET prog_Title
    call    WriteString
    call    CrLf
    inc     TxtEdit
    mov     eax, TxtEdit                    
    call    WriteDec
    call    CrLf
    inc     TxtEdit
    mov     eax, TxtEdit 
    call    WriteDec
    mov     edx, OFFSET intro_1
    call    WriteString
    call    CrLf
    inc     TxtEdit
    mov     eax, TxtEdit 
    call    WriteDec
    mov     edx, OFFSET prompt_1
    call    WriteString
    mov     edx, OFFSET userName          ; get username
    mov     ecx, 32
    call    ReadString
    inc     TxtEdit
    mov     eax, TxtEdit 
    call    WriteDec
    mov     edx, OFFSET intro_2
    call    WriteString
    mov     edx, OFFSET username
    call    WriteString
    call    CrLf
    mov     count, 0


; userIntructions; provides instructions to user for how to interact with program 
  L1:
    inc     TxtEdit
    mov     eax, TxtEdit 
    call    WriteDec
    mov     edx, OFFSET negTerms
    call    WriteString
    call    CrLf
    inc     TxtEdit
    mov     eax, TxtEdit 
    call    WriteDec
    mov     edx, OFFSET negTerms1
    call    WriteString
    
; getUserData; validates user input 
    mov     edx, OFFSET negNum
    call    ReadInt
    mov     negNum, eax
    mov     eax, negNum
    CMP     eax, LowL_CONST
    JGE     SoFarSoGood                   ;user value is -1 or less, jump to SoFarSoGood
    

SoFarSoGood:
    CMP     eax, -1                       ;compare user number to ensure it is less than -1
    JLE     allClear                      ;user value is between -1 and -100, as intended  
    JG      improp1                       ;jump to improp1 if number is greater than -1

improp1:
    inc     TxtEdit
    mov     eax, TxtEdit 
    call    WriteDec
    JMP     Closing

improp2:
    inc     TxtEdit
    mov     eax, TxtEdit 
    call    WriteDec
    mov     edx, OFFSET error2            ;error message stating their value is < -100
    call    WriteString
    call    CrLf
    JMP     L1

allClear:
Looper:                         
    
; Increment loop counter          
    inc     TxtEdit
    mov     eax, TxtEdit 
    call    WriteDec
    inc     count
    mov     eax, count 
    mov     edx, OFFSET accumNum1
    call    WriteString
    call    WriteDec                       
    mov     edx, OFFSET accumNum2
    call    WriteString 
    call    CrLf
    
; Sum users values    
    inc     TxtEdit
    mov     eax, TxtEdit 
    call    WriteDec
    mov     eax, negNum   
    add     eax, numSum
    mov     numSum, eax 
    mov     edx, OFFSET sum
    call    WriteString 
    call    WriteInt
    call    CrLf
   
; Calc average negative value    
    inc     TxtEdit
    mov     eax, TxtEdit 
    call    WriteDec
    mov     eax, numSum
    mov     ebx, count
    cdq
    idiv    ebx
    mov     numAvg, eax
    mov     eax, numAvg
    mov     numRemain, edx
    mov     edx, OFFSET avgNum
    call    WriteString
    call    WriteInt
    call    CrLF 
    inc     TxtEdit
    mov     eax, TxtEdit 
    call    WriteDec
    call    CrLf
    JMP     L1

; goodBye
closing:       
    call    CrLf
    inc     TxtEdit
    mov     eax, TxtEdit 
    call    WriteDec
    cmp     count, 0
    JE      Special 
    mov     edx, OFFSET goodBye1
    call    WriteString
    mov     edx, OFFSET username
    call    WriteString
    call    CrLf
    inc     TxtEdit
    mov     eax, TxtEdit 
    call    WriteDec
    mov     edx, OFFSET goodBye2
    call    WriteString
    call    CrLF
    JMP     cls

; special goodBye; used when user exits program without any negative input
special: 
    mov     edx, OFFSET goodBye3
    call    WriteString
    mov     edx, OFFSET userName
    call    WriteString
    call    CrLf


cls:
exit	; exit to operating system
main ENDP

; 
END main