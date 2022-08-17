#include <stdio.h>

void say_hello()
{
  puts("Hello, bye");
}

void do_asm()
{
  __asm__(
      "subq $16, %rsp\n"
      "movq $43, (%rsp)\n"
      "movq $42, 8(%rsp)\n"
      "pushq $44\n"
      "popq %rax\n"
      "call say_hello\n"
      "add $16, %rsp\n"
  );
}


int main()
{
  do_asm();
  return 0;
}
