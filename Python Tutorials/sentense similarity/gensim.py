import string
import re
import nltk
from nltk.corpus import wordnet as wn
from nltk.corpus import wordnet_ic
from nltk.decorators import memoize

def preprocess(text):
    """
    Helper function to preprocess text (lowercase, remove punctuation etc.)
    """
    text = text.translate(None, string.punctuation)
    words = filter(None, re.split('\s+', text))
    words = nltk.pos_tag(words)
    words = [(word.lower(), nltk.simplify_wsj_tag(tag)) for word, tag in words]
    words = [(word, 'V') if tag.startswith('V') else (word, tag)
             for word, tag in words]
    return words

class SimilarityCalculator:

    SIMILARITIES = {'path' : lambda s1, s2, ic: s1.path_similarity(s2),
                    #'lch' : lambda s1, s2, ic: s1.lch_similarity(s2),
                    'wup' : lambda s1, s2, ic: s1.wup_similarity(s2),
                    #'res' : lambda s1, s2, ic: s1.res_similarity(s2, ic),
                    #'jcn' : lambda s1, s2, ic: s1.jcn_similarity(s2, ic),
                    'lin' : lambda s1, s2, ic: s1.lin_similarity(s2, ic)
                    }

    def __init__(self, collection, sim_measure, ic):
        self.pos_tags = ['N', 'V']
        self.wn_pos_tags = [wn.NOUN, wn.VERB]
        self.collection = collection
        self.sim_measure = SimilarityCalculator.SIMILARITIES[sim_measure]
        self.ic = ic
        self.cache = {}

    def word_similarity(self, word1, word2, pos_tag):
        if (word1, word2, pos_tag) in self.cache:
            return self.cache[(word1, word2, pos_tag)]
        elif (word2, word1, pos_tag) in self.cache:
            return self.cache[(word2, word1, pos_tag)]
        else:
            wn_pos_tag = self.wn_pos_tags[self.pos_tags.index(pos_tag)]
            synsets1 = wn.synsets(word1, wn_pos_tag)
            synsets2 = wn.synsets(word2, wn_pos_tag)
            if not synsets1 or not synsets2:
                sim = 0
            else:
                sim = max(self.sim_measure(sense1, sense2, self.ic) or 0
                           for sense1 in synsets1 for sense2 in synsets2)
            self.cache[(word1, word2, pos_tag)] = sim
            return sim

    def max_similarity(self, word, words, pos_tag):
        a = max(self.word_similarity(word, other, pos_tag)
                   for other in words) if words else 0
        print word, words, a
        return a

    def similarity(self, *sentences):
        pos_sets = {}
        for tag in self.pos_tags:
            pos_sets[tag] = [[word for word, pos_tag in sentence
                              if pos_tag == tag] for sentence in sentences]
        sim = sum(sum(self.max_similarity(word, pos_sets[tag][1], tag) *
                      self.collection.idf(word)
                      for word in pos_sets[tag][0]) for tag in self.pos_tags)
        denom = sum(sum(self.collection.idf(word) for word in pos_sets[tag][0])
                    for tag in self.pos_tags)
        if denom > 0:
            sim /= denom
        return sim

    def similarity_bidirectional(self, sentence1, sentence2):
        return (self.similarity(sentence1, sentence2) +
                self.similarity(sentence2, sentence1)) / 2

# def test():
col = nltk.TextCollection(nltk.corpus.brown)
brown_ic = wordnet_ic.ic('ic-brown.dat')
sc = SimilarityCalculator(col, 'wup', brown_ic) # ,bp
sentence1 = preprocess("The jurors were taken into the courtroom in groups of 40 and asked to fill out a questionnaire.")
sentence2 = preprocess("About 120 potential jurors were being asked to complete a lengthy questionnaire.")
print sc.similarity_bidirectional(sentence1, sentence2)

#if __name__ == "__main__":
    #test()