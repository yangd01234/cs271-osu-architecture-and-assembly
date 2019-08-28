TITLE Program 4     (Project_4.asm)

; Author:  Derek Yang
; Last Modified: 8/3/2018
; OSU email address: yangde@oregonstate.edu
; Course number/section: CS 271 400
; Assignment Number: Program 4  Due Date: 8/4/2018
; Description: The following MASM program will get a user request of range 10 to 200, 
; generate a list of random integers from 100 to 999.  The program will first display 
; the unsorted list.  Once displayed, the program will then proceed to sort the list 
; and display the sorted list.  Finally, the program will display the median.

INCLUDE Irvine32.inc

MIN = 10
MAX = 200
LO = 100
HI = 999

.data

intro_1		BYTE	"Sorting Random Integers       Programmed by Derek Yang",0
intro_2		BYTE	"This program generates	random numbers in the range [100 .. 999],",0
intro_3		BYTE	"displays the original list, sorts the list, and calculates the",0
intro_4		BYTE	"median value.  Finally, it displays the list sorted in descending order.",0

prompt_1	BYTE	"How many numbers should be generated? [10 .. 200]",0
error_1		BYTE	"Invalid Input",0

title_s		BYTE	"The sorted list:",0				;17 bytes
title_u		BYTE	"The unsorted random numbers:",0	;29 bytes
title_m		BYTE	"The median is:",0					;14 bytes
spaces		BYTE	"   ",0

even_text	BYTE	"This is even",0
odd_text	BYTE	"This is odd",0

input_1		DWORD	?
array		DWORD	MAX	DUP(?)
arraylen	DWORD	0

.code
main PROC

; the following procedures are required:
; main
	push	OFFSET intro_1
	push	OFFSET intro_2
	push	OFFSET intro_3
	push	OFFSET intro_4
	call	introduction

	; get data		PARAMS: request(reference)
	push	OFFSET	input_1 ;+4
	call	getData

	; fill array	PARAMS:	request(value), array(reference)
	push	input_1
	push	OFFSET	array
	call	fillArray

	; displaylist	PARAMS: array(reference),request(value), title(reference)
	push	OFFSET	array
	push	input_1
	push	OFFSET	title_u
	call	displaylist

	; sort list		PARAMS: array(reference), request(value)
	push	OFFSET	array
	push	input_1
	call	sortList

	; displaylist	PARAMS: array(reference),request(value), title(reference)
	push	OFFSET	array
	push	input_1
	push	OFFSET	title_s
	call	displaylist

	; displayMedian	PARAMS: array(reference),request(value)
	push	OFFSET	array
	push	input_1
	push	OFFSET title_m
	call	displayMedian

	exit	; exit to operating system
main ENDP
;Procedure to display introduction.
;receives: intro_1-4
;returns: printed introduction
;preconditions: 
;registers changed: edx
; getData 
introduction PROC

	push	ebp
	mov		ebp,esp

	mov		edx, [ebp+20]
	call	WriteString
	call	CrLf

	mov		edx, [ebp+16]
	call	WriteString
	call	CrLf

	mov		edx, [ebp+12]
	call	WriteString
	call	CrLf

	mov		edx, [ebp+8]
	call	WriteString
	call	CrLf

	pop		ebp
	ret
introduction ENDP

;Procedure to gather user input data within limits.
;receives: request(reference) as esp+8
;returns: user input
;preconditions: 
;registers changed: eax, ecx, edx
; getData 
getData PROC
	push	ebp
	mov		ebp,esp
	mov		ecx,[esp+8] ;sets ecx to input_1 

	val_sub:
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	ReadInt

	cmp		eax,MAX
	jg		invalid
	cmp		eax,MIN
	jl		invalid
	jmp		complete

	invalid:
	mov		edx, OFFSET error_1
	call	WriteString
	call	CrLf
	jmp		val_sub


	complete:
	inc		eax
	mov		[ecx],eax
	pop		ebp
	ret		4
getData ENDP


;Procedure to fill an array with random numbers.
;receives: array(reference) as ebp+8, request(value) as ebp+12
;returns: a filled array with random values
;preconditions: Must have user input
;registers changed: eax, ecx, esi

fillArray PROC
; NOTE: ESI = source index (getting stuff from array), EDI = destination index (moving stuff into array)
	push	ebp
	mov		ebp,esp
	mov		esi, [ebp+8]  ;@ of array
	mov		ecx, [ebp+12] ;loop counter for n number of inputs
	call	Randomize ;initialize random seed
	generate_random:
	; RandomRange - generate a random integer from 0 to eax-1
		mov		eax, HI
		sub		eax, LO
		call	RandomRange
		add		eax, LO
		inc		eax  ;since randomrange performs eax-1
		mov		[esi],eax
		add		esi,4	;increment array pos
		loop	generate_random

	pop		ebp
	ret		8
fillArray ENDP


;Procedure to print an array.
;receives: array(reference) as ebp+16, request(value) as ebp+12, title(reference) as ebp+8
;returns: a printed array
;preconditions: array must exist
;registers changed: eax, ebx, esi, edx

displayList PROC
	push	ebp
	mov		ebp,esp
	mov		esi,[ebp+16] ;@ of array
	mov		ecx,[ebp+12] ;loop counter for n number of inputs
	dec		ecx
	mov		edx, [ebp+8]  ;title
	mov		ebx, 0

	call	WriteString
	call	CrLf

	rows:
		inc		ebx
		mov		eax,[esi]
		call	WriteDec
		add		esi,4	;next pos
		mov		edx, OFFSET spaces
		call	WriteString

		cmp		ebx,10
		je		end_row
		cmp		ebx,10
		jne		finish_loop

	end_row:
		mov		ebx, 0
		call	CrLf

	finish_loop:
	loop	rows
	call	CrLf
	pop		ebp
	ret		12
displayList ENDP

;Procedure to sort an array.
;receives: array(reference) as ebp+12,request(value) as ebp+8
;returns: a sorted array
;preconditions: array must exist
;registers changed: eax, ebx, ecx, esi, edx

sortList PROC
	push	ebp
	mov		ebp,esp
	mov		ecx, [ebp+8] ;loop counter for n number of inputs
	;dec ecx
	;mov		[ebp+8],ecx  
	mov		esi,[ebp+12]

	start_sort:
		mov		eax,[esi]	;get current
		mov		ebx,[esi+4]	;get next element in array
		cmp		eax,ebx		;compare eax to ebx
		jl		swap
		add		esi,4		;point to next element in array
		loop	start_sort
		jmp		finished

	swap:
		lea		eax,[esi]
		lea		ebx,[esi+4]
		push	eax
		push	ebx
		
		call	exchangeElements
		inc		ecx

		loop	start_sort

	finished:
		mov		ecx,[ebp+8]
		dec		ecx
		cmp		ecx,0
		je		complete
		mov		[ebp+8],ecx
		mov		esi, [ebp+12]
		jmp		start_sort

	complete:
		pop		ebp
		ret		8			;note, remember ret default 4.  Need to account for params
sortList ENDP


;Sub-Procedure to exchange two elements in a list.
;receives: two positions in array as reference
;returns: two positions of array swapped
;preconditions: positions in array must exist
;registers changed: eax, ebx, ecx, edx

exchangeElements PROC
		push	ebp
		mov		ebp,esp
		pushad
		;NOTE: mov		eax,[eax] value
		;NOTE: mov		eax,[ebp+12] @
		mov		eax,[ebp+8] ;store current number 
		mov		ebx, [ebp+12] ;store current number 
		mov		ecx,[eax] ;value of eax
		mov		edx,[ebx] ;value of ebx
		;now we need to put values back into address
		mov		[eax],edx
		mov		[ebx],ecx
		popad
		pop ebp
		ret		8

exchangeElements ENDP


;Procedure to display the median of the array.
;receives: array(reference) as ebp+16,request(value) as ebp+12, and title as ebp+8
;returns: median of list
;preconditions: list must be sorted
;registers changed: eax, ebx, esi, edx

displayMedian PROC
		push	ebp
		mov		ebp, esp
		mov		eax, [ebp+12]	;input_1
		cdq	
		mov		esi, [ebp+16]   ;array

		mov		edx,[ebp+8]
		call	WriteString
		call	CrLf

		dec		eax
		mov		edx,0
		mov		ebx,2
		div		ebx
		shl		eax,2
		add		esi,eax
		cmp		edx,0
		je		evenSize

	oddSize:
		mov		eax,[esi]
		call	WriteDec
		call	CrLf
		jmp		complete


	evenSize:
		mov		eax,[esi]
		add		eax,[esi-4]
		cdq
		mov		edx,0
		mov		ebx,2
		div		ebx
		call	WriteDec
		call	CrLf
		

	complete:
		pop		ebp
		ret		12
displayMedian ENDP
END main

