import networkx as nx
#import numpy as np
import matplotlib.pyplot as plt
#~~~~~~~~~~~~~~~~~~~~~~~~~~random network~~~~~~~~~~~~~~~~~~~~~~~~~~#
#RG = nx.random_graphs.random_regular_graph(3,20)
#生成包含20个节点、每个节点有3个邻居的规则图RG
#pos = nx.spectral_layout(RG)
#定义一个布局，此处采用了spectral布局方式，后变还会介绍其它布局方式，注意图形上的区别
#nx.draw(RG,pos,with_labels=False,node_size = 30)
#绘制规则图的图形，with_labels决定节点是非带标签（编号），node_size是节点的直径
#plt.show()  #显示图形
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~BA network~~~~~~~~~~~~~~~~~~~~~#
G = nx.random_graphs.barabasi_albert_graph(1000,3)   #生成一个n=1000，m=3的BA无标度网络
print G.degree(0)                                   #返回某个节点的度
print G.degree()                                     #返回所有节点的度
print nx.degree_histogram(G)    #返回图中所有节点的度分布序列（从1至最大度的出现频次）
#~~~~~~~~~~~~~~~~~~~~~~draw the degree distribution~~~~~~~~~~~~~~~#
degree =  nx.degree_histogram(G)          #返回图中所有节点的度分布序列
x = range(len(degree))                             #生成x轴序列，从1到最大度
y = [z / float(sum(degree)) for z in degree]  
#将频次转换为频率，这用到Python的一个小技巧：列表内涵，Python的确很方便：）
plt.loglog(x,y,color="blue",linewidth=2)           #在双对数坐标轴上绘制度分布曲线  
plt.show()                                         #显示图表
#~~~~~~~~~~~~~~~~~~~~~~~~~~output the CC AND PATH~~~~~~~~~~~~~~~~~~#
nx.average_clustering(G)#OUTPUT the cluster coefficient
#nx.clustering(G) 则可以计算各个节点的群聚系数。
nx.diameter(G) #返回图G的直径（最长最短路径的长度)
nx.average_shortest_path_length(G)#返回图G所有节点间平均最短路径长度
nx.degree_assortativity(G) #计算一个图的度匹配性
#~~~~~~~~~~~~~Degree centrality measures~~~~~~~~~~~~~~~~~~~~~~~~~~~#
degree_centrality(G)     #Compute the degree centrality for nodes.
in_degree_centrality(G)     #Compute the in-degree centrality for nodes.
out_degree_centrality(G)     #Compute the out-degree centrality for nodes.

closeness_centrality(G[, v, weighted_edges])    # Compute closeness centrality for nodes.

betweenness_centrality(G[, normalized, ...])   #  Compute betweenness centrality for nodes.
edge_betweenness_centrality(G[, normalized, ...])   #  Compute betweenness centrality for edges.

current_flow_closeness_centrality(G[, ...])   #  Compute current-flow closeness centrality for nodes.

current_flow_betweenness_centrality(G[, ...])    # Compute current-flow betweenness centrality for nodes.
edge_current_flow_betweenness_centrality(G)   #  Compute current-flow betweenness centrality for edges.

eigenvector_centrality(G[, max_iter, tol, ...])    # Compute the eigenvector centrality for the graph G.
eigenvector_centrality_numpy(G)   #  Compute the eigenvector centrality for the graph G.

load_centrality(G[, v, cutoff, normalized, ...])  #   Compute load centrality for nodes.
edge_load(G[, nodes, cutoff])    # Compute edge load.
