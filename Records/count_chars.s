# Count the characters untill a null byte is reached
#
# Input : The adress of the char string
#
# Output: Returns the count in rax
#
# Registers Used:
# rax - current position
# rdi -  address (input)

.type  count_chars, @function
.globl count_chars

count_chars:
	movq $0, %rax

count_loop_begin:
    # is current char null?
    cmpb $0, (%rdi, %rax, 1)
    je   count_loop_end

    # otherwise increment current position by 1
	inc %rax
	jmp count_loop_begin

count_loop_end:
	ret
