import requests
from bs4 import BeautifulSoup

def main(): 
    url = 'http://lvbridge.lv/files/OT2019/Saldus2019/1s.htm'
    req= requests.get(url)
    sc = req.status_code
    print('Status was {}'.format(sc))

    with open('2019-07-26_3.posms_2019_Saldus.html', 'r') as file:
        txt = file.read()
    
#    if (sc == 200):
#        txt = req.text
#    else: 
#        with open('2019-07-26_3.posms_2019_Saldus.html', 'r') as file:
#            txt = file.read()
    
    soup =  BeautifulSoup(txt, 'lxml')
    titleContent = (soup.title.contents)[0]
    title = " ".join(titleContent.split())
    
    len(list(soup.children))
    c1 = list(soup.children)[0]
    # Get the 1st PRE element
    aa = soup.findAll('pre')[0]
    # Get the 1st A-child
    aa = aa.findChildren("a")[0]
    word = aa.decode_contents()

    text_file = open('plaintext-file.txt', 'w')
    text_file.write('# {}\n'.format(title))
    text_file.write(word)
    text_file.close()

if __name__ == '__main__':
    main()