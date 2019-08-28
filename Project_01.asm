TITLE Project 01 Elementary Arithmetic     (Project_01.asm)

; Author: Derek Yang
; Last Modified: 7/8/2018
; OSU email address: yangde@oregonstate.edu
; Course number/section: CS 271 Section 400
; Assignment Number:  Project 01          Due Date: 7/8/2018
; Description:  The following program will perform the following tasks:
; Display author name and program title
; Display instructions for user
; Display extra credit option
; Prompt the user for two input numbers
; Validate that the second input number is smaller than first
; Calculate the sum, difference, product, quotient, and remainder of the two input
; Display a terminating message

INCLUDE Irvine32.inc


.data
number_1	DWORD ?
number_2	DWORD ?
sum			DWORD ?
difference	DWORD ?
product		DWORD ?
quotient	DWORD ?
remainder	DWORD ?

intro_1		BYTE "Project 01 Elementary Arithmetic	by Derek Yang",0
intro_2		BYTE "Enter two numbers to view the sum, difference, ",0
intro_3		BYTE "product, (integer) quotient and remainder of the numbers",0
intro_ec	BYTE "**EC: Program verifies second number less than first.",0
ec_val		BYTE "The second number must be less than the first!",0
prompt_1	BYTE "First number: ",0
prompt_2	BYTE "Second number: ",0

output_eq	BYTE " = ",0
output_add	BYTE " + ",0
output_sub	BYTE " - ",0
output_mul	BYTE " x ",0
output_div	BYTE " / ",0
output_rem	BYTE " remainder ",0

closing_1	BYTE "Impressed? Bye!",0


.code
main PROC

;Introduction of the program
Introduction:
; Print the program title and my name
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf

; Print instructions
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_3
	call	WriteString
	call	CrLf
		
;Get the data portion of the program
Input:
; Get two numbers
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	ReadInt
	mov		number_1, eax

	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt
	mov		number_2, eax

; Extra Credit #2 portion to verify number_1 is smaller than number_2
	mov		eax, number_2
	cmp		eax, number_1
	jge		Incorrect
	jle		Solution

;If first number is smaller than second
Incorrect:
	mov		edx, OFFSET ec_val
	call	WriteString
	call	CrLf
	jmp		Input
	

;Calculate the required values
Solution:
; Sum
	mov		eax, number_1
	mov		edx, number_2
	add		eax, edx
	mov		sum, eax

; Difference
	mov		eax, number_1
	mov		edx, number_2
	sub		eax, edx
	mov		difference, eax
; Product
	mov		eax, number_1
	mov		edx, number_2
	mul		edx
	mov		product, eax

; Quotient and Remainder
	mov		edx, 0  ;move zero into edx
	mov		eax, number_1
	mov		ebx, number_2
	div		ebx
	mov		quotient, eax
	mov		remainder, edx

;Display the results
Results:
; Print Sum
	mov		eax, number_1
	call	WriteInt
	mov		edx, OFFSET output_add
	call	WriteString
	mov		eax, number_2
	call	WriteInt
	mov		edx, OFFSET output_eq
	call	WriteString
	mov		eax, sum
	call	WriteInt
	call	CrLf

; Print Difference
	mov		eax, number_1
	call	WriteInt
	mov		edx, OFFSET output_sub
	call	WriteString
	mov		eax, number_2
	call	WriteInt
	mov		edx, OFFSET output_eq
	call	WriteString
	mov		eax, difference
	call	WriteInt
	call	CrLf

; Print Product
	mov		eax, number_1
	call	WriteInt
	mov		edx, OFFSET output_mul
	call	WriteString
	mov		eax, number_2
	call	WriteInt
	mov		edx, OFFSET output_eq
	call	WriteString
	mov		eax, product
	call	WriteInt
	call	CrLf

; Print Quotient
	mov		eax, number_1
	call	WriteInt
	mov		edx, OFFSET output_div
	call	WriteString
	mov		eax, number_2
	call	WriteInt
	mov		edx, OFFSET output_eq
	call	WriteString
	mov		eax, quotient
	call	WriteInt

; Print Remainder
	mov		edx, OFFSET output_rem
	call	WriteString
	mov		eax, remainder
	call	WriteInt
	call	CrLf

; Print the goodbye message
Goodbye:
	mov		edx, OFFSET closing_1
	call	WriteString
	call	CrLf
	exit	; exit to operating system

main ENDP

; (insert additional procedures here)

END main
