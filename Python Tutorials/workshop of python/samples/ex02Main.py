#!/usr/bin/env python
# -*- coding: UTF-8  -*-

"""docstring
"""

__revision__ = '0.1'

import sys,os

def usage():
#定义函数usage
    print "inputFile"
    pass 

def error():
    usage()
    sys.exit(-1)
    #强制该脚本马上结束，并返回-1作为error code

def readLines(inf):
    for line in open(inf):
    #打开文件inf，并按行读入
        print line

if __name__=="__main__":

    argvNum=2
    if len(sys.argv)<argvNum:
    #获取命令行的参数，sys.argv为数组，len(list)为求该数组list的元素个数。
        error()
    print sys.argv[0]    
    inf=sys.argv[1]
    
    #sys.argv的index从0开始，但是sys.argv[0]为该脚本的名字
    readLines(inf)
    #函数传递按照引用(即c里面的指针)的方法传递。
    #如果该参数引用的值本身不能改变如string类/int类，可以看成是pass by value
    #如果该参数引用的值能改变如数组，可以看成是pass by reference

