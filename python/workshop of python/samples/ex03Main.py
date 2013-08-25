#!/usr/bin/env python
# -*- coding: UTF-8  -*-

"""docstring
"""

__revision__ = '0.1'

import sys,os

def usage():
    print "inputFile inputDecode outputEncode"
    pass 

def error():
    usage()
    sys.exit(-1)

def deCoding(content,code):
    if isinstance(content,str):
    	#判断是否为string类型
        content=content.decode(code)
        #为string类型按照code进行解码，解码后为unicode类型
    return content

def enCoding(content,code):
    if isinstance(content,unicode):
    	#判断是否为unicode 类型
        content=content.encode(code)
        #为unicode类型按照code进行编码，编码后为string类型
        
    return content

def readLines(inf,decode,encode):
    for line in open(inf):
        line=deCoding(line,decode)
        #对中文进行解码decode
        line=line.strip()
        #去除line两端多余的空符号(包括tab/space/换行等)
        if len(line)==0:
            continue
        info=line.split()
        #把line按它们之间的空格切割开，现成数组
        count=0
        for ch in info:
            count+=len(ch)
        print "[%d]%s"%(count,enCoding(line,encode))

if __name__=="__main__":

    argvNum=4
    if len(sys.argv)<argvNum:
        error()
        
    inf=sys.argv[1]

    
    decode=sys.argv[2]
    encode=sys.argv[3]
    readLines(inf,decode,encode)

