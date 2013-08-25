# !/usr/bin/env python
# -*- coding: UTF-8  -*-
# GetSina Weibo Repost_timeline
# Author: chengjun wang
# 20120328@Canberra


from weibopy.auth import OAuthHandler
from weibopy.api import API
from urlparse import parse_qsl
from getPIN import GetPIN  # need the module of getPIN from http://wpxiaomo.sinaapp.com/archives/415

'''
Step 0: automatically get authorization by oauth2.0
'''
APP_KEY = " "
APP_SECRET = " "
 
def get_access_token(username, password):
    auth = OAuthHandler(APP_KEY, APP_SECRET)
    auth_url = auth.get_authorization_url()
    print "Auth URL: ",auth_url
    veri_obj = GetPIN(auth_url, username, password)   
    verifier = veri_obj.getPIN()
    print "VERIFIER: ",verifier
    if verifier==-1:
        raise Exception("Error Account")
    token = auth.get_access_token(verifier)
    return dict(parse_qsl(str(token)))
	
def api(): 
    token=get_access_token('w..','c..')  #input your weibo id and password here#
    atKey =token['oauth_token']
    atSecret = token['oauth_token_secret']
    from weibopy.error import WeibopError
    auth = OAuthHandler(APP_KEY, APP_SECRET)
    auth.setToken( atKey, atSecret ) 
    api = API(auth) # bind the authentication information to connect to API
    return api
	