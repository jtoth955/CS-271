TITLE Program #6B     (Program6B.asm)

; Author: John Toth
; OSU Email: tothj@onid.oregonstate.edu
; CS 271-400
; Assignment #: 6B
; Assignment due date: June 7, 2015
; Date: 5/28/2014
; Description: Project 6B generates and displays combinatorial problems, using the Random function in 
; the Irvine library. The user is prompted to provide a results value, to which it is evaluated to 
; determine if the user was or was not correct.

;References for borrowed code: 
;Random number generation came from lecture #20
;myWriteString macro came from lecture #26
;myReadString macro came from lecture #26
;getData was sourced from a couple string conversion programs found on GitHub
;combination/factorial was sourced from Irvine ch 8.3.2 and J. Ziefle on GitHub
;replay fn was updated to implement a more efficient design by N. Chan on GitHub  

INCLUDE Irvine32.inc

;myWriteString  MACRO   
    myWriteString   MACRO   buffer   
        push    edx
        mov     edx, OFFSET buffer
        call    WriteString
        pop     edx
ENDM

;myReadstring   Macro
    myReadString     MACRO     varName
        push    ecx
        push    edx
        mov     edx, OFFSET varName
        mov     ecx, (SIZEOF varName) - 1
        call    Readstring
        pop     edx
        pop     ecx
ENDM

;global constant definitions
MAX = 12;
MIN = 3;    
RMIN = 1;

.data
userName        BYTE    33 DUP(0)               ;users name, entered as a string 
userVal         BYTE    33 DUP(0)               ;users string input 
rVal            DWORD   ?                       ;# of elements to select in set
nVal            DWORD   ?                       ;# of elements in the set
answer          DWORD   ?                       ;users response
result          DWORD   ?                       ;calculated result
Prog_intro1     BYTE    "--Program Intro-- ",0
Prog_Title      BYTE    "Combinations problem calculator. ",0
Prog_Title_2    BYTE    "Your enter an answer, I'll determine if it's correct! ", 0
intro_1         BYTE    "My name is John, we'll be working with string conversion and factorials",0
prompt_1        BYTE    "What is your name? ",0
intro_2         BYTE    "Nice to meet you, ",0
problem_1       BYTE    "Problem: ",0
problem_2       BYTE    "Number of elements in the set: ",0
problem_3       BYTE    "Number of elements to choose in the set: ",0
prompt_2        BYTE    "How many ways can you choose? ",0 ;
error_1         BYTE    "Improper value, try again! ",0
answer_1        BYTE    "There are ",0
answer_2        BYTE    " combinations of ",0
answer_3        BYTE    " items from a set of ",0
inCorrect       BYTE    "Sorry, wrong answer. ",0
correct         BYTE    "Correct! Well Done!! ", 0
goAgain         BYTE    "Another problem? (y/n) ",0
response        BYTE    10 DUP(0)
yes             BYTE    "y",0
no              BYTE    "n",0
goodBye1        BYTE    "That was fun, ",0
goodBye2        BYTE    "Thanks for doing this exercise with me ",0

.code
main            PROC

;Randomize fn call necessary to use RandomRange in Irvine Library
    call    Randomize

;Call to introduction proc
    call    introduction

playAgain:
;Call to showProblem
    push    OFFSET  rVal
    push    OFFSET  nVal
    call    showProblem

;Call to getData
    push	  OFFSET userVal
    push	  OFFSET answer
    call    getData

;Call to combinations
    push    rVal
    push    nVal
    push    OFFSET result
    call    combinations

;Call to showResults
    push    rVal
    push    nVal
    push    result
    push    answer
    call    showResults
    
;Call to replay
    call    replay
    mov     esi, OFFSET response
    mov     edi, OFFSET yes
    cmpsb   
    je      playAgain

;Call to fareWell 
    call    CrLf
    call    farewell 
     
     exit	; exit to operating system
main ENDP

;******************************************************************
;Procedure to introduce the program and display instructions.
;receives: none
;returns: none
;preconditions:  none
;registers changed: none
;******************************************************************

introduction    PROC
    myWriteString   Prog_intro1
    call    CrLf
    call    CrLf
    myWriteString   prog_Title
    call    CrLf
    myWriteString   prog_Title_2
    call    CrLf
    myWriteString   intro_1
    call    CrLf
    call    CrLf
    myWriteString   prompt_1
    myReadString    userName
    myWriteString   intro_2
    myWriteString   userName
    call    CrLf

    ret 
introduction    ENDP

;******************************************************************
;Procedure that generates random numbers and displays the problem
;receives: addresses of nVal and rVal 
;returns: random numbers for combinationatorial problems
;preconditions:  none
;registers changed: none
;******************************************************************

showProblem	PROC
    push	  ebp                     ;Set up stack frame
    mov	  ebp, esp
    mov     ecx, [ebp+12]
    mov     ebx, [ebp+8]

    mov     eax, MAX
    sub     eax, MIN
    inc     eax
    call    RandomRange             ;eax in [0 - MAX]
    add     eax, MIN                ;eax in [MIN - MAX]
    mov     [ebx], eax              ;place random number into nVal

    mov     eax, [ebx]              ;rVal must be less than or equal to nVal
    sub     eax, MIN                ;rVal minus MIN is stored into eax 
    inc     eax
    call    RandomRange             ;eax in [MIN - rVal]
    add     eax, MIN
    mov     [ecx], eax              ;move random value into rVal
    call    CrLf
    myWriteString   problem_1
    call    CrLf
    call    CrLf
    myWriteString   problem_2       
    mov     eax, [ebx]              ;nVal is placed into eax
    call    WriteDec
    call    CrLf
    myWriteString   problem_3
    mov     eax, [ecx]              ;rVal is placed into eax
    call    WriteDec
    call    CrLf

    pop     ebp
    ret     8
    showProblem ENDP

;******************************************************************
;Procedure displays prompt and gets the user's answer
;receives: address of answer
;returns: inputted string, converted to int, and saved in answer
;preconditions:  none
;registers changed: none
;******************************************************************

getData         PROC
	push	  ebp                     ;Set up stack frame
	mov	  ebp, esp
	
L1:	
	myWriteString prompt_2
	mov	  edx, [ebp+12]
	mov	  ecx, 10
	call	ReadString
	mov	  ecx, eax
	mov	  esi, [ebp+12]
	cld
	mov		edx, 0	           ;initialize to zero

counter:                            

	lodsb                          ;load byte from memory into al
	cmp	  al, 48                  ;ensure input is within lower bounds. ASCII code for 0 is 48
	jl	  invalid                  
	cmp	  al, 57                  ;ensure input is within upper bounds. ASCII code for 9 is 57
	jg	  invalid
	movzx  eax, al                 ;zero extend al to 32 bits
	push	  ecx
	mov	  ecx, eax
	mov	  ebx, 10
	mov	  eax, edx
	mul	  ebx                     ;multiply by 10 to get number of decimal places
	mov	  edx, eax
	mov	  ebx, 48
	sub	  ecx, ebx	           ;subtract string character from 48
	add	  edx, ecx	           ;x = 10 * x + (str[k]-48)
	pop	  ecx
	loop	  counter
	jmp	  saveInput
	
invalid:

	myWriteString  error_1         ;error message displayed if input value is not 0-9
	call	  CrLf
	jmp    L1

saveInput:	

	mov	  ebx, [ebp+8]    	      ;move address of answer into ebx
	mov	  [ebx], edx		      ;store user input in answer
	
	pop	  ebp
	ret	  8
getData	      ENDP


;******************************************************************
;Procedure to perform combination calculations
;receives: values of nVal, rVal, and address result
;returns: calculated result of combination 
;preconditions:  none
;registers changed: none
;******************************************************************

combinations	PROC                                      
	push	  ebp                     
	mov	  ebp, esp                ;Set up stack frame
     mov    eax, [ebp+12]           ;place rVal into eax
     mov    ebx, [ebp+16]           ;place nVal into ebx
     cmp    eax, ebx
     je     equal                   ;if nVal == rVal, jump to equal

     mov    eax, [ebp+12]           ;calculate (n-r)! 
     sub    eax, [ebp+16]
     mov    ebx, eax
     push   ebx
     call   factorial               ;call factorial to do the calculations
     mov    ecx, eax

     mov    ebx, [ebp+16]           ;calculate rVal factorial (r!)
     push   ebx
     call   factorial
     mul    ecx
     mov    ecx, eax

     mov    ebx, [ebp+12]           ;calculate nVal factorial (n!)
     push   ebx
     call   factorial

     mov    edx, 0                  ;calculate (n!/(r!(n-r)!))
     div    ecx
     mov    ecx, [ebp+8]
     mov    [ecx], eax
     jmp    quit                

equal:                              ;when nVal = rVal, result is one
     mov     ecx, [ebp+8]
     mov     eax, 1
     mov     [ecx], eax             ;move value into result

quit: 
     pop    ebp
     ret    12
combinations    ENDP


;******************************************************************
;Procedure to perform calculations recursively
;receives: value of a number, result address
;returns: n!, r! & (n-r)!
;preconditions:  none
;registers changed: none
;******************************************************************

factorial	      PROC
    push    ebp                     
    mov     ebp, esp                ;Set up stack frame
    mov     eax, [ebp+8]    
    cmp     eax, 1
    jle     quit

recurse:
    dec     eax
    push    eax
    call    factorial
    mov     esi, [ebp+8]
    mul     esi

quit:
    pop     ebp
    ret     4

factorial       ENDP


;******************************************************************
;Procedure that displays the user's answer, result and if the user 
;was correct or incorrect
;receives: values for answer, result, rVal and nVal
;returns: user's answer, result, and whether user was correct or 
;incorrect
;preconditions:  none
;registers changed: none
;******************************************************************

showResults	PROC
	push	  ebp                     
	mov	  ebp, esp                ;Set up stack frame
     mov    ecx, [ebp+8]            ;place user's input into ecx

     call   CrLf
     myWriteString  answer_1
     mov     eax, [ebp+12]          ;eax = result
     call   WriteDec
     myWriteString  answer_2
     mov    eax, [ebp+20]           ;eax = rVal
     call   WriteDec
     myWriteString  answer_3
     mov    eax, [ebp+16]           ;eax = nVal
     call   WriteDec
     call   CrLf
     cmp    ecx, [ebp+12]           ;compare users response to correct answer
     je     correctAnswer                      
     myWriteString  inCorrect       ;displays if the user inputs the wrong value
     call   CrLf
     jmp    quit             

correctAnswer:                      
     myWriteString  correct    

quit:                               ;jump to exit if user gueses the wrong value
     pop    ebp
     ret    16
showResults     ENDP


;******************************************************************
;Procedure that asks user if they would like to play again 
;receives: none
;returns: none 
;preconditions:  none
;registers changed: esi, edi
;******************************************************************
replay          PROC

tryAgain:
    call CrLf
    call CrLf
    myWriteString   goAgain         ;message asks user if they would like to re-run program
    myReadString    response
    mov     esi, OFFSET response    ;mov reference of user response into esi
    mov     edi, OFFSET yes         ;mov reference of "yes" variable into edi
    cmpsb                           ;cmp BYTE response of user
    je      quit                    ;quit if true
    mov     esi, OFFSET response
    mov     edi, OFFSET no
    cmpsb
    je      quit                    ;quit if false
    myWriteString   error_1         ;display error message if input != to char "y" or "n"
    jmp     tryAgain

quit:
    ret
replay          ENDP

;******************************************************************
;Procedure to farewell
;receives: none
;returns: none
;preconditions:  none
;registers changed: none
;******************************************************************

farewell    	PROC
   
    call    CrLf                    ;end of program
    myWriteString goodBye1
    myWriteString username
    call    CrLf
    myWriteString goodBye2
    call    CrLF
    call    Crlf

    ret
farewell        ENDP

END main