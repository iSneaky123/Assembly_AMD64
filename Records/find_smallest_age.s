.include "linux.s"
.include "record_def.s"

.section .data
file_name: .ascii "test.dat\0"

.section .bss
.lcomm record_buffer, RECORD_SIZE

.section .text
.globl _start

_start:
    # Open File
    movq $SYS_OPENAT, %rax
    movq $CURR_DIR, %rdi
    movq $file_name, %rsi
    movq $READ_ONLY, %rdx
    movq $0, %r10
    syscall

    # Store File Descriptor
    movq %rax, %rdi
    movq $record_buffer, %rsi

    movq $100, %rbx # we will store small value here

operation_loop:
    # Read a record
    call read_record

    # if new record is not fetched / reached end of file > exit
    cmpq $RECORD_SIZE, %rax
    jne exit

    # check if new age is smallest age
    cmpl record_buffer + RECORD_AGE, %ebx
    jle operation_loop

    # if biggest age so far, update smallest age
    movl record_buffer + RECORD_AGE, %ebx
    jmp operation_loop

exit:
    movq $SYS_EXIT, %rax
    movq %rbx, %rdi
    syscall
