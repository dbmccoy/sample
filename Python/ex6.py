#this is a dumb solution do this instead

#name = input("Enter a string ")
#name_reversed = name[::-1]

#if name == name_reversed:
#    print ("A palindrome string")
#else:
#    print ("Not a palindrom string")

def GibStr():
    try:
        s = str(input('input a string: '))
    except:
        print('not a str')
        GibStr()
    return s

s = GibStr()

val = True

for i in range(0,len(s)):
    if(s[i] == s[len(s)-1-i]):
        continue
    else:
        val = False

print(val)
