# -*- coding: cp936 -*-
# chengjun wang
# App Key:1150905942
# App Secret:09c5a64d9ad359609a2f962a570dddee


#-*- encoding: utf-8 -*-
# ����������鿴PIN
import webbrowser
# sina weibo python SDK
from weibopy.auth import OAuthHandler
from weibopy.api import API
# ��д�����AppKey
AppKey = '1150905942'
# ��д�����AppSecret
AppSecret = '09c5a64d9ad359609a2f962a570dddee'
my_auth = OAuthHandler(AppKey , AppSecret)
webbrowser.open(my_auth.get_authorization_url())
# ����������л�õ�PIN
verifier = raw_input('PIN: ').strip()
my_auth.get_access_token(verifier)
my_api = API(my_auth)
#�������ͨ��my_api ��������API
 
for object in my_api.user_timeline(count=20):
    id = object.__getattribute__("id")
    text = object.__getattribute__("text")
    created_at = object.__getattribute__("created_at")
    print str(id) +":"+ str(created_at)+":"+ text
