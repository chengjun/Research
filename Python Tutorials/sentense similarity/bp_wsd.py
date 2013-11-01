from nltk.corpus import wordnet as wn
from nltk.corpus import stopwords
import re

gloss_rel = lambda x: x.definition
example_rel = lambda x: " ".join(x.examples)
hyponym_rel = lambda x: " ".join(w.definition for w in x.hyponyms())
meronym_rel = lambda x: " ".join(w.definition for w in x.member_meronyms() + \
                                 x.part_meronyms() + x.substance_meronyms())
also_rel = lambda x: " ".join(w.definition for w in x.also_sees())
attr_rel = lambda x: " ".join(w.definition for w in x.attributes())
hypernym_rel = lambda x: " ".join(w.definition for w in x.hypernyms())

relpairs = {wn.NOUN: [(hyponym_rel, meronym_rel), (meronym_rel, hyponym_rel),
                      (hyponym_rel, hyponym_rel),
                      (gloss_rel, meronym_rel), (meronym_rel, gloss_rel),
                      (example_rel, meronym_rel), (meronym_rel, example_rel),
                      (gloss_rel, gloss_rel)],
            wn.ADJ: [(also_rel, gloss_rel), (gloss_rel, also_rel),
                     (attr_rel, gloss_rel), (gloss_rel, attr_rel),
                     (gloss_rel, gloss_rel),
                     (example_rel, gloss_rel), (gloss_rel, example_rel),
                     (gloss_rel, hypernym_rel), (hypernym_rel, gloss_rel)],
            wn.VERB:[(example_rel, example_rel),
                     (example_rel, hypernym_rel), (hypernym_rel, example_rel),
                     (hyponym_rel, hyponym_rel),
                     (gloss_rel, hyponym_rel), (hyponym_rel, gloss_rel),
                     (example_rel, gloss_rel), (gloss_rel, example_rel)]}

def preprocess(text):
    """
    Helper function to preprocess text (lowercase, remove punctuation etc.)
    """
    words = re.split('\s+', text)
    punctuation = re.compile(r'[-.?!,":;()|0-9]')
    words = [punctuation.sub("", word) for word in words]
    words = filter(None, words)
    words = [word.lower() for word in words]
    words = [word for word in words if not word in stopwords.words('english')]
    return words

def lcs(S1, S2):
    """
    Helper function to compute length and offsets of longest common substring of
    S1 and S2. Uses the classical dynamic programming algorithm.
    Shamelessly copied off Wikibooks.
    """
    M = [[0]*(1+len(S2)) for i in xrange(1+len(S1))]
    longest, x_longest, y_longest = 0, 0, 0
    for x in xrange(1,1+len(S1)):
        for y in xrange(1,1+len(S2)):
            if S1[x-1] == S2[y-1]:
                M[x][y] = M[x-1][y-1] + 1
                if M[x][y]>longest:
                    longest = M[x][y]
                    x_longest = x
                    y_longest = y
            else:
                M[x][y] = 0
    return longest, x_longest - longest, y_longest - longest

def score(gloss1, gloss2):
    """
    Compute score between two glosses based on length of common substrings.
    """
    gloss1 = preprocess(gloss1)
    gloss2 = preprocess(gloss2)
    curr_score = 0
    longest, start1, start2, = lcs(gloss1, gloss2)
    while longest > 0:
        gloss1[start1 : start1 + longest] = []
        gloss2[start2 : start2 + longest] = []
        curr_score += longest ** 2
        longest, start1, start2, = lcs(gloss1, gloss2)
    return curr_score

def relatedness(sense1, sense2, relpairs):
    """
    Compute the relatedness of two senses (synsets) using the list of pairs of
    relations in relpairs.
    """
    return sum(score(pair[0](sense1), pair[1](sense2)) for pair in relpairs)

def wsd(context, target, winsize, pos_tag):
    """
    Find the best sense for a word in a given context.

    Arguments:
    context - sentence(s) we are analyzing; expected as list of strings
    target  - string representing the word whose senses we're trying to
              disambiguate. Target is assumed to occur once in sentence. In case
              of multiple occurences, the first one is considered. Will throw
              ValueError if target is not in sentence
    winsize - size of window used for disambiguating. The algorithm will only
              look at winsize words of the appropriate part-of-speech around the
              target word
    pos_tag - part of speech of target word
    """
    context = filter(None, [wn.synsets(word, pos=pos_tag) for word in context])
    target_synsets = wn.synsets(target, pos=pos_tag)
    pos = context.index(target_synsets)
    window = context[max(pos - winsize, 0) : pos] + \
             context[pos + 1 : min(pos + winsize + 1, len(context))]
    sense_scores = [sum(sum(relatedness(sense, other_sense, relpairs[pos_tag])
                              for other_sense in senses)
                   for senses in window) for sense in target_synsets]
    best_score = max(sense_scores)
    best_index = sense_scores.index(best_score)
    return target_synsets[best_index], best_score

def test():
    sentence = "I went fishing for some sea bass"
    sentence = preprocess(sentence)
    sense, score = wsd(sentence, "bass", 3, wn.NOUN)
    print "best score was {} by synset {} (definition = '{}')".format(
        score, sense, sense.definition)

if __name__ == "__main__":
    test()