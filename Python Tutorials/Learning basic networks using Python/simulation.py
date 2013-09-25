import networkx as nx
#import numpy as np
import matplotlib.pyplot as plt
#RG = nx.random_graphs.random_regular_graph(3,20)
#生成包含20个节点、每个节点有3个邻居的规则图RG
#pos = nx.spectral_layout(RG)
#定义一个布局，此处采用了spectral布局方式，后变还会介绍其它布局方式，注意图形上的区别
#nx.draw(RG,pos,with_labels=False,node_size = 30)
#绘制规则图的图形，with_labels决定节点是非带标签（编号），node_size是节点的直径
#plt.show()  #显示图形

G = nx.random_graphs.barabasi_albert_graph(1000,3)   #生成一个n=1000，m=3的BA无标度网络
print G.degree(0)                                   #返回某个节点的度
print G.degree()                                     #返回所有节点的度
print nx.degree_histogram(G)    #返回图中所有节点的度分布序列（从1至最大度的出现频次）
degree =  nx.degree_histogram(G)          #返回图中所有节点的度分布序列
x = range(len(degree))                             #生成x轴序列，从1到最大度
y = [z / float(sum(degree)) for z in degree]  
#将频次转换为频率，这用到Python的一个小技巧：列表内涵，Python的确很方便：）
plt.loglog(x,y,color="blue",linewidth=2)           #在双对数坐标轴上绘制度分布曲线  
plt.show()                                                          #显示图表
