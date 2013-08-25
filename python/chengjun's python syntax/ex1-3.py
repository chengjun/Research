# wang chengjun
# Contact: wangchj04@gmail.com
# 2011/05/19

"""example1-3 retrieving Twitter API trends"""
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
import json
print json.dumps(search_results, sort_keys=True, indent=1)

# it will take some seconds of time, take easy.

