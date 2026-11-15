.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue    
    bge x0, a1, exception  # if length of array <= 0
    # If length of array is no less than 1
    li t1, 0  # set i = 0

loop_start:
    lw t0, 0(a0)  # t0 = a[i]
    # If a[i] >= 0
    bge t0, x0, loop_continue
    # If a[i] < 0
    sw x0, 0(a0)  # store a[i] back to memory
    
loop_continue:
    addi a0, a0, 4  # address of next integer in the array
    addi t1, t1, 1  # i += 1
    blt t1, a1, loop_start  # i < n
    j loop_end
    
exception:
    li a0 36
    j exit

loop_end:
    # Epilogue
    jr ra
