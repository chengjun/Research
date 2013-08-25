import networkx
g=networkx.Graph()
g.add_edge(1,2)
g.add_node("spam")
print g.nodes()
print g.edges()
