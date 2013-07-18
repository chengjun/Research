* first read data with SPSS.
GET 
  FILE='D:\Chengjun\tweets data\tweets data\tweets_clean.sav'. 
DATASET NAME DataSet1 WINDOW=FRONT.

*RT @nytimes: Williamsburg Journal: As Neighborhood Shifts, Chain Stores Follow http://nyti.ms/bVJckF
RT @nytimes: Henryk Mikolaj Gorecki, Composer, Dies http://nyti.ms/a7xN0I
retweetedFromPostId      retweetedFromUsername
3105537910640640	        nytimes
3093004088778752	        nytimes.


* select cases of retweets.
USE ALL.
COMPUTE filter_$=(replyToPostId ~= 0).
VARIABLE LABELS filter_$ 'replyToPostId ~= 0 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

* Frequent retweetedFromPostId.
FREQUENCIES VARIABLES=retweetedFromPostId
  /ORDER=ANALYSIS.
*it stops sinceThe total number of pivot table cells across split files exceeds 3081136
This limit can be altered by using the SET MXCELLS command. If the working file was 
being created or modified during the current procedure, any changes were probably lost..


*select retweets and save out.
DATASET ACTIVATE retweets.
FILTER OFF.
USE ALL.
SELECT IF (retweetedFromPostId ~= 0).
EXECUTE.
*there are 1045333 retweets.


Save Outfile=='D:\Chengjun\tweets data\tweets data\retweets.sav'
 /Drop = json timeOfCrawl filter_$.

freq retweetedFromPostId.




