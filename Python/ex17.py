#http://www.practicepython.org/exercise/2014/06/06/17-decode-a-web-page.html

import requests
from bs4 import BeautifulSoup

url = 'http://nytimes.com'
r = requests.get(url)
r_html = r.text

soup = BeautifulSoup(r_html, 'html.parser')

#<h2 class="story-heading">

for head in soup.find_all('h2', {'class': 'story-heading'}):
    if head.string is not None:
        print(head.string.strip())
