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
        self.api = API(self.auth,source=self.consumer_key)
        
    def basicAuth(self, source, username, password):
        self.auth = BasicAuthHandler(username, password)
        self.api = API(self.auth,source=source)
        
    def update_profile_image (self, filename):
        user = self.api.update_profile_image(filename)
        self.obj = user
        id = self.getAtt("id")
        profile_image_url = self.getAtt("profile_image_url")
        print("update,uid="+ str(id) +",profile_image_url="+ profile_image_url)

test = Test()
test.basicAuth('consumer_key', 'username', 'password')
test.update_profile_image ("test.jpg")

