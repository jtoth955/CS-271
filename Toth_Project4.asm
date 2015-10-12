TITLE Program #4     (Program4.asm)

; Author: John Toth
; OSU Email: tothj@onid.oregonstate.edu
; CS 271-400
; Assignment #: 4
; Assignment due date: May 10, 2015 
; Date: 4/2/2015
; Description: This program calculates composite numbers 

INCLUDE Irvine32.inc

ULCOMP_NUM = 400                            ;Upper limit Composite Number
TAB = 9                                     ;ASCII code for 'Tab'

.data
compNums    DWORD   ?           ;Number of Composite Numbers to be displayed, by user
numVal      DWORD   ?           ;Numerator value
dumVal      DWORD   ?           ;Denominator value
userName    BYTE    33  DUP(0)  ; string to be entered by user
Prog_intro1 BYTE    "--Program Intro-- ",0
Prog_intro2 BYTE    "**EC: I displayed the Composite Numbers in columns ",0
Prog_Title  BYTE    "This is a program that calculates composite numbers ",0
intro_1     BYTE    "My name is John and we're going to work with Composite Numbers ", 0 
prompt_1    BYTE    "What is your name? ",0
intro_2     BYTE    "Nice to meet you, ",0
numComp     BYTE    "How many Composite Numbers you would like to display? ",0
numComp2    BYTE    "Please enter a number between 1-400: ",0 
error1      BYTE    "Your number is greater than 400, try again! ",0
error2      BYTE    "Your number is less than 1, try again! ",0
compMsg     BYTE    "Your Composite Numbers are: ",0
goodBye1    BYTE    "That was fun, ",0
goodBye2    BYTE    "Thanks for doing this exercise with me ",0

.code
main PROC
    call    introduction
    call    getUserData
    call    showComposites
    call    farewell

    exit	; exit to operating system
main ENDP

;Procedure to introduce the program.
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx

introduction    PROC
    mov     edx, OFFSET Prog_intro1
    call    WriteString 
    call    CrLf
    mov     edx, OFFSET Prog_intro2
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

    ret
Introduction    ENDP
	
;Procedure to get value for number of composites to display, from user.
;receives: none
;returns: User inputs number of composites to be displayed, within range of 1-400
;preconditions:  none
;registers changed: eax,edx

getUserData     PROC

;get number of Composites to display
L1:  
    mov     edx, OFFSET numComp
    call    WriteString  
    call    CrLf
    mov     edx, OFFSET numComp2
    call    WriteString
    call    ReadInt 
    mov     compNums, eax
    mov     eax, compNums
    CMP     eax, ULCOMP_NUM                 ;compares user input to upper level constant value          
    JBE     SoFarSoGood                     ;jumps to next comparison if good
    JA      improp1                         ;jumps to error if bad

SoFarSoGood:
    CMP     eax, 1                          ;compare eax to ensure number is 1 or greater
    JB      improp2                         ;jump to improp2 if less than 1
    JAE     allClear                        ;jumps to end if all clear

improp1: 
    mov     edx, OFFSET error1              ;verify number is less than or equal to 400
    call    WriteString 
    call    CrLf
    JMP     L1

improp2: 
    mov     edx, OFFSET error2              ;verify number is greater than or equal to 1
    call    WriteString
    call    CrLf
    JMP     L1

allClear:

    ret
getUserData     ENDP

;Procedure to produce composite values.
;receives: user input value for number of composite values to show
;returns: composite values 
;preconditions:  none
;registers changed: 

showComposites      PROC

    call    CrLf
    mov     edx, OFFSET compMsg
    call    WriteString
    call    CrLf  
    call    CrLf  
    mov     numVal, 4                           ;initialize initial composite value
    mov     dumVal, 2
    mov     ecx, compNums
Looper: 
    mov     eax, numVal
    cdq
    mov     ebx, dumVal
    div     ebx
    CMP     edx, 0
    JE      compCheck                           ;if edx equals 0, jump to compCheck to check for Composite Number
    CMP     numVal, ebx
    JE      nPlusOne                            ;if ebx and numVal are equal, increase numerator
    JG      dPlusOne                            ;if numVal is greater, increase denominator

compCheck:                                      ;check to see if numVal and ebx are equal 
    CMP     numVal, ebx
    JE      nPlusOne                            ;if they are equal, increase numerator by 1
    CMP     numVal, eax                         ;check to see if numVal and eax are equal
    JE      nPlusOne                            
    JG      isComposite                         ;if numVal is greater, we have a composite number 

nPlusOne:                                       
    add     numVal, 1                           ;add 1 to numerator
    mov     dumVal, 2                           ;reset denominator to 2
    JMP     Looper

dPlusOne:
    add     dumVal, 1                           ;increase denominator by 1
    JMP     Looper     

isComposite: 
    mov     eax, numVal                         ;print composite number
    call    WriteDec
    mov     al, TAB                             ;**E.C. - use tab character to align output
    call    WriteChar
    add     numVal, 1                           ;increase numerator by 1
    mov     dumVal, 2                           ;reset denominator to default value of 2
    CMP     ecx, 0                              ;compare ecx to 0, begin loop again if ecx is greater
    JE      peaceOut                            ;jump to ENDP if ecx equals 0
    loop    Looper


peaceOut:

    ret
showComposites  ENDP

;Procedure say goodbye.
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx

farewell        PROC
closing:       
    call    CrLf
    call    CrLf
    mov     edx, OFFSET goodBye1
    call    WriteString
    mov     edx, OFFSET username
    call    WriteString
    call    CrLf
    mov     edx, OFFSET goodBye2
    call    WriteString
    call    CrLF
    call    Crlf
   
    ret
farewell        ENDP 

END main