""""exe1-4 paging through twitter search results"""
import twitter
search_results=[]
twitter_search = twitter.Twitter(domain="search.twitter.com",api)
for page in range(1,7):
    search_results.append(twitter_search.search(q="TABOK SELENA",
                                                rpp=100, page=page))
import json
print json.dumps(search_results, sort_keys=True, indent=1)
# it will take some seconds of time, take easy.
