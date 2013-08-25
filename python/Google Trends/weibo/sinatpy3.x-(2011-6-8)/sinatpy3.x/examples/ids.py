#!/usr/bin/python
#coding=gbk

'''
Created on 2011-2-25

@author: sina(weibo.com)
'''

import unittest
from weibopy.auth import OAuthHandler, BasicAuthHandler
from weibopy.api import API

class Test(unittest.TestCase):
    
    consumer_key=''
    consumer_secret=''
    
    def __init__(self):
            """ constructor """
    
    def getAtt(self, key):
        try:
            return self.obj.__getattribute__(key)
        except Exception as e:
            print(e)
            return ''
    
    def setAccessToken(self, key, secret):
        self.auth = OAuthHandler(self.consumer_key, self.consumer_secret)
        self.auth.setAccessToken(key, secret)
        self.api = API(self.auth)
        
    def basicAuth(self, source, username, password):
        self.auth = BasicAuthHandler(username, password)
        self.api = API(self.auth,source=source)
    
    def friends_ids(self):
        fids = self.api.friends_ids()
        self.obj = fids
        ids = self.getAtt("ids")
        next_cursor = self.getAtt("next_cursor")
        previous_cursor = self.getAtt("previous_cursor")
        print("friends_ids---"+ str(ids) +":next_cursor"+ str(next_cursor) +":previous_cursor"+ str(previous_cursor))
        
    def followers_ids(self):
        fids = self.api.followers_ids()
        self.obj = fids
        ids = self.getAtt("ids")
        next_cursor = self.getAtt("next_cursor")
        previous_cursor = self.getAtt("previous_cursor")
        print("followers_ids---"+ str(ids) +":next_cursor"+ str(next_cursor) +":previous_cursor"+ str(previous_cursor))
        
test = Test()
test.basicAuth('consumer_key', 'username', 'password')
test.friends_ids()
test.followers_ids()

