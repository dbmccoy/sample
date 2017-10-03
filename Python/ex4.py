
def GibNum():
    valid = False
    while valid == False:
        try:
            inp = int(input('input a number '))
            valid = True
        except:
            print('thats not a number')
    return inp

inp = GibNum()

l = []

for i in range(2,inp):
    if(inp % i == 0):
        l.append(i)

print(l)
