#include <stdio.h>
#include <stdint.h>

int main () {
  uint32_t arr[] = {50, 60, 70}; // 32-bit unsigned array
  uint32_t *q = arr;

  printf("    *q: %d is %d\n", *q, q[0]);
  printf("*(q+1): %d is %d\n", *(q+1), q[1]);
  printf("*(q-1): %d is %d\n", *(q-1), q[-1]);
}
