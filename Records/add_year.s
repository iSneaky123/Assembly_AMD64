.include "linux.s"
.include "record_def.s"

.section .data
    input_file_name: .ascii "teswt.dat\0"
    output_file_name: .ascii "testout.dat\0"

    no_open_file_code: .ascii "0001: \0"
    no_open_file_msg: .ascii "Can't Open Input File.\0"


.section .bss
    .lcomm record_buffer, RECORD_SIZE

    .equ FD_IN, -8
    .equ FD_OUT, -16

.section .text
    .global _start

_start:
    # Preserving Stack for storing file_descriptors
    movq %rsp, %rbp
    subq $16, %rsp

    # Open Input File
    movq $SYS_OPENAT, %rax
    movq $CURR_DIR, %rdi
    movq $input_file_name, %rsi
    movq $READ_ONLY, %rdx
    movq $0, %r10
    syscall

    # when os returns fd value less than 0, it means error
    cmpq $0, %rax
    jl file_error

    # Store input file descriptor
    movq %rax, FD_IN(%rbp)

    # Opening Output File
    movq $SYS_OPENAT, %rax
    movq $CURR_DIR, %rdi
    movq $output_file_name, %rsi
    movq $WRITE_ONLY, %rdx
    orq $CREATE, %rdx
    orq $TRUNCATE, %rdx
    movq $AR_URW, %r10
    syscall 

    # Store output file descriptor
    movq %rax, FD_OUT(%rbp)

loop_begin:
    movq FD_IN(%rbp), %rdi
    movq $record_buffer, %rsi
    call read_record

    # check if returned number of bytes read is same as Records size else EOF / Error
    cmpq $RECORD_SIZE, %rax
    jne loop_end

    # increment age
    incl record_buffer + RECORD_AGE

    # Write the record out
    movq FD_OUT(%rbp), %rdi
    movq $record_buffer, %rsi
    call write_record

    jmp loop_begin

loop_end:
    #exit program
    movq $SYS_EXIT, %rax
    movq $0, %rbx
    syscall

file_error:
    movq $no_open_file_code, %rdi
    movq $no_open_file_msg, %rsi
    call error_exit
