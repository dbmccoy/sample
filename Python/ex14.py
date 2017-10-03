def set2(li):
    l = []
    for i in li:
        if i not in l:
            l.append(i)
    return l

print(set2([1,2,2,3,4]))
