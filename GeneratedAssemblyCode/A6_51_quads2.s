
	.section	.rodata
.LC0:
	.string	"\n\tComputing product and ncr\n\n"
.LC1:
	.string	"Enter 2 integers: "
.LC2:
	.string	"The product is: "
.LC3:
	.string	"\n"
.LC4:
	.string	"The ncr is: "
.LC5:
	.string	"\n"
	.text	
	.globl	ncr
	.type	ncr, @function
ncr: 
.LFB4:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$88, %rsp
	movq	%rdi, -20(%rbp)
	movq	%rsi, -16(%rbp)
	movl	$1, %eax
	movl 	%eax, -36(%rbp)
	movl	-36(%rbp), %eax
	movl 	%eax, -32(%rbp)
	movl	$1, %eax
	movl 	%eax, -40(%rbp)
	movl	-40(%rbp), %eax
	movl 	%eax, -24(%rbp)
	movl	$1, %eax
	movl 	%eax, -48(%rbp)
	movl	-48(%rbp), %eax
	movl 	%eax, -28(%rbp)
.L11: 
	movl	-28(%rbp), %eax
	cmpl	-16(%rbp), %eax
	jle .L13
	jmp .L14
.L12: 
	movl	$1, %eax
	movl 	%eax, -52(%rbp)
	movl 	-28(%rbp), %eax
	movl 	-52(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -56(%rbp)
	movl	-56(%rbp), %eax
	movl 	%eax, -28(%rbp)
	jmp .L11
.L13: 
	movl 	-20(%rbp), %eax
	movl 	-28(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -60(%rbp)
	movl	$1, %eax
	movl 	%eax, -64(%rbp)
	movl 	-60(%rbp), %eax
	movl 	-64(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -68(%rbp)
	movl 	-32(%rbp), %eax
	imull 	-68(%rbp), %eax
	movl 	%eax, -72(%rbp)
	movl	-72(%rbp), %eax
	movl 	%eax, -32(%rbp)
	movl 	-24(%rbp), %eax
	imull 	-28(%rbp), %eax
	movl 	%eax, -76(%rbp)
	movl	-76(%rbp), %eax
	movl 	%eax, -24(%rbp)
	jmp .L12
.L14: 
	movl 	-32(%rbp), %eax
	cltd
	idivl 	-24(%rbp)
	movl 	%eax, -44(%rbp)
	movl	-44(%rbp), %eax
jmp .LFE4
	.LFE4:
leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
	.size	ncr, .-ncr
	.globl	get_prod
	.type	get_prod, @function
get_prod: 
.LFB5:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$40, %rsp
	movq	%rdi, -20(%rbp)
	movq	%rsi, -16(%rbp)
	movl 	-20(%rbp), %eax
	imull 	-16(%rbp), %eax
	movl 	%eax, -28(%rbp)
	movl	-28(%rbp), %eax
	movl 	%eax, -24(%rbp)
	movl	-24(%rbp), %eax
jmp .LFE5
	.LFE5:
leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
	.size	get_prod, .-get_prod
	.globl	main
	.type	main, @function
main: 
.LFB6:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$116, %rsp

	movq 	$.LC0, -40(%rbp)
	movl 	-40(%rbp), %eax
	movq 	-40(%rbp), %rdi
	call	printStr
	movl	%eax, -44(%rbp)
	movq 	$.LC1, -84(%rbp)
	movl 	-84(%rbp), %eax
	movq 	-84(%rbp), %rdi
	call	printStr
	movl	%eax, -88(%rbp)
	movl 	-36(%rbp), %eax
	movq 	-36(%rbp), %rdi
	call	readInt
	movl	%eax, -92(%rbp)
	movl	-92(%rbp), %eax
	movl 	%eax, -24(%rbp)
	movl 	-36(%rbp), %eax
	movq 	-36(%rbp), %rdi
	call	readInt
	movl	%eax, -96(%rbp)
	movl	-96(%rbp), %eax
	movl 	%eax, -28(%rbp)
	movl 	-24(%rbp), %eax
	movq 	-24(%rbp), %rdi
movl 	-28(%rbp), %eax
	movq 	-28(%rbp), %rsi
	call	get_prod
	movl	%eax, -100(%rbp)
	movl	-100(%rbp), %eax
	movl 	%eax, -32(%rbp)
	movq 	$.LC2, -104(%rbp)
	movl 	-104(%rbp), %eax
	movq 	-104(%rbp), %rdi
	call	printStr
	movl	%eax, -108(%rbp)
	movl 	-32(%rbp), %eax
	movq 	-32(%rbp), %rdi
	call	printInt
	movl	%eax, -112(%rbp)
	movq 	$.LC3, -48(%rbp)
	movl 	-48(%rbp), %eax
	movq 	-48(%rbp), %rdi
	call	printStr
	movl	%eax, -52(%rbp)
	movl 	-24(%rbp), %eax
	movq 	-24(%rbp), %rdi
movl 	-28(%rbp), %eax
	movq 	-28(%rbp), %rsi
	call	ncr
	movl	%eax, -56(%rbp)
	movl	-56(%rbp), %eax
	movl 	%eax, -32(%rbp)
	movq 	$.LC4, -60(%rbp)
	movl 	-60(%rbp), %eax
	movq 	-60(%rbp), %rdi
	call	printStr
	movl	%eax, -64(%rbp)
	movl 	-32(%rbp), %eax
	movq 	-32(%rbp), %rdi
	call	printInt
	movl	%eax, -68(%rbp)
	movq 	$.LC5, -72(%rbp)
	movl 	-72(%rbp), %eax
	movq 	-72(%rbp), %rdi
	call	printStr
	movl	%eax, -76(%rbp)
	movl	$0, %eax
	movl 	%eax, -80(%rbp)
	movl	-80(%rbp), %eax
jmp .LFE6
	.LFE6:
leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
	.size	main, .-main
	.ident		"Compiled by 200101015"
	.section	.note.GNU-stack,"",@progbits
