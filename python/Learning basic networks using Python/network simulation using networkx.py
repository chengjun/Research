import networkx as nx
import matplotlib.pyplot as plt

RG = nx.random_graphs.random_regular_graph(3,200)
#���ɰ���20���ڵ㡢ÿ���ڵ���3���ھӵĹ���ͼRG
pos = nx.spectral_layout(RG)
#����һ�����֣��˴�������spectral���ַ�ʽ����仹������������ַ�ʽ��ע��ͼ���ϵ�����
nx.draw(RG,pos,with_labels=False,node_size = 30)
#���ƹ���ͼ��ͼ�Σ�with_labels�����ڵ��ǷǴ���ǩ����ţ���node_size�ǽڵ��ֱ��
plt.show()  #��ʾͼ��

