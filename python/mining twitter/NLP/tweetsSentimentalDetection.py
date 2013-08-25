# -*- coding: utf-8 -*-
"""
Created on Wed Apr 25 14:53:43 2012

@author: comm
"""
import nltk
#from nltk.classify.naivebayes import NaiveBayesClassifier
#from nltk.probability import ELEProbDist
#import numpy as np

pos_tweets = [('I love this car', 'positive'),
              ('This view is amazing', 'positive'),
              ('I feel great this morning', 'positive'),
              ('I am so excited about the concert', 'positive'),
              ('He is my best friend', 'positive')]
neg_tweets = [('I do not like this car', 'negative'),
              ('This view is horrible', 'negative'),
              ('I feel tired this morning', 'negative'),
              ('I am not looking forward to the concert', 'negative'),
              ('He is my enemy', 'negative')]
tweets = []
for (words, sentiment) in pos_tweets + neg_tweets:
    words_filtered = [e.lower() for e in words.split() if len(e) >= 3]
    tweets.append((words_filtered, sentiment))

def get_words_in_tweets(tweets):
    all_words = []
    for (words, sentiment) in tweets:
      all_words.extend(words)
    return all_words

def get_word_features(wordlist):
    wordlist = nltk.FreqDist(wordlist)
    word_features = wordlist.keys()
    return word_features
    
word_features = get_word_features(get_words_in_tweets(tweets))

def extract_features(document):
    document_words = set(document)
    features = {}
    for word in word_features:
      features['contains(%s)' % word] = (word in document_words)
    return features

t1=[]
t2=[]
for i in tweets:
    t1.append(i[0])
    t2.append(i[1])

ts = map(extract_features, t1)

training_set=range(len(ts))

for i in range(len(ts)):
    training_set[i]=(ts[i],t2[i])

classifier = nltk.NaiveBayesClassifier.train(training_set)



tweet = 'you are horrible'
print classifier.classify(extract_features(tweet.split()))









