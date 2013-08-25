#!/usr/bin/env python
# -*- coding: utf8 -*-

from weibo import APIClient
import urllib2
import urllib
import sys
import time
from time import clock
import csv
import random

reload(sys)
sys.setdefaultencoding('utf-8')

'''
feelingme
App Key：1535698250
App Secret：11a84889e23532d7c4649471877bda18
'''

'''Step 0 Login with OAuth2.0''' 
if __name__ == "__main__":
	APP_KEY = '1535698250' # app key
	APP_SECRET = '11a84889e23532d7c4649471877bda18' # app secret
	CALLBACK_URL = 'https://api.weibo.com/oauth2/default.html' # callback url
	AUTH_URL = 'https://api.weibo.com/oauth2/authorize'
	USERID = 'wangchj04'
	PASSWD = 'weibochengwang6' #your pw
	
	client = APIClient(app_key=APP_KEY, app_secret=APP_SECRET, redirect_uri=CALLBACK_URL)
	referer_url = client.get_authorize_url()
	print "referer url is : %s" % referer_url
	
	cookies = urllib2.HTTPCookieProcessor()
	opener = urllib2.build_opener(cookies)
	urllib2.install_opener(opener)
	
	postdata = {"client_id": APP_KEY,
				"redirect_uri": CALLBACK_URL,
				"userId": USERID,
				"passwd": PASSWD,
				"isLoginSina": "0",
				"action": "submit",
				"response_type": "code",
				}
	headers = {"User-Agent": "Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20100101 Firefox/11.0",
				"Host": "api.weibo.com",
				"Referer": referer_url
			}
 
	req  = urllib2.Request(
	   url = AUTH_URL,
	   data = urllib.urlencode(postdata),
	   headers = headers
	   )
	try:
		resp = urllib2.urlopen(req)
		print "callback url is : %s" % resp.geturl()
		code = resp.geturl()[-32:]
		print "code is : %s" %  code
	except Exception, e:
		print e
		
r = client.request_access_token(code)
access_token1 = r.access_token # The token return by sina
expires_in = r.expires_in 
 
print "access_token=" ,access_token1
print "expires_in=" ,expires_in   # access_token lifetime by second. http://open.weibo.com/wiki/OAuth2/access_token
 
"""save the access token"""
client.set_access_token(access_token1, expires_in) 

'''Step 2 Get the diffusers'''
"""read ids"""
dataReader = csv.reader(open('C:/Python27.3/weibo/leftout.csv', 'r'), delimiter=',', quotechar='|')
ids = []
for row in dataReader:
    ids.append(int(row[0]))  # get the number to get the mid
print ids
	
"""read reposts"""	
# dataReader = csv.reader(open('C:/Python27/weibo/repostsSample3.csv', 'r'), delimiter=',', quotechar='|')
# reposts = []
# for row in dataReader:
    # reposts.append(int(row[2]))  # get the number of reposts for the mid

# mid = client.get.statuses__querymid(id = ids[384], type = 1) # test "43580",3439425096525550,422523,98926,147,FALSE ygxCRrnAO 3439425096525550 http://weibo.com/1686659730/ygxCRrnAO
# mid = client.get.statuses__repost_timeline(id = ids[0], page = pageNum, count = 200) # test "43580",3439425096525550,422523,98926,147,FALSE ygxCRrnAO 3439425096525550 http://weibo.com/1686659730/ygxCRrnAO

addressForSavingData= "C:/Python27.3/weibo/diffsersSaveLeftout1.csv"    
file = open(addressForSavingData,'wb') # save to csv file 

start = clock()  
print start

lenid = len(ids)
# lenid = 554 # test with the first two cases

for n in range(0, lenid + 1):  # the 4th  should be (3, 4)
	try:
		rate = client.get.account__rate_limit_status()
		sleep_time = rate.reset_time_in_seconds + 300
		remaining_ip_hits = rate.remaining_ip_hits
		remaining_user_hits = rate.remaining_user_hits
		if remaining_ip_hits >= 10 and remaining_user_hits >= 3:
			rtc = client.get.statuses__count(ids = str(ids[n])) # mid, 100
			reposts = rtc[0]['reposts']
			if reposts%200 == 0:
				pages = reposts/200
			else:
				pages = reposts/200 + 1
			try:
				for pageNum in range(1, pages +1 +1)[::-1]:   
					'''Do check here!!!''' # for pageNum in range(1, 19 + 1)[::-1] if you want to crawl page 19 to page 1
					r = client.get.statuses__repost_timeline(id = ids[n], page = pageNum, count = 200)
					if len(r) == 0:
						pass
					else:
						m = int(len(r['reposts']))
						for i in range(0, m):
							"""1.1 reposts"""
							mid = r['reposts'][i].id
							text = r['reposts'][i].text.replace(",", "")
							created = r['reposts'][i].created_at
							"""1.2 reposts.user"""
							user = r['reposts'][i].user
							user_id = user.id
							user_name = user.name
							user_province = user.province
							user_city = user.city
							user_gender = user.gender
							user_url = user.url
							user_followers = user.followers_count
							user_bifollowers = user.bi_followers_count
							user_friends = user.friends_count
							user_statuses = user.statuses_count
							user_created = user.created_at
							user_verified = user.verified
							"""2.1 retweeted_status"""
							rts = r['reposts'][i].retweeted_status
							rts_mid = rts.id 
							rts_text = rts.text.replace(",", "")
							rts_created = rts.created_at       
							"""2.2 retweeted_status.user"""
							rtsuser_id = rts.user.id
							rtsuser_name = rts.user.name
							rtsuser_province = rts.user.province
							rtsuser_city = rts.user.city
							rtsuser_gender = rts.user.gender
							rtsuser_url = rts.user.url
							rtsuser_followers = rts.user.followers_count
							rtsuser_bifollowers = rts.user.bi_followers_count
							rtsuser_friends = rts.user.friends_count
							rtsuser_statuses = rts.user.statuses_count
							rtsuser_created = rts.user.created_at
							rtsuser_verified = rts.user.verified  
							timePass = clock()-start
							if round(timePass) % 1 == 0:
								print mid, rts_mid, "I have been working for %s seconds" % round(timePass)
								time.sleep( random.randrange(3, 9, 1) )  # To avoid http error 504 gateway time-out
							if round(timePass) % 300 == 0:
								print "sleep every 10 minutes", "I have been working for %s seconds" % round(timePass)
								time.sleep( 120)
							print >>file, "%s,'%s','%s',%s,'%s',%s,%s,%s,'%s',%s,%s,%s,'%s',%s,%s,'%s',%s,'%s',%s,%s,%s,'%s',%s,%s,%s,%s,%s,%s,%s"  % (mid, created, text, # 3 # "%s,%s,|%s|,%s,|%s|,%s,%s,%s,|%s|,%s,%s,%s,%s,%s,%s,%s,%s,|%s|,%s,%s,%s,|%s|,%s,%s,%s,%s,%s" % (mid, created, text, # 3
												user_id, user_name, user_province, user_city, user_gender,  # 5 --> 5
												user_url, user_followers, user_friends, user_statuses, user_created, user_verified,  # rts_text, # 6 --> 9
												rts_mid, rts_created, # 2
												rtsuser_id, rtsuser_name, rtsuser_province, rtsuser_city, rtsuser_gender, # 5 --> 18 
												rtsuser_url, rtsuser_followers, rtsuser_friends, rtsuser_statuses, rtsuser_created, rtsuser_verified, reposts, pageNum)  # 6  --> 22
			except Exception, e:
				print >> sys.stderr, 'Encountered Exception:', e
				time.sleep(120)
				pass
		elif remaining_ip_hits < 10 or remaining_user_hits < 3:
			print "Python will sleep %s seconds" % sleep_time
			time.sleep(sleep_time+60)
	except Exception, e:
		print >> sys.stderr, 'Encountered Exception:', e
		time.sleep(120)
		pass
		

file.close()
		
''' Step 1 Get the number of reposts'''
"""get the user ids"""
# dataReader = csv.reader(open('C:/Python27/weibo/sampledRtIds2.csv', 'r'), delimiter=',', quotechar='|')
# ids = []
# for row in dataReader:
    # ids.append(int(row[0]))  # modify the number to get the diffusers' ids

# file = open("C:/Python27/weibo/repostsRT300000m2.csv",'wb') # save to csv file

# start = clock()  
# print start

# for seqNum in range(1500, 2999):
	# id = ids[(0 + 100*seqNum) : (100+100*seqNum)]
	# id = str(id).strip('[]').replace('L', '')
	# rate = client.get.account__rate_limit_status()
	# sleep_time = rate.reset_time_in_seconds + 300
	# remaining_ip_hits = rate.remaining_ip_hits
	# remaining_user_hits = rate.remaining_user_hits
	# if remaining_ip_hits >= 10 and remaining_user_hits >= 5:
		# rtc = client.get.statuses__count(ids = id) # mid, 100
		# for n in range(0, len(rtc)): # 0-99
			# mid = rtc[n]['id']
			# reposts = rtc[n]['reposts']
			# comments = rtc[n]['comments']
			# attitudes = rtc[n]['attitudes']
			# timePass = clock()-start
			# if round(timePass) % 10 == 0:
				# print mid, reposts, len(rtc), "I have been working for %s seconds" % round(timePass)
			# print >>file, "%s,%s,%s,%s" % (mid, reposts, comments, attitudes)
	# elif remaining_ip_hits < 10 or remaining_user_hits < 5:
		# print "Python will sleep %s seconds" % sleep_time
		# time.sleep(sleep_time+60)

	
# file.close()


# pt = client.get.statuses__public_timeline(count=200,  access_token =str(access_token1) )
# print pt
# print client.get.statuses__user_timeline() 
# print client.post.statuses__update(status=u'Python Sina microblog for OAuth 2.0 testing')	
# t = client.get.search__topics(q = "apple" , count = 10, page = 1) # decode('utf8',somecodeforerrortoskip) 
# file = open("C:/Python27/weibo/trends.csv",'wb') # save to csv file
# print >>file, "%s,%s,%s,%s,|%s|,%s" % (userid, user, time, tweetid, tweet, source)	
# file.close()

	
