.include "record-def.s"
.include "linux.s"

.globl read_record
.globl write_record

.type read_record, @function
.type write_record, @function

# read_record(%rdi=Fd, %rsi=buffer)
read_record:
	movq $SYS_READ, %rax
	movq $RECORD_SIZE, %rdx
	syscall

	ret

# write_record(%rdi=fd, $rsi=buffer)
write_record:
	movq $SYS_WRITE, %rax
	movq $RECORD_SIZE, %rdx
	syscall

	ret
