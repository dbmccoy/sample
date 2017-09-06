def partial[A,B,C](n: A, fn: (A,B) => C): B => C = {
  fn(n,_:B)
}
