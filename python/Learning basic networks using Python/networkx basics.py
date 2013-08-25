import networkx as nx
#import numpy as np
import matplotlib.pyplot as plt
#~~~~~~~~~~~~~~~~~~~~~~~~~~random network~~~~~~~~~~~~~~~~~~~~~~~~~~#
#RG = nx.random_graphs.random_regular_graph(3,20)
#���ɰ���20���ڵ㡢ÿ���ڵ���3���ھӵĹ���ͼRG
#pos = nx.spectral_layout(RG)
#����һ�����֣��˴�������spectral���ַ�ʽ����仹������������ַ�ʽ��ע��ͼ���ϵ�����
#nx.draw(RG,pos,with_labels=False,node_size = 30)
#���ƹ���ͼ��ͼ�Σ�with_labels�����ڵ��ǷǴ���ǩ����ţ���node_size�ǽڵ��ֱ��
#plt.show()  #��ʾͼ��
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~BA network~~~~~~~~~~~~~~~~~~~~~#
G = nx.random_graphs.barabasi_albert_graph(1000,3)   #����һ��n=1000��m=3��BA�ޱ������
print G.degree(0)                                   #����ĳ���ڵ�Ķ�
print G.degree()                                     #�������нڵ�Ķ�
print nx.degree_histogram(G)    #����ͼ�����нڵ�Ķȷֲ����У���1�����ȵĳ���Ƶ�Σ�
#~~~~~~~~~~~~~~~~~~~~~~draw the degree distribution~~~~~~~~~~~~~~~#
degree =  nx.degree_histogram(G)          #����ͼ�����нڵ�Ķȷֲ�����
x = range(len(degree))                             #����x�����У���1������
y = [z / float(sum(degree)) for z in degree]  
#��Ƶ��ת��ΪƵ�ʣ����õ�Python��һ��С���ɣ��б��ں���Python��ȷ�ܷ��㣺��
plt.loglog(x,y,color="blue",linewidth=2)           #��˫�����������ϻ��ƶȷֲ�����  
plt.show()                                         #��ʾͼ��
#~~~~~~~~~~~~~~~~~~~~~~~~~~output the CC AND PATH~~~~~~~~~~~~~~~~~~#
nx.average_clustering(G)#OUTPUT the cluster coefficient
#nx.clustering(G) ����Լ�������ڵ��Ⱥ��ϵ����
nx.diameter(G) #����ͼG��ֱ��������·���ĳ���)
nx.average_shortest_path_length(G)#����ͼG���нڵ��ƽ�����·������
nx.degree_assortativity(G) #����һ��ͼ�Ķ�ƥ����
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
