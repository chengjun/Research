# -*- coding: utf-8 -*-
"""
@author: chengjun
"""
import re
import csv
import time
import re

HTML="http://youtu.be/wCujys4QAhw"
re_category = re.compile('category"><a href=[^>]+>([^<]+)</a>')
CATEGORY = re_category.search(HTML).group(1)
# In the above code, HTML is the video html file and the CATEGORY is the video's category.
# The codes below MAY find out the author:
re_author = re.compile('"author"[^>]*>([^<]+)')
AUTHOR= re_author.search(HTML).group(1)
# The codes below MAY find out all the tags in a list:
re_tags =  re.compile('tag">([^<]+)<')
TAGS = re_tags.findall(HTML)


# 1. By Google YouTube data api:
     # Google provides api for these purposes in java an python respectively. 
	 # Here is the link of the python version(which is what I use):https://developers.google.com/youtube/1.0/developers_guide_python#GettingStarted. 
	 # These packages can help us obtain any information we want --- and I think this is the formal and stable way.
# 2 By cracking the HTML source by RE(regular expression)