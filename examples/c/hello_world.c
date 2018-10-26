#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void println(const char * val);

int main(void) {
    println("こんにちは 世界");
}

void println(const char * val) {
    printf("%s\n", val);
}
