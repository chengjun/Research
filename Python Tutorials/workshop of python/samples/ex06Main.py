#!/usr/bin/env python
# -*- coding: UTF-8  -*-

"""docstring
"""

__revision__ = '0.1'

import sys
import urllib2
from common import writeDb,bzipCompression,bzipDecompression
#使用多文件来编写脚本，导入writeDb,bzipCompression,bzipDecompression 这些函数
#也可以是import common 但是调用这些函数时必须是common.funcName 如common.writeDb() 

def usage():
    print "urlsFile,outDbFile"
    pass 

def error():
    usage()
    sys.exit(-1)

def downloadFunc(url,timeout=10):
    page=None
    isOk=False
    sock=None
    try:
        sock = urllib2.urlopen(url,timeout=timeout)
        #通过url建立一个socket链接，timeout要大于0，并且单位是秒，为等待服务器建立链接的时间
        #如果时间到后，依然服务器没有反映，就抛出异常
        page= sock.read()
        #读入该url的内容，即下载对应url的内容
        isOk=True
    except:
        pass
    finally:
        if sock:
            sock.close()
            #关闭本socket
    return isOk, page

if __name__=="__main__":

    argvNum=3
    if len(sys.argv)<argvNum:
        error()
    outDbFile=sys.argv[2]
    (sta,outDb)=writeDb(outDbFile)
    #新建一个BDB数据结构，类是标准数据dict，但是key，value必须是string或bytes
    assert sta
    for line in open(sys.argv[1]):
        line=line.strip()
        if line.startswith("http://"):
        	#判断每行是否以http://开头
            url=line
            (isOk,content)=downloadFunc(url)
            if isOk:
                bytes=bzipCompression(content)
                #启用bzip压缩
                outDb.setdefault(url,bytes)
                #设置key和value
            else:
                print "fail to download:",url

    maxCount=10
    for url,bytes in outDb.iteritems():
        content=bzipDecompression(bytes)
        #启用bzip解缩
        curCount=0
        print url
        for line in content.split("\n"):
            curCount+=1
            if curCount>maxCount:
                break
            print line

    outDb.close()
    #关闭该db，并保持写入完全

