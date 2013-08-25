#!/usr/bin/python
#coding=gbk

'''
Created on 2011-2-25

@author: sina(weibo.com)
'''


import unittest
from weibopy.auth import OAuthHandler
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
        
    def auth(self):
        
        if len(self.consumer_key) == 0:
            print("Please set consumer_key！！！")
            return
        
        if len(self.consumer_key) == 0:
            print("Please set consumer_secret！！！")
            return
                
        self.auth = OAuthHandler(self.consumer_key, self.consumer_secret)
        auth_url = self.auth.get_authorization_url()
        print('Please authorize: ' + auth_url)
        verifier = input('PIN: ').strip()
        self.auth.get_access_token(verifier)
        self.api = API(self.auth)
        
    def setAccessToken(self, key, secret):
        self.auth = OAuthHandler(self.consumer_key, self.consumer_secret)
        self.auth.setAccessToken(key, secret)
        self.api = API(self.auth)
    
    def update(self, message):
        status = self.api.update_status(message)
        self.obj = status
        id = self.getAtt("id")
        text = self.getAtt("text")
        print("update,id="+ str(id) +",text="+ text)
        
    def destroy_status(self, id):
        status = self.api.destroy_status(id)
        self.obj = status
        id = self.getAtt("id")
        text = self.getAtt("text")
        print("update---"+ str(id) +":"+ text)

test = Test()
test.auth()
test.update("oauthupdate-test-测试-----")

