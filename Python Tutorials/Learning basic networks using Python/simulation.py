import networkx as nx
#import numpy as np
import matplotlib.pyplot as plt
#RG = nx.random_graphs.random_regular_graph(3,20)
#���ɰ���20���ڵ㡢ÿ���ڵ���3���ھӵĹ���ͼRG
#pos = nx.spectral_layout(RG)
#����һ�����֣��˴�������spectral���ַ�ʽ����仹������������ַ�ʽ��ע��ͼ���ϵ�����
#nx.draw(RG,pos,with_labels=False,node_size = 30)
#���ƹ���ͼ��ͼ�Σ�with_labels�����ڵ��ǷǴ���ǩ����ţ���node_size�ǽڵ��ֱ��
#plt.show()  #��ʾͼ��

G = nx.random_graphs.barabasi_albert_graph(1000,3)   #����һ��n=1000��m=3��BA�ޱ������
print G.degree(0)                                   #����ĳ���ڵ�Ķ�
print G.degree()                                     #�������нڵ�Ķ�
print nx.degree_histogram(G)    #����ͼ�����нڵ�Ķȷֲ����У���1�����ȵĳ���Ƶ�Σ�
degree =  nx.degree_histogram(G)          #����ͼ�����нڵ�Ķȷֲ�����
x = range(len(degree))                             #����x�����У���1������
y = [z / float(sum(degree)) for z in degree]  
#��Ƶ��ת��ΪƵ�ʣ����õ�Python��һ��С���ɣ��б��ں���Python��ȷ�ܷ��㣺��
plt.loglog(x,y,color="blue",linewidth=2)           #��˫�����������ϻ��ƶȷֲ�����  
plt.show()                                                          #��ʾͼ��
