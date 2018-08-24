	.file	"test_builtin_expect.c"
	.text
	.globl	test_likely
	.type	test_likely, @function
test_likely:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	cmpl	$0, -4(%rbp)
	setne	%al
	movzbl	%al, %eax
	testq	%rax, %rax
	je	.L2
	movl	$5, -4(%rbp)
	jmp	.L3
.L2:
	movl	$6, -4(%rbp)
.L3:
	movl	-4(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	test_likely, .-test_likely
	.globl	test_unlikely
	.type	test_unlikely, @function
test_unlikely:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	cmpl	$0, -4(%rbp)
	setne	%al
	movzbl	%al, %eax
	testq	%rax, %rax
	je	.L6
	movl	$5, -4(%rbp)
	jmp	.L7
.L6:
	movl	$6, -4(%rbp)
.L7:
	movl	-4(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	test_unlikely, .-test_unlikely
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.10) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
