import networkx as nx
import matplotlib.pyplot as plt
ER = nx.random_graphs.erdos_renyi_graph(20,0.2)
#生成包含20个节点、以概率0.2连接的随机图
pos = nx.shell_layout(ER)
#定义一个布局，此处采用了shell布局方式
nx.draw(ER,pos,with_labels=False,node_size = 30) 
plt.show()
