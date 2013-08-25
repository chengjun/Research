#!/usr/bin/python
#coding=gbk

'''
Created on 2011-2-25

@author: sina(weibo.com)
'''

import unittest
import time
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
        self.api = API(self.auth, source=self.consumer_key)
        
    def basicAuth(self, source, username, password):
        self.authType = 'basicauth'
        self.auth = BasicAuthHandler(username, password)
        self.api = API(self.auth,source=source)
    def get_privacy(self):
        privacy = self.api.get_privacy()
        self.obj = privacy
        ct = self.getAtt("comment")
        dm = self.getAtt("dm")
        real_name = self.getAtt("real_name")
        geo = self.getAtt("geo")
        badge = self.getAtt("badge") 
        print ("privacy---"+ str(ct) + str(dm) + str(real_name) + str(geo) + str(badge))
    def update_privacy(self):
        update_privacy = self.api.update_privacy(comment=0)        

test = Test()
test.basicAuth('source', 'username', 'password')
test.get_privacy()
test.update_privacy()
