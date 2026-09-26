#include <stdio.h>
#include <stdint.h>

// void mystery(short arr[], int len) {
//     printf("%d ", len);
//     printf("%d\n", sizeof(arr));  // 会报错
// }

int main() {
    short nums[] = {1, 2, 3, 99, 100};
    printf("%d ", sizeof(nums));
    printf("%d ", sizeof(short));
    int length = sizeof(nums) / sizeof(short);
    printf("%d ", length);

    /* 编译器无法提前确定数组作为形参时的大小，
     * 所以长度需要提前算好作为参数传入。
     * 数组名会退化为指针，长度为 8 。*/
//    mystery(nums, sizeof(nums)/sizeof(short)) 
//    mystery(nums, length);

    return 0;
}
