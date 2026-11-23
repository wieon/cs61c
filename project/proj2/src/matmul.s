.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Error checks
    # The height or width of either matrix is less than 1
    bge x0, a1, exception  # if height of A <= 0
    bge x0, a2, exception  # if width of A <= 0
    bge x0, a4, exception  # if height of B <= 0
    bge x0, a5, exception  # if width of B <= 0
    
    # The width of A does not match the height of B
    bne a2, a4, exception

    # Prologue
    # When calls dot, register a0-a6 will turn to garbage, so we need to save them to s0-s6 at first.
    addi sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6
    
    # Initialize
    li t0, 0  # i = 0, stride of outer loop
    
outer_loop_start:
    li t1, 0  # j = 0, stride of inner loop, reset j
    
inner_loop_start:
   # Save arguments of dot in registers
    mv a0, s0  # a0 (int*) is the pointer to the start of A
    li t2, 4
    mul t2, t2, t1  # offset of B
    add a1, s3, t2  # a1 (int*) is the pointer to the start of B
    mv a2, s2  # a2 (int) is the number of elements to use
    li a3, 1  # a3 (int) is the stride of A
    mv a4, s5  # a4 (int) is the stride of B
    
    # Prologue ( when matmul serves as caller )
    # Save important non-preserved registers
    # Save t0-t1 before calling dot function, or they will contain garbage when dot returns
    addi sp, sp, -8
    sw t0, 0(sp)
    sw t1, 4(sp)
    
    # Call dot function
    jal dot
    
    # Save the dot product of A and B to C
    sw a0, 0(s6)
    addi s6, s6, 4  # update the pointer to C
    
    # Epilogue ( when matmul serves as caller )
    # Restore saved non-preserved registers
    lw t0, 0(sp)
    lw t1, 4(sp)
    addi sp, sp, 8

    # Update j and judge the condition for next loop
    addi t1, t1, 1  # j++
    blt t1, s5, inner_loop_start  # when j < k ( width of B )
    
inner_loop_end:
    addi t0, t0, 1  # i++
    bge t0, s1, outer_loop_end  # when i >= n ( height of A )
    li t2, 4
    #mul t2, t2, t0  # i * m ( width of A )
    mul t2, t2, s2 # offset of A
    add s0, s0, t2  # point to the next row of A
    j outer_loop_start  # start the next outer loop
    
outer_loop_end:
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    addi sp, sp, 32

    jr ra

exception:
    addi a0, x0, 38  # return code 38
    j exit