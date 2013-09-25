# -*- coding: utf-8 -*-
"""
Created on Tue Mar 06 02:41:22 2012

@author: Wu Lingfei
"""
import re
import csv
import time
import numpy as np
# import win32com.client
import gdata.youtube
import gdata.youtube.service

address = "D:/research/dissertation/youtubeData/"


def getVideoList (username):
    try:
        url = 'http://gdata.youtube.com/feeds/api/users/'+username+'/uploads'
        yt_service = gdata.youtube.service.YouTubeService()
        #yt_service.ssl = True
        feed = yt_service.GetYouTubeVideoFeed(url)
        urls = []
        for entry in feed.entry:
            tu = entry.GetSwfUrl()
            tv = re.split("version",re.split("/v/",tu)[1])[0][:-1]
            tt = 'http://www.youtube.com/watch?v='+tv
            urls.append(tt)
        return(np.array(urls))
    except:
        return(np.array(['non']))


def getVideoViews (url) :
    try:
        ie6=win32com.client.Dispatch("InternetExplorer.Application")
        ie6.Navigate(url)
        # open IE
        #ie6.Visible = 1 #if you want to see the explore brower 
        while ie6.Busy:
            time.sleep(2)
        document=ie6.Document
        document.getElementById("watch-insight-button").click()
        time.sleep(2)
        #click the view statistics
        tt = document.body.innerHTML
        tt = unicode(tt)
        tt = tt.encode('ascii','ignore')
        ie6.Quit()
        # obtain the body of html, convert it to string and close IE
        p1 = re.findall('src="http://chart.apis.google.com/.+', tt)
        p2 = re.findall('Total views.*H4', tt)
        vs = re.split('\<',re.split('Total views:',p2[0])[1])[0]
        vs = vs.replace(',','')
        vs = float(vs.strip())       
        # get the max value of y axis
        v = p1[0]
        t1 = re.findall('chxl.*chxp', v)
        t2 = re.split('&amp',re.split('chxl=1:|',t1[0])[1])[0]
        startdate = t2[1:9]
        enddate = t2[-8:]
        # get the starting and ending dates of records
        d1 = re.findall('chd.*amp', v)
        d2 = re.split('&amp',re.split('chd=t:',d1[0])[1])[0]
        d3 = re.split(",",d2)
        d4 = np.array(map(float,d3))/100
        maxvl = vs/d4[-1]
        data = d4*maxvl
        #get the 100 data points provided by youtube
        data = np.append(np.array([startdate,enddate]),data)
        if len(data) < 102:
            data = np.append(data,np.tile("0",102-len(data)))
            return(data)
        else:
            return(data)
    except:
        return np.append(np.array(["start","end"]),np.tile("0",100))

def getUserViews (username):
    try:
        tu = getVideoList(username)
        td = map(getVideoViews, tu)
        for i in np.arange(len(tu)):
            td[i] = np.append(tu[i],td[i])
        add = address + username + '.csv'
        file = open(add,'wb')
        w = csv.writer(file,delimiter=',',quotechar='|', quoting=csv.QUOTE_MINIMAL)
        w.writerows(td)
        file.close()
    except:
        pass

    
start = time.clock()
getUserViews('TJPU609')
print time.clock()-start
