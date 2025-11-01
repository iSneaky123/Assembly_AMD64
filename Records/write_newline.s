.include "linux.s"

.globl write_newline
.type  write_newline, @function

.section .data

newline:
	.ascii   "\n"
	.section .text

write_newline:
	movq $SYS_WRITE, %rax
    # File Descriptor comes as input
    movq $newline, %rsi
    movq $1, %rdx
    syscall

	ret
