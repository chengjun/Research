#!/usr/bin/env python
# -*- coding: UTF-8  -*-

from mechanize import Browser
import re
import sys

class GetPIN():
    def __init__(self,url,username, password):
        self.br = Browser()
        self.br.set_handle_equiv(False)
        self.br.set_handle_robots(False)
        self.url = url
        self.username = username
        self.password = password
 
    def getPIN(self):
        self.br.open(self.url)
        try:
            self.br.select_form(name="authZForm")
            self.br['userId'] = self.username
            self.br['passwd'] = self.password
            response = self.br.submit()
            data = response.readlines()
        except:
            data = self.br.response().readlines()
        pattern = r'<span class="fb">(.*?)</span>' 
        pat = re.compile(pattern)
        for line in data:
            if pat.search(line):
                verifier = pat.findall(line)
                break
        if len(verifier):
            return verifier[0]
        else:
            return -1
 
if __name__ == "__main__":
    print "This is a Module"
    sys.exit(-1)