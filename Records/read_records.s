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

    # save file descriptor
    movq %rax, %rbx

record_read_loop:
    movq $record_buffer, %rsi
    movq %rbx, %rdi
    call read_record

    # Since data in structed and buffer is of fix size
    # Corrupted data / EOF will not match fixed data size
    cmpq $RECORD_SIZE, %rax
    jne finished_reading

    # Get First Name end index
    movq $record_buffer, %rdi
    call count_chars

    # Write First name to terminal 
    movq $STDOUT, %rdi
    movq $record_buffer, %rsi
    movq %rax, %rdx # bytes to write
    movq $SYS_WRITE, %rax
    syscall

    # Append new_line to terminal
    call write_newline

    jmp record_read_loop

finished_reading:
    movq $SYS_EXIT, %rax
    movq $0, %rdi
    syscall
