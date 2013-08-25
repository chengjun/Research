#!/usr/bin/env python
# -*- coding: UTF-8  -*-

"""docstring
"""

__revision__ = '0.1'

import sys,os

def usage():
    print "inputFile"
    pass 

def error():
    usage()
    sys.exit(-1)


def readLines(inf):
    dictInfo={}
    #使用字典数据结构
    for line in open(inf):
        line=line.strip()
        if len(line)==0:
            continue
        words=line.split()
        for word in words:
            times=dictInfo.setdefault(word,0)
            #如果key=word不在字典里，则设置该value为0，如果key在字典里，不进行操作
            dictInfo[word]=times+1
            #对于key=word对应的value进行更新

    for word,times in dictInfo.iteritems():
    	#按照key,value的方式迭代的从字典里取出
        print "[%s]:%d"%(word,times)
        #格式化打印%d表示打印的内容是int，%s表示打印内容是string

if __name__=="__main__":

    argvNum=2
    if len(sys.argv)<argvNum:
        error()
    inf=sys.argv[1]
    readLines(inf)

