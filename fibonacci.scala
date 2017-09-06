def fib(n: Int): Int = {
  def go(n1: Int, n2: Int): Int =
    if(n1 == n) n1 + n2
    else go(n1+1,n2 + n1)

  if(n == 0) 0
  else if (n == 1) 1

  go(2,1)
}

println(fib(2))
