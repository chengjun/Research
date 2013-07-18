***find cases whose number of record is not 8.
get file 'D:\temp\sinaweibo\tweet.all.sav'.
compute caseno=$casenum.
exe. 

del var caseno.
compute caseno=$casenum.
exe. 
compute interv=trunc(caseno/8).
exe. 
if (interv=caseno/8) interv=interv-1.
exe.
aggre out ' D:\temp\sinaweibo\tweet.match.sav'/break=uid newid.twe interv/n=n(interv).
exe.
freq interv.. 
split files by interv.
rank caseno/rank into tag.
split files off.
if tweet="$MESSAGE " tag2=1.
EXECUTE.
freq tag2.      
sel if tag=1 or tag2=1.
exe.
aggre out/break=interv/n=n(interv).    
exe.         
freq n.           
***30324 is problematic.242592.00. 
get file 'D:\temp\sinaweibo\tweet.all.sav'.
compute caseno=$casenum.
exe. 
sel if caseno<> 242592.00. 
exe.
del var caseno.
compute caseno=$casenum.
exe. 
compute interv=trunc(caseno/8).
exe. 
if (interv=caseno/8) interv=interv-1.
exe.
string tweet1 to tweet8 (a400).
vector tweet=tweet1 to tweet8.
compute tweet(tag) = tweet.
exe.
sort cases by interv.
agg out */presorted/break=interv/tweet1 to tweet8=max(tweet1 to tweet8).
exe.
save out  'D:\temp\sinaweibo\tweet.all2_winson.sav'.

get file  'D:\temp\sinaweibo\tweet.all2_winson.sav'.
match files file */table  'D:\temp\sinaweibo\tweet.match.sav'/by interv.
exe.
del var tweet1 tweet2.
save out 'D:\ZhangLun\Weibo\data\tweet.all.sav'.
string message.id (a400).  
compute message.id=subtra(tweet3,17).
EXECUTE.
string tweet.time (a400) crawl.time(a400) port(a400) tweet (a400) link(a400).
compute tweet.time=subtra(tweet4, 30).
compute crawl.time=subtra(tweet5, 17).
compute port=subtra(tweet6,17).
compute tweet=subtra(tweet7,17).
compute link=subtra(tweet8,17).
exe.
del var tweet3 to tweet8.
rename var interv=tweet.id.
variable labels tweet.id 'tweet.id'.
variable labels uid 'user id in sina'/ newid.twe 'sequential user id for matching retweet'/message.id 'message id'
/port 'the device the user used'/link 'the URL the tweet'.
del var n.
save out 'D:\ZhangLun\Weibo\data\tweet.all.sav'.

******datacleaning.retweet.
***find cases whose number of record is not 8.
get file 'D:\temp\sinaweibo\retweet.all.sav'.
compute caseno=$casenum.
exe. 
compute interv=trunc(caseno/8).
exe. 
if (interv=caseno/8) interv=interv-1.
exe.
freq interv.. 
split files by interv.
rank caseno/rank into tag.
split files off.
if retweet="$MESSAGE " tag2=1.
EXECUTE.
freq tag2.      
sel if tag=1 or tag2=1.
exe.
**there is no problematic cases.           

get file 'D:\temp\sinaweibo\retweet.all.sav'.
compute caseno=$casenum.
exe. 
compute interv=trunc(caseno/8).
exe. 
if (interv=caseno/8) interv=interv-1.
exe.
aggre out ' D:\temp\sinaweibo\retweet.match.sav'/break=uid newid.re interv/n=n(interv).
EXECUTE.
freq interv.. 
split files by interv.
rank caseno/rank into tag.
split files off.
string retweet1 to retweet8 (a400).
vector retweet=retweet1 to retweet8.
compute retweet(tag) = retweet.
exe.
sort cases by interv.
agg out */presorted/break=interv/retweet1 to retweet8=max(retweet1 to retweet8).
exe.
save out  'D:\temp\sinaweibo\retweet.all2_winson.sav'.


get file  'D:\temp\sinaweibo\retweet.all2_winson.sav'.
match files file */table  'D:\temp\sinaweibo\retweet.match.sav'/by interv.
exe.
del var retweet1 .
save out 'D:\ZhangLun\Weibo\data\retweet.all.sav'.
get file 'D:\ZhangLun\Weibo\data\retweet.all.sav'.
string r.message.id (a400) test(a20).  
compute r.message.id=subtra(retweet3,17).
compute test=subtra(retweet2,17).
EXECUTE.
freq test.
string retweet.time (a400) re.crawl.time(a400) re.port(a400) retweet (a400) re.link(a400).
compute retweet.time=subtra(retweet4, 30).
compute re.crawl.time=subtra(retweet5, 17).
compute re.port=subtra(retweet6,17).
compute retweet=subtra(retweet7,17).
compute re.link=subtra(retweet8,17).
exe.
del var retweet2 to retweet8.
rename var interv=retweet.id.
variable labels retweet.id 're.tweet.id'.
variable labels uid 'user id in sina'/ newid.re 'sequential user id for matching retweet'/r.message.id 'message id in reweet'
/re.port 'the device the user used'/re.link 'the URL the tweet'.
del var n.
save out 'D:\ZhangLun\Weibo\data\retweet.all.sav'.

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

sort cases by V1 V2.
rename var V1=tweet.id V2=tweet.following.
freq file.
del var tag n.
save out  'D:\ZhangLun\Weibo\data\network.tweet.all.sav'.

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


