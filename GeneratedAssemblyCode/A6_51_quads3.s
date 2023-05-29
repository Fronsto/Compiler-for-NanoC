
	.section	.rodata
.LC0:
	.string	"One of the numbers is less than 10\n"
.LC1:
	.string	"The numbers fit the criteria\n"
.LC2:
	.string	"Two or more numbers are equal\n"
.LC3:
	.string	"One of the numbers is greater than 100\n"
.LC4:
	.string	"\n\tBoolean expressions and if-else\n\n"
.LC5:
	.string	"Enter 3 distinct integers between 10 and 100: "
.LC6:
	.string	"SUCCESS\n"
.LC7:
	.string	"FAILURE\n"
	.text	
	.globl	testingBoolean
	.type	testingBoolean, @function
testingBoolean: 
.LFB17:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$104, %rsp
	movq	%rdi, -20(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -12(%rbp)
	movl	$0, %eax
	movl 	%eax, -28(%rbp)
	movl	-28(%rbp), %eax
	movl 	%eax, -24(%rbp)
	movl	$10, %eax
	movl 	%eax, -32(%rbp)
	movl	-20(%rbp), %eax
	cmpl	-32(%rbp), %eax
	jl .L39
	jmp .L37
.L37: 
	movl	$10, %eax
	movl 	%eax, -60(%rbp)
	movl	-16(%rbp), %eax
	cmpl	-60(%rbp), %eax
	jl .L39
	jmp .L38
.L38: 
	movl	$10, %eax
	movl 	%eax, -64(%rbp)
	movl	-12(%rbp), %eax
	cmpl	-64(%rbp), %eax
	jl .L39
	jmp .L40
	jmp .L50
.L39: 
	movq 	$.LC0, -68(%rbp)
	movl 	-68(%rbp), %eax
	movq 	-68(%rbp), %rdi
	call	printStr
	movl	%eax, -72(%rbp)
	jmp .L50
.L40: 
	movl	$100, %eax
	movl 	%eax, -76(%rbp)
	movl	-20(%rbp), %eax
	cmpl	-76(%rbp), %eax
	jle .L41
	jmp .L49
.L41: 
	movl	$100, %eax
	movl 	%eax, -80(%rbp)
	movl	-16(%rbp), %eax
	cmpl	-80(%rbp), %eax
	jle .L42
	jmp .L49
.L42: 
	movl	$100, %eax
	movl 	%eax, -84(%rbp)
	movl	-12(%rbp), %eax
	cmpl	-84(%rbp), %eax
	jle .L43
	jmp .L49
	jmp .L50
.L43: 
	movl	-20(%rbp), %eax
	cmpl	-16(%rbp), %eax
	je .L47
	jmp .L44
.L44: 
	movl	-16(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jne .L45
	jmp .L47
.L45: 
	movl	-20(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jne .L46
	jmp .L47
	jmp .L48
.L46: 
	movq 	$.LC1, -88(%rbp)
	movl 	-88(%rbp), %eax
	movq 	-88(%rbp), %rdi
	call	printStr
	movl	%eax, -36(%rbp)
	movl	$1, %eax
	movl 	%eax, -40(%rbp)
	movl	-40(%rbp), %eax
	movl 	%eax, -24(%rbp)
	jmp .L50
.L47: 
	movq 	$.LC2, -44(%rbp)
	movl 	-44(%rbp), %eax
	movq 	-44(%rbp), %rdi
	call	printStr
	movl	%eax, -48(%rbp)
.L48: 
	jmp .L50
.L49: 
	movq 	$.LC3, -52(%rbp)
	movl 	-52(%rbp), %eax
	movq 	-52(%rbp), %rdi
	call	printStr
	movl	%eax, -56(%rbp)
.L50: 
	movl	-24(%rbp), %eax
jmp .LFE17
	.LFE17:
leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
	.size	testingBoolean, .-testingBoolean
	.globl	main
	.type	main, @function
main: 
.LFB18:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$100, %rsp

	movq 	$.LC4, -44(%rbp)
	movl 	-44(%rbp), %eax
	movq 	-44(%rbp), %rdi
	call	printStr
	movl	%eax, -48(%rbp)
	movq 	$.LC5, -68(%rbp)
	movl 	-68(%rbp), %eax
	movq 	-68(%rbp), %rdi
	call	printStr
	movl	%eax, -72(%rbp)
	movl 	-36(%rbp), %eax
	movq 	-36(%rbp), %rdi
	call	readInt
	movl	%eax, -76(%rbp)
	movl	-76(%rbp), %eax
	movl 	%eax, -24(%rbp)
	movl 	-36(%rbp), %eax
	movq 	-36(%rbp), %rdi
	call	readInt
	movl	%eax, -80(%rbp)
	movl	-80(%rbp), %eax
	movl 	%eax, -28(%rbp)
	movl 	-36(%rbp), %eax
	movq 	-36(%rbp), %rdi
	call	readInt
	movl	%eax, -84(%rbp)
	movl	-84(%rbp), %eax
	movl 	%eax, -32(%rbp)
	movl 	-24(%rbp), %eax
	movq 	-24(%rbp), %rdi
movl 	-28(%rbp), %eax
	movq 	-28(%rbp), %rsi
movl 	-32(%rbp), %eax
	movq 	-32(%rbp), %rdx
	call	testingBoolean
	movl	%eax, -88(%rbp)
	movl	-88(%rbp), %eax
	movl 	%eax, -40(%rbp)
	movl	$1, %eax
	movl 	%eax, -92(%rbp)
	movl	-40(%rbp), %eax
	cmpl	-92(%rbp), %eax
	je .L53
	jmp .L54
	jmp .L55
.L53: 
	movq 	$.LC6, -96(%rbp)
	movl 	-96(%rbp), %eax
	movq 	-96(%rbp), %rdi
	call	printStr
	movl	%eax, -52(%rbp)
	jmp .L55
.L54: 
	movq 	$.LC7, -56(%rbp)
	movl 	-56(%rbp), %eax
	movq 	-56(%rbp), %rdi
	call	printStr
	movl	%eax, -60(%rbp)
.L55: 
	movl	$0, %eax
	movl 	%eax, -64(%rbp)
	movl	-64(%rbp), %eax
jmp .LFE18
	.LFE18:
leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
	.size	main, .-main
	.ident		"Compiled by 200101015"
	.section	.note.GNU-stack,"",@progbits
