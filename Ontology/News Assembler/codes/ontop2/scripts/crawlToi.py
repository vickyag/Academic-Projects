import urllib.request
import bs4 as bs
import re
import MySQLdb

conn = MySQLdb.connect(host="localhost", user="root", passwd="", db="ontop2db")


page_num = 2
while page_num < 20:
    if(page_num == 1):
        url = "https://timesofindia.indiatimes.com/india/"
    else:
        url = "https://timesofindia.indiatimes.com/india/"+str(page_num)+""
    print("Getting data from url =", url)
    html_doc = urllib.request.urlopen(url)
    soup = bs.BeautifulSoup(html_doc, 'html.parser')
    page_num = page_num + 1
    count = 1
    for temp in soup.find_all('span', class_='w_tle'):
        link = "https://timesofindia.indiatimes.com"+temp.a.get('href')
        article_doc = html_doc = urllib.request.urlopen(link)
        article = bs.BeautifulSoup(article_doc, 'html.parser')
        content = article.find('div', class_="Normal")
        if(content == None):
            continue
        content = content.text
        headline = temp.a.text
        city = re.search('(.+?):', content)
        if(city == None or len(city[0])>10):
            continue
        print("Retrieved: "+headline+"\n")
        # print("city: "+city[0][:-1]+"\n")
        content = content[len(city[0]):].strip()
        #print("content: "+content+"\n")
        author = article.find('span', attrs={"class": "time_cptn"}).findAll('span')[1].text.strip()
        # print("author: "+author+"\n")
        date = article.find('span', attrs={"class": "time_cptn"}).findAll('span')[2].text.strip()
        # print("date: "+date[:-11]+"\n")
        if(count > 10):
            break
        print(count)
        count += 1

        try:
            x = conn.cursor()

            # print("trying to save,", headline)

            headline = re.sub("[^ ^a-z^A-Z]", "", headline)
            headline = re.sub("[^ ^a-z^A-Z]", "", headline)

            content = re.sub("[^ ^a-z^A-Z]", "", content)
            content = re.sub("[^ ^a-z^A-Z]", "", content)

            date = re.sub("[^ ^a-z^A-Z]", "", date)
            date = re.sub("[^ ^a-z^A-Z]", "", date)

            # """INSERT
            # INTO
            # `all_articles_hindu`(`headline`, `content`, `entities`)
            # VALUES('No work in Parliament, all activity is outside',
            #        'No business was transacted in both the Rajya Sabha and the Lok Sabha for the second consecutive day on Tuesday, but the Parliament’s lawns are brimming with lawmakers holding placards protesting against a host of issues.',
            #        'March 06, 2018 23:21 IST')"""

            sql = "INSERT INTO `articles_toi`(`headline`, `content`, `entities`) VALUES (\'{}\',\'{}\',\'{}\')".format(
                headline, content, date);

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