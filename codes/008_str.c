#include <stdio.h>

int main() {
    char str[5] = "awsd";
    char c = 'a';
    char d = '\0';
    char e = '<';
    /* print string array */
    // for (int i = 0; i < 5; i++) {
    //     printf("%c\n", str[i]);
    // }

    /* test if the end of string array is '\0' */
    // if ('\0' == str[4]) {
    //     printf("==");
    // } else {
    //     printf("!=");
    // }

    /* test if '\0' can be compared */
    // if (c == '\0') {
    //     printf("%c == \\0", c);
    // } else {
    //     printf("%c != \\0", c);
    // }

    // if (d == '\0') {
    //     printf("%c == \\0", c);
    // } else {
    //     printf("%c != \\0", c);
    // }

    switch (e) {
        case '<': e = 'a'; break;
        default: break;
    }
    printf("%c", e);
    
    return 0;
}