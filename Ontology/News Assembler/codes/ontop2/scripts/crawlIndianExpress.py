import urllib.request
import bs4 as bs
# import xml.etree.cElementTree as et
import re
import MySQLdb

conn = MySQLdb.connect(host="localhost", user="root", passwd="", db="ontop2db")

# tag_news = et.Element("news")

# Number of articles to store in the xml file
total_articles = 101

count = 1
page_num = 1
while count <= total_articles:
    url = "http://indianexpress.com/section/india/" + "page" + "/" + str(page_num) + "/"
    print("Getting data from url =", url)
    html_doc = urllib.request.urlopen(url)
    soup = bs.BeautifulSoup(html_doc, 'html.parser')
    page_num = page_num + 1

    for temp in soup.find_all('div', class_='snaps'):
        link = temp.a.get('href')
        article = urllib.request.urlopen(link)
        article = bs.BeautifulSoup(article, 'html.parser')

        xml_headline = article.h1.text.lstrip().rstrip()
        # xml_description = article.h2.text.lstrip().rstrip()
        xml_content = ''
        # xml_place = ''
        # xml_author = ''

        # author = article.find('div', class_='editor').find('a')
        # if author:
        #     xml_author = author.text.lstrip().rstrip()

        content = article.find('div', attrs={"class": "full-details"}).findAll('p')
        for x in content:
            para = x.text
            if para.find('jQuery') > 0:
                break
            else:
                xml_content += para

        # date = article.find('div', class_='editor').find('span')
        # xml_date = date['content']

        # place = article.find('div', class_='editor').text
        # m = re.search('\|(.+?)\|', place)
        # if m:
        #     xml_place = m.group(1).lstrip().rstrip()

        # print("Number of Articles Elapsed =", count)
        # print("――――――――――――――――――――――――――――――――――――――― Article = {} ―――――――――――――――――――――――――――――――――――――――".format(count))
        print("Headline =", xml_headline)
        # print("Description =", xml_description)
        # print("Author =", xml_author)
        # print("Content =", xml_content)
        # print("Date Published =", xml_date)
        # print("Place =", xml_place)

        # tag_article = et.SubElement(tag_news, "article")
        #
        # tag_headline = et.SubElement(tag_article, "headline")
        # tag_headline.text = xml_headline
        #
        # tag_description = et.SubElement(tag_article, "description")
        # tag_description.text = xml_description
        #
        # tag_author = et.SubElement(tag_article, "author")
        # tag_author.text = xml_author
        #
        # tag_content = et.SubElement(tag_article, "content")
        # tag_content.text = xml_content
        #
        # tag_date = et.SubElement(tag_article, "date")
        # tag_date.text = xml_date
        #
        # tag_place = et.SubElement(tag_article, "place")
        # tag_place.text = xml_place

        count = count + 1
        if count > total_articles:
            break

        try:
            x = conn.cursor()

            # print("trying to save,", headline)

            headline = re.sub("[^ ^a-z^A-Z]", "", xml_headline)
            headline = re.sub("[^ ^a-z^A-Z]", "", headline)

            content = re.sub("[^ ^a-z^A-Z]", "", xml_content)
            content = re.sub("[^ ^a-z^A-Z]", "", content)

            # date = re.sub("[^ ^a-z^A-Z]", "", date)
            # date = re.sub("[^ ^a-z^A-Z]", "", date)

            # """INSERT
            # INTO
            # `all_articles_hindu`(`headline`, `content`, `entities`)
            # VALUES('No work in Parliament, all activity is outside',
            #        'No business was transacted in both the Rajya Sabha and the Lok Sabha for the second consecutive day on Tuesday, but the Parliament’s lawns are brimming with lawmakers holding placards protesting against a host of issues.',
            #        'March 06, 2018 23:21 IST')"""

            sql = "INSERT INTO `articles_indianexp`(`headline`, `content`, `link`) VALUES (\'{}\',\'{}\',\'{}\')".format(headline, content, link);

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

# et.dump(tag_news)
# tree = et.ElementTree(tag_news)
# tree.write("temp.xml")