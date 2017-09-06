def compose[A,B,C](f: B => C, g: A => B): A => C = {
  a => f(g(a))
}

def isInt[B](n: B): Boolean = n.getClass.getSimpleName match{
  case "Integer" => true
  case _ => false
}

def strLen(s: String): Int = s.length

compose(isInt(4),strLen("hi"))

def ex[A,B](f: A => B): A => B = {
  a => f(a)
}

def printType[A](n: A) = {
  println(n.getClass.getSimpleName)
}
