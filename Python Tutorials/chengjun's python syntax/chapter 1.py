# wang chengjun
# Contact: wangchj04@gmail.com
# 2011/05/19

"""ex 1-3 retrieving Twitter API trends"""
import twitter
twitter_api = twitter.Twitter(domain="api.twitter.com", api_version='1')
trends = twitter_api.trends()
# print trends
print [trend['name'] for trend in trends['trends'] ]

# it's weird that I input the codes separately, it works.
# but it dones't work together.
# I add print to fix this bug.

""""exe1-4 paging through twitter search results"""
search_results=[]
twitter_search = twitter.Twitter(domain="search.twitter.com")
for page in range(1,6): 
    search_results.append(twitter_search.search(q="Victoria Secret",
                                                rpp=400, page=page))
    # i make page range less 2 pages to save time.
    # range(1,3) only output page 1 and page 2, rather than 3 pages.
    # I make rpp=10, with 1 results per page, to save time.
    
""""exe1-5 pretty-printing twitter data as JSON"""
import json
# print json.dumps(search_results, sort_keys=True, indent=1)
# it will take some seconds of time, take easy and be patient.


"""ex1-6 a simple list comprehension in python"""
tweets=[r['text']
    for result in search_results
        for r in result['results']]

"""ex1-7 calculating lexical diversity for tweets"""
words=[]
for t in tweets:
    words +=[w for w in t.split()]
    
    # Why doesn't this code work? the same answer, add print to output results.
print len(words) #total words
print len(set(words)) #unique words
print 1.0*len(set(words))/len(words) #lexical diversity
print 1.0*sum([len(t.split()) for t in tweets])/len(tweets) # avg words per tweet


"""ex1-8 pickling your data"""
f=open("myData.pickle","wb")
import cPickle
cPickle.dump(words,f)
f.close()

"""ex1-9 using nltk to perform basic frequency analysis"""
import nltk
words=cPickle.load(open("myData.pickle"))
freq_dist=nltk.FreqDist(words)
# print freq_dist
print freq_dist.keys()[:50]  # 50 most frequent tokens
print freq_dist.keys()[-50:] # 50 least frequent tokens

"""ex1-10 using regular expressions to find retweets"""
import re
rt_patterns=re.compile(r"(RT|via)((?:\b\ w*@\w+)+)", re.IGNORECASE)
example_tweets=["RT @pkusjcer what is TABOK SELENA ",
                "pkusjcer want to know what is TABOK SELENA!!!(via @pkusjcer)"]
for t in example_tweets:
    print rt_patterns.findall(t)

"""ex1_11 building and analyzing a graph describing who retweets whom"""
import networkx as nx
import re

g=nx.DiGraph()

all_tweets=[tweet
            for page in search_results
                for tweet in page["results"]]
            
def get_rt_sources(tweet):
    rt_patterns=re.compile(r"(RT|via)((?:\b\ w*@\w+)+)", re.IGNORECASE)
    return [source.strip()
            for tuple in rt_patterns.findall(tweet)
                for source in tuple
                    if source not in ("RT","via")]
            
for tweet in all_tweets:
            rt_sources=get_rt_sources(tweet["text"])
            if not rt_sources:continue
            for rt_source in rt_sources:
                g.add_edge(rt_source, tweet["from_user"],{"tweet_id" :tweet["id"]})
# print out some stats

print g.number_of_nodes()
print g.number_of_edges()
print g.edges(data=True)[0]
print len(nx.connected_components(g.to_undirected()))
# print sorted(nx.degree(g))

"""ex1-12 Generating dot language output is easy regardless of platform"""
import os
import sys

OUT="Victoria Secret.dot"

# Writes out a DOT language file that can be converted into an 
# image by Graphviz

def write_dot_output(g, OUT):

    try:
        nx.drawing.write_dot(g, OUT)
        print >> sys.stderr, 'Data file written to', OUT
    except ImportError, e:

        dot = ['"%s" -> "%s" [tweet_id=%s]' % (n1, n2, g[n1][n2]['tweet_id'])
               for (n1, n2) in g.edges()]
        f = open(OUT, 'w')
        f.write('''strict digraph {
    %s
    }''' % (';\n'.join(dot), ))
        f.close()

        print >> sys.stderr, 'Data file written to: %s' % f.name
        
if __name__ == '__main__':
    
        # Write Graphviz output

    if not os.path.isdir('out'):
        os.mkdir('out')

    f = os.path.join(os.getcwd(), 'out', OUT)

    write_dot_output(g, f)

    print >> sys.stderr, \
            'Try this on the DOT output'




        
