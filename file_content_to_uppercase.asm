	; SYSTEM V AMD64, x86
	; This is a simple program which reads a file, converts all of its characters to Uppercase and writes it to a file

	;    Constants
	NULL EQU 0
	BUF_SIZE EQU 64

	; System calls
	SYS_READ EQU 0
	SYS_WRITE EQU 1
	SYS_CLOSE EQU 3
	SYS_EXIT EQU 60
	SYS_OPENAT EQU 257

	; Directory
	CURR_DIR EQU -100

	;    File Options
	CREATE_WRITE EQU 0x41
	READ EQU 0

	; File Permissions
	URW_GR_OR EQU 0o644

	section .data
	input   db "input.txt", 0
	output  db "output.txt", 0

	section .bss
	buffer  resb BUF_SIZE

	section .text
	global  _start
	global  to_uppercase

_start:
	;   We need to store file descriptor for both input and output
	mov rbp, rsp
	sub rsp, 16

	;   Opening Input File
	mov rax, SYS_OPENAT
	mov rdi, CURR_DIR
	lea rsi, [rel input]
	mov rdx, READ
	mov r10, NULL
	syscall

	;    Exit on error
	test rax, rax
	js   error

	;   input file descriptor
	mov qword [rbp], rax

	;   Opening Output File
	mov rax, SYS_OPENAT
	mov rdi, CURR_DIR
	lea rsi, [rel output]
	mov rdx, CREATE_WRITE
	mov r10, URW_GR_OR
	syscall

	test rax, rax
	js   exit

	;   output file descriptor
	mov qword [rbp + 8], rax

read_write_loop:
	;   Read 64 Bytes From the Input file
	mov rax, SYS_READ
	mov rdi, qword [rbp]
	lea rsi, buffer
	mov rdx, BUF_SIZE
	syscall

	;    When no bytes are read from Input file, Close files
	test rax, rax
	jz   exit

	mov rbx, rax

	;    Convert all lowercase characters to uppercase
	mov  rdi, buffer
	mov  rsi, BUF_SIZE
	call to_uppercase

	;   Write result to output file
	mov rdi, qword [rbp + 8]
	mov rsi, rax; output of to_uppercase
	mov rdx, BUF_SIZE
	mov rax, SYS_WRITE
	syscall

	jmp read_write_loop

exit:
	;   Close input file
	mov rax, SYS_CLOSE
	mov rdi, qword [rbp]
	syscall

	;   Close output file
	mov rax, SYS_CLOSE
	mov rdi, qword [rbp + 8]
	syscall

	mov rax, 60
	mov rdi, 0
	syscall

error:
	mov rax, 60
	mov rdi, 1
	syscall

to_uppercase:
	mov rax, rdi
	mov rdi, 0

convert_loop:
	cmp rdi, rsi
	jge return

	cmp byte [rax + rdi], 97; Check if character is not less than a in ascii
	jl  shift

	cmp byte [rax + rdi], 122; Check if character is not greater than z in ascii
	jg  shift

	sub byte [rax + rdi], 32; Convert Character to Upper Case in ascii

shift:
	inc rdi
	jmp convert_loop

return:
	ret
