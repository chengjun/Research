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


reload(sys)
sys.setdefaultencoding('utf8')

addressForSavingData= "D:/Research/Dropbox/Crystal_RA_Job/data/Schwab/Schwab_data_cleaningSep.csv"    
file = open(addressForSavingData,'wb') # save to csv file 

addressForSavingError = "D:/Research/Dropbox/Crystal_RA_Job/data/Schwab/SchwabError.csv"  
errorlog = open(addressForSavingError,'w')
errorlog.close()   

#soup = BeautifulSoup(open('D:/Research/Dropbox/Crystal_RA_Job/data/Schwab/result/martin-andrade.html'))

dir_path = ('D:/Research/Dropbox/Crystal_RA_Job/data/Schwab/result') # ashoka\result
for dir_entry in os.listdir(dir_path):
    dir_entry_path = os.path.join(dir_path, dir_entry)
    soup = BeautifulSoup(open(dir_entry_path))
    
    """1. Get the name"""
    name = soup.h1.next_element  # get the name
    print name.encode('utf8')
    
    """2. Get the field description"""
    field = soup.find_all("div", "field-item even")

    try:
        organization= soup.find('div','field field-name-field-org-public-name field-type-text field-label-inline clearfix').find('div', 'field-item even').next_element
    except:
        organization = ''
        print 'The basic information is not complete'          
        pass
    try:
        year = soup.find('div','field field-name-field-year-founded field-type-number-integer field-label-inline clearfix').find('div', 'field-item even').next_element
    except:
        year = ''
        print 'The basic information is not complete'           
        pass
    try:
        country = soup.find('div','field field-name-field-country field-type-text field-label-inline clearfix').find('div', 'field-item even').next_element
    except:
        country = ''
        print 'The basic information is not complete'                   
        pass
    try: 
        website = soup.find('div','field field-name-field-website field-type-text field-label-inline clearfix').find('div', 'field-item even').next_element.next_element.strip()
    except:
        website = ''
        print 'The basic information is not complete'                   
        pass    
       
    """3. Get the short description"""
    shortIntro = soup.find('div','field field-name-body field-type-text-with-summary field-label-hidden').b.next_element
    
    #print shortIntro.encode('utf8')
    
    """4. Get the keyword info"""
    keywords = soup.find('div','field field-name-body field-type-text-with-summary field-label-hidden').find_all("b") #the length is not fixed!!!!!!:<#
    
    """5. Get the backgroud info""" 
    focus = ''
    geo = ''
    model = ''
    benefit = ''
    budget = ''
    revenue = ''
    recognization = ''  
    background = '' 
    innovation = '' 
    entrepreneur = '' 
    contents = []
    try:
        for n in keywords[1:len(keywords)]:
                if n.next_element.strip(':')== 'Focus':
                    focus = n.next_sibling.strip()
                elif n.next_element.strip(':')== 'Geographic Area of Impact':
                    geo = n.next_sibling.strip()
                elif n.next_element.strip(':')== 'Model':
                    model = n.next_sibling.strip() 
                elif n.next_element.strip(':')== 'Number of Direct Beneficiaries':
                    benefit = n.next_sibling.strip()
                elif n.next_element.strip(':')== 'Annual Budget':
		    try:
			budget = n.next_sibling.strip()
		    except:
			budget = ''
                elif n.next_element.strip(':')== 'Percentage Earned Revenue':
                    revenue = n.next_sibling.strip()
                elif n.next_element.strip(':')== 'Recognition':       
                    recognization = n.next_sibling.strip()
                    
                elif n.next_element.strip(':') == 'Background':
                    title_content = str(n.next_sibling.next_sibling.encode('utf8').strip())
                    contents = [title_content]
                    for f in n.parent.find_next_siblings():
                        el = str(f.next_element.encode('utf8'))
                        if isinstance(el, bs4.element.Tag) and el.name == 'b':
                            break
                        contents.append(el)  
                    background = ''.join(contents).strip() 
                    contents = []
                elif n.next_element.strip(':') == 'Innovation and Activities':
                    title_content = str(n.next_sibling.next_sibling.encode('utf8').strip())
                    contents = [title_content]
                    for f in n.parent.find_next_siblings():
                        el = str(f.next_element.encode('utf8'))
                        if isinstance(el, bs4.element.Tag) and el.name == 'b':
                            break
                        contents.append(el)                 
                    innovation = ''.join(contents).strip().strip('<b>The Entrepreneur</b>').strip('<b>The Entrepreneurs</b>')
                    contents = []
                elif n.next_element.strip(':') == 'The Entrepreneur':
                    title_content = str(n.next_sibling.next_sibling.encode('utf8').strip())
                    contents = [title_content]
                    for f in n.parent.find_next_siblings():
                        el = str(f.next_element.encode('utf8'))
                        if isinstance(el, bs4.element.Tag) and el.name == 'b':
                            break
                        contents.append(el)                
                    entrepreneur = ''.join(contents).strip()  
                    contents = []
		elif n.next_element.strip(':') == 'The Entrepreneurs':
		    title_content = str(n.next_sibling.next_sibling.encode('utf8').strip())
		    contents = [title_content]
		    for f in n.parent.find_next_siblings():
			el = str(f.next_element.encode('utf8'))
			if isinstance(el, bs4.element.Tag) and el.name == 'b':
			    break
			contents.append(el)                
		    entrepreneur = ''.join(contents).strip()  
		    contents = []		    
		    
		else:
		    pass
                    
        """Write 16 variables to csv: Separated with | and quotation marks"""
	print >>file, "%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s"  % (name, organization, year, country, website, shortIntro, focus, geo, model, benefit, budget, revenue, recognization, background, innovation, entrepreneur)
        #print >>file, "'%s'|'%s'|%s|'%s'|'%s'|'%s'|'%s'|'%s'|'%s'|'%s'|'%s'|'%s'|'%s'|'%s'|'%s'|'%s'"  % (name, organization, year, country, website, shortIntro, focus, geo, model, benefit, budget, revenue, recognization, background, innovation, entrepreneur)
	
    except:
        e =  "The backgroud information is not complete"    
	errorlog = open(addressForSavingError, 'a')
	print >>errorlog, "%s,%s"  % (name, e)
	errorlog.close()        
file.close()	

"""Reference"""
    
#http://www.lovelucy.info/python-crawl-pages.html
#http://www.crummy.com/software/BeautifulSoup/bs4/doc/

#htmltext = "<p><b>Background</b><br />x1</p><p><b>Innovation</b><br />x2</p><p>x3</p><p>x4</p><p><b>Activitis</b><br />x5</p><p>x6</p>"
#html = BeautifulSoup(htmltext)

#for n in html.find_all('b'):
    #title_name = n.next_element
    #title_content = n.next_sibling.next_sibling    
    #results = [title_content]
    #for f in n.parent.find_next_siblings():
        #el = f.next_element
        #if isinstance(el, bs4.element.Tag) and el.name == 'b':
            #break
        #results.append(el)
    #print title_name, results
    
    
#def findparagraphs(keyid):
	#key = keyid.parent
	#title_content = key.next_sibling.next_sibling.encode('utf8')
	#contentt = [title_content]
	#for f in key.parent.find_next_siblings():
	    #el = f.next_element.encode('utf8')
	    #if isinstance(el, bs4.element.Tag) and el.name == 'b':
		#break
	    #contentt.append(el)
	    #contentt = ''.join(contentt) 
	#return contentt