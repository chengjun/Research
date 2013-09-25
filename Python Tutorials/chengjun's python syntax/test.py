"""ex 1-3 retrieving Twitter API trends"""
import twitter
twitter_api = twitter.Twitter(domain="api.twitter.com", api_version='1')
trends = twitter_api.trends()
# print trends
print [trend['name'] for trend in trends['trends'] ]

# it's weird that I input the codes separately, it works.
# but it dones't work together.
# I add print to fix this bug.

""""exe1-4 paging through twitter search results"""
search_results=[]
twitter_search = twitter.Twitter(domain="search.twitter.com")
for page in range(1,6): 
    search_results.append(twitter_search.search(q="Victoria Secret",
                                                rpp=400, page=page))
    # i make page range less 2 pages to save time.
    # range(1,3) only output page 1 and page 2, rather than 3 pages.
    # I make rpp=10, with 1 results per page, to save time.
