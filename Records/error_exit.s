# PURPOSE :
#   Exit Gracefully when an error occurs in your program
#
# Input :
#   rdi -> Starting Address of the Error Code
#   rsi -> Starting Address of the Error Message 
#
# Output :
#   Does not return at all.
#   Prints error code and message to STDERR and
#   Exits program with status code 1
#
# Registers used :
#   rax, rbx, rdi, rsi, rdx
#   I know many people will cry about using rbx as it is callee saved
#   But i dont care, this function doesn't return back to caller, it exits
#   i did use rcx instead of rbx before, but kernel changes its value across syscalls
#   Lesson Learned, rcx, r11 should not be relied on after syscalls

.include "linux.s"

.globl error_exit
.type error_exit, @function

error_exit:
    # store copy of rsi
    movq %rsi, %rbx

# Write Error Code to STDERR
    # Get size of the error code
    # rdi already has start adress of error code
    call count_chars
    
    # Rdi has buffer (start address)
    # count_chars returned size of error code in rax
    movq %rax, %rdx
    movq %rdi, %rsi 
    movq $STDERR, %rdi
    movq $SYS_WRITE, %rax
    syscall

# Write Error Message to STDERR
    # Get the size of error message
    movq %rbx, %rdi
    call count_chars

    movq %rax, %rdx
    movq %rbx, %rsi
    movq $STDERR, %rdi
    movq $SYS_WRITE, %rax
    syscall

    movq $STDERR, %rdi
    call write_newline

# Exit with status 1
    movq $SYS_EXIT, %rax
    movq $1, %rdi
    syscall
