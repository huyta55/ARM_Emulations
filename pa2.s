.section .data

input_x_prompt	:	.asciz	"Please enter x: "
input_y_prompt	:	.asciz	"Please enter y: "
input_spec	:	.asciz	"%d"
result		:	.asciz	"x^y = %d\n"

.section .text

.global main

main:

# add code and other labels here
	# Loading the x input prompt and printing it
	LDR x0, =input_x_prompt
	BL printf
	# Branching to get the x value
	BL get_xy_input
	# Moving the x value we got from x0 onto permanent register x19
	MOV x19, x0
	
	# Printing the get y input prompt
	LDR x0, =input_y_prompt
	BL printf
	# Branching to get the y value
	BL get_xy_input
	# Moving the y value from x0 onto permanent register x20
	MOV x20, x0
	
	# Calling the exponent function
	MOV x0, x19
	MOV x1, x20
	BL exponent
	
	# Moving the result of exponent into the right registers and loading the output prompt, then printing the result
	MOV x1, x2
	LDR x0, =result
	BL printf
	
	# Exiting the program
	B exit


# Function for calculating exponents recursively
exponent:
	
	# Check if y < 1, y is in x1
	SUBS x9, x1, xzr
	# if y > 1, go to exp
	B.GT exp
	# Check if y == 0
	CBZ x1, retOne
	# Else y < 0, so return 0
	B retZero
	
	
# Function to return zero in case y < 0
retZero:
	ADD x2, xzr, xzr
	RET
# Function to return one in case y = 0
retOne:
	# Since the return register is x2, put 1 in x2
	MOV x2, 1
	RET

# function for Exponent if y > 0
exp:
	# Check if y == 1, so then just return x, which is in x0
	subs x11, x1, 1
	B.EQ retx
	# Making stack frame b4 recursively calling exponent
	SUB sp, sp, 32
	STUR x0, [sp, 24]
	STUR x1, [sp, 16]
	STUR x29, [sp, 8]
	stur x30, [sp, 0]
	
	# Iterating -1 to make y = y - 1 for the next exponent call
	SUB x1, x1, 1
	
	BL exponent
	
	# Restoring stack frame to avoid overflow
	LDUR x0, [sp, 24]
	LDUR x1, [sp, 16]
	LDUR x29, [sp, 8]
	LDUR x30, [sp, 0]
	ADD sp, sp, 32
	
	# return from recursion is in x2, so use it to multiply x to it
	MUL x2, x2, x0
	RET
	
# Function for returning x in case y = 1
retx:
	MOV x2, x0
	RET
# Function for getting input
get_xy_input:
	# Making the stack frame
	SUB sp, sp, 8
	STR x30, [sp]
	# Loading the registers to accept user input
	LDR x0, =input_spec
	# Making space for scanf to use
	SUB sp, sp, 8
	MOV x1, sp
	BL scanf
	# Loading the values got from user input onto x0 and return
	LDRSW x0, [sp]
	LDR x30, [sp, 8]
	ADD sp, sp, 16
	RET
	
# branch to this label on program completion
exit:
	mov x0, 0
	mov x8, 93
	svc 0
	ret
