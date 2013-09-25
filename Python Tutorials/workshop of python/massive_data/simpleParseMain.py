#!/usr/bin/env python
# -*- coding: UTF-8  -*-

"""docstring
"""

__revision__ = '0.1'

import sys,os

def usage():
    print "inXmlFile outFile"
    pass 

def error():
    usage()
    sys.exit(-1)


#def parse(value,data):#age
    #key="%f"%(age)
    #times=int(data.setdefault(key,'0'))
    #data[key]="%f"%(times+1)

def lineParse(line,record,fields):
    begin=line.find("<")
    end=line.find(">",begin)
    assert begin>=0 and end>=0
    tag=line[begin+1:end]
    assert tag in fields
    assert tag not in record
    nbegin=line.rfind("</")
    nend=line.find(">",nbegin)
    assert nbegin>=0 and nend>=0
    tag2=line[nbegin+2:nend]
    assert tag==tag2
    value=line[end+1:nbegin]
    record.setdefault(tag,value)
    
def formatWrite(dict,orderFields):
    tmp=[]
    for field in orderFields:
        value=dict.get(field,'null').replace("\t","%^&") # I modify here to change the format
        tmp.append(value)
    return tmp


personFields=[
"id",
"sex",
"address",
"fansNum",
"summary",
"wbNum",
"gzNum",
"blog",
"edu",
"work",
"renZh",
"brithday",
]

if __name__=="__main__":

    argvNum=3
    if len(sys.argv)<argvNum:
        error()


    fields=set(personFields)
    recordBegin=False

    out=open(sys.argv[2],'w')
    strOut="%s\n"%("\t".join(personFields))
    out.write(strOut.encode("utf-8"))
    #allData
    #for line in allData.split("\n")
    for line in open(sys.argv[1]):
        line=line.decode('utf-8')
        line=line.strip()
        if len(line)==0:
            continue
        if line.startswith("<person>"):
            record={}
            recordBegin=True
            continue
        elif line.startswith("</person>"):
            if len(record)==0:
                print "empty record"
            else:
                tmp=formatWrite(record,personFields)
                strOut="%s\n"%("\t".join(tmp))
                out.write(strOut.encode("utf-8"))
            recordBegin=False
        if recordBegin:
            assert line.startswith("<")
            assert line.endswith(">")
            lineParse(line,record,fields)

    out.close()
