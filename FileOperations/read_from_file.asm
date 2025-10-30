	; SYSTEM V AMD64, x86
	; This is an example program for reading from file and writing to STD_OUT fd(1)

	;    Constants
	NULL EQU 0

	; Syscalls
	SYS_READ EQU 0
	SYS_WRITE EQU 1
	SYS_CLOSE EQU 3
	SYS_EXIT EQU 60
	SYS_OPEN EQU 257

	; Directory
	CURR_DIR EQU -100

	;    File Stuffs
	READ EQU 0

	; Other Constants
	STD_OUT EQU 1
	BUF_LEN EQU 64

	;       Section stuff
	section .data
	input_file db "input.txt", 0

	section .bss
	read_buffer  resb BUF_LEN

	section .text
	global  _start

_start:
	;   Open File
	mov rax, SYS_OPEN
	mov rdi, CURR_DIR
	lea rsi, [rel input_file]
	mov rdx, READ
	mov r10, NULL
	syscall

	;    Check for errors
	test rax, rax
	js   error_exit

	;   storing file descriptor
	mov rbx, rax

read_file:
	;   Read from File
	mov rax, SYS_READ
	mov rdi, rbx
	lea rsi, [rel read_buffer]
	mov rdx, BUF_LEN
	syscall

	;    Check if we have reached end of file
	test rax, rax
	js   error_exit
	jz   exit

	;   Write to Terminal
	mov rdi, STD_OUT
	lea rsi, [rel read_buffer]
	mov rdx, rax
	mov rax, SYS_WRITE
	syscall

	jmp read_file

exit:
	mov rax, SYS_CLOSE
	mov rdi, rbx
	syscall

	mov rax, SYS_EXIT
	xor rdi, rdi
	syscall

error_exit:

	mov rax, SYS_EXIT
	mov rdi, 1
	syscall

