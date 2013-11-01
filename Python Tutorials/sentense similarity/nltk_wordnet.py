#!/usr/bin/env python

from nltk.corpus import wordnet as wn

# nltk.download()

d = wn.synset('donation.n.01')
g = wn.synset('gift.n.01')

print "it works!"
print d.wup_similarity(g)

'''The cookbook recommends Wu-Palmer Similarity method'''


def getSenseSimilarity(worda,wordb):
	"""
	find similarity betwwn word senses of two words
	"""
	wordasynsets = wn.synsets(worda)
	wordbsynsets = wn.synsets(wordb)
	synsetnamea = [wn.synset(str(syns.name)) for syns in wordasynsets]
	synsetnameb = [wn.synset(str(syns.name)) for syns in wordbsynsets]

	for sseta, ssetb in [(sseta,ssetb) for sseta in synsetnamea\
	for ssetb in synsetnameb]:
		pathsim = sseta.path_similarity(ssetb)
		wupsim = sseta.wup_similarity(ssetb)
		if pathsim != None:
			print "Path Sim Score: ",pathsim,
			" WUP Sim Score: ",wupsim,\
			"\t",sseta.definition, 
			"\t", ssetb.definition


if __name__ == "__main__":
	getSenseSimilarity('cat','walk')
	getSenseSimilarity('cricket','score')