# !/usr/bin/env python
# -*- coding: UTF-8  -*-
# Parse html files using BeautifulSoup
# Author: chengjun wang
# 20130825@HK, Amoy

import bs4
from bs4 import BeautifulSoup
import os
import csv
import sys
import lxml

reload(sys)
sys.setdefaultencoding('utf8')

addressForSavingData= "D:/Research/Dropbox/Crystal_RA_Job/data/ashoka/ashoka_data_cleaningSep1.csv"   
file = open(addressForSavingData,'wb') # save to csv file 

addressForSavingError = "D:/Research/Dropbox/Crystal_RA_Job/data/ashoka/ashokaError1.csv"  
errorlog = open(addressForSavingError,'w')
errorlog.close()   

#soup = BeautifulSoup(open('D:/Research/Dropbox/Crystal_RA_Job/data/ashoka/test/sunita-bagal.html'))
try:
    dir_path = ('D:/Research/Dropbox/Crystal_RA_Job/data/ashoka/test') # ashoka\result
    for dir_entry in os.listdir(dir_path):
        dir_entry_path = os.path.join(dir_path, dir_entry)
        soup = BeautifulSoup(open(dir_entry_path))
        try:
            """1. Get the basic information"""
            name = soup.h2.next_element.replace('\n', ' ').strip()  # get the name
            print name.encode('utf8')
            
            try:
                category = soup.find('div','fellow-field-of-work').find('a').next_element
            except:
                pass
            
            try:
                category = soup.find('div','fellow-field-of-work').find('a')
            except:
                pass            
            
            subsectors = ''
            targets = ''
            
            try:
                subsector = []
                for f in soup.find('div','fellow-subsectors').find_all('a'):
                    el = f.next_element
                    subsector.append(el)
                subsectors = ';'.join(subsector)
                
                target = []
                for f in soup.find('div','fellow-target').find_all('a'):
                    el = f.next_element
                    target.append(el)
                targets = ';'.join(target)
            except:
                print "No subsector or no target!"
            finally:
                pass
            
            try:
                organization = soup.h4.next_element.replace('\n', ' ').strip() 
            except:
                organization = ''
                pass
            
            location1 = soup.h5.next_element
            location2 = soup.h5.a.next_element
            
            try:
                profileIntro = soup.find('div','field field-type-text field-field-profile-introduction').p.next_element.next_element.replace('\n', ' ').strip()
            except:
                pass
            
            try:
                profileIntro = soup.find('div','field field-type-text field-field-profile-introduction').em.next_element.next_element.replace('\n', ' ').strip()
            except:
                pass
            
            year_fellowship = soup.find('div',style = 'margin: 0px 0px 0px 20px;').i.next_element.replace('\n', ' ').strip()
            
            """2. Get background information"""
            person = str(soup.find_all('div',id = 'profile-person'))
            
            person = person.strip('[<div id="profile-person">').replace('<span class="read-more">...\xc2\xa0<a href="javascript:void(null);" style="text-decoration: none"><strong>Read More [+]</strong></a></span>\n<span class="details">', '').replace('<br/><br/> </span>\n</div>]', '').replace('<br/><br/>','').replace('\n', ' ').strip()
            
            strategy = str(soup.find_all('div',id = 'profile-strategy'))
            
            strategy = strategy.strip('[<div id="profile-strategy">').replace('<span class="read-more">...\xc2\xa0<a href="javascript:void(null);" style="text-decoration: none"><strong>Read More [+]</strong></a></span>\n<span class="details">', '').replace('<br/><br/> </span>\n</div>]', '').replace('<br/><br/>','').replace('\n', ' ').strip()
            
            problem = str(soup.find_all('div',id = 'profile-problem'))
            
            problem = problem.strip('[<div id="profile-strategy">').replace('<span class="read-more">...\xc2\xa0<a href="javascript:void(null);" style="text-decoration: none"><strong>Read More [+]</strong></a></span>\n<span class="details">', '').replace('<br/><br/> </span>\n</div>]', '').replace('<br/><br/>','').replace('\n', ' ').strip()
            
            
            idea = str(soup.find_all('div',id = 'new-ideas'))
            
            idea = idea.strip('[<div id="new-ideas">').replace('<span class="read-more">...\xc2\xa0<a href="javascript:void(null);" style="text-decoration: none"><strong>Read More [+]</strong></a></span>\n<span class="details">', '').replace('<br/><br/> </span>\n</div>]', '').replace('<br/><br/>','').replace('\n', ' ').strip()
            
            
            introduction = str(soup.find_all('div',id = 'introduction'))
            
            introduction = introduction.strip('[<div id="introduction">').replace('<span class="read-more">...\xc2\xa0<a href="javascript:void(null);" style="text-decoration: none"><strong>Read More [+]</strong></a></span>\n<span class="details">', '').replace('<br/><br/> </span>\n</div>]', '').replace('<br/><br/>','').replace('\n', '').replace('</p></div>]', '').replace('<p>', '').replace('/n', ' ').strip()
            
            """3. Get the 4 related people information"""
            rname = []
            rorg= []
            for r in soup.find_all('td')[0:4]:   # Take care here!
                ap_rname = r.find_all('span')[1].a.next_element
                ap_rorg = r.find_all('span')[2].next_element
                rname.append(ap_rname)
                rorg.append(ap_rorg)
            rnames = ';'.join(rname).replace('\n', ' ').strip()
            rorgs = ';'.join(rorg).replace('\n', ' ').strip() 
            
            """Write 16 variables to csv: Separated with | and semicolons"""
            print >>file, "%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s"  % (name, category, subsectors, targets, organization, location1, location2, profileIntro, year_fellowship, introduction, idea, problem, strategy, person, rnames, rorgs)    
        except:
            e =  "The backgroud information is not complete"    
            errorlog = open(addressForSavingError, 'a')
            print >>errorlog, "%s,%s"  % (name, e)
            errorlog.close()   
except:
    er =  "The read section went wrong"    
    errorlog = open(addressForSavingError, 'a')
    print er
    print >>errorlog, "%s,%s"  % (name, er)
    errorlog.close()
finally:
    pass

file.close()	    

