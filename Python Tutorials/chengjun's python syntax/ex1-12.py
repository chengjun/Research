"""ex1-12 Generating dot language output is easy regardless of platform"""
OUT="TABOK SELENA_search_results.dot"

try:
    nx.drawing.write_dot(g,OUT)
except ImportError, e:

    #help for windows users: not a general-purpose method, but representative of
    #the same output write_dot would provide for this graph
    #if installed and easy to implement

dot=['"%s"->"%s" [tweet_id=%s]'%(n1,n2,g[n1][n2]['tweet_id'])\
     for n1,n2 in g.edges()]
f=open(OUT,'w')
f.write('strict digraph {\n%s\n}' %(';\n'.join(dot),)
f.close()
    
