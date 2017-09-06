def curry[A](f: (A,A) => A): A => (A => A) = {
  def cur(a: A): A => A = {
    (b: A) => f(a,b)
  }

  cur
}

def add(a: Int, b: Int) = a + b
def multiply(a: Int, b: Int) = a * b

val addCurried = curry(add)
val multiplyCurried = curry(multiply)

def curry[A,B,C](f: (A,B) => C): A => (B => C) = {
  a => (b => f(a,b))
}

def uncurry[A,B,C](f: A => (B => C)): (A,B) => C = {
  (a, b) => f(a)(b)
}

def StringLenComp(a: Int, b: String): Boolean = {
  b.length < a
}

val LenUnderInt = curry(StringLenComp)
