## here is an example of getting your name and print it out if it is Alphabet or not an alphabet, ## 	
LC0:
	.ascii "Enter your name: \0"
LC1:
	.ascii "%c\0"
LC5:
  .ascii "\12The smallest capital letter is %c \12\0"

	.globl	_main
	.def	_main;	.scl	2;	.type	32;	.endef

_main:

	pushl	%ebp
	movl	%esp, %ebp
	
	pushl	%ebx
	
	subl	$32, %esp
		
	movl	$LC0, (%esp)
	call	_printf  			# Enter your name: 
	
	movl	$0, %ebx			# make array index i=0, array[i], I assume an array of 5 elements
	jmp		L2
L3:
	leal	8(%esp,%ebx), %eax
	movl	%eax, 4(%esp)
	movl	$LC1, (%esp)
	call	_scanf
	
	addl	$1, %ebx			# scan charachter by character
L2:
	cmpl	$6, %ebx			# I assume an array of 7 elements
	jle		L3

  movl $91, 28(%esp)                    # max will be stored on stack 28(%esp)
	
	
	movl	$0, %ebx			# initial value of array array[i], i=0
	jmp		L4
L6:
	addl	$1, %ebx
L4:
	cmpl	$6, %ebx			# size of array
	jg		Done
	movzbl	8(%esp,%ebx), %eax

	leal	-65(%eax), %edx   	# array[i]>=65 && array[i]<=90, 65 is "A" and 90 is "Z" so if it is "A" to "Z"
	cmpb	$25, %dl			# -65 to 90 = 25

  jg L6 # char is not a capital letter, next iteration in loop

	movl 28(%esp), %edx # current smallest capital
	movsbl	%al, %ecx			# %al is input charachter

  cmp %edx, %ecx  # compares current letter with smallest capital letter stored
  jge L6  

  
  movl %ecx, %edx # if current letter if less than stored smallest, store current as the new smallest
  movl %edx, 28(%esp)  # store the letter as new smallest in the 28+(%esp)

	jmp		L6

Done:
  movl 28(%esp), %edx
  movl %edx, 4(%esp)
  movl $LC5, (%esp)  # outputs the smallest capital number
  call _printf
	movl	$0, %eax
	
	andl	$32, %esp
	
	leave
	ret
