import twitter
# twitter_search=twitter.Twitter(domain="api.twitter.com")
# trends = twitter_search.trends()
twitter_api = twitter.Twitter(domain="api.twitter.com", api_version='1')
trends = twitter_api.trends()
[trend['name'] for trend in trends['trends']]
