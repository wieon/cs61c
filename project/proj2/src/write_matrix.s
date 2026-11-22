.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

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
    mv s3, a3
    
    # Open the file with write permissions
    mv a0, s0  # a pointer to the filename string
    li a1, 1  # permission bits, 1 for write-only.
    jal fopen
    mv s4, a0  # save file descriptor to s4
    li t0, -1
    beq a0, t0, exception_27  # if opening the file failed
    
    # Allocates heap memory
    li a0, 8  # the size of the memory to allocate in bytes
    jal malloc
    mv s5, a0  # save the pointer to the allocated memory to s5
    sw s2, 0(s5)  # save the number of rows in the matrix to memory
    sw s3, 4(s5)  # save the number of columns in the matrix to memory
    
    # Write the number of rows and columns to the file
    mv a0, s4  # file descriptor
    mv a1, s5  # pointer to the allocated memory containing the number of rows and columns
    li a2, 2  # the number of elements to write to the file
    li a3, 4  # the size of each element
    jal fwrite
    li t0, 2
    bne a0, t0, exception_30  # if fwrite does not write the correct number of elements
    
    # Write the data to the file
    mv a0, s4  # file descriptor
    mv a1, s1  # a pointer to the matrix in memory
    mul a2, s2, s3  # the number of elements to write to the file
    li a3, 4  # the size of each element
    jal fwrite
    mul t0, s2, s3
    bne a0, t0, exception_30 # if fwrite does not write the correct number of elements

    # Close the file
    mv a0, s4  # file descriptor
    jal fclose
    li t0, -1
    beq a0, t0, exception_28

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

exception_27:
    # fopen returns an error
    li a0, 27
    j exit
    
exception_28:
    # fclose returns an error
    li a0, 28
    j exit
    
exception_30:
    # fwrite does not write the correct number of bytes
    li a0, 30
    j exit