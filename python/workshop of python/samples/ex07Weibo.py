#!/usr/bin/env python
# -*- coding: UTF-8  -*-

"""docstring
"""
set enc=utf-8  # enc to encode
set fileencoding=utf-8
set fileencodings=ucs-bom,utf8,prc
set guifont=Monaco:h11
set guifontwide=NSimsun:h12

__revision__ = '0.1'

import sys,os
import webbrowser
from weibo1 import APIClient, OAuthToken
#使用sina SKD提供的python接口

def usage():
    print "infodbFile"
    pass 

def error():
    usage()
    sys.exit(-1)

def sinaWeiBo2(appKey,appSecret,name):
    client = APIClient(app_key=appKey, app_secret=appSecret,isAuthorization=False)
    for object in client.get.statuses__user_timeline(source=appKey, screen_name=name):
    	#获取该user发布的前20条微博
        print ""
        #id = object["id"]
        text = object["text"]
        created_at = object["created_at"]
		user = object["user"]
		in_reply_to_status_id = object["in_reply_to_status_id"]
        print str(created_at)+":"+ text.encode('gb18030'),
        if 'retweeted_status' in object:
            object=object['retweeted_status']
            print "retweeted:",object['id']+"@"+object['text'].encode('gb18030'),	
	
	
def sinaWeiBo(appKey,appSecret,infoDb,user,content):
    access_token=infoDb.get(user,None)
    if not access_token:
        client = APIClient(app_key=appKey, app_secret=appSecret)
   		# 用appKey创建一个client
        request_token = client.get_request_token()
        # 1.app认证，如果认证成功，有sina返回一个request_token
        url="http://api.t.sina.com.cn/oauth/authorize?oauth_token=%s"%(request_token.oauth_token)
        # 需要用户对该app进行授权，这样保证app不会获取用户的帐号和密码
        webbrowser.open(url)
        oauth_verifier = raw_input('PIN: ').strip()
        # 验证用户是否对app授权 即2.授权认证
        request_token = OAuthToken(request_token.oauth_token, request_token.oauth_token_secret, oauth_verifier)
        # 构造新一个request_token
        client = APIClient(app_key=appKey, app_secret=appSecret, token=request_token)
        access_token = client.get_access_token()
        # 向sina获取access_token，即3.代理访问认证
        infoDb.setdefault(user,access_token)
    client = APIClient(app_key=appKey, app_secret=appSecret, token=access_token)
    client.post.statuses__update(status=content.decode('utf-8').encode('utf-8'))
    for object in client.get.statuses__user_timeline():
    	# 获取该user发布的前20条微博
        print ""
        # id = object["id"]
        text = object["text"]
        created_at = object["created_at"]
        print str(created_at)+":"+ text.encode('gb18030'),
        if 'retweeted_status' in object:
            object=object['retweeted_status']
            print "retweeted:",object['text'].encode('gb18030'),
           



import cPickle

if __name__=="__main__":

    argvNum=2
    if len(sys.argv)<argvNum:
        error()

    user='yorkerjaster@126.com'
    appKey = '1150905942' 
    appSecret = '09c5a64d9ad359609a2f962a570dddee'
    name='李开复'
    infodbFile=sys.argv[1]
    infoDb={}

    if os.path.exists(infodbFile):
        assert os.path.isfile(infodbFile)
        inf=open(infodbFile)
        infoDb=cPickle.load(inf)
        #从文件里读入python dict
        inf.close()
		
    # content='hello world 你好hihi'            
    #sinaWeiBo(appKey,appSecret,infoDb,user,content)

    sinaWeiBo2(appKey,appSecret,name)
    outf=open(infodbFile,'w')
    cPickle.dump(infoDb,outf,2)
    #把python dict dump到文件里面
    outf.close()
