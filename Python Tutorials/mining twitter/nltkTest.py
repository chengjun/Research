# nltkTest.py
# Twitter sentiment analysis using Python and NLTK
# original author: Laurent Luce
# Reproduced by chengjun wang to test the validity
# 20120319@Canberra

# find the original post by Laurent Luce following the link below:
# http://www.laurentluce.com/posts/twitter-sentiment-analysis-using-python-and-nltk/

import nltk

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

# print tweets
# print to see the result

test_tweets = [
	(['feel', 'happy', 'this', 'morning'], 'positive'),
	(['larry', 'friend'], 'positive'),
	(['not', 'like', 'that', 'man'], 'negative'),
	(['house', 'not', 'great'], 'negative'),
	(['your', 'song', 'annoying'], 'negative')]

# print test_tweets

# The list of word features need to be extracted from the tweets. It is a list with every distinct words
# ordered by frequency of appearance. We use the follow ing function to get the list plus the tw o helper
# functions.

def get_words_in_tweets(tweets):
	all_words = []
	for (words, sentiment) in tweets:
		all_words.extend(words)
	return all_words
def get_word_features(wordlist):
	wordlist = nltk.FreqDist(wordlist)
	word_features = wordlist.keys()
	return word_features
# what does word_features do?
word_features = get_word_features(get_words_in_tweets(tweets))
# print word_features


# To create a classifier, we need to decide what features are relevant. To do that, we first need a
# feature extractor. The one we are going to use returns a dictionary indicating what words are
# contained in the input passed. Here, the input is the tweet. We use the word features list defined
# above along with the input to create the dictionary.

def extract_features(document):
    document_words = set(document)
    features = {}
    for word in word_features:
      features['contains(%s)' % word] = (word in document_words)
    return features
	
# call the feature extractor with the document ['love', 'this', 'car'] 
# document=['love', 'this', 'car']
# features = extract_features(document)
# print features


training_set = nltk.classify.util.apply_features(extract_features, tweets)
# print training_set
# be careful here, it should be nltk.classify.util.apply_features rather than nltk.classify.apply_features
# apply the features to our classifier using the method apply_features.
# We pass the feature extractor along with the tweets list defined above.

# The variable training_set contains the labeled feature sets. It is a list of tuples which each tuple
# containing the feature dictionary and the sentiment string for each tweet. The sentiment string is 
# also called label.

classifier = nltk.NaiveBayesClassifier.train(training_set)
# look inside the classifier train method in the source code of the NLTK library

def train(labeled_featuresets, estimator=nltk.probability.ELEProbDist):  
    # Create the P(label) distribution
    label_probdist = estimator(label_freqdist)  
    # Create the P(fval|label, fname) distribution
    feature_probdist = {}
    return NaiveBayesClassifier(label_probdist, feature_probdist)

# print label_probdist.prob('positive')
# print label_probdist.prob('negative')

# print feature_probdist
# print feature_probdist[('negative', 'contains(best)')].prob(True)

# print classifier.show_most_informative_features(32)
# show_most_informative_features

tweet = 'Larry is not my friend'
# print classifier.classify(extract_features(tweet.split()))


# take a look at how the classify method works internally in the NLTK library. What we pass to the classify method is the feature set of
# the tweet we want to analyze. The feature set dictionary indicates that the tweet contains the word "friend".
print extract_features(tweet.split()), '\n'

# def classify(self, featureset):
    # Discard any feature names that we've never seen before.
    # Find the log probability of each label, given the features.
	# {'positive': -1.0, 'negative': -1.0}
	# Then add in the log probability of features given labels.
	# {'positive': -5.4785441837188511, 'negative': -14.784261334886439}
    # Generate a probability distribution dictionary using the dict logprod
	# DictionaryProbDist(logprob, normalize=True, log=True)
    # Return the sample with the greatest probability from the probability	
    # distribution dictionary

	
'''Taking the following test tweet 'Your song is annoying'. The classifier thinks it is positive.
The reason is that we don't have any information on the feature name annoying. 
Larger the training sample tweets is, better the classifier will be.'''	

# tweet = 'Your song is annoying'
print classifier.classify(extract_features(tweet.split()))


	
'''find the original post by Laurent Luce following the link below:
http://www.laurentluce.com/posts/twitter-sentiment-analysis-using-python-and-nltk/'''














