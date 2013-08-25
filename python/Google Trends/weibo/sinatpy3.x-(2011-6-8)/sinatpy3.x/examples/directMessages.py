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
        self.api = API(self.auth)
        
    def basicAuth(self, source, username, password):
        self.auth = BasicAuthHandler(username, password)
        self.api = API(self.auth,source=source)
        
    def direct_message(self):
        messages = self.api.direct_messages()
        mid = ''
        for msg in messages:
            self.obj = msg
            mid = self.getAtt("id")
            text = self.getAtt("text")
            print("direct_message---"+ str(mid) +":"+ text)
        return mid
    
    def sent_direct_messages(self):
        messages = self.api.sent_direct_messages()
        for msg in messages:
            self.obj = msg
            mid = self.getAtt("id")
            text = self.getAtt("text")
            print("sent_direct_messages---"+ str(mid) +":"+ text)
            
    def new_direct_message(self):
        msg = self.api.new_direct_message(id=1114365581,text='directMessages--test-测试-'+ str(time.time()))
        self.obj = msg
        mid = self.getAtt("id")
        text = self.getAtt("text")
        print("new_direct_message---"+ str(mid) +":"+ text)
            
    def destroy_direct_message(self, id):
        msg = self.api.destroy_direct_message(id)
        self.obj = msg
        mid = self.getAtt("id")
        text = self.getAtt("text")
        print("destroy_direct_message---"+ str(mid) +":"+ text)


test = Test()
test.basicAuth('consumer_key', 'username', 'password')
mid =  test.direct_message()
test.sent_direct_messages()
test.new_direct_message()
test.destroy_direct_message(mid)
