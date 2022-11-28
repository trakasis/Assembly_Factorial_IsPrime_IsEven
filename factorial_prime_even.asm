.586
.MODEL FLAT, stdcall
.STACK 4096
ExitProcess proto,dwExitCode:dword

.DATA
mynum DWORD 6
mynumfactorial DWORD 0     ; VSCode got mad about dashes in the variable name so i left them out
mynumflags WORD 0

IsEven MACRO num
	   mov edx, 0
	   mov edx, num
	   and edx, 1

	   cmp edx, 0
	   je ItsZero
	   cmp edx, 1
	   je ItsNotZero

	   ItsZero:
			or mynumflags, 0000000000000010b
			jmp done
	   ItsNotZero:
			jmp done
	   
	   done:

	   ENDM


.CODE
main PROC

	cmp mynum, 0
	jl InputLTZero
	push mynum
	call Factorial
	add esp, 4
	mov mynumfactorial, eax
	jmp PrimeCall

	InputLTZero:
		mov mynumfactorial, -1
		and mynumflags, 0
		jmp EndOf

	PrimeCall:
	cmp mynum, 0
	je InputIsZero
	cmp mynum, 1
	je InputOneOrTwo
	cmp mynum, 2
	je InputOneOrTwo
	jmp nextCall

	InputOneOrTwo:
		or mynumflags, 0000000000000001b
		jmp goToMacro

	InputIsZero:
		or mynumflags, 0000000000000000b
		jmp goToMacro

	nextCall:
		push mynum
		call IsPrime
		add esp, 4

	goToMacro:
	cmp mynum, 0
	je EndOf
	IsEven mynum
	
	EndOf:
	invoke ExitProcess, 0
main ENDP

Factorial PROC
	push ebp
	mov ebp, esp
	push edx


	cmp DWORD PTR [ebp+8], 0
	jne NotZero
	mov eax, 1
	jmp done

	NotZero:
		mov eax, DWORD PTR [ebp+8]
		dec eax
		push eax
		call Factorial
		imul DWORD PTR [ebp+8]
	done:
		pop edx
		pop ebp
		ret 4


Factorial ENDP


IsPrime PROC
	push ebp
	mov ebp, esp
	push edx
	push ebx

	mov edx, 0
	mov ebx, 0
	mov eax, 0

	mov eax, DWORD PTR [ebp+8]
	mov ebx, DWORD PTR [ebp+8]
	dec ebx
	
		  AboveOne: cmp ebx, 1
					je EndAboveOne

					div ebx
					cmp edx, 0
					je NotAPrime
					and eax, 0
					and edx, 0
					mov eax, DWORD PTR [ebp+8]
					dec ebx
					jmp AboveOne

	NotAPrime:
			  and mynumflags, 0
			  jmp done

	EndAboveOne:
		and mynumflags, 0
		or mynumflags, 0000000000000001b
		jmp done

	done:
		pop ebx
		pop edx
		pop ebp
		ret 4

IsPrime ENDP

END
