.include "linux.s"
.include "record_def.s"

# since first argument is file name we will skip it
.equ arg1, 16
.equ arg2, 24
.equ arg3, 32
.equ arg4, 40
.equ arg5, 48
.equ FIRSTNAME_SIZE, 40
.equ LASTNAME_SIZE, 40
.equ MESSAGE_SIZE, 40
.equ ADDRESS_SIZE, 240
.equ AGE_SIZE, 4

.section .data
    file_name: .ascii "test.dat\0"

.section .bss
    .lcomm buffer, RECORD_SIZE

.section .text
    .globl _start

_start:
    # Check if 6 arguments are supplied
    cmpq $6, (%rsp)
    jne invalid_number_of_arguments

    # Check if first name doesnt exceed its size
    leaq arg1(%rsp), %rdi
    call count_chars
    cmpq $FIRSTNAME_SIZE, %rax
    jg invalid_argument

    # Load FirstName into buffer
    # Source Already in rdi
    leaq buffer + RECORD_FIRSTNAME(%rip), %rsi
    movq %rax, %rdx
    movq $FIRSTNAME_SIZE, %rcx
    call write_to_buffer

    # Check if Last Name doesnt exceed its size
    leaq arg2(%rsp), %rdi
    call count_chars
    cmpq $LASTNAME_SIZE, %rax
    jg invalid_argument

    # Load Last Name into buffer
    leaq buffer + RECORD_LASTNAME(%rip), %rsi
    movq %rax, %rdx
    movq $LASTNAME_SIZE, %rcx
    call write_to_buffer

    # Check if Message doesnt exceed its size
    leaq arg3(%rsp), %rdi
    call count_chars
    cmpq $MESSAGE_SIZE, %rax
    jg invalid_argument

    # Load Message into buffer
    leaq buffer + RECORD_MESSAGE(%rip), %rsi
    movq %rax, %rdx
    movq $MESSAGE_SIZE, %rcx
    call write_to_buffer

    # Check if Address doesnt exceed its size
    leaq arg3(%rsp), %rdi
    call count_chars
    cmpq $ADDRESS_SIZE, %rax
    jg invalid_argument

    # Load Message into buffer
    leaq buffer + RECORD_ADDRESS(%rip), %rsi
    movq %rax, %rdx
    movq $ADDRESS_SIZE, %rcx
    call write_to_buffer




errorless_exit:
    movq $0, %rdi
    jmp exit

invalid_argument:
    movq $2, %rdi
    jmp exit

invalid_number_of_arguments:
    movq $1, %rdi
    jmp exit

exit:
    movq $SYS_EXIT, %rax
    syscall
