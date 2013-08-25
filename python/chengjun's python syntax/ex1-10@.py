


"""ex1-10 using regular expressions to find retweets"""
import re
rt_patterns=re.compile(r"(RT|via)((?:\b\w*@\w+)+)", re.IGNORECASE)
example_tweets=["RT@pkusjcer what is TABOK SELENA ",
                "pkusjcer want to know what is TABOK SELENA!!!(via@pkusjcer)"]
for t in example_tweets:
    print rt_patterns.findall(t)
