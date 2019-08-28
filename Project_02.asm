TITLE Program 02    (Project_02.asm)

; Author: Derek Yang
; Last Modified: 7/14/2018
; OSU email address: yangde@oregonstate.edu
; Course number/section: CS 271 Section 400
; Assignment Number: Program 2                Due Date: 7/15/2018
; Description: 
; The following program Fibonacci numbers and follow the listed requirements:
; Display the program title and programmer’s name. Then get the user’s name, and greet the user.
; Prompt the user to enter the number of Fibonacci terms to be displayed. Advise the user to enter an integer
; in the range [1 .. 46].
; Get and validate the user input (n).
; Calculate and display all of the Fibonacci numbers up to and including the nth term. The results should be
; displayed 5 terms per line with at least 5 spaces between terms.
; Display a parting message that includes the user’s name, and terminate the program

INCLUDE Irvine32.inc

UPPER_BOUND = 47
LOWER_BOUND = 0

.data

username	DWORD	?
terms		DWORD	?
col			DWORD	3
row         DWORD   1

space		BYTE	" ",0
space_five  BYTE    "     ",0

intro_1		BYTE	"Project 02 Fibonacci Numbers",0
intro_2		BYTE	"Programmed by Derek Yang",0

prompt_1	BYTE	"What's your name?",0
prompt_2	BYTE	"Hello, ",0
prompt_3	BYTE	"Enter the number of Fibonacci terms to be displayed",0
prompt_4	BYTE	"Give the number as an integer in the range [1..46].",0
prompt_5	BYTE	"How many Fibonacci terms do you want? ",0
prompt_6	BYTE	"Results certified by Leonardo Pisano.",0
prompt_7	BYTE	"Goodbye, ",0



.code
main PROC

; Introduction of the program
introduction:
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf
	call	CrLf

; Ask the user for name and say hello
	mov		edx, OFFSET prompt_1
	call	WriteString

	mov		edx, OFFSET username
	mov		ecx, 32
	call	ReadString
	call	CrLf
	mov		edx, OFFSET prompt_2
	call	WriteString
	mov		edx, OFFSET username
	call	WriteString
	call	CrLf

; Display instructions to user
userInstructions:
	mov		edx, OFFSET prompt_3
	call	WriteString
	call	CrLf
	mov		edx, OFFSET prompt_4
	call	WriteString
	call	CrLf
	mov		edx, OFFSET prompt_5
	call	WriteString

; Gathers user data
getUserData:
	call	ReadInt
	mov		terms,eax
	cmp		terms,LOWER_BOUND
	jle		userInstructions
	cmp		terms,UPPER_BOUND
	jge		userInstructions

; display output calculation
	mov		eax,0
	mov		ebx,1
	mov		ecx,terms

displayFibs:
	mov		edx,eax
	add		ebx,edx
	mov		eax,ebx
	mov		ebx,edx
	call	WriteDec
	mov		edx, OFFSET space_five
	call	WriteString

	cmp		row,5
	jge		endRow
	inc		row
	loop	displayFibs
	jmp		farewell

endRow:
	call	CrLf
	mov		row,1
	loop	displayFibs

; Terminate message
farewell:
	mov		edx, OFFSET prompt_7
	call	WriteString
	mov		edx, OFFSET username
	call	WriteString
	call	CrLf
	mov		edx, OFFSET prompt_6
	call	WriteString
	exit	; exit to operating system
main ENDP

END main
