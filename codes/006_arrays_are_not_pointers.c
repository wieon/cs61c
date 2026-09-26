#include <stdio.h>
#include <stdint.h>

int main() {
	int *p, *q, x;
	int a[4];
	p = &x;
	q = a + 1;

	*p = 1;
	printf("*p:%d, p:%x, &p:%x\n", *p, p, &p);

	*q = 2;
	printf("*q:%d, q:%x, &q:%x\n", *q, q, &q);

	*a = 3;
	printf("*a:%d, a:%x, &a:%x\n", *a, a, &a);
}
