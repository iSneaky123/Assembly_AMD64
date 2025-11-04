# PURPOSE: 
#    Write data into buffer and pad null bytes into buffer till record size is reached
#
# INPUT:
#   %rdi - starting address of source
#   %rsi - start address of destination
#   %rdx - bytes to copy
#   %rcx - max size of destination 
#
# OUTPUT: Void
#
# REGISTERS 
#   rax, r8

.type write_to_buffer, @function
.globl write_to_buffer

write_to_buffer:
    xor rax, rax

write_loop:
    cmpq %rdx, %rax
    jge pad_bytes

    movb (%rdi, %rax, 1), %r8l
    movb %r8l, (%rsi, %rax, 1)
    inc %rax
    jmp write_loop

pad_bytes:
    cmpq %rcx, %rax
    je exit

    movb $0, (%rsi, %rax, 1)
    inc rax
    jmp pad_bytes

exit:
    ret
