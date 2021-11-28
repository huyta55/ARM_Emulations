.section .data
userInput       :   .space 7

input_prompt    :   .asciz  "Input a string: "
input_spec      :   .asciz  "%[^\n]"
length_spec     :   .asciz  "String length: %d\n"
palindrome_spec :   .asciz  "String is a palindrome (T/F): %c\n"

.section .text

.global main

# program execution begins here
main:

# add code and other labels here
    # loading the input prompt and printing it
    LDR x0, =input_prompt
    BL printf
    # loading the registers for the user input and then linking to scanf
    LDR x0, =input_spec
    LDR x1, =userInput
    BL scanf
    # looping through the userInput and determining the length of the string
    # x19 = userInput temp; x20 = i; x22 = wordLength;
    LDR x19, = userInput
    ADD x20, xzr, xzr 

    ADD x22, xzr,xzr 
    B lengthLoop
lengthLoop:
# creating the loop to check the length of the string inputted by the user
    # Loading the byte of whatever char the loop is on
    LDRB w15, [x19, x20]
    ADD x13, xzr, xzr
    SUB x14, x15, x13
    CBNZ x14, increment
    ADD x20, x20, 1
    MOV x11, 7
    # x12 = 7 - i
    SUB x12, x11, x20
    # x13 = 0 to check whether it's a nonzero character
    CBZ x12, printLength
    B lengthLoop

increment:
    ADD x22, x22, 1
    ADD x20, x20, 1
    MOV x11, 7
    # x12 = 7 - i
    SUB x12, x11, x20
    # x13 = 0 to check whether it's a nonzero character
    CBZ x12, printLength
    B lengthLoop

printLength: 
    LDR x0, =length_spec
    MOV x1, x22
    BL printf
    
    LDR x0, =input_spec
    LDR x1, =userInput
    BL scanf
    B checkPalindrome
# branch to this label on program completion

checkPalindrome:
    # check if the length is 0 or 1, if so then it is a palindrome
    ADD x10, xzr, x22
    CBZ x10, isPalindrome
    MOV x11, 1
    SUB x12, x11, x22
    CBZ x12, isPalindrome
    # else, check the actual string of characters
    ADD x20, xzr, xzr
    B palindromeLoop

palindromeLoop:
    # check whether the charAt(i) and charAt(length - i - 1) is the same
    LDRB w10, [x19, x20]
    SUB x13, x22, x20
    SUB x13, x13, 1
    LDRB w11, [x19, x13]
    SUB x14, x10, x11
    CBNZ x14, notPalindrome
    # iterates the loop and give break condition
    ADD x20, x20, 1
    SUB x9, x22, x20
    CBZ x9, isPalindrome
    # else goes to next iteration of loop
    b palindromeLoop

isPalindrome:
    LDR x0, =palindrome_spec
    MOV w1, 84
    BL printf
    B exit
notPalindrome:
    LDR x0, =palindrome_spec
    MOV w1, 70
    BL printf
    B exit
exit:

    mov x0, 0
    mov x8, 93
    svc 0
    ret
    