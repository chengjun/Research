#Copyright 2011, Adrian Nackov
#Released under BSD licence (3 clause): 
#http://www.opensource.org/licenses/bsd-license.php
#https://bitbucket.org/aeter/summrz/src/c57caa9d3599/summarizer/similarity.py

from nltk.corpus import wordnet
from nltk.cluster.util import cosine_distance
from math import log10, sqrt
import cPickle


class BrownCorpus(object):
    """
    Serializing/caching some stuff, in order not to
    have to precompute all the stuff all the time.
    """

    def __init__(self, use_serialized_stats=True):
        """
        Sets:
        -- self.word_freq -> How often a word is met in the Brown corpus
        -- self.word_count ->  How many words there are in the Brown corpus

        Side effects:
        -- writes the "FREQUENCY_FILE" in the current directory, if nonexistent 
        """

        FREQUENCY_FILE = 'brown_corpus_word_frequencies.pkl'
        WORD_COUNT = 1161192 # how many words are there in the corpus

        if not use_serialized_stats:
            from nltk.probability import FreqDist
            from nltk.corpus import brown
            self.word_count = len(brown.words())
            self.word_freq = FreqDist()
            for w in brown.words():
                self.word_freq.inc(w.lower())
            try:
                with open(FREQUENCY_FILE, 'wb') as f:
                    cPickle.dump(self.word_freq, f)
            except OSError, e:
                # Don nothing, but just warn
                print "Serializing Brown corpus stats failed: %s" % str(e)
        else:
            self.word_count = WORD_COUNT
            try:
                with open(FREQUENCY_FILE, 'rb') as f:
                    self.word_freq = cPickle.load(f)
            except EnvironmentError, e:
                print "Deserializing Brown Corpus stats failed: %s" % str(e)

    def information_content(self, word):
        """
        Per 4.2.2. of the cited paper of Li, McLean, Bandar...
        """
        return 1 - (log10(self.word_freq[word] + 1) /
                    log10(self.word_count + 1))

def word_similarity(w1, w2):
    """
    A crude algorithm to determine the distance between 2 words.
    """

    try:
        return get_synset(w1).wup_similarity(get_synset(w2))
    except IndexError: # no synsets for the word in wordnet
        return 0 # words aren't similar at all

def get_synset(word):
    '''
    Takes the first meaning of the word in the wordnet database/corpus:
    '''
    return wordnet.synsets(word)[0]

def sentence_similarity(words_s1, words_s2, use_semantics=False):
    if use_semantics: # way slower
        return _sentence_similarity(words_s1, words_s2)
    else:
        from preprocessing import Sentence
        from nltk.util import bigrams, trigrams
        sent1 = Sentence(' '.join(words_s1)).preprocess()
        sent2 = Sentence(' '.join(words_s2)).preprocess()
        # how many unigrams are in both sentences?
        num_unigrams = len([w for w in sent1.sci_data if w in sent2.sci_data])
        # how many bigrams are there in both sentences?
        bigrams_s1 = bigrams(sent1.sci_data)
        bigrams_s2 = bigrams(sent2.sci_data)
        num_bigrams = len([b for b in bigrams_s1 if b in bigrams_s2])
        # how many trigrams are there in both sentences?
        trigrams_s1 = trigrams(sent1.sci_data)
        trigrams_s2 = trigrams(sent2.sci_data)
        num_trigrams = len([t for t in trigrams_s1 if t in trigrams_s2])

        # give bigrams a weight factor of 2, trigrams a weight factor of 3:
        similarity = 1/\
                1 + (num_unigrams + pow(num_bigrams, 2) + pow(num_trigrams, 3))
        return similarity

def _sentence_similarity(words_s1, words_s2):
    """
    A function to be used for distance between 2 sentences.

    input:  ws1: vector of words for sentence 1
            ws2: vector of words for sentence 2

    output: a float of the similarity between the 2 sentences

    Uses the algorithm from the paper of Li, McLean, Bandar,
    O'Shea, Crockett. 
    """

    # calculate semantic similarity
    joint_words = words_s1 + [w for w in words_s2 if w not in words_s1]
    brown_corpus = BrownCorpus(use_serialized_stats=True)

    # derive it empirically...by trial and error. The paper used 0.2
    SIMILARITY_THRESHOLD = 0.15

    def get_semantic_vector(sentence_words):
        semantic_vector = []
        for w in joint_words:
            if w in sentence_words: 
                semantic_vector.append(1)
            else:
                max_similar = sorted(sentence_words,
                                     key=lambda word:word_similarity(word, w))[0]
                similarity_score = word_similarity(max_similar, w)
                if similarity_score < SIMILARITY_THRESHOLD:
                    similarity_score = 0
                semantic_vector.append(
                        similarity_score *
                        brown_corpus.information_content(max_similar) *
                        brown_corpus.information_content(w))
        return semantic_vector

    semantic_vector_s1 = get_semantic_vector(words_s1)
    semantic_vector_s2 = get_semantic_vector(words_s2)
    semantic_similarity = cosine_distance(semantic_vector_s1, semantic_vector_s2)

    # calculate word order similarity
    def get_word_order_vector(sentence_words):
        word_order_vector = []
        for w in joint_words:
            if w in sentence_words:
                word_order_vector.append(sentence_words.index(w))
            else:
                max_similar = sorted(sentence_words,
                                     key=lambda word:word_similarity(word, w))[0]
                similarity_score = word_similarity(max_similar, w)
                if similarity_score < SIMILARITY_THRESHOLD:
                    similarity_score = 0
                if similarity_score == 0:
                    word_order_vector.append(0)
                else:
                    word_order_vector.append(sentence_words.index(max_similar))
        return word_order_vector

    word_order_vector_s1 = get_word_order_vector(words_s1)
    word_order_vector_s2 = get_word_order_vector(words_s2)
    word_order_similarity = \
            length([(a-b) for a,b in zip(word_order_vector_s1,
                                         word_order_vector_s2)]) /\
            length([(a+b) for a,b in zip(word_order_vector_s1,
                                         word_order_vector_s2)])

    DELTA = 0.8 # Empirically derived, the paper used 0.85

    return DELTA * semantic_similarity + (1 - DELTA) * word_order_similarity

def length(vector):
    return sqrt(dot_product(vector, vector))

def dot_product(vector1, vector2):
    return sum((a*b) for a,b in zip(vector1, vector2))