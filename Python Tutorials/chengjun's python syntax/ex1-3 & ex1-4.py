# wang chengjun
# Contact: wangchj04@gmail.com
# 2011/05/19

"""ex 1-3 retrieving Twitter API trends"""
import twitter
twitter_api = twitter.Twitter(domain="api.twitter.com", api_version='1')
trends = twitter_api.trends()
print trends
print [trend['name'] for trend in trends['trends'] ]

# it's weird that I input the codes separately, it works.
# but it dones't work together.
# I add print to fix this bug.

""""exe1-4 paging through twitter search results"""
search_results=[]
twitter_search = twitter.Twitter(domain="search.twitter.com")
for page in range(1,7): 
    search_results.append(twitter_search.search(q="TABOK SELENA",
                                                rpp=100, page=page))
    # i make page range less 2 pages to save time.
    # range(1,3) only output page 1 and page 2, rather than 3 pages.
    # I make rpp=10, with 1 results per page, to save time.
    
""""exe1-5 pretty-printing twitter data as JSON"""
import json
print json.dumps(search_results, sort_keys=True, indent=1)
# it will take some seconds of time, take easy and be patient.


"""ex1-6 a simple list comprehension in python"""
tweets=[r['text']
    for result in search_results
        for r in result['results']]

"""ex1-7 calculating lexical diversity for tweets"""
words=[]
for t in tweets:
    words +=[w for w in t.split()]
    
    # Why doesn't this code work? the same answer, add print to output results.
print len(words) #total words
print len(set(words)) #unique words
print 1.0*len(set(words))/len(words) #lexical diversity
print 1.0*sum([len(t.split()) for t in tweets])/len(tweets) # avg words per tweet


"""ex1-8 pickling your data"""
f=open("myData.pickle","wb")
import cPickle
cPickle.dump(words,f)
f.close()


