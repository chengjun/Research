### Similarities (the best part)
from gensim.similarities import Similarity

# This index corpus consists of what you want to compare future queries against
index_documents = ["A bear walked in the dark forest.",
             "Tall trees have many more leaves than short bushes.",
             "A starship may someday travel across vast reaches of space to other stars.",
             "Difference is the concept of how two or more entities are not the same."]
# A corpus can be anything, as long as iterating over it produces a representation of the corpus documents as vectors.
corpus = (dictionary.doc2bow(tokenize_func(document)) for document in index_documents)

index = Similarity(corpus=lsi_transformation[logent_transformation[corpus]], num_features=400, output_prefix="shard")

print "Index corpus:"
pprint.pprint(documents)

print "Similarities of index corpus documents to one another:"
pprint.pprint([s for s in index])

query = "In the face of ambiguity, refuse the temptation to guess."
sims_to_query = index[lsi_transformation[logent_transformation[dictionary.doc2bow(tokenize_func(query))]]]
print "Similarities of index corpus documents to '%s'" % query
pprint.pprint(sims_to_query)

best_score = max(sims_to_query)
index = sims_to_query.tolist().index(best_score)
most_similar_doc = documents[index]
print "The document most similar to the query is '%s' with a score of %.2f." % (most_similar_doc, best_score)