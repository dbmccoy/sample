class main(object):
    def __init__(self):
        def get_num():
            while True:
                try:
                    num = int(input("how many fibonnacis? "))
                    return num
                except:
                    print('put in a number, wise guy')
        fib(get_num())


def fib(num):
    l = []
    for i in range(0, num):
        if i <= 1:
            l.append(1)
            print(1)
        else:
            x = l[len(l) - 1] + l[len(l) - 2]
            l.append(x)
            print(x)



if __name__ == '__main__':
    main()
