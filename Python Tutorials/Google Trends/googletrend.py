from pyGTrends import pyGTrends
from csv import DictReader

connector = pyGTrends('google username','google password')
connector.download_report(('occupy wall street', 'ռ�컪����'))  
                          # date='2011-10',
                          # geo='AT',
                          # scale=1)
print connector.csv()
# print connector.csv(section='Language')
# print DictReader(connector.csv().split('\n'))
