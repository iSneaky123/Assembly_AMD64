# Purpose : This program will convert string to unsigned numbers in ascii
#
# Input : %rdi (starting address of string)
#
# Output: -1 in case of failure, number
#
# Registers:
#   rax - returns the number
#   rcx - to know where string ends
#   rdx - to calculate current index of string
#   rsi - to store byte

.equ ascii_zero, 48
.equ ascii_nine, 57
.equ ascii_to_number_difference, 48

.type ascii_to_number, @function
.globl ascii_to_number

.section .text

ascii_to_number:
    call count_chars
    movq %rax, %rcx # store size of string in rcx

    xorq %rax, %rax
    xorq %rdx, %rdx
    xorq %rsi, %rsi

start_loop:
    cmpq %rcx, %rdx
    jge exit

    # multiple rax by 10 to add another digit later on
    # for initial iteration this has no value as rax is 0
    imul $10, %rax

    # Extract the byte from string for conversion
    movzbq (%rdi, %rdx, 1), %rsi

    # Check if byte is ascii number or not (between ascii value 48 and 57 inclusive)
    cmpq $ascii_zero, %rsi 
    jl error
    cmpq $ascii_nine, %rsi 
    jg error

    # convert ascii to number
    sub $ascii_to_number_difference, %rsi

    addq %rsi, %rax
    inc %rdx
    jmp start_loop

error:
    movq $-1, %rax

exit:
    ret
