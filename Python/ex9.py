import random

playing = True
play_counts = 0
while playing == True:
    n = random.randint(1,9)

    isInt = False

    print('let\'s play a a game')
    print('type "exit" to quit')

    while isInt == False:
        try:
            i = float(input('enter a number> '))
        except:
            if(i == 'exit'):
                break
        isInt = True

    if(i == n):
        print('wow u got it')
    elif(i < n):
        print('too low')
    else:
        print('too high')
    play_counts += 1

print('you played ' + play_counts + ' times')
