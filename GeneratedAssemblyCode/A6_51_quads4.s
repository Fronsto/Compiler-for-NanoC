
	.section	.rodata
.LC0:
	.string	"\n\tRecursive factorial\n\n"
.LC1:
	.string	"Enter an integer: "
.LC2:
	.string	"The factorial mod 100 is: "
.LC3:
	.string	"\n"
	.text	
	.globl	factorial
	.type	factorial, @function
factorial: 
.LFB3:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$64, %rsp
	movq	%rdi, -20(%rbp)
	movl	$0, %eax
	movl 	%eax, -24(%rbp)
	movl	-20(%rbp), %eax
	cmpl	-24(%rbp), %eax
	je .L9
	jmp .L10
	jmp .L11
.L9: 
	movl	$1, %eax
	movl 	%eax, -28(%rbp)
	movl	-28(%rbp), %eax
jmp .LFE3
	jmp .L11
.L10: 
	movl	$1, %eax
	movl 	%eax, -32(%rbp)
	movl 	-20(%rbp), %eax
	movl 	-32(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -36(%rbp)
	movl 	-36(%rbp), %eax
	movq 	-36(%rbp), %rdi
	call	factorial
	movl	%eax, -40(%rbp)
	movl 	-20(%rbp), %eax
	imull 	-40(%rbp), %eax
	movl 	%eax, -44(%rbp)
	movl	$100, %eax
	movl 	%eax, -48(%rbp)
	movl 	-44(%rbp), %eax
	cltd
	idivl 	-48(%rbp)
	movl 	%edx, -52(%rbp)
	movl	-52(%rbp), %eax
jmp .LFE3
.L11: 
	movl	$0, %eax
	movl 	%eax, -56(%rbp)
	movl	-56(%rbp), %eax
jmp .LFE3
	.LFE3:
leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
	.size	factorial, .-factorial
	.globl	main
	.type	main, @function
main: 
.LFB4:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$84, %rsp

	movq 	$.LC0, -36(%rbp)
	movl 	-36(%rbp), %eax
	movq 	-36(%rbp), %rdi
	call	printStr
	movl	%eax, -40(%rbp)
	movq 	$.LC1, -52(%rbp)
	movl 	-52(%rbp), %eax
	movq 	-52(%rbp), %rdi
	call	printStr
	movl	%eax, -56(%rbp)
	movl 	-24(%rbp), %eax
	movq 	-24(%rbp), %rdi
	call	readInt
	movl	%eax, -60(%rbp)
	movl	-60(%rbp), %eax
	movl 	%eax, -32(%rbp)
	movl 	-32(%rbp), %eax
	movq 	-32(%rbp), %rdi
	call	factorial
	movl	%eax, -64(%rbp)
	movl	-64(%rbp), %eax
	movl 	%eax, -28(%rbp)
	movq 	$.LC2, -68(%rbp)
	movl 	-68(%rbp), %eax
	movq 	-68(%rbp), %rdi
	call	printStr
	movl	%eax, -72(%rbp)
	movl 	-28(%rbp), %eax
	movq 	-28(%rbp), %rdi
	call	printInt
	movl	%eax, -76(%rbp)
	movq 	$.LC3, -80(%rbp)
	movl 	-80(%rbp), %eax
	movq 	-80(%rbp), %rdi
	call	printStr
	movl	%eax, -44(%rbp)
	movl	$0, %eax
	movl 	%eax, -48(%rbp)
	movl	-48(%rbp), %eax
jmp .LFE4
	.LFE4:
leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
	.size	main, .-main
	.ident		"Compiled by 200101015"
	.section	.note.GNU-stack,"",@progbits
