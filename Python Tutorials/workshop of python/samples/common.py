#!/usr/bin/env python
# -*- coding: UTF-8  -*-

"""docstring
"""

__revision__ = '0.1'

import os
import bz2
import bsddb

def writeDb(outFile, isOverWrite=False, isAppend=False):
    if os.path.exists(outFile):
    	#判断是否存在文件outFile
        if isOverWrite:
            print "warning overwrite db:%s"% outFile
            db=bsddb.btopen(outFile,"n")
            #new 一个bdb即覆盖原有旧的db
            #read-write - truncate to zero length
            return  True, db
        elif not isAppend:
            print "warning db:%s exists exit"% outFile
            return False,  ""
        else:
            print "append db:%s" % outFile
    db=bsddb.btopen(outFile,"c")
    #append一个bdb，如果该bdb不存在create一个
    #read-write - create if necessary
    return True, db




def readDb(inFile):
    if not os.path.exists(inFile):
        print "error:db file:%s not found" % inFile
        return False , ""
    db=bsddb.btopen(inFile,"r")
    #只读(read only)
    return True, db


def bzipCompression(content):
    bytes=bz2.compress(content)
    #使用bzip压缩输出为bytes
    return bytes

def bzipDecompression(bytes):
    content=bz2.decompress(bytes)
    #使用bzip解缩输入为bytes
    return content
