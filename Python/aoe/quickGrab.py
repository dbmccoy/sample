import pyscreenshot as ImageGrab
import os
import time

"""
box coordinates assume app opened in windowed mode and pinned to right half
of screen using win+right
"""

def screen_grab():
    box = (959,175,1919,893)
    im = ImageGrab.grab(box)
    im.save(os.getcwd() + '\\full_snap__' + str(int(time.time())) + '.png', 'PNG')

def main():
    screen_grab()

if __name__ == '__main__':
    main()
