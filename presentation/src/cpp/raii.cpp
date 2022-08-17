#include <iostream>
#include <stdexcept>
#include <stdio.h>

class LousyString
{
public:
  LousyString(const char* msg, int i) {
    str_ = new char[42];
    snprintf(str_, 42, "%s #%d", msg, i);
  }

  ~LousyString() {
    std::cout << "Dtor of " << str_ << std::endl;
    delete [] str_;
  }

private:
  char* str_ = nullptr; // Don't, just use a std::string
};

void recursive(int i)
{
  LousyString hello("Hello", i);
  LousyString world("World", i);

  if (i == 0)
    throw std::runtime_error("Terrible way to end a recursion");
  else
    recursive(i - 1);
}

int main()
{
  try {
    recursive(2);
  } catch (...) {};
}
