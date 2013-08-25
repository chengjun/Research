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
    
    def create_friendship(self):
        user = self.api.create_friendship(id=1114365581)
        self.obj = user
        uid = self.getAtt("id")
        screen_name = self.getAtt("screen_name")
        print("create_friendship---"+ str(uid) +":"+ screen_name)
        
    def destroy_friendship(self):
        user = self.api.destroy_friendship(id=1114365581)
        self.obj = user
        uid = self.getAtt("id")
        screen_name = self.getAtt("screen_name")
        print("destroy_friendship---"+ str(uid) +":"+ screen_name)
        
    def exists_friendship(self):
        self.obj = self.api.exists_friendship(user_a=1772333754, user_b=1773365880)
        friends = self.getAtt("friends")
        print("exists_friendship--- "+ str(friends))
        
    def show_friendship(self, uid):
        showList = self.api.show_friendship(target_id=uid)
        for obj in showList:
            self.obj = obj
            uid = self.getAtt("id")
            screen_name = self.getAtt("screen_name")
            print("show_friendship---"+ str(uid) +":"+ screen_name)


test = Test()
test.basicAuth('consumer_key', 'username', 'password')
test.create_friendship()
test.show_friendship(1114365581)
test.exists_friendship()
test.destroy_friendship()


