def str_reverse(s):
    li = s.split()
    l2 = []
    for i in range(0,len(li)):
        l2.append(li.pop())
    return l2
print(str_reverse('sometimes you eat the bear, and sometimes, it eats you'))
