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
    def tags(self):
        tags = self.api.tags(user_id=1377583044)
        for line in tags:
            self.obj = line
            tagid=self.getAtt("id")
            value = self.getAtt(tagid)
            print (tagid,value)
    def tag_create(self ,message):
#        message = message.encode("utf-8")
        tag_create = self.api.tag_create(tags=message)
        for line in tag_create:
            self.obj = line
            tagid = self.getAtt("tagid")
            print ("tag_create---"+tagid)
    def tag_suggestions(self):
        tag_suggestions=self.api.tag_suggestions()
        for line in tag_suggestions:
            self.obj = line
            id = self.getAtt("id")
            value = self.getAtt("value")
            print ("tag_suggestions---"+ id +":"+ value)
    def tag_destroy(self,tag_id):
        tag_destroy=self.api.tag_destroy(tag_id)
        self.obj=tag_destroy
        result=self.getAtt("result")
        print ("tag_destroy---"+ result)
    def tag_destroy_batch(self,tag_ids):
        tag_destroy_batch=self.api.tag_destroy_batch(tag_ids)
        for line in tag_destroy_batch:
            self.obj = line
            tagid=self.getAtt("tagid")
            print ("tag_destroy_batch---"+ tagid)                        
    
test=Test()
#AccessToken的 key和Secret
test.setAccessToken("key", "secret")
test.tags()