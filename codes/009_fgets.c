#include <stdio.h>

int main() {
    char a[10] = {'#', '#','#', '#','#', '#','#', '#','#', '#',};
    fgets(a, 6, stdin);  // read from keyboard input
    printf("%s", a);  // print out as string
}