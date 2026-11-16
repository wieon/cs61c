.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    # Prologue
    # if the number of elements to use is less than 1
    bge x0, a2, exception_36  # 0 >= a2
    
    # if the stride of either array is less than 1
    bge x0, a3, exception_37  # 0 >= a3, namely the stride of arr0 <= 0
    bge x0, a4, exception_37  # 0 >= a4, namely the stride of arr0 <= 0
    
    # initialize registers
    li t2, 0  # i, count the number of iteration
    li t3, 0  # store the multiplying result of two elements
    li t4, 0  # sum of dot
    li t5, 0  # store the stride of bytes of arr0
    li t6, 0  # store the stride of bytes of arr1
    slli t5, a3, 2  # a3 * 4
    slli t6, a4, 2  # a4 * 4
    
loop_start:
    # load numbers to registers
    lw t0, 0(a0)  # load a[i]
    lw t1, 0(a1)  # load b[j]

    # multiply numbers and add to the sum
    mul t3, t0, t1  # a[i] * b[j]
    add t4, t4, t3  # sum += ( a[i] * b[j] )

    # update i
    addi t2, t2, 1  # i += 1
    
    # update the pointers to the arr0 and arr1
    add a0, a0, t5  # sp0 += ( a3 * 4 )
    add a1, a1, t6  # sp1 += ( a4 * 4 )

    # iterate only when both arrays are not out-of-bound
    bge t2, a2, loop_end  # end when i >= n
    j loop_start  # continue iterating

exception_36:
    # the function terminates the program with error code 36
    li a0, 36
    j exit
    
exception_37:
    # the function terminates the program with error code 37
    li a0, 37
    j exit

loop_end:
    # return the dot product of the two arrays
    add a0, t4, x0

    # Epilogue
    jr ra
