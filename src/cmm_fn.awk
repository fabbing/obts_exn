BEGIN {
  re = "\\(function{[^}]*} " fn
}

FS=""

$0 ~ re {
  do {
    print
    for (i=1; i<=NF; i++) {
      if ($i == "(") {
        p_open++
      }
      else if ($i == ")") {
        p_close++
      }
    }
    getline
  }
  while (p_close < p_open)
}
