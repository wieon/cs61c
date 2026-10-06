.globl factorial

.data
n: .word 8

.text
# Don't worry about understanding the code in main
# You'll learn more about function calls in lecture soon
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

# factorial takes one argument:
# a0 contains the number which we want to compute the factorial of
# The return value should be stored in a0
factorial:
    # YOUR CODE HERE
    # Initialization
    addi t1 t1 1 # t1 stores result of fatorial
    addi t2 t2 1 # t2 stores i, which counts iterative times
    beq a0 x0 exit

loop:
    addi t3 x0 1 # j = 1
    mv t4 t1 # store result of previous loops to be added this loop
     
iter:
    add t1 t1 t4 # result += fac(i-1)
    addi t3 t3 1 # j++
    bge t2 t3 iter # goto iter when j == i
    
    addi t2 t2 1 # i++
    blt t2 a0 loop

exit:
    mv a0 t1 # store the result in a0

    # This is how you return from a function. You'll learn more about this later.
    # This should be the last line in your program.
    jr ra
