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
        
    def friends_timeline(self):
        timeline = self.api.friends_timeline(count=2, page=1)
        for line in timeline:
            self.obj = line
            mid = self.getAtt("id")
            text = self.getAtt("text")
            print("friends_timeline---"+ str(mid) +":"+ text)

    def comments_timeline(self):
        timeline = self.api.comments_timeline(count=2, page=1)
        for line in timeline:
            self.obj = line
            mid = self.getAtt("id")
            text = self.getAtt("text")
            print("comments_timeline---"+ str(mid) +":"+ text)
            
    def user_timeline(self):
        timeline = self.api.user_timeline(count=5, page=1)
        for line in timeline:
            self.obj = line
            mid = self.getAtt("id")
            text = self.getAtt("text")
            created_at = self.getAtt("created_at")
            print("user_timeline---"+ str(mid) +":"+ str(created_at)+":"+ text)
        timeline = self.api.user_timeline(count=20, page=2)
        
    def public_timeline(self):
        timeline = self.api.public_timeline(count=2, page=1)
        for line in timeline:
            self.obj = line
            mid = self.getAtt("id")
            text = self.getAtt("text")
            print("public_timeline---"+ str(mid) +":"+ text)


test = Test()
test.basicAuth('consumer_key', 'username', 'password')
test.comments_timeline()
test.friends_timeline()
test.user_timeline()
test.public_timeline()

