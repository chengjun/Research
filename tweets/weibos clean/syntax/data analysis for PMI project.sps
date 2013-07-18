***data analysis for PMI Project. 
string tweet.date (A20).
COMPUTE tweet.date=SUBSTR(tweet.time, 1,10).
exe. 
freq tweet.date.
del var tweet.time2.
string tweet.time2(A20).
compute tweet.time2=SUBSTR (tweet.time,12,8).
exe.
del var tweet.time. 
rename var tweet.time2=tweet.time.
compute tweet.hour=xdate.hour(tweet.time).
EXECUTE.
sort cases by tweet.date.
split files by tweet.date .
FREQUENCIES tweet.hour/HISTOGRAM.
save out 'D:\ZhangLun\Weibo\data\pmi.tweet.sav'.
sort cases by newid.twe tweet.date tweet.time.
aggre out */break=newid.twe tweet.date/n=n(newid.twe).
exe. 
rename var n=n.tweets.perday.
freq n.tweets.perday/histo.
sort cases n.tweets.perday(d).
save out 'd:\temp\sinaweibo\n.tweets.perday.sav'.

get file  'D:\ZhangLun\Weibo\data\pmi.tweet.sav'.
if tweet.hour>= 1 and tweet.hour<= 7 duration=1.
if tweet.hour>=8 and tweet.hour<= 18 duration=2..
if ( tweet.hour>=19 and tweet.hour<= 23) or (tweet.hour=0 ) duration=3.
EXECUTE.
VALUE LABELS duration 1 'early morning' 2 'work time'  3 'night'.
FREQUENCIES duration.
sort cases by newid.twe duration.
aggre out * /break=newid.twe duration/n=n(newid.twe).
exe. 
freq duration.
CASESTOVARS /id=newid.twe/index=duration.
if n.1.00>0 duration1=1.
if n.2.00>0 duration2=2. 
if n.3.00>0 duration3=3.
exe. 
del var n.1.00 n.2.00 n.3.00 .
format duration1 (F1.0)/duration2 (f1.0)/duration3(f1.0).
string duration1.1  duration2.2 duration3.3 (A4).
compute duration1.1=string(duration1,f2.0).
compute duration2.2=string(duration2,f2.0).
compute duration3.3=string(duration3,f2.0).
exe.
string duration.combine(a10).
compute duration.combine=concat (duration1.1, duration2.2, duration3.3).
exe. 
freq duration.combine.
del var duration1 duration2 duration3 duration1.1 duration2.2 duration3.3.
if duration.combine=' .   2   .'  time.of.day=1.
exe. 
if duration.combine=' .   .   3' time.of.day=2.
if duration.combine=' .   2   3' time.of.day=3.
if duration.combine=' 1   .   .' time.of.day=4.
if duration.combine=' 1   .   3' time.of.day=5.
if duration.combine=' 1   2   .' time.of.day=6.
if duration.combine=' 1   2   3' time.of.day=7.
exe. 
VALUE LABELS time.of.day 1 'work' 2 'night' 3 'work+night' 4 'morning' 5 'non worktime (morning+night)' 6 'morning+work' 7 'all day'.
freq time.of.day.
del var duration.combine. 
sort cases by newid.twe.
save out  'd:\temp\sinaweibo\time.of.day.sav'.
get file  'D:\ZhangLun\Weibo\data\pmi.tweet.sav'.
sort cases by newid.twe tweet.date.
aggre out */break=newid.twe tweet.date/n=n(newid.twe).
exe. 
aggre out * /break=newid.twe/n.day=n(newid.twe).
exe. 
save out  'd:\temp\sinaweibo\n.day.sav'.
get file  'd:\temp\sinaweibo\n.tweets.perday.sav'.
sort cases by newid.twe.
aggre out */break=newid.twe/n.tweets.total=sum(n.tweets.perday).
exe. 
save out  'd:\temp\sinaweibo\tweet.total.sav'.
match files file*/file  'd:\temp\sinaweibo\n.day.sav'/file  'd:\temp\sinaweibo\time.of.day.sav'/by newid.twe.
exe.
save out  'd:\temp\sinaweibo\user.time.sav'.
get file 'D:\ZhangLun\Weibo\data\network.tweet.all.sav'.
sort cases by tweet.following.
rename var tweet.following=uid. 
match files file*/table 'E:\Sina Weibo\CleanData\filename.tweet.sav'/by uid.
exe. 
rename var newname=newid.following.
freq newid.following/format=notable.
del var uid.
rename var tweet.id=uid. 
sort cases by uid.
 match files file*/table 'E:\Sina Weibo\CleanData\filename.tweet.sav'/by uid.
exe. 
rename var newname=newid.user.
freq newid.user/format=notable.
del var uid.
save out  'D:\ZhangLun\Weibo\data\network.tweet.all.sav'.
**read network data to pajek.

get file  'D:\ZhangLun\Weibo\data\network.tweet.all.sav'.
sort cases by newid.following newid.user.
aggre out * /break=newid.following newid.user/n=n(newid.following).
desc n.
rename var newid.following=newid.user newid.user=newid.following.
add files file*/file  'D:\ZhangLun\Weibo\data\network.tweet.all.sav'.
exe. 
sort cases by newid.user.
aggre out */break=newid.user/n=n(newid.user).
exe. 
compute casenum=$casenum.
exe. 
save out 'D:\temp\sinaweibo\casenum.tweet.sav'.

match files table   'D:\temp\sinaweibo\casenum.tweet.sav' /file  'D:\ZhangLun\Weibo\data\network.tweet.all.sav'/by newid.user.
exe. 
del var newid.user n.
rename var newid.following=newid.user casenum=V1.
sort cases by newid.user.
match files file * /table  'D:\temp\sinaweibo\casenum.tweet.sav'/by newid.user.
exe. 
rename var casenum=V2. 
del var n newid.user.
del var file.
sort cases by V1 V2.
aggre out * /break=V1 V2 /n=n(V1).
exe. 
desc n.
STRING V3 (A10).
  COMPUTE V3= STRING(V1, F10.0).
  EXECUTE.

STRING V4 (A10).
  COMPUTE V4= STRING(V2, F10.0).
  EXECUTE.
del var V1 V2.
STRING V1 (A12) V2(A12).
compute V1=(ltrim(rtrim(V3))).
compute V2=(ltrim(rtrim(V4))).
exe. 
del var V3 V4.
sort cases by V1 V2. 
aggre out */break=V1 V2/n=n(V1).
exe. 
del var n.
save out 'D:\temp\sinaweibo\edge.tweet.sav'.

get file   'D:\temp\sinaweibo\casenum.tweet.sav'.
del var n. 
STRING V1 (A12).
  COMPUTE V1= STRING(newid.user, F12.0).
  EXECUTE.
string newtext (a12) space (a4).
compute space=' " '. 
compute newtext=concat(ltrim(rtrim(space)),rtrim(ltrim(V1)), ltrim(rtrim(space))).
exe.
STRING V3 (A12).
  COMPUTE V3= STRING(casenum, F12.0).
  EXECUTE.
del var newid.user space casenum V1.
rename var newtext=V4.
string V1 (A12).
compute V1=(ltrim(rtrim(V3))).
exe. 
rename var V4=V2.
del var V3.
save out  'D:\temp\sinaweibo\vertices.tweet.sav'.

add files file  'D:\temp\sinaweibo\vertices.tweet.sav'/file  'D:\temp\sinaweibo\edge.tweet.sav'.
exe. 
save out  'D:\temp\sinaweibo\net.tweet.sav'.

**export to pajek.
***get result of closness for each id. 
rename var vertxlab=newid.
rename var V1=close.
del var vertexID.
save out  'D:\temp\sinaweibo\close.sav'.
get file 'D:\temp\sinaweibo\close.sav'.
sort cases by newid.
save out  'D:\temp\sinaweibo\close.sav'.
rename var vertxlab=newid.
rename var V2=between.
del var vertexID.
save out  'D:\temp\sinaweibo\between.sav'.
get file  'D:\temp\sinaweibo\between.sav'.
sort cases by newid.
save out  'D:\temp\sinaweibo\between.sav'.
match files file */file  'D:\temp\sinaweibo\close.sav'/by newid.
exe. 

***cluster analysis using lifestyle. 
get file  'D:\ZhangLun\Weibo\data\pmi.tweet.sav'.
do repeat h= h1 to h24 / value=1 to 24 .  
if tweet.hour=value  h=1.
end repeat.
exe.
sort cases by newid.twe.
aggre out */break=newid.twe/ h1 to h24=sum(h1 to h24).
exe. 
recode  h1 to h24 (sysmis=0).
exe. 
recode h1 to h24 (1 through HIGHEST =1).
exe. 

QUICK CLUSTER h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11 h12 h13 h14 h15 h16 h17 h18 h19 h20 h21 h22 h23 h24    
  /MISSING=LISTWISE
  /CRITERIA=CLUSTER(2) MXITER(10) CONVERGE(0)
  /METHOD=KMEANS(NOUPDATE)
  /SAVE CLUSTER DISTANCE
  /PRINT INITIAL.
temp.
sel if QCL_1=1.
QUICK CLUSTER h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11 h12 h13 h14 h15 h16 h17 h18 h19 h20 h21 h22 h23 h24    
  /MISSING=LISTWISE
  /CRITERIA=CLUSTER(2) MXITER(10) CONVERGE(0)
  /METHOD=KMEANS(NOUPDATE)
  /SAVE CLUSTER DISTANCE
  /PRINT INITIAL.
sort cases by QCL_1 QCL_3.
