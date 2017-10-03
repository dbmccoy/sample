

def main():
    print('main')
    a = Account()

class Account():
    def __init__(self):
        print('account')

class CheckingAccount(Account):
    pass

if __name__ == "__main__": main()
