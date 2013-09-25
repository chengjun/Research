import networkx as nx
import matplotlib.pyplot as plt
WS = nx.random_graphs.watts_strogatz_graph(20,4,0.3)  #���ɰ���20���ڵ㡢ÿ���ڵ�4�����ڡ��������������Ϊ0.3��С��������
pos = nx.circular_layout(WS)          #����һ�����֣��˴�������circular���ַ�ʽ
nx.draw(WS,pos,with_labels=False,node_size = 30)  #����ͼ��
plt.show()
