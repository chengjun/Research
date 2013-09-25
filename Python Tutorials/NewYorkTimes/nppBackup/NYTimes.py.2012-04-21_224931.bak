import sys
sys.path.insert(0, '..')
from urllib import urlopen
from couchdb import Server
from couchdb.mapping import Document, TextField, IntegerField, DateField, date
from couchdbinterface import entities

#search 'keyword' during 'pastDay' for 'maxPage' which have 'numOfArt' article in 1 page
def wrapNYTimes(keyword, pastDay = 30, maxPage = 10):
    for i in range(maxPage):
        print 'wrapping NYTimes : page '+str(i+1)
        url = 'http://query.nytimes.com/search/sitesearch?query=%s&less=multimedia&more=past_%d&page=%d' % (keyword, pastDay, i+1)
        #print 'pageURL: '+url
        req = urlopen(url)
        page = req.read()
        page = page[page.find('<div id="search_results"><ul class="results">'):page.find('</ul></div>')]
        lineList = page.splitlines()
        lineList.pop(0)
        parseResult(lineList, keyword)

#parse results from 1 page and store to 'Article' db
def parseResult(LineList, keyword):
    while (len(LineList) > 0):
        type = LineList.pop(0)
        content = ''
        if (type == '<li class="clearfix noThumb summary">'):
            content = LineList.pop(0)
            while (LineList.pop(0) != '</li>'):
                continue
        elif (type == '<li class="clearfix"><ul class="columns">'):
            while (LineList.pop(0) != '<li class="summary">'):
                continue
            content = LineList.pop(0)
            while (LineList.pop(0) != '</ul></li>'):
                continue
        else :  #it must not be happened
            return
        
        try:
            article = entities.Article()
            article.date = parseDate(content)
            if (article.date == None):
                continue
            article.title = parseTitle(content)
            article.extract = parseSumm(content)
            article.link = parseUrl(content)
            article._id = article.link
            article.source = 'nyt'
            article.create()
        except (UnicodeDecodeError):
            continue

#return article title
def parseTitle(content):
    title = content[:content.find('</h3>')]
    while (True):
        if (title.find('<') >= 0):
            prev = title[:title.find('<')]
            next = title[title.find('>')+1:]
            title = prev + next
        else:
            break
    #print 'title: '+title
    return title

#return article publication date
def parseDate(content):
    span = content[content.find('<span class="byline">'):content.find('</span>')]
    span = span[span.find('>')+1:]
    if (span == ''):
        return None
    #print 'date: '+span
    dateList = span.split()
    year = int(dateList[2])
    month = dateList[0]
    day = int(dateList[1][:dateList[1].find(',')])
    
    mm = 0
    if (month == 'January'):
        mm = 1
    elif (month == 'February'):
        mm = 2
    elif (month == 'March'):
        mm = 3
    elif (month == 'April'):
        mm = 4
    elif (month == 'May'):
        mm = 5
    elif (month == 'June'):
        mm = 6
    elif (month == 'July'):
        mm = 7
    elif (month == 'August'):
        mm = 8
    elif (month == 'September'):
        mm = 9
    elif (month == 'October'):
        mm = 10
    elif (month == 'November'):
        mm = 11
    elif (month == 'December'):
        mm = 12
    return date(year, mm, day)

#return summary of article
def parseSumm(content):
    summ = content[content.find('</h3>'):content.find('<span')]
    while (True):
        if (summ.find('<') >= 0):
            prev = summ[:summ.find('<')]
            next = summ[summ.find('>')+1:]
            summ = prev + next
        else:
            break
    #print 'summ: ' + summ
    return summ

#return URL of article
def parseUrl(content):
    url = content[content.find('<a href='):]
    url = url[url.find('"')+1:url.find('?')]
    #print 'url: ' + url
    return url

#################TEST####################

wrapNYTimes('japan')