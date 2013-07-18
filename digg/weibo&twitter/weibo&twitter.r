# News diffusion on Sina weibo
# chengjun @ dorm
# 20120114

#~~~~~~~~~~~~~read data~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
rt<-read.csv("D:/Chengjun/Weibo/data/Diffusion Data on Weibo/retweet.all.csv", 
  header = T, dec = ".")
# dim(rt) # [1] 260903     10
#  names(rt)
# [1] "retweet.id"    "uid"           "newid.re"      "r.message.id" 
# [5] "test"          "retweet.time"  "re.crawl.time" "re.port"      
# [9] "retweet"       "re.link"   
#~~~~~~~~~~~~~ get the retweeters uid to search the social graph~~~~~~~~~~~~~~~#
as.data.frame(table(rt$newid.re))  # 17773 unique retweeters with new id

# as.data.frame(table(rt$uid)) # 17773 unique retweeters
users<-as.data.frame(table(rt$uid))
users<-users[order(users$Var1),]
names(users)<-c("uid", "Freq")
# write.csv(users, "D:/Chengjun/Weibo/data/Diffusion Data on Weibo/Retweeters.csv")
hist(as.numeric(levels(users$uid)[users$uid]), breaks=100, xlab="user_id") # distribution of unique uid
#~~~~~~~~~~~~get the popular weibo~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# dim(as.data.frame(table(rt$r.message.id))) # 243369 unique weibos! one person 13.7 retweets.
# as.data.frame(table(rt$test)) # two tests, test1 with 1800 retweets and test 2 with 259103 rts.
# head(rt$re.port)
 head(rt$retweet)
weibo<-as.data.frame(table(rt$r.message.id))
hist(weibo$Freq)
table(weibo$Freq)
#     1      2      3      4      5 
# 227333  14665   1251    113      7 
# but it's wrong!!
dim(as.data.frame(unique(rt$re.link))) # 118568, there are actually 118568 retweeted news!
link<-as.data.frame(table(rt$re.link))
link<-link[order(link$Fre),]
link[118558:118568,]  
# 110648  http://t.sina.com.cn/1989464693/wr4mYykQMC  182
# 10741  http://t.sina.com.cn/1277304507/ez2EoDosbzb  186
# 33602  http://t.sina.com.cn/1653689003/eyW0l6zwHtt  203
# 42343   http://t.sina.com.cn/1683498705/zF4n1QBsmC  871
# 66129  http://t.sina.com.cn/1764452651/eyWkHFxuZqd 1052
# 118568                                        null 2847
null<-subset(rt, rt$re.link=="null")
case1<-subset(rt, rt$re.link=="http://t.sina.com.cn/1764452651/eyWkHFxuZqd")
hist(log(log(link$Freq)), breaks=100)
as.data.frame(table(link$Freq))
# there are 1 weibo with 2847 rts (null, it's error), 1052 rts, 871 rts!!

#~~~~~~~~~~~~~~~~~~~~~~~~~sample network~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
?read.table
srtnet<-read.table("D:/Chengjun/Weibo/data/Diffusion Data on Weibo/SampleNetwork.txt",  header = FALSE, sep ="|")
          
# RetweetNetwork
# A|B	A转发B

# ReverseedRetweetNetwork
# A|B	A被B转发

# AllNetwork
# A|B|0	A转发B
# A|B|1	A被B转发
# A|B|2	A、B相互转发
#~~~~~~~~~~~~~~~~~~~~~~~~~~~# match 1359 times~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
100, 110, 120, 130, 140, 146, 150, 160, 170, 180, 186, 190
281, 266, 669, 483, 344, 111, 307, 5120, 9310, 6100, 5340, 697

# function of matching 1359 times
proc.time()
memory.limit(20000)
  mfunc<-function(n){
    subdata<-read.table(paste("E:/Sun Caihong Data (Weibo)/DATA_LINK/Rename/rename txt/", n,".txt", sep=""), header = FALSE, sep ="|")                     
    subnet<-subset(subdata, subdata[,1]%in%users$uid)
    return(subnet)
    }
  data<-lapply(c(101:200), mfunc) # class is list
  re1<-as.data.frame(do.call("rbind", data));dim(re1)
  write.csv(re1, "D:/Chengjun/Weibo/data/Diffusion Data on Weibo/subnetwork200.csv")
proc.time() # 10 minutes 100 files. good.
## work with tmp  and cleanup
rm(data)
rm(re1)

  data<-lapply(c(201:300), mfunc) # class is list
  re1<-as.data.frame(do.call("rbind", data));dim(re1)
  write.csv(re1, "D:/Chengjun/Weibo/data/Diffusion Data on Weibo/subnetwork300.csv")
proc.time() # 10 minutes 100 files. good.
## work with tmp  and cleanup
rm(data)
rm(re1)

  data<-lapply(c(301:400), mfunc) # class is list
  re1<-as.data.frame(do.call("rbind", data));dim(re1)
  write.csv(re1, "D:/Chengjun/Weibo/data/Diffusion Data on Weibo/subnetwork400.csv")
proc.time() # 10 minutes 100 files. good.
## work with tmp  and cleanup
rm(data)
rm(re1)

  data<-lapply(c(401:500), mfunc) # class is list
  re1<-as.data.frame(do.call("rbind", data));dim(re1)
  write.csv(re1, "D:/Chengjun/Weibo/data/Diffusion Data on Weibo/subnetwork500.csv")
proc.time() # 10 minutes 100 files. good.
## work with tmp  and cleanup
rm(data)
rm(re1)

  data<-lapply(c(501:600), mfunc) # class is list
  re1<-as.data.frame(do.call("rbind", data));dim(re1)
  write.csv(re1, "D:/Chengjun/Weibo/data/Diffusion Data on Weibo/subnetwork600.csv")
proc.time() # 10 minutes 100 files. good.
## work with tmp  and cleanup
rm(data)
rm(re1)

  data<-lapply(c(601:700), mfunc) # class is list
  re1<-as.data.frame(do.call("rbind", data));dim(re1)
  write.csv(re1, "D:/Chengjun/Weibo/data/Diffusion Data on Weibo/subnetwork700.csv")
proc.time() # 10 minutes 100 files. good.
## work with tmp  and cleanup
rm(data)
rm(re1)

  data<-lapply(c(701:800), mfunc) # class is list
  re1<-as.data.frame(do.call("rbind", data));dim(re1)
  write.csv(re1, "D:/Chengjun/Weibo/data/Diffusion Data on Weibo/subnetwork800.csv")
proc.time() # 10 minutes 100 files. good.
## work with tmp  and cleanup
rm(data)
rm(re1)

  data<-lapply(c(801:900), mfunc) # class is list
  re1<-as.data.frame(do.call("rbind", data));dim(re1)
  write.csv(re1, "D:/Chengjun/Weibo/data/Diffusion Data on Weibo/subnetwork900.csv")
proc.time() # 10 minutes 100 files. good.
## work with tmp  and cleanup
rm(data)
rm(re1)

  data<-lapply(c(901:1000), mfunc) # class is list
  re1<-as.data.frame(do.call("rbind", data));dim(re1)
  write.csv(re1, "D:/Chengjun/Weibo/data/Diffusion Data on Weibo/subnetwork1000.csv")
proc.time() # 10 minutes 100 files. good.
## work with tmp  and cleanup
rm(data)
rm(re1)

  data<-lapply(c(1001:1100), mfunc) # class is list
  re1<-as.data.frame(do.call("rbind", data));dim(re1)
  write.csv(re1, "D:/Chengjun/Weibo/data/Diffusion Data on Weibo/subnetwork1100.csv")
proc.time() # 10 minutes 100 files. good.
## work with tmp  and cleanup
rm(data)
rm(re1)

  data<-lapply(c(1101:1200), mfunc) # class is list
  re1<-as.data.frame(do.call("rbind", data));dim(re1)
  write.csv(re1, "D:/Chengjun/Weibo/data/Diffusion Data on Weibo/subnetwork1200.csv")
proc.time() # 10 minutes 100 files. good.
## work with tmp  and cleanup
rm(data)
rm(re1)

  data<-lapply(c(1201:1300), mfunc) # class is list
  re1<-as.data.frame(do.call("rbind", data));dim(re1)
  write.csv(re1, "D:/Chengjun/Weibo/data/Diffusion Data on Weibo/subnetwork1300.csv")
proc.time() # 10 minutes 100 files. good.
## work with tmp  and cleanup
rm(data)
rm(re1)

  data<-lapply(c(1301:1359), mfunc) # class is list
  re1<-as.data.frame(do.call("rbind", data));dim(re1)
  write.csv(re1, "D:/Chengjun/Weibo/data/Diffusion Data on Weibo/subnetwork1359.csv")
proc.time() # 10 minutes 100 files. good.
## work with tmp  and cleanup
rm(data)
rm(re1)

# proc.time() # 10 minutes 100 files. good.
     用户      系统      流逝 
  6831.56     85.23 121324.77 
#      用户      系统      流逝 
  1182.48     19.48 115452.19 


snet100<-read.csv("D:/Chengjun/Weibo/data/Diffusion Data on Weibo/subnetwork100.csv", header=T, sep=",")
snet200<-read.csv("D:/Chengjun/Weibo/data/Diffusion Data on Weibo/subnetwork200.csv", header=T, sep=",")
snet300<-read.csv("D:/Chengjun/Weibo/data/Diffusion Data on Weibo/subnetwork300.csv", header=T, sep=",")
snet400<-read.csv("D:/Chengjun/Weibo/data/Diffusion Data on Weibo/subnetwork400.csv", header=T, sep=",")
snet500<-read.csv("D:/Chengjun/Weibo/data/Diffusion Data on Weibo/subnetwork500.csv", header=T, sep=",")
snet600<-read.csv("D:/Chengjun/Weibo/data/Diffusion Data on Weibo/subnetwork600.csv", header=T, sep=",")
snet700<-read.csv("D:/Chengjun/Weibo/data/Diffusion Data on Weibo/subnetwork700.csv", header=T, sep=",")
snet800<-read.csv("D:/Chengjun/Weibo/data/Diffusion Data on Weibo/subnetwork800.csv", header=T, sep=",")
snet900<-read.csv("D:/Chengjun/Weibo/data/Diffusion Data on Weibo/subnetwork900.csv", header=T, sep=",")
snet1000<-read.csv("D:/Chengjun/Weibo/data/Diffusion Data on Weibo/subnetwork1000.csv", header=T, sep=",")
snet1100<-read.csv("D:/Chengjun/Weibo/data/Diffusion Data on Weibo/subnetwork1100.csv", header=T, sep=",")
snet1200<-read.csv("D:/Chengjun/Weibo/data/Diffusion Data on Weibo/subnetwork1200.csv", header=T, sep=",")
snet1300<-read.csv("D:/Chengjun/Weibo/data/Diffusion Data on Weibo/subnetwork1300.csv", header=T, sep=",")
snet1400<-read.csv("D:/Chengjun/Weibo/data/Diffusion Data on Weibo/subnetwork1359.csv", header=T, sep=",")

snet<-rbind(snet100, snet200, snet300, snet400, snet500, snet600,snet700, snet800, snet900,
     snet1000, snet1100, snet1200,snet1300, snet1400)
write.csv(snet, "D:/Chengjun/Weibo/data/Diffusion Data on Weibo/socialgraph_of_retweet.csv")
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~network threshold~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# length(unique(snet[,2]))# [1] 17753
# length(unique(rt$uid))# [1] 17773
# so 20 of them don't follow anyone.
# only use the uid  retweet.time  re.link
## although here we could identify from whom the news flow from, i ignore the information.
snews<-data.frame(rt$uid, rt$retweet.time, rt$re.link)
names(snet)<-c("X", "uid", "fid")
names(snews)<-c("uid", "time", "news")
# assign a newsindex for each news
id<-as.data.frame(table(snews$news))
rid<-rank(1/rank(id$Freq, na.last = TRUE, ties.method = "random")) 
id$rank<-rid
names(id)<-c("news", "Freq",  "newsindex") 
sid<-subset(id, id$newsindex<=100)  # only top 100 news deserves attentions, 65 reposts for the rank 100 news.
snews<-merge(snews, id, by="news")
# clean and transform the time
snews$time<-as.character(snews$time)
snews$time<-substr(snews$time, 1, 19)
 c1<-format(b1, format = "%Y-%m-%d %H:%M:%S", usetz = FALSE)
 c2<-format(b2, format = "%Y-%m-%d %H:%M:%S", usetz = FALSE)
snews$ptime <- as.numeric(gsub("[: -]", "" ,snews$time, perl=TRUE))

# strptime(snews$time[1:2], format="%Y-%m-%d %H:%M:%S")
write.csv(snews, "D:/Chengjun/Weibo/data/Diffusion Data on Weibo/news_diffusion.csv")
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~funcion of newsthresholds~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
names(snews)
names(snet)
##~~~~~~~~~~~~~~不知为什么，我的function总出错。因此开始检查~~~~~~~~~~~~~~~~~~~~~##
# 首先固定第一层函数的newsid，选择一个用来sapply的newsid为100,即编号为100的新闻。
            newsid<-100
# 选出编号为100的新闻的所有转发者，如下：
            voters<-subset(snews,snews$newsindex==newsid); dim(voters)
# 固定第二层函数的id，选择编号为1的转发者
            id<-voters$uid[1];id
# 可得到这一个转发者的所关注的所有的人的list
            friends=subset(snet$fid, snet$uid==id);friends  #for each voter, find his friends
# 其中，这些人当中转发第100条新闻的人的id的list如下
    adoptedFriends=intersect(friends,voters$uid); adoptedFriends
# 这些转发者的转发时间：
            timeofAdoptinfriend=subset(voters$ptime,voters$uid%in?optedFriends)
# 编号为1的转发者的转发时间。
            timeofuid<-subset(voters$ptime, voters$uid==id);timeofuid
# 得到比编号为1的转发者转发时间还早的被关注者的数量
          NofEarlierAdoptFriends=length(subset(timeofAdoptinfriend,timeofAdoptinfriend<timeofuid))
#计算出该门槛值，如下：
     rate=NofEarlierAdoptFriends/length(friends)

# 结果发现一个很practical的问题：对于同一条微博，一个人转发多次！！！！
# 这是一个诡异却可以理解的事件。
# 例如编号为2的转发者的朋友中的一个人转发了第100条新闻8次！去掉多次转发，这个数据更小了。


> subset(voters,voters$uid== 1182389073)
                                            news        uid                time Freq newsindex        ptime
8363 http://t.sina.com.cn/1182389073/ez1aj3AweXo 1182389073 2011-04-23 22:27:20   65       100 2.011042e+13
8371 http://t.sina.com.cn/1182389073/ez1aj3AweXo 1182389073 2011-04-23 23:23:22   65       100 2.011042e+13
8376 http://t.sina.com.cn/1182389073/ez1aj3AweXo 1182389073 2011-04-23 22:14:05   65       100 2.011042e+13
8377 http://t.sina.com.cn/1182389073/ez1aj3AweXo 1182389073 2011-04-24 09:13:18   65       100 2.011042e+13
8378 http://t.sina.com.cn/1182389073/ez1aj3AweXo 1182389073 2011-04-23 22:24:16   65       100 2.011042e+13
8389 http://t.sina.com.cn/1182389073/ez1aj3AweXo 1182389073 2011-04-24 10:40:26   65       100 2.011042e+13
8393 http://t.sina.com.cn/1182389073/ez1aj3AweXo 1182389073 2011-04-23 22:43:27   65       100 2.011042e+13
8397 http://t.sina.com.cn/1182389073/ez1aj3AweXo 1182389073 2011-04-24 09:39:18   65       100 2.011042e+13


nthreshold<-function(newsid)
     {               
	voters<-subset(snews,snews$newsindex==newsid)   #get the voters for story n
	
      # get the thresold of a voter
	vthreshold=function(id)
      {
            
		friends=subset(snet$fid, snet$uid==id)  #for each voter, find his friends
		adoptedFriends=intersect(friends,voters$uid)
		timeofAdoptinfriend=subset(voters$ptime,voters$uid %in% adoptedFriends)
		NofEarlierAdoptFriends=length(subset(timeofAdoptinfriend,timeofAdoptinfriend<voters$ftime)) 	
		rate=NofEarlierAdoptFriends/length(friends)
	return(rate)
	}
	voterthresholds=sapply(voters$uid,vthreshold)

	l=length(voters$uid)
	data<-cbind(rep(newsindex,l),voters$uid,vthresolds)
   return (data)
     }

 t1<-sapply(100,newsthresholds)   # there are 3553 news stories.

> names(snews)
[1] "news"      "uid"       "time"      "Freq"      "newsindex" "ptime"

##~~~~~~~~~~~~~~~~~~~~~~~read twitter social graph~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
#data# http://an.kaist.ac.kr/traces/WWW2010.html

tw<-read.table("D:/Chengjun/twitter_social_ network/twitter_rv/twitter_rv.txt", 
           header = FALSE, sep = "", 
           na.strings = "NA", colClasses = NA, 
           nrows = 10,
           skip = 0)
tw

# 1.47*10^9
# USER \t FOLLOWER \n
# 12 13  # means that Users 13 is a follower of user 12.
# before April of 2010

# I split the large file into many small ones.
## numeric to screen names
name<-read.table("D:/Chengjun/twitter_social_ network/numeric2screen/numeric2screen.txt",
                header=F, sep="",
                na.strings = "NA", colClasses = NA, 
                nrows = 10,
                skip = 0)
## get the numeric for the tweets user










