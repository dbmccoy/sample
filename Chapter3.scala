//EXERCISE 2: Implement the function tail for "removing" the first element tail
//of a . Notice the function takes constant time. What are different choices you List
//could make in your implementation if the is Nil ? We will return to this List Nil
//question in the next chapter.

def tail[A](l: List[A]): List[A] = l match {
  case Nil => sys.error("tail of empty list")
  case ::(_,t) => t
}

//EXERCISE 3: Generalize tail to the function drop, which removes the first
//n elements from a list

def drop[A](l: List[A], n: Int): List[A] = l match{
  case Nil => sys.error("the list is empty")
  case ::(l(n - 1),t) => t
}

//EXERCISE 4: Implement dropWhile, which removes elements from the
//List prefix as long as they match a predicate. Again, notice these functions take
//time proportional only to the number of elements being dropped—we do not need
//to make a copy of the entire List

def dropWhile[A](l: List[A])(f: A => Boolean): List[A] =
  l match{
    case (h :: t) if f(h) => dropWhile(t)(f)
    case _ => l
  }

//EXERCISE 5: Using the same idea, implement the function setHead for setHead
//replacing the first element of a List with a different value. List
//Data sharing often brings some more surprising efficiency gains. For instance,
//here is a function that adds all the elements of one list to the end of another:

def setHead[A](l: List[A],n: A): List[A] =
  l match{
    case Nil => sys.error("the list is empty")
    case (_ :: t) => n :: t
  }

//EXERCISE 6: Not everything works out so nicely. Implement a function,
//init, which returns a List consisting of all but the last element of a List.
// So, given List(1,2,3,4) init , will return List(1,2,3). Why can't this
//function be implemented in constant time like ?
import scala.collection.mutable.ListBuffer

def init[A](l: List[A]): List[A] = {
    var buffer = new ListBuffer[A]() //mutation not observable shhh is ok
    def go(n: Int): List[A] =
      if(buffer.length >= l.length - 1) buffer.toList
      else {buffer += l(n)
        go(n+1)}
    go(0)
  }

//Implement a random fill function

def fill(u: Int, i: Int): List[Int] = {
  @annotation.tailrec
  def go(n: Int, l: List[Int]): List[Int] = {
    if(n >= i ) l
    else(go(n+1,::(util.Random.nextInt(u),l)))
  }

  go(0,Nil)
}

foldRight[A,B](l: List[A], z: B)(f: (A,B) => B): B =
  l match {
    case Nil = => z
    case ::(x,xs) => f(x, foldRight(xs, z)(f))
  }

def sum2(l: List[Int]) =
  foldRight(l, 0.0)(_ + _)
