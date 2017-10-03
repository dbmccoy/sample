def head_tail(li):
    x = len(li) - 1
    if(x == 0):
        return [li[0]]
    else:
        return [li[0], li[len(li)-1]]

l = [1,2,3,4]
print(head_tail(l))

l2 = [1]
print(head_tail(l2))
