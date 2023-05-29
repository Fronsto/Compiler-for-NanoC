
	.section	.rodata
.LC0:
	.string	"\n\tFibonacci numbers\n\n"
.LC1:
	.string	"Enter a number : "
.LC2:
	.string	"Read value: "
.LC3:
	.string	"\n"
.LC4:
	.string	"Fibonacci of "
.LC5:
	.string	" is "
.LC6:
	.string	"\n"
	.text	
	.globl	fibonacci
	.type	fibonacci, @function
fibonacci: 
.LFB12:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$52, %rsp
	movq	%rdi, -20(%rbp)
	movl	$2, %eax
	movl 	%eax, -24(%rbp)
	movl 	-20(%rbp), %eax
	cltd
	idivl 	-24(%rbp)
	movl 	%edx, -28(%rbp)
	movl	$0, %eax
	movl 	%eax, -32(%rbp)
	movl	-28(%rbp), %eax
	cmpl	-32(%rbp), %eax
	je .L27
	jmp .L28
	jmp .L30
.L27: 
	movl 	-20(%rbp), %eax
	movq 	-20(%rbp), %rdi
	call	f_even
	movl	%eax, -36(%rbp)
	jmp .L29
.L28: 
	movl 	-20(%rbp), %eax
	movq 	-20(%rbp), %rdi
	call	f_odd
	movl	%eax, -40(%rbp)
	movl	-40(%rbp), %eax
	movl 	%eax, -44(%rbp)
	jmp .L30
.L29: 
	movl	-36(%rbp), %eax
	movl 	%eax, -44(%rbp)
	jmp .L30
.L30: 
	movl	-44(%rbp), %eax
jmp .LFE12
	.LFE12:
leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
	.size	fibonacci, .-fibonacci
	.globl	f_odd
	.type	f_odd, @function
f_odd: 
.LFB13:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$68, %rsp
	movq	%rdi, -20(%rbp)
	movl	$1, %eax
	movl 	%eax, -24(%rbp)
	movl	-20(%rbp), %eax
	cmpl	-24(%rbp), %eax
	je .L33
	jmp .L34
	jmp .L36
.L33: 
	movl	$1, %eax
	movl 	%eax, -28(%rbp)
	jmp .L35
.L34: 
	movl	$1, %eax
	movl 	%eax, -32(%rbp)
	movl 	-20(%rbp), %eax
	movl 	-32(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -36(%rbp)
	movl 	-36(%rbp), %eax
	movq 	-36(%rbp), %rdi
	call	f_even
	movl	%eax, -40(%rbp)
	movl	$2, %eax
	movl 	%eax, -44(%rbp)
	movl 	-20(%rbp), %eax
	movl 	-44(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -48(%rbp)
	movl 	-48(%rbp), %eax
	movq 	-48(%rbp), %rdi
	call	f_odd
	movl	%eax, -52(%rbp)
	movl 	-40(%rbp), %eax
	movl 	-52(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -56(%rbp)
	movl	-56(%rbp), %eax
	movl 	%eax, -60(%rbp)
	jmp .L36
.L35: 
	movl	-28(%rbp), %eax
	movl 	%eax, -60(%rbp)
	jmp .L36
.L36: 
	movl	-60(%rbp), %eax
jmp .LFE13
	.LFE13:
leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
	.size	f_odd, .-f_odd
	.globl	f_even
	.type	f_even, @function
f_even: 
.LFB14:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$68, %rsp
	movq	%rdi, -20(%rbp)
	movl	$0, %eax
	movl 	%eax, -24(%rbp)
	movl	-20(%rbp), %eax
	cmpl	-24(%rbp), %eax
	je .L39
	jmp .L40
	jmp .L42
.L39: 
	movl	$0, %eax
	movl 	%eax, -28(%rbp)
	jmp .L41
.L40: 
	movl	$1, %eax
	movl 	%eax, -32(%rbp)
	movl 	-20(%rbp), %eax
	movl 	-32(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -36(%rbp)
	movl 	-36(%rbp), %eax
	movq 	-36(%rbp), %rdi
	call	f_odd
	movl	%eax, -40(%rbp)
	movl	$2, %eax
	movl 	%eax, -44(%rbp)
	movl 	-20(%rbp), %eax
	movl 	-44(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -48(%rbp)
	movl 	-48(%rbp), %eax
	movq 	-48(%rbp), %rdi
	call	f_even
	movl	%eax, -52(%rbp)
	movl 	-40(%rbp), %eax
	movl 	-52(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -56(%rbp)
	movl	-56(%rbp), %eax
	movl 	%eax, -60(%rbp)
	jmp .L42
.L41: 
	movl	-28(%rbp), %eax
	movl 	%eax, -60(%rbp)
	jmp .L42
.L42: 
	movl	-60(%rbp), %eax
jmp .LFE14
	.LFE14:
leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
	.size	f_even, .-f_even
	.globl	main
	.type	main, @function
main: 
.LFB15:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$116, %rsp

	movq 	$.LC0, -32(%rbp)
	movl 	-32(%rbp), %eax
	movq 	-32(%rbp), %rdi
	call	printStr
	movl	%eax, -36(%rbp)
	movq 	$.LC1, -80(%rbp)
	movl 	-80(%rbp), %eax
	movq 	-80(%rbp), %rdi
	call	printStr
	movl	%eax, -84(%rbp)
	movl 	-24(%rbp), %eax
	movq 	-24(%rbp), %rdi
	call	readInt
	movl	%eax, -88(%rbp)
	movl	-88(%rbp), %eax
	movl 	%eax, -112(%rbp)
	movq 	$.LC2, -92(%rbp)
	movl 	-92(%rbp), %eax
	movq 	-92(%rbp), %rdi
	call	printStr
	movl	%eax, -96(%rbp)
	movl 	-112(%rbp), %eax
	movq 	-112(%rbp), %rdi
	call	printInt
	movl	%eax, -100(%rbp)
	movq 	$.LC3, -104(%rbp)
	movl 	-104(%rbp), %eax
	movq 	-104(%rbp), %rdi
	call	printStr
	movl	%eax, -108(%rbp)
	movl 	-112(%rbp), %eax
	movq 	-112(%rbp), %rdi
	call	fibonacci
	movl	%eax, -40(%rbp)
	movl	-40(%rbp), %eax
	movl 	%eax, -28(%rbp)
	movq 	$.LC4, -44(%rbp)
	movl 	-44(%rbp), %eax
	movq 	-44(%rbp), %rdi
	call	printStr
	movl	%eax, -48(%rbp)
	movl 	-112(%rbp), %eax
	movq 	-112(%rbp), %rdi
	call	printInt
	movl	%eax, -52(%rbp)
	movq 	$.LC5, -56(%rbp)
	movl 	-56(%rbp), %eax
	movq 	-56(%rbp), %rdi
	call	printStr
	movl	%eax, -60(%rbp)
	movl 	-28(%rbp), %eax
	movq 	-28(%rbp), %rdi
	call	printInt
	movl	%eax, -64(%rbp)
	movq 	$.LC6, -68(%rbp)
	movl 	-68(%rbp), %eax
	movq 	-68(%rbp), %rdi
	call	printStr
	movl	%eax, -72(%rbp)
	movl	$0, %eax
	movl 	%eax, -76(%rbp)
	movl	-76(%rbp), %eax
jmp .LFE15
	.LFE15:
leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
	.size	main, .-main
	.ident		"Compiled by 200101015"
	.section	.note.GNU-stack,"",@progbits
