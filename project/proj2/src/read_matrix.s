.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -28
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    mv s0, a0
    mv s1, a1
    mv s2, a2
    
    # Open the file with permission
    mv a0, s0  # a pointer to the filename string
    li a1, 0  # permission bits, 0 for read-only
    jal fopen
    mv s3, a0  # store file descriptor in s3
    li t0, -1
    beq s3, t0, exception_27  # If opening the file failed, file descriptor value is -1.

    # Read the number of rows from the file
    mv a0, s3  # move file descriptor to a0
    mv a1, s1  # A pointer to the buffer which will contain the number of rows.
    li a2, 4  # The number of bytes to read from the file
    jal fread
    li t0, 4
    bne a0, t0, exception_29  # fread does not read the correct number of bytes
    
    # Read the number of columns from the file
    mv a0, s3  # move file descriptor to a0
    mv a1, s2  # A pointer to the buffer which will contain the number of columns.
    li a2, 4  # The number of bytes to read from the file
    jal fread
    li t0, 4
    bne a0, t0, exception_29  # fread does not read the correct number of bytes

    # Allocate space on the heap to store the matrix
    lw t0, 0(s1)  # read the number of rows from memory
    lw t1, 0(s2)  # read the number of columns from memory
    mul t2, t0, t1  # number of rows * number of columns
    slli t2, t2, 2  # The size of the memory that we want to allocate (in bytes)
    mv s4, t2  # store the size of allocated memory in s4
    mv a0, s4  # argument of malloc
    jal malloc
    mv s5, a0  # store the pointer to the allocated memory in s4
    beq a0, x0, exception_26  # malloc returns an error
    
    # Read the matrix from the file to the memory allocated
    mv a0, s3  # move file descriptor to a0
    mv a1, s5  # the pointer to the allocated memory
    mv a2, s4 # the number of bytes to read from the file
    jal fread
    bne a0, s4, exception_29  # fread does not read the correct number of bytes
    
    # Close the file
    mv a0, s3  # move file descriptor to a0
    jal fclose
    li t0, -1
    beq a0, t0, exception_28  # fclose returns an error
    
    # Return a pointer to the matrix in memory
    mv a0, s5

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 28

    jr ra

exception_26:
    # malloc returns an error
    li a0, 26
    j exit

exception_27:
    # fopen returns an error
    li a0, 27
    j exit

exception_28:
    # fclose returns an error
    li a0, 28
    j exit
    
exception_29:
    # fread does not read the correct number of bytes
    li a0, 29
    j exit