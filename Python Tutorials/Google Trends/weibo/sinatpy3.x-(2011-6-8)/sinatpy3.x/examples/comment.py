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
        
    def comments(self, id):
        comments = self.api.comments(id=id)
        for comment in comments:
            self.obj = comment
            mid = self.getAtt("id")
            text = self.getAtt("text")
            print("comments---"+ str(mid) +":"+ text)
    
    def comments_timeline(self):
        comments = self.api.comments_timeline()
        for comment in comments:
            self.obj = comment
            mid = self.getAtt("id")
            text = self.getAtt("text")
            print("comments_timeline---"+ str(mid) +":"+ text)
    
    def comments_by_me(self):
        comments = self.api.comments_by_me(count=5)
        mid = ''
        for comment in comments:
            self.obj = comment
            mid = self.getAtt("id")
            text = self.getAtt("text")
            created_at = self.getAtt("created_at")
            print('comments_by_me,id='+ str(mid) +',text='+ text+',created_at='+ str(created_at))
        return mid
    
    def comment(self, mid):
        comment = self.api.comment(id=mid, comment='commect-test-测试--'+ str(time.time()))
        self.obj = comment
        mid = self.getAtt("id")
        text = self.getAtt("text")
        print("comment---"+ str(mid) +":"+ text)
    
    def comment_destroy (self, mid):
        comment = self.api.comment_destroy(mid)
        self.obj = comment
        mid = self.getAtt("id")
        text = self.getAtt("text")
        print("comment_destroy---"+ str(mid) +":"+ text)

test = Test()
test.basicAuth('consumer_key', 'username', 'password')
test.comments(1891429516)
test.comment(1891429516)
test.comments_timeline()
mid = test.comments_by_me()
test.comment_destroy(mid)
