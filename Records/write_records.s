.include "linux.s"
.include "record_def.s"

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

record2:
	.ascii "Marilyn\0"
	.rept 32
    	.byte 0
	.endr

	.ascii "Taylor\0"
	.rept 33
    	.byte 0
	.endr

    .ascii "My Name is Marilyn Taylor\0"
    .rept 14
        .byte 0
    .endr 

	.ascii "2224 S Johannan St\nChicago, IL 12345\0"
	.rept 203
	    .byte 0
	.endr

	.long 29

record3:
	.ascii "Derrick\0"
	.rept 32
    	.byte 0
	.endr

	.ascii "McIntire\0"
	.rept 31
	    .byte 0
	.endr

    .ascii "My name is Derrick McIntire\0"
    .rept 12
        .byte 0 
    .endr

	.ascii "500 W Oakland\nSan Diego, CA 54321\0"
	.rept 206
    	.byte 0
	.endr

	.long 36

file_name:
	.ascii "test.dat\0"

	.section .text
	.globl   _start

_start:
	movq $SYS_OPENAT, %rax
	movq $CURR_DIR, %rdi
	movq $file_name, %rsi
	movq $CREATE, %rdx
	orq  $WRITE_ONLY, %rdx
	movq $AR_URW, %r10
	syscall

    # Pass File output file descriptor to input for writring records
    movq %rax, %rdi

    # Write Record1
    movq $record1, %rsi
    call write_record

    # Write Record2
    movq $record2, %rsi
    call write_record

    # Write Record3
    movq $record3, %rsi
    call write_record

    # Close file
    movq $SYS_CLOSE, %rax
    syscall

    # Exit
    movq $SYS_EXIT, %rax
    movq $0, %rdi
    syscall
