.include "record_def.s"
.include "linux.s"

.section .data
record1:
	.ascii "Fredrick\0"
	.rept 31
    	.byte 0
	.endr

	.ascii "Bartlett\0"
	.rept 31
    	.byte 0
	.endr

    .ascii "My Name is Fredrick Bartlett\0"
    .rept 11
        .byte 0
    .endr

	.ascii "4242 S Prairie\nTulsa, OK 55555\0"
	.rept 209
    	.byte 0
	.endr

	.long 45

file_name: .ascii "loop_record.dat\0"

.section .text
    .globl _start

_start:
    # open file
    movq $SYS_OPENAT, %rax
    movq $CURR_DIR, %rdi
    movq $file_name, %rsi
    movq $WRITE_ONLY, %rdx
    orq $CREATE, %rdx
    movq $AR_URW, %r10
    syscall 

    movq $30, %rbx # 30 records

    # Since we are writing identical data into file
    # over 30 times, to optimize iteration
    # we will set all arguments for syscall at once 
    # and then run the loop
    movq %rax, %rdi # storing file descriptor
    movq $record1, %rsi
    movq $RECORD_SIZE, %rdx

start_loop:
    cmpq $0, %rbx
    je end_loop

    movq $SYS_WRITE, %rax
    syscall

    dec %rbx
    jmp start_loop

end_loop:
    movq $SYS_EXIT, %rax
    movq $0, %rdi
    syscall


