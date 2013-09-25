#!/usr/bin/env python
# -*- coding: UTF-8  -*-

"""docstring
"""

__revision__ = '0.1'

import sys,os

def usage():
    print "excelFile outFile"
    pass 

def error():
    usage()
    sys.exit(-1)


import xlrd
#外来模块,必须先安装该模块才行

if __name__=="__main__":

    argvNum=3
    if len(sys.argv)<argvNum:
        error()   
    inf=sys.argv[1]
    outf=sys.argv[2]
    wb = xlrd.open_workbook(inf)
    #打开excel文档
    sh = wb.sheet_by_index(0)
    #按index获取第一个sheet
    #sh = wb.sheet_by_name(u'Sheet1')
    #按name获取对应sheet

    w=open(outf,'w')
    for rownum in range(sh.nrows):#产生从[0,sh.nrows)的整数
    	#该sheet总共有数据的行数
        for rcolnum in range(sh.ncols):
        	#该sheet总共有数据的列数
        	value=sh.cell(rownum,rcolnum).value
        	#cell可以看出是二维数据,从0开始
        	if isinstance(value,unicode):
        		value=value.encode('utf-8')
        	elif isinstance(value,int):
        		value="%d"%(value)
        	elif isinstance(value,float):
        		value="%f"%(value)   
		else:
			value=str(value)
		
		w.write("%s\t"%value)
	w.write("\n")
           
    #按写的模式，打开文件outf
   

    w.close()
    #写入内容
    #'\n'.join(out) 为split('\n')的逆运算
	

