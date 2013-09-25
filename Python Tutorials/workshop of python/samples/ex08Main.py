#!/usr/bin/env python
# -*- coding: UTF-8  -*-

"""docstring
"""

__revision__ = '0.1'

import sys,os
from common import readDb,bzipDecompression

def usage():
    print "inDbFile url"
    pass 

def error():
    usage()
    sys.exit(-1)


import re
#使用正则表达式
pattern=r'<[^<>]*>'
matcher=re.compile(pattern)



if __name__=="__main__":

    argvNum=3
    if len(sys.argv)<argvNum:
        error()
    inDbFile=sys.argv[1]
    (sta,inDb)=readDb(inDbFile)
    assert sta
    url=sys.argv[2]
    bytes=inDb.get(url,None)
    if bytes:
        content=bzipDecompression(bytes)
        content=matcher.sub('',content)
        print content
    else:
        print "inDbFile:%s does not contain url:%s"%(inDbFile,url)

    inDb.close()

