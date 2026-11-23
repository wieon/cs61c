.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    #  Exam the number of command line arguments
    li t0, 5
    bne a0, t0, exception_31  # the number of arguemnts != 5
    
    # Prologue
    addi sp, sp, -52
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp) 
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    sw s11, 48(sp)
    mv s0, a1  # argv
    mv s1, a2
    ebreak
    # Read pretrained m0
    li a0, 8
    jal malloc
    beq a0, x0, exception_26
    mv s2, a0  # store pointer to number of rows and columns of m0
    addi a1, s2, 0  # a pointer to memory where contains the number of rows
    addi a2, s2, 4  # a pointer to memory where contains the number of columns
    lw a0, 4(s0)  # pointer to the filepath string of m0
    jal read_matrix
    mv s3, a0  # pointer to the matrix m0 in memory
    ebreak

    # Read pretrained m1
    li a0, 8
    jal malloc
    beq a0, x0, exception_26
    mv s4, a0  # store pointer to number of rows and columns of m1
    addi a1, s4, 0  # a pointer to memory where contains the number of rows
    addi a2, s4, 4  # a pointer to memory where contains the number of columns
    lw a0, 8(s0)  # pointer to the filepath string of m1
    jal read_matrix
    mv s5, a0  # pointer to the matrix m1 in memory
    
    # Read input matrix
    li a0, 8
    jal malloc
    beq a0, x0, exception_26
    mv s6, a0  # store pointer to number of rows and columns of input
    addi a1, s6, 0  # a pointer to memory where contains the number of rows
    addi a2, s6, 4  # a pointer to memory where contains the number of columns
    lw a0, 12(s0)  # pointer to the filepath string of input
    jal read_matrix
    mv s7, a0  # pointer to the matrix input in memory
    
    # Allocate memory for h
    lw t0, 0(s2)  # number of rows of m0
    lw t1, 4(s6)  # number of columns of input
    mul a0, t0, t1  # size of h
    mv s8, a0  # store size of h
    slli a0, a0, 2  # bytes of h to allocate in memory
    jal malloc
    beq a0, x0, exception_26  # if malloc returns an error
    mv s9, a0  # pointer to h in memory

    # Compute h = matmul(m0, input)
    mv a0, s3  # pointer to m0
    lw a1, 0(s2)  # number of rows of m0
    lw a2, 4(s2)  # number of cols of m0
    mv a3, s7  # pointer to input
    lw a4, 0(s6)  # number of rows of input
    lw a5, 4(s6)  # number of cols of input
    mv a6, s9  # pointer to h
    jal matmul
    # Compute h = relu(h)
    mv a0, s9  # pointer to h
    mv a1, s8  # size of h
    jal relu
    
    # Allocate memory for o
    lw t0, 0(s4)  # number of rows of m1
    lw t1, 4(s6)  # number of cols of input
    mul a0, t0, t1  # size of o
    slli a0, a0, 2  # bytes of o to allocate in memory
    jal malloc
    beq a0, x0, exception_26  # if malloc returns an error
    mv s10, a0  # pointer to o in memory

    # Compute o = matmul(m1, h)
    mv a0, s5  # pointer to m1
    lw a1, 0(s4)  # number of rows of m1
    lw a2, 4(s4)  # number of cols of m1
    mv a3, s7  # pointer to input
    lw a4, 0(s6)  # number of rows of input
    lw a5, 4(s6)  # number of cols of input
    mv a6, s10  # pointer to o
    jal matmul

    # Write output matrix o
    lw a0, 16(s0)  # pointer to output file
    mv a1, s10  # pointer to o in memory
    lw a2, 0(s4)  # number of rows of o
    lw a3, 4(s6)  # number of cols of o
    jal write_matrix
    
    # Compute and return argmax(o)
    mv a0, s10  # pointer to o
    lw t0, 0(s4)  # number of rows of o
    lw t1, 4(s6)  # number of cols of o
    mul a1, t0, t1  # compute the size of o
    jal argmax
    mv s11, a0  # store the index of the largest element
    
    bne s1, x0, continue  # if the print argument != 0
    
    # If enabled (the print argument == 0), print argmax(o) and newline
    mv a0, s11  # the integer to print
    jal print_int
    li a0 '\n'  # the character to print
    jal print_char
 
continue:
    # Frees heap memory
    mv a0, s2
    jal free
    mv a0, s3
    jal free
    mv a0, s4
    jal free
    mv a0, s5
    jal free
    mv a0, s6
    jal free
    mv a0, s7
    jal free
    mv a0, s9
    jal free
    mv a0, s10
    jal free
    
    # Return argmax(o)
    mv a0, s11    
    
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp) 
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    lw s11, 48(sp)
    addi sp, sp, 52
    
    jr ra

exception_26:
    # malloc returns an error
    li a0, 26
    j exit

exception_31:
    # an incorrect number of command line arguments
    li a0, 31
    j exit