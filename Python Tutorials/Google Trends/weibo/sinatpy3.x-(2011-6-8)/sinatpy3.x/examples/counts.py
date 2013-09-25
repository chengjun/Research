#!/usr/bin/python
#coding=gbk

'''
Created on 2011-2-25

@author: sina(weibo.com)
'''

import unittest
from weibopy.auth import BasicAuthHandler, OAuthHandler
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
        self.api = API(self.auth,source=self.consumer_key)
        
    def basicAuth(self, source, username, password):
        self.authType = 'basicauth'
        self.auth = BasicAuthHandler(username, password)
        self.api = API(self.auth,source=source)
        
    def counts(self):
        counts = self.api.counts(ids='1864372538,1484854960,1877120192')
        for count in counts:
            self.obj = count
            mid = self.getAtt("id")
            comments = self.getAtt("comments")
            rt = self.getAtt("rt")
            print("mentions---"+ str(mid) +":"+ str(comments) +":"+ str(rt))
    

test = Test()
test.basicAuth('consumer_key', 'username', 'password')
test.counts()
