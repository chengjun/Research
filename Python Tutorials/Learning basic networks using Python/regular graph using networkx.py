import networkx as nx
import matplotlib.pyplot as plt

RG = nx.random_graphs.random_regular_graph(3,200)
#生成包含20个节点、每个节点有3个邻居的规则图RG
pos = nx.spectral_layout(RG)
#定义一个布局，此处采用了spectral布局方式，后变还会介绍其它布局方式，注意图形上的区别
nx.draw(RG,pos,with_labels=False,node_size = 30)
#绘制规则图的图形，with_labels决定节点是非带标签（编号），node_size是节点的直径
plt.show()  #显示图形

