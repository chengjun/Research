***word segregation for LH. 
get file 'D:\ZhangLun\Weibo\data\tweet.all.sav'.
sort cases by tweet.id newid.twe message.id .
SAVE TRANSLATE OUTFILE='D:\temp\sinaweibo\tweet.word.dat'
  /TYPE=TAB
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES
/keep=tweet.id newid.twe message.id tweet.
