#!/usr/bin/env python
# -*- coding: UTF-8  -*-
#linux下运行该脚本所需
#告诉python解析器，本脚本采用utf-8编码

"""docstring
"""
#本脚本功能描述

__revision__ = '0.1'
#本脚本版本号

import sys,os
#使用python 对应的模块



if __name__=="__main__":
#本脚本的main入口
    while True:
        try:
        #raw_input会抛出一些异常。
            r=raw_input("hello world:>")
            #从键盘读入字符
            print r
            #打印该字符
        except:
        #捕抓EOFError该类异常即win下ctrl+z 或linux下 ctrl+d
        	print 'end'
        	pass

