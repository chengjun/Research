***match stuctrual links. 
get file  'D:\ZhangLun\Weibo\data\tweet.all.sav'.
sort cases by uid newid.twe.
aggre out */break=uid newid.twe/n=n(uid).
exe. 
rename var uid=V1.
save out 'D:\temp\sinaweibo\tweet.id.sav'.
get file  'D:\ZhangLun\Weibo\data\retweet.all.sav'.
sort cases by uid newid.re.
aggre out */break=uid newid.re/n=n(uid).
exe. 
rename var uid=V1.
del var n.
match files file*/file  'D:\temp\sinaweibo\tweet.id.sav'/by V1/map.
EXECUTE.
freq n/format=notable.
save out 'D:\temp\sinaweibo\tweet-retweet.id.sav'.
get file  'D:\temp\sinaweibo\tweet-retweet.id.sav'.
del var  newid.twe newid.re n.
rename var V1=V2.
sort cases by V2. 
aggre out */break=V2/tag=n(V2).
exe.
save out  'D:\temp\sinaweibo\tweet-retweet.v2.sav'.

set MITERATE 1400.
define !matchfile (loops=!tokens(1))
!do !var=370   !to !loops
get file !concat("  'E:\Sina Weibo\DATA_LINK\Rename\",!var,".sav' ") .
sort cases by V1.
match files table 'D:\temp\sinaweibo\tweet-retweet.id.sav'/file */by V1/map.
exe.
sel if newid.twe>0 or newid.re>0.
EXECUTE.
sort cases by V2.
match files table  'D:\temp\sinaweibo\tweet-retweet.v2.sav'/file */by V2.
EXECUTE.
sel if tag>0.
exe.
save out !concat(" 'D:\temp\sinaweibo\netmatch\",!var,".sav' ") .
!doend. 
!enddefine. 
!matchfile loops=1359.
exe. 

get file  'D:\temp\sinaweibo\netmatch\1.sav' .
define !addfile (loops=!tokens(1))
!do !var=2 !to !loops
add files file*/file !concat(" 'D:\temp\sinaweibo\netmatch\",!var,".sav' ") .
!doend. 
!enddefine. 
!addfile loops=1359.
exe. 
freq newid.re/format=notable.
sort cases by V1 V2.
rename var V1=tweet.id V2=tweet.following.
freq file.
del var tag n newid.re newid.twe.
save out  'D:\ZhangLun\Weibo\data\network.tweet.all.sav'.