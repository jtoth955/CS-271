TITLE DemoString     (demo6.asm)

; Author: Paulson
; CS271	in-class demo        9/15/2012
; Description:  This program asks the user to enter a string,
;               and then displays the string in all caps.
;               Finally, the string is displayed backwards.

INCLUDE Irvine32.inc
MAXSIZE	= 100
.data
inString	BYTE		MAXSIZE DUP(?)		; User's string
outString	BYTE		MAXSIZE DUP(?)		; User's string capitalized
prompt1	BYTE		"Enter a string: ",0
sLength	DWORD	0

.code
main PROC
; Get user input:
	mov	edx,OFFSET prompt1
	call	WriteString
	mov	edx,OFFSET inString
	mov	ecx,MAXSIZE
	call	ReadString
	call	WriteString
	call	CrLf
	
; Set up the loop counter, put the string addresses in the source 
; and index registers, and clear the direction flag:
	mov	sLength,eax
	mov	ecx,eax
	mov	esi,OFFSET inString
	mov	edi,	OFFSET outString
	cld

; Check each character to determine if it is a lower-case letter.
; If yes, change it to a capital letter.  Store all characters in
; the converted string:
counter:
	lodsb
	cmp	al,97	; 'a' is character 97
	jb	notLC
	cmp	al,122	; 'z' is character 122
	ja	notLC
	sub	al,32
notLC:
	stosb
	loop	counter
	
; Display the converted string:
	mov	edx,OFFSET outString
	call	WriteString
	call	CrLf
	
; Reverse the string
	mov	ecx,sLength
	mov	esi,OFFSET inString
	add	esi,ecx
	dec	esi					; last byte of inString
	mov	edi,OFFSET outstring	; first byte of outString

reverse:
	std						; get characters from end to beginning
	lodsb
	cld						; store characters from beginning to end
	stosb
	loop	reverse

; Display reversed string
	mov	edx,OFFSET outString
	call	WriteString
	call	CrLf
	
	exit			;exit to operating system
main ENDP

END main




push        ebp
mov     ebp,esp

tryAgain:
myWriteString   prompt_2
mov     edx, [ebp+16]               ;move OFFSET of temp to receive string of integers
mov     ecx, 10
call    ReadString
cmp     eax, 10
jg      invalidInput

mov     ecx, eax                    ;loop for each char in string
mov     esi,[ebp+16]                ;point at char in string

pushad
loopString:                         ;loop looks at each char in string
    mov     ebx,[ebp+12]
    mov     eax,[ebx]               ;move address of answer into eax
    mov     ebx,10d     
    mul     ebx                     ;multiply answer by 10
    mov     ebx,[ebp+12]            ;move address of answer into ebx
    mov     [ebx],eax               ;add product to answer
    mov     al,[esi]                ;move value of char into al register
    inc     esi                     ;point to next char
    sub     al,48d                  ;subtract 48 from ASCII value of char to get integer  

    cmp     al,0                    ;error checking to ensure values are digits 0-9
    jl      invalidInput
    cmp     al,9
    jg      invalidInput

    mov     ebx,[ebp+12]            ;move address of answer into ebx
    add     [ebx],al                ;add int to value in answer

    loop    loopString      
    popad
    jmp     moveOn
invalidInput:                       ;reset registers and variables to 0
    mov     al,0
    mov     eax,0
    mov     ebx,[ebp+12]
    mov     [ebx],eax
    mov     ebx,[ebp+16]
    mov     [ebx],eax       
    myWriteString   error
    call    CrLf
    jmp     tryAgain
moveOn:
    pop     ebp
    ret     12