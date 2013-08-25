#!/usr/bin/python
#coding=gbk

'''
Created on 2011-2-25

@author: sina(weibo.com)
'''

import unittest
from weibopy.auth import OAuthHandler, BasicAuthHandler
from weibopy.api import API

class test(unittest.TestCase):
    
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
        
    def friends(self):
        timeline = self.api.friends()
        for line in timeline:
            self.obj = line
            fid = self.getAtt("id")
            name = self.getAtt("screen_name")
            print("friends---"+ str(fid) +":"+ name)



test = test()
test.basicAuth('consumer_key', 'username', 'password')
test.friends()

