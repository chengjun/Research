# !/usr/bin/env python
# -*- coding: UTF-8  -*-
# GetSina Weibo Repost_timeline
# Author: chengjun wang
# 20120328@Canberra

'''
http://docs.python.org/release/3.1.5/howto/functional.html
'''

# A recursive generator that generates Tree leaves in in-order.
def inorder(t):
    if t:
        for x in inorder(t.left):
            yield x

        yield t.label

        for x in inorder(t.right):
            yield x
