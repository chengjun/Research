import networkx as nx
import matplotlib.pyplot as plt
ER = nx.random_graphs.erdos_renyi_graph(20,0.2)
#���ɰ���20���ڵ㡢�Ը���0.2���ӵ����ͼ
pos = nx.shell_layout(ER)
#����һ�����֣��˴�������shell���ַ�ʽ
nx.draw(ER,pos,with_labels=False,node_size = 30) 
plt.show()
