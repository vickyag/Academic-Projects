import urllib.request
import bs4 as bs
import re
import MySQLdb

conn = MySQLdb.connect(host="localhost", user="root", passwd="", db="ontop2db")

page_num = 1
while page_num < 11:
    url = "http://www.thehindu.com/news/national/?page="+str(page_num)+""
    print("Getting data from url =", url)
    html_doc = urllib.request.urlopen(url)
    soup = bs.BeautifulSoup(html_doc, 'html.parser')
    page_num = page_num + 1
    count = 1
    for temp in soup.find_all('div', class_='Other-StoryCard'):
        link = temp.h3.a.get('href')
        article_doc = html_doc = urllib.request.urlopen(link)
        article = bs.BeautifulSoup(article_doc, 'html.parser')
        all_content = article.find('div', attrs={"id": "content-body-14269002-"+link[-12:-4]+""})
        if(all_content == None):
            continue
        all_content = all_content.find_all('p')
        content = ""
        for para in all_content:
            content = content + para.text.strip()
        headline = temp.h3.a.text.strip()
        # city = article.findAll('span', attrs={"class": "blue-color ksl-time-stamp"})[0].text.strip()
        # if(city == None or len(city)>10):
        #     continue
        print("Headline = " + headline)
        # print("city: "+city[:-1]+"\n")
        # print("content: "+content+"\n")
        #author = article.find('div', attrs={"class": "author-container hidden-xs"}).findAll('a')[1].text.strip()
        #print("author: "+author+"\n")
        #date = article.findAll('span', attrs={"class": "blue-color ksl-time-stamp"})[1].text.strip()
        #print("date: "+date+"\n")
        if(count > 10):
            break
        print(count)
        count += 1
        #
        # if count == 3:
        #     break

        # entities = [date, ",", author, ",", city]

        try:
            x = conn.cursor()

            # print("trying to save,", headline)

            headline = re.sub("[^ ^a-z^A-Z]", "", headline)
            headline = re.sub("[^ ^a-z^A-Z]", "", headline)

            content = re.sub("[^ ^a-z^A-Z]", "", content)
            content = re.sub("[^ ^a-z^A-Z]", "", content)

            # date = re.sub("[^ ^a-z^A-Z]", "", date)
            # date = re.sub("[^ ^a-z^A-Z]", "", date)

            # """INSERT
            # INTO
            # `all_articles_hindu`(`headline`, `content`, `entities`)
            # VALUES('No work in Parliament, all activity is outside',
            #        'No business was transacted in both the Rajya Sabha and the Lok Sabha for the second consecutive day on Tuesday, but the Parliament’s lawns are brimming with lawmakers holding placards protesting against a host of issues.',
            #        'March 06, 2018 23:21 IST')"""

            sql = "INSERT INTO `articles_thehindu`(`headline`, `content`) VALUES (\'{}\',\'{}\')".format(headline, content);

            x.execute(sql)
        except:
            print("unable to insert")
            print(sql)
            print()
            conn.rollback()
            exit()
    conn.commit()


conn.close()
print("Script Ends")