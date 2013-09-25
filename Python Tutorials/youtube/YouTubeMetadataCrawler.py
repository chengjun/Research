# YouTube API Crawler
# -*- coding: utf-8 -*-

'''
author: chengjun wang
email: wangchj04@gmail.com
Canberra, 2012/3/24
'''

import gdata.youtube
import gdata.youtube.service
import sys

# Use google data api to use YouTubeService
yt_service = gdata.youtube.service.YouTubeService()
yt_service.ssl = True # Turn on HTTPS/SSL access.

# A complete client login request
yt_service.email = '@gmail.com'
yt_service.password = 'pw'
yt_service.source = 'my-example-application'
yt_service.developer_key = 'key'
yt_service.client_id = 'WebMiningLab'
yt_service.ProgrammaticLogin()


# import id
import csv
import numpy as np
addressofid = "C:/Python27/weibo/youtube/id_test.csv"
addressForSavingData = "C:/Python27/weibo/youtube/save.csv"

def importIdFromCsv (fileAdress):
    testfile = open(fileAdress, 'rb')
    test = np.recfromcsv(testfile)
    testfile.close()
    names = range(0,len(test))
    for i in names:
        names[i] = test[i][0]
    return(names)
	
ids = importIdFromCsv(addressofid)

import time as time
start = time.clock()
file = open(addressForSavingData,'wb') # save to cvs file
for video_id in ids:
    try:
        entry = yt_service.GetYouTubeVideoEntry(video_id=video_id)
    except Exception, e:
        print >>sys.stderr, "Failed to retrieve entry video_id=%s: %s" %(video_id, e)
    else:
		# Define the taget information
		author= entry.author[0].name.text
		title= entry.media.title.text
		# description='description: %s' % entry.media.description.text # too long
		category= entry.media.category[0].text
		duration= entry.media.duration.seconds
		tags= entry.media.keywords.text
		w = csv.writer(file,delimiter=',',quotechar='|', quoting=csv.QUOTE_MINIMAL)
		w.writerow((video_id, author, title, category, duration, tags)) # write it		
file.close()
pass
print time.clock()-start
# Running time test

'''
References
1. YouTube deverlopers guide for python
https://developers.google.com/youtube/1.0/developers_guide_python
2. Introduction to the library of gdata.youtube:
http://gdata-python-client.googlecode.com/svn/trunk/pydocs/gdata.youtube.html#YouTubeVideoEntry
3. StackOverFlow
http://stackoverflow.com/questions/8083268/youtube-video-id-from-firefox-bookmark-html-source-code-almost-there
4. clickstreamCrawling.py by Lingfei Wu
you can find it in our group emails.
'''



