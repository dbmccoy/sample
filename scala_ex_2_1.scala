/*EXERCISE 1 (optional): Write a function to get the nth Fibonacci number. The
first two Fibonacci numbers are 0 and 1, and the next number is always the sum of
the previous two. Your definition should use a local tail-recursive function.*/

def fib(n: Int): Int = {
    if(n==1) 0
    if(n==2) 1
    def go(i: Int, f1: Int, f2: Int) = {
        if(i == n) f1 + f2
        else go(i+1,f2,f1+f2)
    }
    go(3,0,1)
}

println(fib(9))
