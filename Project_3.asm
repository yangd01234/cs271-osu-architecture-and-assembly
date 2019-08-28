TITLE Program 3     (Project_3.asm)

; Author: Derek Yang
; Last Modified: 7/21/2018
; OSU email address: yangde@oregonstate edu
; Course number/section: CS 271 Section 400
; Assignment Number: Program 3            Due Date:7/29/2018
; Description: The user enters a number n, and the program
; verifies that n is within 1 to 400.  If n is out of range, 
; the user is reprompted until s/he enters a value in the
; specified range.  The program then calculates and displays
; all of the composite numbers up to and including the nth 
; composite.  The results will be displayed 10 composites per
; line with at least 3 spaces between numbers.

INCLUDE Irvine32.inc

UPPER_LIMIT = 400
LOWER_LIMIT = 1

.data

num_comp    DWORD	?
placeholder	DWORD	4
comp_bool	DWORD	0
line_count	DWORD	0
intro_1		BYTE	"Project 03 Composite Numbers",0
intro_2		BYTE	"Programmed by Derek Yang",0
prompt_1	BYTE	"Enter the number of composites you would like to see [1-400]: ",0
error_1		BYTE	"Out of range. Try again.",0
goodbye		BYTE	"Results certified by Euclid.  Goodbye",0
space		BYTE	"   ",0



.code

main PROC
	call	introduction
	call	getUserData
	call	CrLf
	call	showComposites
	call	farewell
	exit	; exit to operating system
main ENDP

; Procedure to display introduction.
; receives: intro_1 and intro_2 global variables.
; registers changed: edx
introduction PROC
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf

	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf
	ret

introduction ENDP

; Procedure to gather user data.  Calls the 
; validate sub-procedure.
; receives: prompt_1 and num_comp global variables.
; registers changed: edx
getUserData PROC
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	CrLf
	call	ReadInt

	mov		num_comp,eax
	call	validate
	call	WriteDec
	call	CrLf
	ret

getUserData ENDP

; Sub-Procedure to validate input within 1-400.
; receives: UPPER_LIMIT and LOWER_LIMIT constants.
;           error_1 and prompt_1 global variables.
; registers changed: edx
validate PROC
	val_sub:
	cmp		num_comp,UPPER_LIMIT
	jg		invalid
	cmp		num_comp,LOWER_LIMIT
	jl		invalid
	jmp		complete

	invalid:
	mov		edx, OFFSET error_1
	call	WriteString
	call	CrLf

	mov		edx, OFFSET prompt_1
	call	WriteString
	call	CrLf

	call	ReadInt
	mov		num_comp,eax
	jmp		val_sub

	complete:
	ret

validate ENDP

; Procedure to loop through all n and display n number
; of composites using the LOOP instruction. Contains
; isComposite sub-procedure.
; receives: placeholder and comp_bool as global variables.
; registers changed: eax, ebx, edx
showComposites PROC
	mov ecx, num_comp
	;dec ecx
	mov eax, 0

	print_all:
	call	isComposite
	cmp		comp_bool,0
	je		print_all

	inc line_count
	mov		eax, line_count
	mov		ebx, 10
	mov		edx, 0
	div		ebx
	cmp		edx, 0
	jne		finish_loop
	call	CrLf

	finish_loop:
	loop	print_all

	ret
showComposites ENDP

; Sub-Procedure to calculate if current placeholder
; is a composite number.
; receives: placeholder and comp_bool as global variables.
; registers changed: eax, ebx, edx

isComposite PROC
	;start with the starting number
	mov		ebx, 2
	isCompositeStart:
	mov		eax, placeholder
	mov		edx, 0
	div		ebx
	inc		ebx
	cmp		ebx,placeholder
	je		compNotFound
	cmp		edx,0
	je		compFound
	jmp		isCompositeStart

	compFound:
	mov		eax, placeholder
	call	WriteDec
	mov		edx, OFFSET space
	call	WriteString
	mov		comp_bool,1
	jmp		finish

	compNotFound:
	mov		comp_bool,0

	finish:
	inc		placeholder
	ret

isComposite ENDP

; Procedure to display goodbyte message.
; receives: goodbye as a global variable.
; registers changed: edx

farewell PROC
	call	CrLf
	mov		edx, OFFSET goodbye
	call	WriteString
	call	CrLf
	ret

farewell ENDP

END main
