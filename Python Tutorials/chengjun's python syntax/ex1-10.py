"""ex1-10 using regular expressions to find retweets"""
import twitter
import re
rt_patterns=re.compile(r"(via|RT)((?:\b\ w*@\w+)+)", re.IGNORECASE)
 
example_tweets=["SOS",
                "pkusjcer want to know what is TABOK SELENA!!!((via @pkusjcer))",
                "",
                "RT @pkusjcer what is TABOK SELENA"]

for t in example_tweets: # A loop
    print rt_patterns.findall(t)

# i add 'print' to output the results.
# there are no blanks between via and @ and RT AND @

