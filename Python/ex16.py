from enum import Enum
import random

class PasswordType(Enum):
    weak = 'w'
    strong = 's'
    insane = 'i'

def main():
    while True:
        try:
            pwt = input('enter the desired password strength:\n [w]eak \n [s]trong \n [i]nsane \n>')
            print(pw_gen(PasswordType(pwt)))
            return
        except:
            print('invalid')

def pw_gen(pw_type):
    words = ('puppies','password','money')
    chars = ('abcdefghijklmnopqrstuvwxyz123456789')
    spec = '!@#$%^&*()[],.<>/?"'

    if pw_type == PasswordType.weak:
        return random.choice(words)
    if pw_type == PasswordType.strong:
        st = ''
        for i in range(0,10):
            st += chars[random.randint(0,len(chars))]
        return st
    if pw_type == PasswordType.insane:
        st = ''
        for i in range(0,20):
            chars2 = chars + spec
            next_char = chars2[random.randint(0,len(chars2))]
            if(random.randint(0,1) == 1): next_char = next_char.upper()
            st += next_char
        return st

if __name__ == '__main__' : main()
