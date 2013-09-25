# -*- coding: utf-8 -*-
"""
Programming for Linguists:
An Introduction to Python
15/12/2011
dowloand from http://www.clips.ua.ac.be/
"""

'''
Import the corpus 
'''
from nltk.corpus import movie_reviews
from random import shuffle
from nltk.classify import NaiveBayesClassifier

'''
Create a list of categorized documents
'''
documents = [(list(movie_reviews.words(fileid)), category) \
for category in movie_reviews.categories( ) for fileid in \
movie_reviews.fileids(category)]
'''
check
'''
print documents[:2]
'''
Shuffle your list of documents randomly
'''

shuffle(documents)
'''
Divide your data in training en test

''' 
train_docs = documents[:1800]

test_docs = documents[1800:]
'''
We only consider word unigram features here, so make a dictionary of all (normalized) words from the training data
'''
train_words = { }
for (wordlist, cat) in train_docs:
    for w in wordlist:
        w = w.lower()
        if w not in train_docs:
            train_words[w] = 1
        else:
            train_words[w] +=1
'''
check
'''
print len(train_words)            
'''
Define a feature extraction function

'''
def extract_features(wordlist):
    document_words = set(wordlist)
    features ={}
    for word in document_words:

        word = word.lower( )
        if word in train_words:

            features[word] = (word in document_words)
    return features

extract_features(movie_reviews.words('pos/cv957_8737.txt')) 
'''
Use your feature extraction function to extract all features from your training and test set 
'''
train_feats=[(extract_features(wordlist), cat) for (wordlist,cat) in train_docs]

test_feats=[(extract_features(wordlist), cat) for (wordlist,cat) in test_docs]
'''
Train e.g. NLTK’s Naïve Bayes classifier on the training set
'''

classifier = NaiveBayesClassifier.train(train_feats)

predicted_labels = classifier.batch_classify([fs for (fs, cat) in test_feats]) 
'''
Evaluate the model on the test set
''' 
print nltk.classify.accuracy(classifier, test_feats)

classifier.show_most_informative_features(20)
'''
another test
'''
review = 'Titanic left me with fond memories.' 
classifier.classify(extract_features(review.split()))


