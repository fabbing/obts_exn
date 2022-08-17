BEGIN {
  re = "^" fn ":"
}

$0 ~ re {
  print
  while ((getline n) > 0) {
    if (match(n, "^[ ]*$"))
      exit
    print n
  }
}
