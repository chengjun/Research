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
        self.authType = 'basicauth'
        self.auth = BasicAuthHandler(username, password)
        self.api = API(self.auth,source=source)
        
    def favorites(self):
        statuses = self.api.favorites(id=1773365880)
        for status in statuses:
            self.obj = status
            sid = self.getAtt("id")
            text = self.getAtt("text")
            print("favorites---"+ str(sid) +":"+ text)
        
    def create_favorite(self, id):
        status = self.api.create_favorite(id)
        self.obj = status
        sid = self.getAtt("id")
        text = self.getAtt("text")
        print("create_favorite---"+ str(sid) +":"+ text)
            
    def destroy_favorite(self, id):
        msg = self.api.destroy_favorite(id)
        self.obj = msg
        mid = self.getAtt("id")
        text = self.getAtt("text")
        print("destroy_favorite---"+ str(mid) +":"+ text)

test = Test()
test.basicAuth('consumer_key', 'username', 'password')
test.favorites()
test.create_favorite(1469109530)
test.destroy_favorite(1469109530)

