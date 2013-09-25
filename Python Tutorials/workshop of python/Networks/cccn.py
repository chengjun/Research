# PATH: cd C:\Users\Andreas Joseph\Documents\My Dropbox\phd\presentations\cccn 3-5-12


# ------------------------------------
# CCCN Internal Seminar 3 - May - 2012
# ------------------------------------

# scientific Python distribution from http://enthought.com/products/epd.php

# Only ONE important rule for python: 
#          Statement (blocks) are limited by indentation (Off-Side Rule)

# no ";" , no "{}" , no "BEGIN/END"

# Furthermore, you need to know that value of variables are constantly updated 
# ("dynamic semantics", maybe different in Python 3.x)

# basic packages/module

import random            as rn			# basic operations with random numbers
import math              as ma			# basic maths
import numpy             as np			# numerics package
import scipy             as sp			# numeric and scientific computing
import networkx          as nx			# complex network package
import scipy.stats       as st			# a lot of statitics
import matplotlib.pyplot as plt			# a world of graphics and figures

# and many more: Python comes with a huge standard library


# EXAMPLE
# -------

nbr_friends = 15				# will later be the number of nodes

cccn_friends = range(0, nbr_friends)		# this list contains anything you want to have as nodes


# 1. lists and iterations:

print 'Best friends: '

for friend in cccn_friends: print friend,

print # newline
print

# comment: comma at the end prevents a new line after a 'print' statement


# 2. dictionary:

# let's see how old our friends are:

cccn_ages = []

for friend in cccn_friends: cccn_ages.append(rn.randint(1,100))

# test

print 'And their ages: '

print cccn_ages,

print
print

# let's assign them 

age_by_name = dict(zip(tuple(cccn_friends),tuple(cccn_ages)))


# 3. complex networks:

# create random graph of friends

cccn = nx.Graph()
cccn.add_nodes_from(cccn_friends)


while not (nx.is_connected(cccn) and nx.number_of_edges(cccn) > 15):
    two_friends = tuple(rn.sample(cccn_friends,2))
    cccn.add_edge(*two_friends)


# alternative (not necessarily connected):
cccn_2 = nx.Graph()			# an empty undirected graph
best_friends = []			# empty list of edges

for i in range(0,20):			# generate edges
    edge = tuple(rn.sample(cccn_friends,2))
    best_friends.append(edge)    

cccn_2.add_edges_from(best_friends)	# add edges to network

nx.is_connected(cccn_2) 				# check if network is connected
nx.connected_components(cccn_2)				# list of connected components ordered by their node number (biggest first)
nx.connected_component_subgraphs(cccn_2)[0].nodes()	# get nodes of largest connected component

cccn.edges()				# list of edges
cccn.nodes()				# list of nodes

# basic graph characteristics
len(cccn.edges()), nx.number_of_edges(cccn)	# number of edges
len(cccn.nodes()), nx.number_of_nodes(cccn)	# number of edges

nx.degree(cccn) 			# dictionary of keyed by nodes and valued by corr. degree

nx.degree(cccn).values()		# list of degrees (can be readily fitted to some distribution)
nx.degree_histogram(cccn)		# list of the frequency of each degree value

nx.is_connected(cccn) 					# check if network is connected
nx.connected_component_subgraphs(cccn)			# list of connected components ordered by their node number (biggest first)
nx.connected_component_subgraphs(cccn)[0].nodes()	# get nodes of largest connected component

nx.clustering(cccn)			# dict of node clustering 
nx.average_clustering(cccn)		# average clustering coefficient

nx.closeness_centrality(cccn)		# dict of closeness centrality

nx.betweenness_centrality(cccn)		# dict of betweenness centrality

# draw graph

plt.figure(0)
plt.title('The standard way')
nx.draw(cccn)				# draw graph (standard fashion)
plt.show()

plt.figure(1)
plt.title('The round way')
nx.draw_circular(cccn)			# draw graph with circular layout of node positions
plt.show()

# attributes

# graph
cccn.graph = {'location' : 'coffee room'}    # set  graph attributes
cccn.graph['location']                       # call graph attributes

# nodes
nx.set_node_attributes(cccn, 'age', age_by_name)	# set node attribute
age = nx.get_node_attributes(cccn,'age')		# define attribute dict (over nodes)
age							# get node attribute 'age' (all nodes)
#cccn.node['Ron']['age']				# access single node
cccn.nodes(data=True)			# access all nodes

# edges
weights = {}				# create dict for edge attributes
for edge in cccn.edges():
    a = float(cccn.node[edge[0]]['age'])
    b = float(cccn.node[edge[1]]['age'])
    weight = np.mean([a,b])
    weights[edge] = weight

nx.set_edge_attributes(cccn, 'weight', weights)	# set edge attribute

guanxi = nx.get_edge_attributes(cccn, 'weight')	# define attribute dict (over edges)
guanxi						# get edge attribute (all edges)
cccn.edges(data=True)				# access all edges and their data
cccn.edges(data=True)[0][2]['weight']		# get specific weight 

# e.g. cccn['Ron']['Ping']['weight']		# gives direct acces on the graph

# iteration over edges accessing their weight (or any other attribute if existent)

print "Let's see how strong the ties really are!"
print

for edge in cccn.edges(data=True):		# iterate over edges and print something nice!
    friend_1 = edge[0]
    friend_2 = edge[1]
    weight   = edge[2]['weight']
    if weight > 50.: print 'Guanxi:', repr(weight).ljust(4),':', repr(friend_1).ljust(12),\
                            'and', repr(friend_2).ljust(12), 'are very good friends!'
    else: print 'Guanxi:', repr(weight).ljust(4),':', repr(friend_1).ljust(12),\
                            'and', repr(friend_2).ljust(12), 'are just colleagues!'


# 4. graph generators: E.g. Small World Graph

small_world = nx.watts_strogatz_graph(30, 4, 0.25)	# number of nodes, nearest neighbour connections
							# and re-connection probability
plt.figure(2)
plt.title('A Small World!')
nx.draw_circular(small_world)
plt.show()




    




















