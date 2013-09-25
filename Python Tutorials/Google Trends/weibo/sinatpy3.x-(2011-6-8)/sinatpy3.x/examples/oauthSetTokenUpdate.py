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
    
    def update(self, message):
        status = self.api.update_status(lat='39', long='110', status=message)
        self.obj = status
        id = self.getAtt("id")
        text = self.getAtt("text")
        print("update---"+ str(id) +":"+ text)
        
    def destroy_status(self, id):
        status = self.api.destroy_status(id)
        self.obj = status
        id = self.getAtt("id")
        text = self.getAtt("text")
        print("update---"+ str(id) +":"+ text)

test = Test()
#AccessToken的 key和Secret
test.setAccessToken('key', 'secret')
test.basicAuth('4227760858', 'test5monitor@sina.cn', 'weibotest5')
test.update("setToken-upload-test-测试")

