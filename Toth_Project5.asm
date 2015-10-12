TITLE Program #5     (Program5.asm)

; Author: John Toth
; OSU Email: tothj@onid.oregonstate.edu
; CS 271-400
; Assignment #: 5
; Assignment due date: May 24, 2015
; Date: 5/14/2014
; Description: Program that takes in a user specified number of integers. The program that fills an array
; with random numbers, sorts in descending order, then displays the median value of all numbers

INCLUDE Irvine32.inc


TAB = 9                                     ;ASCII code for 'Tab'
MIN = 10                                    ;lower limit of user request
MAX = 200                                   ;upper limit of user request
LO = 100                                    ;lower limit of array values
HI = 999                                    ;upper limit of array values

.data
userName        BYTE    33 DUP(0)           ;string to be entered by user
arrayVal        DWORD   ?                   ;user defined array size
list            DWORD   MAX DUP(?)
countMinus      DWORD   ?   
helper          DWORD   ? 
medVal          DWORD   ?            
Prog_intro1     BYTE    "--Program Intro-- ",0
Prog_intro2     BYTE    "**EC: I displayed the sorted and unsorted numbers in columns ",0
Prog_Title      BYTE    "We'll be filling an array with random numbers, sort it, then display the values",0
intro_1         BYTE    "My name is John and we're going to work with Arrays and Sorting",0
prompt_1        BYTE    "What is your name? ",0
intro_2         BYTE    "Nice to meet you, ",0
numArray        BYTE    "Please enter a number between 10 and 200: ",0
error1          BYTE    "Your number is greater than 200, try again! ",0
error2          BYTE    "Your number is less than 10, try again! ",0
unSorted        BYTE    "Your unsorted list is: ",0
SortedLst       BYTE    "Your sorted list is: ",0
medianVal       BYTE    "The median is: ",0
goodBye1        BYTE    "That was fun, ",0
goodBye2        BYTE    "Thanks for doing this exercise with me ",0
 

.code
main PROC
;Randomize fn call necessary to use RandomRange in Irvine Library
    call    Randomize

;Call to introduction proc
    call    introduction

;Call to getData 
    push    OFFSET arrayVal
    call    getData                            ;get users requested number of values     

;Call to fillArray  
    push    OFFSET list
    push    arrayVal
    call    fillArray
  
;Call to displayList, showing randomized array of user defined size  
    push    OFFSET list
    push    arrayVal
    call    displayList

;Call to sortList
    push    OFFSET list
    push    arrayVal
    call    sortList

;Call to displayMedian
    push    OFFSET list
    push    arrayVal
    call    displayMedian
    call    CrLf
    call    CrLf
    mov     edx, OFFSET SortedLst
    call    WriteString
    call    CrLf

;Call to displayList, showing sorted array
    push    OFFSET list
    push    arrayVal
    call    displayList
   
;Call to farewell   
    call    farewell

	exit	; exit to operating system
main ENDP



;******************************************************************
;Procedure to introduce the program.
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx
;******************************************************************

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
introduction    ENDP



;******************************************************************
;Procedure to get the users request for number of integers.
;receives: none
;returns: user input in global count
;preconditions:  none
;registers changed: eax, ebx, edx
;******************************************************************

getData         PROC
gd:
    push    ebp
    mov     ebp, esp
    call    CrLf
    mov     edx, OFFSET numArray
    call    WriteString
    call    ReadInt                         ;get user's number
    CMP     eax, MIN
    JL      tooLow                          ;user input lower than lower bound
    CMP     eax, MAX
    JG      tooHigh                         ;user input higher than upper bound
    mov     ebx, [ebp+8]
    mov     [ebx],  eax
    pop     ebp
    ret     4

tooLow:
    mov     edx, OFFSET error2              ;print error message
    call    WriteString
    call    CrLf
    pop     ebp
    JMP     gd

tooHigh:
    mov     edx, OFFSET error1
    call    WriteString
    call    CrLf
    pop     ebp
    JMP     gd

getData         ENDP



;******************************************************************
;Procedure to fill array.
;receives: address of array and value of count on system stack
;returns: none
;preconditions:  none
;registers changed: eax, ebx, ecx, edi
;source: I used notes from lecture to help construct this portion
;******************************************************************

fillArray       PROC
    push    ebp
    mov     ebp, esp
    mov     ecx, [ebp+8]                    ;count in ecx
    mov     edi, [ebp+12]                   ;address of array in edi
    mov     ebx, 0
    call    CrLf
    mov     edx, OFFSET unSorted
    call    WriteString
    call    CrLf

again:
    mov     eax, HI                         ;place hi value in eax
    sub     eax, LO                         ;subtract lo value from hi value
    inc     eax                             ;+1 for full useable range of number values
    call    RandomRange                     ;call to random number library
    add     eax, LO
    mov     [edi], eax                      ;place randomly generated value in array
    add     edi, 4                          ;increment 4 memory spaces in preppration for next array value
    inc     ebx                             ;increment loop count 
    loop    again

    pop     ebp
    ret     8

fillArray       ENDP



;******************************************************************
;Procedure to sort array.
;receives: address of array and value of count on system stack
;returns: none
;preconditions:  none
;registers changed: eax, ebx, edx, esi
;source: This section was constructed with help from the bubble 
;sort description, from our text
;******************************************************************

sortList         PROC
    push    ebp
    mov     ebp, esp
    mov     ecx, [ebp+8]                    ;count in ecx
    mov     esi, [ebp+12]                   ;address of array
    dec     ecx
    

L1: 
    push    ecx
    mov     esi, [ebp+12]                   ;back to beginning of array
        
L2: 
    mov     eax, [esi]                      ;place array position in eax
    cmp     [esi+4], eax            
    jg      L3
    xchg    eax, [esi+4]                    ;exchange array position for value in eax
    mov     [esi], eax

L3: 
    add     esi, 4                          ;move array position forward by 1
    loop    L2

    pop     ecx
    loop    L1

L4: 
    pop     ebp
    ret     8

sortList        ENDP



;******************************************************************
;Procedure to calculate array median.
;receives: address of array and value of count on system stack
;returns: none
;preconditions:  none
;registers changed: eax, ebx, edx, esi
;******************************************************************

displayMedian   PROC
    push    ebp
    mov     ebp, esp
    mov     ecx, [ebp+8]                    ;ecx is in loop control
    mov     esi, [ebp+12]                   ;address of array

median:
    mov     eax, ecx
    cdq
    mov     ebx, 2
    div     ebx
    dec     eax
    mov     countMinus, eax
    cmp     edx, 0
    je      notOdd
    jne     notEven
    call    CrLf

notOdd:
    mov     eax, countMinus                 ;placing value of array position in eax
    mov     ebx, 4                          ;multiply by DWORD value to find actual position
    mul     ebx
    mov     countMinus, eax
    add     esi, countMinus                 ;place position in array pointer
    mov     eax, [esi]
    mov     helper, eax
    add     esi, 4      
    mov     eax, [esi]
    add     eax, helper
    mov     ebx, 2
    div     ebx 
    mov     medVal, eax                     ;place median value of even array size, in medVal
    jmp     printMedian                 

notEven:
    inc     eax
    mov     ebx, 4
    mul     ebx                             ;multiply by DWORD value to locate array pointer value
    mov     countMinus, eax
    add     esi, countMinus
    mov     eax, [esi]
    mov     medVal, eax                     ;place median value of odd array size, medVal
    jmp     printMedian

printMedian:
    call    CrLf
    call    CrLf
    mov     edx, OFFSET medianVal
    call    WriteString
    mov     eax, medVal
    call    WriteDec
    call    CrLf
    call    CrLf

endMedian:
    pop     ebp
    ret     8

displayMedian   ENDP




;******************************************************************
;Procedure to display array.
;receives: address of array and value of count on system stack
;returns: none
;preconditions:  none
;registers changed: eax, ebx, edx, esi
;source: I used notes from lecture to help construct this portion
;******************************************************************

displayList     PROC
    push    ebp
    mov     ebp, esp
    mov     esi, [ebp+12]                   ;address of array
    mov     ecx, [ebp+8]                    ;ecx is in loop control

more:
    mov     eax, [esi]                      ;get current element in array
    call    WriteDec
    mov     al, TAB
    call    WriteChar
    add     esi, 4                          ;next element in array
    loop    more

endMore:
    pop     ebp
    ret     8

displayList     ENDP



;******************************************************************
;Procedure say goodbye.
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx
;******************************************************************

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
