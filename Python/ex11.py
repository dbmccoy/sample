play = True
while play == True:
    n = int(input('enter a number> '))
    try:
        prime = False
        for i in range(2,n):
            if(n % i == 0):
                prime = True
                break
        print(prime)
    except:
        break
