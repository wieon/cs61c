#include <stdio.h>
#include <stdint.h>
int main(int argc, char *argv[]) {
    int32_t x = 0;
    int32_t y;  /* declared but not initialized */
    
    printf("before: x=%d, y=%d\n", x, y); /* y will print random number */
    x++;
    y += x;

    printf(" after: x=%d, y=%d\n", x, y);
    return 0;
}
