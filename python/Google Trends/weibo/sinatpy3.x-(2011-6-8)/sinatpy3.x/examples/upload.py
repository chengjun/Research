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
        self.api = API(self.auth, source=self.consumer_key)
        
    def basicAuth(self, source, username, password):
        self.auth = BasicAuthHandler(username, password)
        self.api = API(self.auth,source=source)
    
    def upload(self, filename, message):
        status = self.api.upload(filename, status=message)        
        self.obj = status
        id = self.getAtt("id")
        text = self.getAtt("text")
        self.obj = self.getAtt("user")
        profile_image_url  = self.getAtt("profile_image_url")
        print("upload,id="+ str(id) +",text="+ text +",profile_image_url="+ profile_image_url)

test = Test()
test.basicAuth('consumer_key', 'username', 'password')
test.upload("test.jpg", "upload-test-测试")

