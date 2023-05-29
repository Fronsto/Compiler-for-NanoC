
	.comm	arr,40,4
	.section	.rodata
.LC0:
	.string	"\n\tBubble Sort and Binary Search\n\n"
.LC1:
	.string	"Enter the number of elements in the array: "
.LC2:
	.string	"Enter the elements of the array: "
.LC3:
	.string	"Enter the element to be searched: "
.LC4:
	.string	"The sorted array is: "
.LC5:
	.string	" "
.LC6:
	.string	"\n"
.LC7:
	.string	"\nElement is not present in array"
.LC8:
	.string	"\nElement is present at index "
.LC9:
	.string	"\n"
	.text	
	.globl	bubbleSort
	.type	bubbleSort, @function
bubbleSort: 
.LFB26:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$124, %rsp
	movq	%rdi, -20(%rbp)
	movl	$0, %eax
	movl 	%eax, -36(%rbp)
	movl	-36(%rbp), %eax
	movl 	%eax, -28(%rbp)
.L55: 
	movl	$1, %eax
	movl 	%eax, -40(%rbp)
	movl 	-20(%rbp), %eax
	movl 	-40(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -84(%rbp)
	movl	-28(%rbp), %eax
	cmpl	-84(%rbp), %eax
	jl .L57
	jmp .L63
.L56: 
	movl	$1, %eax
	movl 	%eax, -92(%rbp)
	movl 	-28(%rbp), %eax
	movl 	-92(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -96(%rbp)
	movl	-96(%rbp), %eax
	movl 	%eax, -28(%rbp)
	jmp .L55
.L57: 
	movl 	-20(%rbp), %eax
	movl 	-28(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -100(%rbp)
	movl	$1, %eax
	movl 	%eax, -104(%rbp)
	movl 	-100(%rbp), %eax
	movl 	-104(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -108(%rbp)
	movl	-108(%rbp), %eax
	movl 	%eax, -24(%rbp)
	movl	$0, %eax
	movl 	%eax, -112(%rbp)
	movl	-112(%rbp), %eax
	movl 	%eax, -32(%rbp)
.L58: 
	movl	-32(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jl .L60
	jmp .L56
.L59: 
	movl	$1, %eax
	movl 	%eax, -116(%rbp)
	movl 	-32(%rbp), %eax
	movl 	-116(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -44(%rbp)
	movl	-44(%rbp), %eax
	movl 	%eax, -32(%rbp)
	jmp .L58
.L60: 
	# =[] operation ; t11 = arr[j]
	movl	-32(%rbp), %eax
	movslq	%eax, %rdx
	leaq	0(,%rdx,4), %rdx
	leaq	arr(%rip), %rax
	movl	(%rdx,%rax), %eax
	movl 	%eax, -48(%rbp)
	movl	$1, %eax
	movl 	%eax, -52(%rbp)
	movl 	-32(%rbp), %eax
	movl 	-52(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -56(%rbp)
	# =[] operation ; t14 = arr[t13]
	movl	-56(%rbp), %eax
	movslq	%eax, %rdx
	leaq	0(,%rdx,4), %rdx
	leaq	arr(%rip), %rax
	movl	(%rdx,%rax), %eax
	movl 	%eax, -60(%rbp)
	movl	-48(%rbp), %eax
	cmpl	-60(%rbp), %eax
	jg .L61
	jmp .L59
	jmp .L62
.L61: 
	# =[] operation ; t15 = arr[j]
	movl	-32(%rbp), %eax
	movslq	%eax, %rdx
	leaq	0(,%rdx,4), %rdx
	leaq	arr(%rip), %rax
	movl	(%rdx,%rax), %eax
	movl 	%eax, -64(%rbp)
	movl	-64(%rbp), %eax
	movl 	%eax, -120(%rbp)
	movl	$1, %eax
	movl 	%eax, -68(%rbp)
	movl 	-32(%rbp), %eax
	movl 	-68(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -72(%rbp)
	# =[] operation ; t18 = arr[t17]
	movl	-72(%rbp), %eax
	movslq	%eax, %rdx
	leaq	0(,%rdx,4), %rdx
	leaq	arr(%rip), %rax
	movl	(%rdx,%rax), %eax
	movl 	%eax, -76(%rbp)
	# []= operation ; arr[j] = t18
	movl	-76(%rbp), %eax
	movl	-32(%rbp), %edx
	movslq	%edx, %rdx
	leaq	0(,%rdx,4), %rcx
	leaq	arr(%rip), %rdx
	movl	%eax, (%rcx,%rdx)
	movl	$1, %eax
	movl 	%eax, -80(%rbp)
	movl 	-32(%rbp), %eax
	movl 	-80(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -88(%rbp)
	# []= operation ; arr[t20] = temp
	movl	-120(%rbp), %eax
	movl	-88(%rbp), %edx
	movslq	%edx, %rdx
	leaq	0(,%rdx,4), %rcx
	leaq	arr(%rip), %rdx
	movl	%eax, (%rcx,%rdx)
	jmp .L59
.L62: 
	jmp .L59
	jmp .L56
.L63: 
	jmp .LFE26
	.LFE26:
leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
	.size	bubbleSort, .-bubbleSort
	.globl	binarySearch
	.type	binarySearch, @function
binarySearch: 
.LFB27:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$96, %rsp
	movq	%rdi, -20(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -12(%rbp)
	movl	-16(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jge .L66
	jmp .L71
	jmp .L71
.L66: 
	movl 	-16(%rbp), %eax
	movl 	-20(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -28(%rbp)
	movl	$2, %eax
	movl 	%eax, -32(%rbp)
	movl 	-28(%rbp), %eax
	cltd
	idivl 	-32(%rbp)
	movl 	%eax, -52(%rbp)
	movl 	-20(%rbp), %eax
	movl 	-52(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -56(%rbp)
	movl	-56(%rbp), %eax
	movl 	%eax, -24(%rbp)
	# =[] operation ; t4 = arr[mid]
	movl	-24(%rbp), %eax
	movslq	%eax, %rdx
	leaq	0(,%rdx,4), %rdx
	leaq	arr(%rip), %rax
	movl	(%rdx,%rax), %eax
	movl 	%eax, -60(%rbp)
	movl	-60(%rbp), %eax
	cmpl	-12(%rbp), %eax
	je .L67
	jmp .L68
	jmp .L68
.L67: 
	movl	-24(%rbp), %eax
jmp .LFE27
	jmp .L68
.L68: 
	# =[] operation ; t5 = arr[mid]
	movl	-24(%rbp), %eax
	movslq	%eax, %rdx
	leaq	0(,%rdx,4), %rdx
	leaq	arr(%rip), %rax
	movl	(%rdx,%rax), %eax
	movl 	%eax, -64(%rbp)
	movl	-64(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jg .L69
	jmp .L70
	jmp .L70
.L69: 
	movl	$1, %eax
	movl 	%eax, -68(%rbp)
	movl 	-24(%rbp), %eax
	movl 	-68(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -72(%rbp)
	movl 	-20(%rbp), %eax
	movq 	-20(%rbp), %rdi
movl 	-72(%rbp), %eax
	movq 	-72(%rbp), %rsi
movl 	-12(%rbp), %eax
	movq 	-12(%rbp), %rdx
	call	binarySearch
	movl	%eax, -76(%rbp)
	movl	-76(%rbp), %eax
jmp .LFE27
	jmp .L70
.L70: 
	movl	$1, %eax
	movl 	%eax, -80(%rbp)
	movl 	-24(%rbp), %eax
	movl 	-80(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -36(%rbp)
	movl 	-36(%rbp), %eax
	movq 	-36(%rbp), %rdi
movl 	-16(%rbp), %eax
	movq 	-16(%rbp), %rsi
movl 	-12(%rbp), %eax
	movq 	-12(%rbp), %rdx
	call	binarySearch
	movl	%eax, -40(%rbp)
	movl	-40(%rbp), %eax
jmp .LFE27
	jmp .L71
.L71: 
	movl	$1, %eax
	movl 	%eax, -44(%rbp)
	movl	-44(%rbp), %eax
	negl	%eax
	movl 	%eax, -48(%rbp)
	movl	-48(%rbp), %eax
jmp .LFE27
	.LFE27:
leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
	.size	binarySearch, .-binarySearch
	.globl	main
	.type	main, @function
main: 
.LFB28:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$204, %rsp

	movq 	$.LC0, -44(%rbp)
	movl 	-44(%rbp), %eax
	movq 	-44(%rbp), %rdi
	call	printStr
	movl	%eax, -48(%rbp)
	movq 	$.LC1, -88(%rbp)
	movl 	-88(%rbp), %eax
	movq 	-88(%rbp), %rdi
	call	printStr
	movl	%eax, -132(%rbp)
	movl 	-28(%rbp), %eax
	movq 	-28(%rbp), %rdi
	call	readInt
	movl	%eax, -176(%rbp)
	movl	-176(%rbp), %eax
	movl 	%eax, -36(%rbp)
	movq 	$.LC2, -180(%rbp)
	movl 	-180(%rbp), %eax
	movq 	-180(%rbp), %rdi
	call	printStr
	movl	%eax, -184(%rbp)
	movl	$0, %eax
	movl 	%eax, -188(%rbp)
	movl	-188(%rbp), %eax
	movl 	%eax, -32(%rbp)
.L74: 
	movl	-32(%rbp), %eax
	cmpl	-36(%rbp), %eax
	jl .L76
	jmp .L77
.L75: 
	movl	$1, %eax
	movl 	%eax, -192(%rbp)
	movl 	-32(%rbp), %eax
	movl 	-192(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -196(%rbp)
	movl	-196(%rbp), %eax
	movl 	%eax, -32(%rbp)
	jmp .L74
.L76: 
	movl 	-28(%rbp), %eax
	movq 	-28(%rbp), %rdi
	call	readInt
	movl	%eax, -52(%rbp)
	# []= operation ; arr[i] = t10
	movl	-52(%rbp), %eax
	movl	-32(%rbp), %edx
	movslq	%edx, %rdx
	leaq	0(,%rdx,4), %rcx
	leaq	arr(%rip), %rdx
	movl	%eax, (%rcx,%rdx)
	jmp .L75
.L77: 
	movq 	$.LC3, -56(%rbp)
	movl 	-56(%rbp), %eax
	movq 	-56(%rbp), %rdi
	call	printStr
	movl	%eax, -60(%rbp)
	movl 	-28(%rbp), %eax
	movq 	-28(%rbp), %rdi
	call	readInt
	movl	%eax, -64(%rbp)
	movl	-64(%rbp), %eax
	movl 	%eax, -200(%rbp)
	movl 	-36(%rbp), %eax
	movq 	-36(%rbp), %rdi
	call	bubbleSort
	movl	%eax, -64(%rbp)
	movq 	$.LC4, -68(%rbp)
	movl 	-68(%rbp), %eax
	movq 	-68(%rbp), %rdi
	call	printStr
	movl	%eax, -72(%rbp)
	movl	$0, %eax
	movl 	%eax, -76(%rbp)
	movl	-76(%rbp), %eax
	movl 	%eax, -32(%rbp)
.L78: 
	movl	-32(%rbp), %eax
	cmpl	-36(%rbp), %eax
	jl .L80
	jmp .L81
.L79: 
	movl	$1, %eax
	movl 	%eax, -80(%rbp)
	movl 	-32(%rbp), %eax
	movl 	-80(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -84(%rbp)
	movl	-84(%rbp), %eax
	movl 	%eax, -32(%rbp)
	jmp .L78
.L80: 
	# =[] operation ; t20 = arr[i]
	movl	-32(%rbp), %eax
	movslq	%eax, %rdx
	leaq	0(,%rdx,4), %rdx
	leaq	arr(%rip), %rax
	movl	(%rdx,%rax), %eax
	movl 	%eax, -92(%rbp)
	movl	-92(%rbp), %eax
	movl 	%eax, -24(%rbp)
	movl 	-24(%rbp), %eax
	movq 	-24(%rbp), %rdi
	call	printInt
	movl	%eax, -96(%rbp)
	movq 	$.LC5, -100(%rbp)
	movl 	-100(%rbp), %eax
	movq 	-100(%rbp), %rdi
	call	printStr
	movl	%eax, -104(%rbp)
	jmp .L79
.L81: 
	movq 	$.LC6, -108(%rbp)
	movl 	-108(%rbp), %eax
	movq 	-108(%rbp), %rdi
	call	printStr
	movl	%eax, -112(%rbp)
	movl	$0, %eax
	movl 	%eax, -116(%rbp)
	movl	$1, %eax
	movl 	%eax, -120(%rbp)
	movl 	-36(%rbp), %eax
	movl 	-120(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -124(%rbp)
	movl 	-116(%rbp), %eax
	movq 	-116(%rbp), %rdi
movl 	-124(%rbp), %eax
	movq 	-124(%rbp), %rsi
movl 	-200(%rbp), %eax
	movq 	-200(%rbp), %rdx
	call	binarySearch
	movl	%eax, -128(%rbp)
	movl	-128(%rbp), %eax
	movl 	%eax, -40(%rbp)
	movl	$1, %eax
	movl 	%eax, -136(%rbp)
	movl	-136(%rbp), %eax
	negl	%eax
	movl 	%eax, -140(%rbp)
	movl	-40(%rbp), %eax
	cmpl	-140(%rbp), %eax
	je .L82
	jmp .L83
	jmp .L84
.L82: 
	movq 	$.LC7, -144(%rbp)
	movl 	-144(%rbp), %eax
	movq 	-144(%rbp), %rdi
	call	printStr
	movl	%eax, -148(%rbp)
	jmp .L84
.L83: 
	movq 	$.LC8, -152(%rbp)
	movl 	-152(%rbp), %eax
	movq 	-152(%rbp), %rdi
	call	printStr
	movl	%eax, -156(%rbp)
	movl 	-40(%rbp), %eax
	movq 	-40(%rbp), %rdi
	call	printInt
	movl	%eax, -160(%rbp)
.L84: 
	movq 	$.LC9, -164(%rbp)
	movl 	-164(%rbp), %eax
	movq 	-164(%rbp), %rdi
	call	printStr
	movl	%eax, -168(%rbp)
	movl	$0, %eax
	movl 	%eax, -172(%rbp)
	movl	-172(%rbp), %eax
jmp .LFE28
	.LFE28:
leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
	.size	main, .-main
	.ident		"Compiled by 200101015"
	.section	.note.GNU-stack,"",@progbits
