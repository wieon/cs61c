.globl f # this allows other files to find the function f

# f takes in two arguments:
# a0 is the value we want to evaluate f at
# a1 is the address of the "output" array (read the lab spec for more information).
# The return value should be stored in a0
f:
    # Your code here    
    addi t0 a0 0
    addi t1 a1 0
    
    # Compute the offset and address
    addi t2 t0 3
    slli t2 t2 2 
    add t2 t2 t1 # get the address we wish to read
    
    lw t3 0(t2) # read the element
    mv a0 t3 # store the return value in a0

    # This is how you return from a function. You'll learn more about this later.
    # This should be the last line in your program.
    jr ra
