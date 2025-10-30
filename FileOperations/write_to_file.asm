	;    SYSTEM V AMD64, syntax -> nasm
	;    A Simple Assembly progam to write to file
	;    Constants
	NULL EQU 0

	;     Syscall codes
	WRITE EQU 1
	CLOSE EQU 3
	EXIT  EQU 60
	OPEN_FILE EQU 257

	; Directory Related
	CURR_DIR EQU -100

	; File related constants
	WRITE_CREATE EQU 0x41 ; Opens file with CREATE(40) and WRITE(1) flags
	USER_RW EQU 0o600 ; Gives Read (4) and Write (2) perms to user (100) in OCTAL

	NEW_LINE EQU 0x0A

	;       Section
	section .data
	output_file db "output.txt", 0
	content db "Hello World!", NEW_LINE, "I am Sneaky.", NEW_LINE, "I sneak up on nobody.", NEW_LINE, 0
	content_len EQU $ - content

	section .text
	global  _start

_start:
	;   Opening file and getting file descriptor from kernel
	mov rax, OPEN_FILE
	mov rdi, CURR_DIR
	lea rsi, [rel output_file]
	mov rdx, WRITE_CREATE
	mov r10, USER_RW
	syscall

	mov rbx, rax; rax contains file descriptor, or error code in case of negative

	;    check if any error
	test rbx, rbx
	js   error

	;   Writing Content into file
	mov rax, WRITE
	mov rdi, rbx; loading file descriptor that we fetched before, to test for errors
	lea rsi, [rel content]
	mov rdx, content_len
	syscall

	;   Closing File
	mov rax, CLOSE
	mov rdi, rbx
	syscall

error:
	mov rax, EXIT
	mov rdi, 1
	syscall
