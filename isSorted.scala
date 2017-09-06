def isSorted[A](ar: Array[A], gt: (A,A) => Boolean): Boolean = {
  @annotation.tailrec
  def go(n1: Int, n2: Int): Boolean = {
    val lower = gt(ar(n1), ar(n2))
    if(lower == false) false
    else if(n2 == ar.length - 1) true
    else go(n2, n2 + 1)
  }

  go(0,1)
}

def isLower(a: Int, b: Int): Boolean = {
  a < b
}

val arr = Array(1,2,3,4)
val s_arr = Array("aa","aa","aaa","aaaa")

val sorted = isSorted(arr,(a: Int, b: Int) => a < b)
println(sorted)

val str_sorted = isSorted(s_arr,(a: String, b: String) => a.length < b.length)
println(str_sorted)
