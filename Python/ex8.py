playing = True

p1_score = 0
p2_score = 0

while playing == True:

    p1 = input('player 1, what is your move> ')
    p2 = input('player 2, what is your move> ')

    if(p1 == 'rock'):
        if(p2 == 'rock'):
            print('tie')
        if(p2 == 'scissors'):
            print('player 1 wins')
            p1_score += 1
            print(p1_score)
        if(p2 == 'paper'):
            print('player 2 wins')
            p2_score += 1
            print(p2_score)
    if(p1 == 'paper'):
        if(p2 == 'paper'):
            print('tie')
        if(p2 == 'rock'):
            print('player 1 wins')
            p1_score += 1
            print(p1_score)
        if(p2 == 'scissors'):
            print('player 2 wins')
            p2_score += 1
            print(p2_score)
    if(p1 == 'scissors'):
        if(p2 == 'scissors'):
            print('tie')
        if(p2 == 'paper'):
            print('player 1 wins')
            p1_score += 1
            print(p1_score)
        if(p2 == 'rock'):
            print('player 2 wins')
            p2_score += 1
            print(p2_score)
    if(input('keep playing? y/n> ') == 'n'):
        break
