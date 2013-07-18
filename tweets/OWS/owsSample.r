# samping from ows tweets
# chengjun
# 20120502

# select the weibo of 30+ events using python script
# chengjun wang @ Canberra 20120413


data = open("C:/Python27/weibo/Weibo_repost/media landscape data/OWS.XML", 'r')
output = open("C:/Python27/weibo/Weibo_repost/media landscape data/testXml1.txt", 'w')

for line in data:
    if line.find("mid")!= -1 or line.find("rtMid")!= -1:
	output.write(line)
# and then using r to sample
ows<-read.csv("C:/Python27/weibo/Weibo_repost/media landscape data/owsSample.csv", header=F, sep=":")

# strip and spit the strings
space<-gsub(" ","", as.character(ows$V2), fixed=TRUE)
mid<-strsplit(space,split="<")
mid<-as.data.frame(do.call("rbind", mid))
ows$mid<-mid$V1

# index and sample
ows$id<-cumsum(as.character(ows$V1)=="mid")
rt<-subset(ows, ows$V1=="rtMid")
`%ni%`<- Negate(`%in%`)
or<-subset(ows, ows$id%ni%rt$id)
dat<-data.frame(rbind(or, rt))
dat<-id[with(id, order(id)), ]
table(dat$V1) # mid  573  rtMid   419 
umid<-unique(dat$mid)

data<-subset(dat, dat[,4]%in%umid)
data$mid<-as.numeric(levels(data$mid)[data$mid])
mid=unique(data$mid)
write.csv(mid, "C:/Python27/weibo/Weibo_repost/media landscape data/owsSampleMid.csv")
# Using python I get the reposts for 792 tweets
rt<-read.csv("C:/Python27/weibo/Weibo_repost/owsRtTimes.csv", header=F)
rtt<-data.frame(table(rt[,2]))
# check the distribution
hist(rt$V2, breaks=100, xlab="Extent of Diffusion", 
     col="purple", main = paste("Histogram of" , "Diffusion Range"))
plot(log(rtt[,2]/sum(rtt$Freq))~log(as.numeric(rtt[,1])), 
     col="blue", xlab="Retweeted Times", ylab="Probability")
# the linear growth curve!
app<-read.csv("d:/app-2425101550.csv", header=T)
app$day<-c(1:length(app$Time))

plot(app$Installs~app$day, col="green", xlab="Day", ylab="Number of Installs and DAU")
lines(app$DAU~app$day, col="purple")

plot(app$DAU~app$day)
plot(app$Installs~app$DAU)
plot(cumsum(as.numeric(app$Installs))~app$day)

# check the data
# ows<-read.csv("C:/Python27/weibo/Weibo_repost/repostOwsSave.csv", header=F, sep=",", quote = "|", stringsAsFactors=F)
ows<-read.csv("D:/google drive/Google Drive/News diffusion/Sina Weibo/data/repostOwsSave2.csv", header=F, sep=",", quote = "|", stringsAsFactors=F)

names(ows)<-c('mid','created', 
  'user_id', 'user_name', 'user_province', 'user_city', 'user_gender', 
  'user_url', 'user_followers', 'user_friends', 'user_statuses', 'user_created', 'user_verified',  # rts_text, 
  'rts_mid', 'rts_created', 
  'rtsuser_id', 'rtsuser_name', 'rtsuser_province', 'rtsuser_city', 'rtsuser_gender', 
  'rtsuser_url', 'rtsuser_followers', 'rtsuser_friends', 'rtsuser_statuses', 'rtsuser_created', 'rtsuser_verified') # ,
  # 'text')
#
mid<-data.frame(table(ows$rts_mid))


# parse the text to get diffusion path
library(gsubfn)
findVia<-function(n){
  via<-strapply(ows$text[n], paste("\\w*", "@", "\\w*", sep = ""), c, simplify = unlist)[1]
  if (is.null(via)==FALSE) {
     via=(strsplit(via, "@"))[[1]][2]} else {
  if (is.null(via)==TRUE) {
     via=NA}}
  return (via)
  }
list<-lapply(c(1:length(ows$text)), findVia)
via<-as.character(t(t(lapply(list,c))))
ows$via<-via
ows$via[ows$via=="NA"]<-NA
ows$bridge<-ifelse(is.na(ows$via)==TRUE, ows$rtsuser_name, ows$via)
# write.csv(ows, "D:/google drive/Google Drive/News diffusion/Sina Weibo/data/repostOwsSave1.csv")
# 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~hack's law~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
library(igraph) 

id<-unique(ows$rts_mid)

getHack<-function(n){
        subNet<-subset(ows, ows$rts_mid==n)
        length<-length(subNet$user_id)
        subNet<-data.frame(ows$user_name, ows$bridge)
        g<-graph.data.frame(subNet, directed=TRUE, vertices=NULL)
        diameter <- diameter(g)
        area<-length(unique(subset(net$uid1, net$uid2%in%uid)))+ length(uid)
        hack<-c(diameter, area)
        return (hack)
        }
getLength<-function(newsId){
        uid<-subset(digg$uid, digg$newsId==newsId)
        length<-length(uid)
        return (length)
        }

getLifetime<-function(newsId){
        time<-subset(digg$time, digg$newsId==newsId)
        duration<-max(time)-min(time)      
        return (duration)
        }
duration<-lapply(c(1:3553), getLifetime)
length<-lapply(c(1:3553),getLength)

result=as.data.frame(do.call(rbind, list<-lapply(c(1:3553),getHack)))

write.csv(result, "d:/chengjun/digg/digg_hack_law.csv") 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
g<-data.frame(ows$user_name, ows$bridge)
library(igraph)
g<-graph.data.frame(g)
g2 <- simplify(g, remove.loops=T, remove.multiple=F)
is.simple(g2)
l <- layout.fruchterman.reingold(g) # This takes a lot of time

plot(g, layout=l,
     vertex.color="#ff0000", vertex.frame.color="#ff0000", 
     edge.color="#555555", vertex.size=2, 
     vertex.label.dist=0, vertex.label.cex=0.8, 
     vertex.label=NA, 
     vertex.label.font=0.8,
     edge.arrow.size=0.01 )

