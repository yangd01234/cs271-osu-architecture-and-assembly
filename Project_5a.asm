TITLE Program 5a    (Project_5a.asm)

; Author:  Derek Yang
; Last Modified: 8/10/2018
; OSU email address: yangde@oregonstate.edu
; Course number/section: CS 271 400
; Assignment Number:  Program 5a  Due Date: 8/12/2018
; Description adapted from the homework requirements.   The following program will
; gather user input as string, convert to unsigned int; then calculate and display the sum and average;
; and finally convert the numeric values back to string and display using the displayString MACRO.
; Requirements:
; 1) User’s numeric input is validated the hard way: Reads the user's input as a string, and converts the
;    string to numeric form. If the user enters non-digits or the number is too large for 32-bit registers, an
;    error message is displayed and the number  discarded.
; 2) Conversion routines use the lodsb and/or stosb operators.
; 3) All procedure parameters are passed on the system stack.
; 4) Addresses of prompts, identifying strings, and other memory locations are passed by address to
;    the macros.
; 5) Used registers are saved and restored by the called procedures and macros.
; 6) The stack is “cleaned up” by the called procedure.
; 7) The usual requirements regarding documentation, readability, user-friendliness, etc., apply.


INCLUDE Irvine32.inc

HI = 10

.data

in_s		BYTE	12	DUP(?)
out_s		BYTE	12	DUP(?)

intro_1		BYTE	"PROGRAMMING ASSIGNMENT 5a: Designing low-level I/O procedures",0
intro_2		BYTE	"Written by: Derek Yang",0
intro_3		BYTE	"Please provide 10 unsigned decimal integers",0
intro_4		BYTE	"Each number needs to be small enough to fit inside a 32 bit register",0
intro_5		BYTE	"After you have finished inputting the raw numbers I will display a list",0
intro_6		BYTE	"of the integers, their sum, and their average value.",0

input_1		BYTE	"Please enter an unsigned number: ",0
error_1		BYTE	"ERROR: You did not enter an unsigned number or your number was too big.",0
error_2		BYTE	"Please try again: ",0
error_x		BYTE	"Error is here haha!",0

comma		BYTE	", ",0
result_i	BYTE	"You entered the following numbers: ",0
result_s	BYTE	"The sum of these numbers is: ",0
result_a	BYTE	"The average is: ",0

comma_space	BYTE	", ",0
sum			DWORD	?
average		DWORD	?
array		DWORD	12 DUP(?)
buffer_t	BYTE	10  DUP(?)   ;temp array
buffer_l	DWORD	?
buffer_n	DWORD	10	DUP(?)   ;input array
string_t	BYTE	10	DUP(?)
counter		DWORD	0
goodbye		BYTE	"Thanks for playing!",0
temp		DWORD	?

.code

; displayString
; Macro to display strings
; receives: string as a parameter
; returns: printed instructions
; preconditions:
; registers changed: edx

displayString	MACRO	buffer
	push	edx
	mov		edx, buffer
	call	WriteString
	pop		edx
ENDM

; quickDisplayString
; Macro to display strings
; receives: string as a parameter
; returns: printed instructions
; preconditions:
; registers changed: edx

quickDisplayString	MACRO	buffer
	push	edx
	mov		edx, OFFSET buffer
	call	WriteString
	call	CrLf
	pop		edx
ENDM


; getString 
; Macro to get user string input
; receives: varName and prompt as parameter
; returns: modified varName
; preconditions: must pass varName
; registers changed: ecx, edx


getString	MACRO	title, varAdd
	push	eax
	push	ecx
	push	edx

	mov		edx,title
	call	WriteString
	mov		edx, varAdd
	mov		ecx, 32
	call	ReadString

	pop		eax
	pop		ecx
	pop		edx
ENDM




main PROC
	; Introduction
	push	OFFSET intro_1		;28
	push	OFFSET intro_2		;24
	push	OFFSET intro_3		;20
	push	OFFSET intro_4		;16
	push	OFFSET intro_5		;12
	push	OFFSET intro_6		;8
	call	introduction


	; ReadVal procedure for unsigned int 
	push	OFFSET counter			;44
	push	OFFSET temp				;40
	push	SIZEOF buffer_t			;36	
	push	OFFSET buffer_t			;temp array 32 DWORD ?
	push	OFFSET buffer_n			;buffer number 28 DWORD ?
	push	OFFSET buffer_l			;length of string 24
	push	OFFSET input_1			;20
	push	OFFSET error_1			;16
	push	OFFSET error_2			;12
	push	array					;array for integers 8
	;call	ReadVal
	call	LoopRead


	;== for testing purposes ==
	;mov		esi, OFFSET buffer_t
	;mov		ecx, SIZEOF buffer_t
	;L1:
	;mov		eax,[esi]
	;call		WriteInt
	;call		CrLf
	;add		esi,4
	;loop		L1

	; LoopWrite to display sum, average, results, and uses WriteVal to convert numeric value to string
	push	OFFSET result_s		;32
	push	OFFSET result_a		;28
	push	OFFSET result_i		;24
	push	OFFSET comma_space	;20
	push	OFFSET out_s		;16
	push	OFFSET in_s			;12
	push	OFFSET buffer_t     ;8
	call	LoopWrite
; WriteVal procedure for unsigned int
; MACRO getString
; MACRO displayString
	
	;goodbye message
	push	OFFSET goodbye
	call	goodbye_m

	exit	; exit to operating system
main ENDP

; LoopWrite
; Displays average, sum, result as string
; receives: two strings, one array, and 5 string prompts as parameters
; returns: printed average, sum, result as string using subprocedure WriteVal
; preconditions: must have array and two empty string values passed through
; registers changed: eax,ebx,ecx,edx,esi,edi
LoopWrite PROC
	push	ebp
	mov		ebp,esp
	pushad


	mov		eax,1
	mov		ebx,0
	mov		ecx,10
	mov		edi,[ebp+8]

	call			CrLf
	displayString	[ebp+24]
	array_loop:
		mov		eax,[edi]
		add		edi,4
		push	eax
		push	[ebp+12]
		push	[ebp+16]
		call	WriteVal

		displayString [ebp+20]
		loop	array_loop

	mov eax,0
	sub edi,40
	mov ecx,10

sum_calc:
	call			CrLf
	displayString	[ebp+32]
	sum_loop:
		add		eax,[edi]
		add		edi,4
	loop	sum_loop
		mov		ebx,eax
		push	eax
		push	[ebp+12]
		push	[ebp+16]
		call	WriteVal
		call	CrLf

average_calc:
	displayString	[ebp+28]
	mov	eax,ebx
	mov	edx,0
	mov	ebx,10
	div ebx
	push	eax
	push	[ebp+12]
	push	[ebp+16]
	call	WriteVal
	call	CrLf

	popad
	pop		ebp
	ret 12

LoopWrite ENDP


; WriteVal
; Sub Procedure to convert unsigned int to string
; receives: two strings and an unsigned int value as parameters
; returns: string value from previous unsigned int value
; preconditions: needs two string values and numeric unsigned int value
; registers changed: eax,ebx,ecx,edx,edi,esi
WriteVal	PROC
	push	ebp
	mov		ebp,esp
	pushad

	mov		eax, [ebp+16]
	mov		edi, [ebp+12]
	mov		ecx,0
	cld

	convert_wv:
		mov		edx,0
		mov		ebx,10
		div		ebx
		mov		ebx,edx
		add		ebx,48
		push	eax
		mov		eax,ebx
		stosb
		inc		ecx
		pop		eax
		cmp		eax,0
		je		complete_wv
		jmp		convert_wv

	complete_wv:
		stosb
		mov		esi,[ebp+12]
		add		esi,ecx
		dec		esi
		mov		edi,[ebp+8]

	flip_wv:   ;reference from demo_6.asm
		std
		lodsb
		cld
		stosb
		loop	flip_wv

		mov		eax,0
		stosb

		displayString [ebp+8]

		popad
		pop ebp

	ret 12
WriteVal	ENDP


; ReadVal
; Reads user input as string and converts to unsigned int
; receives: prompts, string as parameters, and placeholder variable
; returns: unsigned int
; preconditions: 
; registers changed: eax,ebp,ecx,edx,esi,edi
ReadVal PROC
	push	ebp
	mov	ebp, esp
	pushad

	start:
		mov		edx,[ebp+12]      
		getString edx,[ebp+20]   

		mov		eax, 0
		mov		ebx,10
		mov		ecx,[ebp+16]
		mov		ecx,[ecx]
		mov		esi,[ebp+20]

		cld

	check_char:
		lodsb
		cmp		al,0
		JE		finished

		cmp		al,48
		jb		error_char
		cmp		al,57
		ja		error_char
		sub		al,48
		xchg	eax,ecx;
		mul		ebx
		jc		error_char
		jmp		correct

	error_char:
		displayString [ebp+8]
		mov		edx,ecx;
		mov		edx,0
		jmp		start

	correct:
		add		eax,ecx;

		xchg	eax,ecx;
		jmp		check_char

	finished:
		mov		eax, ecx
		mov		edi,[ebp+20]
		mov		[edi],eax
		mov		eax,0

	popad
	pop		ebp
	ret		16
ReadVal ENDP

; LoopRead
; Loops through and gathers 10 string inputs from the user
; and uses the sub procedure ReadVal to convert string to unsigned int
; receives: prompts and array as parameters
; returns: filled array with unsigned ints
; preconditions:
; registers changed: eax, ebx, ecx, edx, edi
LoopRead PROC
	push	ebp
	mov		ebp,esp
	pushad

	mov		ecx, 10
	mov		edi, [ebp+32];mov the array
	mov		edx,0


	read_start:
		push	[ebp+40]	;40 temp							
		push	[ebp+44]	;44 counter MAKE SURE TO RESET		
		push	[ebp+20]	;20	input_1 message					
		push	[ebp+16]	;16 error_1 message					
		call	ReadVal


		cld

		mov		ebx,[ebp+40]
		mov		eax,[ebx]
		add		edx,eax
		mov		al,[ebx]
		call	WriteDec
		call	CrLf
		mov		[edi],eax
		add		edi,4
		;stosb
		loop	read_start

	popad
	pop		ebp
	ret		40
LoopRead ENDP



; introduction
; Procedure to display introduction
; receives:
; returns: printed instructions
; preconditions:
; registers changed: through expansion edx
introduction PROC
	push	ebp
	mov		ebp,esp

	displayString	[ebp+28]
	call			CrLf
	displayString	[ebp+24]
	call			CrLf
	displayString	[ebp+20]
	call			CrLf
	displayString	[ebp+16]
	call			CrLf
	displaystring	[ebp+12]
	call			CrLf
	displayString	[ebp+8]
	call			CrLf

	pop		ebp
	ret		24
introduction ENDP

; goodbye_m
; Goodbye message!
; receives: a prompt string as a parameter
; returns: printed instructions
; preconditions:
; registers changed: edx
goodbye_m PROC
	push	ebp
	mov		ebp,esp

	call			CrLf
	displayString	[ebp+8]
	call			CrLf
	pop		ebp
	ret		4
goodbye_m ENDP

END main
