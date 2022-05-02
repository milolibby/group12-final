## here is an example of getting your name and print it out if it is Alphabet or not an alphabet, ## 	
LC0:
	.ascii "Enter a string (max length fifteen): \0"
LC1:
	.ascii "%c\0"
LC5:
  .ascii "\12 The smallest capital letter is %c \12\0"

LC6:
  .ascii "\12 There are no capital letters in the string \12\0"

	.globl	_main
	.def	_main;	.scl	2;	.type	32;	.endef

# max length of the string = 15
_main:

	pushl	%ebp
	movl	%esp, %ebp
	
	pushl	%ebx
	
	subl	$32, %esp
		
	movl	$LC0, (%esp)
	call	_printf  			# "Enter a string": 
	
	movl	$0, %ebx			# make array index i=0, array[i], I assume an array of 15 elements
	jmp		L2
L3:
	leal	8(%esp,%ebx), %eax
	movl	%eax, 4(%esp)
	movl	$LC1, (%esp)
	call	_scanf
	
	addl	$1, %ebx			# scan charachter by character
L2:
	cmpl	$14, %ebx			# I assume an array of 15 elements
	jle		L3

  movl $91, 28(%esp)                    # max will be stored on stack 28(%esp)
                                        # this will be initialized to 91 or in ascii "["
	
	
	movl	$0, %ebx			# initial value of array array[i], i=0
	jmp		L4            # jump to test of loop
L6:
	addl	$1, %ebx      # increment i 
L4:
	cmpl	$14, %ebx			# size of array 15
	jg		Done            # if i > 14 the loop is done

  # check to see if char is in alphabet
	movzbl	8(%esp,%ebx), %eax
  leal	-97(%eax), %edx   	# array[i]>= 97 && array[i]<= 122, 97 is "a" and 122 is "z" so if it is  "a" to "z"
	cmpb	$25, %dl			# -96 to 122 = 25
	
	setbe	%cl				  	# set 0 or 1
	
	leal	-65(%eax), %edx   	#array[i]>=65 && array[i]<=90, 65 is "A" and 90 is "Z" so if it is "A" to "Z"
	cmpb	$25, %dl			# -65 to 90 = 25
	
	setbe	%dl				  	# set 0 or 1
	
	orb		%dl, %cl			# (array[i]>= 97 && array[i]<= 122) || (array[i]>=65 && array[i]<=90)
	je		L6

  # checks to see if letter is capital
  leal	-65(%eax), %edx   	# array[i]>=65 && array[i]<=90, 65 is "A" and 90 is "Z" so if it is "A" to "Z"
	cmpb	$25, %dl			# -65 to 90 = 25

  jg L6 # char is not a capital letter, next iteration in loop

	movl 28(%esp), %edx # current smallest capital
	movsbl	%al, %ecx			# %al is input charachter

  cmp %edx, %ecx  # compares current letter with smallest capital letter stored
  jge L6  # if the current letter is greater jump to next iteration of loop

  
  movl %ecx, %edx # if current letter if less than stored smallest, store current as the new smallest
  movl %edx, 28(%esp)  # store the letter as new smallest in the 28+(%esp)

	jmp		L6

Done:
  movl 28(%esp), %edx
  # first check to see that there were any capitals (if 28+(%esp) still is 91)
  cmp $91, %edx
  jne OUTPUT

  movl $LC6, (%esp)  # "There are no capital letters in the string"
  call _puts



OUTPUT:
  movl 28(%esp), %edx  # move the smallest capital to the edx
  cmp $91, %edx       # if the smallest capital is still "["  (there are no capital letters in string)
  je END               # jump to end of program

  movl %edx, 4(%esp)
  movl $LC5, (%esp)  # outputs the smallest capital number
  call _printf

END:
	movl	$0, %eax
	
	andl	$32, %esp
	
	leave
	ret
