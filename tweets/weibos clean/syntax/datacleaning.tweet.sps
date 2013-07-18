***This syntax is to read and clean the tweet file of sina weibo. 
**** use win7xfolder to extract the file name. 
*****use '批量重命名工具' to rename the tweet file (from 1 to 25912). 
set unicode=yes.
compute newname=$casenum.
exe. 
save out 'E:\Sina Weibo\CleanData\filename.tweet.sav'.

***chage .txt file as .sav file.   
set miterate=10000.
define !getdata_tweet (loops=!tokens(1))
!do !var=25001 !to !loops
GET DATA
  /TYPE=TXT
  /FILE=!concat ("'E:\Sina Weibo\sample network\Rename_Tweets\",!var,".txt'")
  /DELCASE=LINE
  /DELIMITERS=""
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=1
  /IMPORTCASE=ALL
  /VARIABLES=
  V1 A400.
CACHE.
EXECUTE.
DATASET NAME DataSet3 WINDOW=FRONT.
compute newname=!var. 
save out !concat ("'E:\Sina Weibo\sample network\Rename_Tweets\",!var,".sav'").

!doend. 
!enddefine. 
!getdata_tweet  loops=25912.

***add file. 
get file 'E:\Sina Weibo\sample network\Rename_Tweets\1.sav'.
define !addfile_tweet (loops=!tokens(1))
!do !var=2 !to !loops
add files file * /file  !concat ("'E:\Sina Weibo\sample network\Rename_Tweets\",!var,".sav'").
exe. 
!doend. 
!enddefine. 
!addfile_tweet loops=5000.
exe.
save out 'D:\temp\sinaweibo\tweet.part1.sav'.

get file 'E:\Sina Weibo\sample network\Rename_Tweets\5001.sav'.
define !addfile_tweet (loops=!tokens(1))
!do !var=5002 !to !loops
add files file * /file  !concat ("'E:\Sina Weibo\sample network\Rename_Tweets\",!var,".sav'").
exe. 
!doend. 
!enddefine. 
!addfile_tweet loops=10000.
exe.
save out 'D:\temp\sinaweibo\tweet.part2.sav'.
exe.

set miterate 15000.
get file 'E:\Sina Weibo\sample network\Rename_Tweets\10001.sav'.
define !addfile_tweet (loops=!tokens(1))
!do !var=10002 !to !loops
add files file * /file  !concat ("'E:\Sina Weibo\sample network\Rename_Tweets\",!var,".sav'").
exe. 
!doend. 
!enddefine. 
!addfile_tweet loops=15000.
exe.
save out 'D:\temp\sinaweibo\tweet.part3.sav'.

set miterate 15000.
get file 'E:\Sina Weibo\sample network\Rename_Tweets\15001.sav'.
define !addfile_tweet (loops=!tokens(1))
!do !var=15002 !to !loops
add files file * /file  !concat ("'E:\Sina Weibo\sample network\Rename_Tweets\",!var,".sav'").
exe. 
!doend. 
!enddefine. 
!addfile_tweet loops=25912.
exe.
save out 'D:\temp\sinaweibo\tweet.part4.sav'.

add files file 'D:\temp\sinaweibo\tweet.part1.sav'/file 'D:\temp\sinaweibo\tweet.part2.sav'
/file 'D:\temp\sinaweibo\tweet.part3.sav'/file 'D:\temp\sinaweibo\tweet.part4.sav'.
EXECUTE.
sort cases by newname.
save out 'D:\temp\sinaweibo\tweet.all.sav'.
get file  'D:\temp\sinaweibo\tweet.all.sav'.
get file  'E:\Sina Weibo\CleanData\filename.tweet.sav'.
del var V1.
sort cases by newname.
match files table */file  'D:\temp\sinaweibo\tweet.all.sav'/by newname/map.
EXECUTE.

del var V3.
rename var V2=uid newname=newid.
compute temp=$casenum.
split files by newid.
rank temp.
split files off.
save out 'D:\temp\sinaweibo\tweet.all.sav'.
