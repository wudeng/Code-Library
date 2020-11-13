.section .data

.section .text
.globl _start
_start:
	movl $1, %eax
	movl $0x80, %ebx
	int $0x80
