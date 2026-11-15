.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    bge x0, a1 exception  # if length of array <= 0
    li t0, 0  # i = 0
    lw t1, 0(a0)  # t1 stores the maximum number
    addi t2, t0, 0  # t2 stores the index of the max number
    addi t0, t0, 1  # i = 1
    beq a1, t0, loop_end  # if a1 = 1
    addi a0, a0, 4  # a0 points to a[1]

loop_start:
    lw t3, 0(a0)
    bge t1, t3, loop_continue  # if current_max_number >= a[i]
    # else current_max_number < a[i]
    mv t1, t3  # copy t3 to t1, update the max number
    mv t2, t0  # copy a0 to t2, update the address of the max number

loop_continue:
    addi a0, a0, 4  # a0 points to the next number in the array
    addi t0, t0, 1  # i += 1
    blt t0, a1, loop_start  # i < n
    j loop_end

exception:
    li a0, 36
    j exit

loop_end:
    mv a0, t2  # return the index of the max number
    # Epilogue
    jr ra
