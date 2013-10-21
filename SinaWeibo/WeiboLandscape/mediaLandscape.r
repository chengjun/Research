# The landscape of China media on Microblog
# 20120409 Wang Chengjun @ Canberra
# 20131021 Wang Chengjun @ CMC, Hong Kong

#####################
"Load Data"
#####################

"import user info"

me<-read.csv("C:/Python27/weibo/Weibo_repost/media landscape data/mediaProfileNew.csv",
    header=T, sep="," , stringsAsFactors=F)
# clean the time format as duraton of days
date<-(as.data.frame(do.call(rbind,  d<-strsplit(me$created_at, split=" "))))[1]
date1<-as.Date(strptime(as.character(date$V1), "%Y/%m/%d"))
date2<-as.Date("2012-04-09")+rep(0,800)
me$day <- date2 - date1
me$day<-as.numeric(as.character(me$day))
"import network"
net<-read.csv("C:/Python27/weibo/Weibo_repost/media landscape data/mediaNetworkNew.csv",
      header=FALSE, sep=",", quote="|", stringsAsFactors=F)
dim(net)

"Network cleaning"
names(net)<-c("a", "b")
getEdge<-function(n){
  nt=nchar(net$b[n])
  ind=substring(net$b[n], 2, nt-1)
  ind=paste(unlist(strsplit(ind,split=" ")), collapse="")
  ind=unlist(strsplit(ind, ","))
  out=rep(net$a[n], length(ind))
  dat=data.frame(out, ind)
  return(dat)}

data<-lapply(c(1:800), getEdge)
df <- do.call("rbind", data) # rbind the data.frame in the list
# write.csv(df, "C:/Python27/weibo/Weibo_repost/media landscape data/mediaEdgeList.csv")
ds<-subset(df, df$ind%in%net$a)
# write.csv(ds, "C:/Python27/weibo/Weibo_repost/media landscape data/mediaEdgeListClean.csv")

##################
"Plot networks"
##################

library(igraph) 
g<-graph.data.frame(ds, directed=T, vertices=NULL)
summary(g)
# plot(g, vertex.label= NA,edge.arrow.size=0.2, vertex.size=2, layout=layout.fruchterman.reingold )
pop<-me$followers_count[match(V(g)$name,as.character(me$id))]
code=sort(unique(pop))
pop=match(pop,code)
V(g)$size=log(me$followers_count*1000)/5
# V(g)$size=log(degree(g)) # the list of nodes is V(g)

me$cat<-c(rep(1, 100), rep(2, 100), rep(3, 100), rep(4, 100), rep(5, 100), rep(6, 100), rep(7, 100), rep(8,100))
cat<-me$cat[match(V(g)$name,as.character(me$id))]
code=sort(unique(cat$cat))
cat=match(cat,code)
# This sorts the values and assigns a unique id for each ID number
# This matches the IDs of column 1 in the edgelist to the unique IDs
V(g)$color <- rainbow(max(cat))[cat]
par(mfrow=c(1,1))
plot(g, vertex.label= NA,edge.arrow.size=0.2,layout=layout.kamada.kawai)

color<-rainbow(max(cat))[c(1:8)]
plot(rep(3,8), col=color,axes = T, ann = F)

######################
"Plot attention flow"
######################
cat<-data.frame(me$id, me$category)
names(cat)<-c("out", "cat")
dc<-merge(ds, cat, by="out")
names(cat)<-c("ind", "cat")
dc<-merge(dc, cat, by="ind")
dc$edge<-paste(dc$cat.x, dc$cat.y)
write.csv(data.frame(table(dc$edge)), "C:/Python27/weibo/Weibo_repost/media landscape data/mediaFlow.csv")

# library(igraph) 
gdc<-graph.data.frame(dc[,3:4], directed=T, vertices=NULL)
summary(gdc)
E(gdc)$color <- "grey"
E(gdc)$width <- log(count.multiple(gdc))-5
E(gdc)$weight <- count.multiple(gdc)/100
E(gdc)$capacity <- sample(1:10, ecount(gdc), replace=TRUE)
V(gdc)$size=log(degree(gdc)^0.5)
plot(gdc, 
     vertex.label = V(gdc)$name, 
     edge.label=E(gdc)$weight,
     edge.label.size=1.5,
     edge.arrow.size=0.5, 
     layout=layout.kamada.kawai)

############################
"Detect rich-club"       
############################
att<-read.csv("D:/Dropbox/Weibo Landscape/data/Profiles 800.csv",
	header = TRUE, sep = ",", quote="", dec=".")

tie<-read.csv("D:/Dropbox/Weibo Landscape/data/Social graph Edgelist 800.csv",
	header = TRUE, sep = ",")# 418454
length(unique(tie$out)) #795
length(unique(tie$ind)) #221605
length(unique(tie$ind))- length(subset(unique(tie$ind), unique(tie$ind)%in%att$id)) # 220887
tieInt<-subset(tie, tie$ind%in%att$id); dim(tieInt) #26481
# distinguish mutual ties
library(igraph)
gc<-graph.data.frame(tieInt[,2:3], directed=TRUE, vertices=NULL)
tieInt$mutual<-is.mutual(gc)
tieIntMut<-subset(tieInt, tieInt$mutual==TRUE) ;dim(tieIntMut) # 9700
# ratio of 
9700/2/408454 # 0.0118
tim<-graph.data.frame(tieIntMut[,2:3], directed=T, vertices=NULL)
plot(tim, layout=layout.fruchterman.reingold,  
	vertex.size=1, edge.arrow.size=0.5)

## plot the mutual rich-club
library(igraph) 
g<-graph.data.frame(tieIntMut[,2:3], directed=T, vertices=NULL)

summary(g)
# plot(g, vertex.label= NA,edge.arrow.size=0.2, vertex.size=2, layout=layout.fruchterman.reingold )
# atts<-subset(att, as.character(att$id) %in% V(g)$name);dim(atts)# 672
id<-data.frame(as.numeric(V(g)$name))   ;names(id)<-c("id") ; head(id)
atts<-merge(id, att, by=c("id"),sort = FALSE)
V(g)$size=log(atts$followers_count*1000)/5
library(car) # install.packages("car")
cat<-recode(att$category, "'celebrity'=1;  'government'=2;  'grassroot'=3;   'magazine'=4;
                           'newspaper'=5;      'radio'=6;         'tv'=7;    'website'=8") 
cat<-as.numeric(levels(cat)[cat])
V(g)$color <- rainbow(max(cat))[cat]
# names(igraph:::.igraph.shapes) # only 7 shapes, the 8th is none which is meaningless! sigh!
shape<-recode(att$category, "'celebrity'='circle';  'government'='square';  'grassroot'='csquare';
                           'magazine'='rectangle'; 'newspaper'='crectangle';  'radio'='vrectangle'; 
                           'tv'='none';    'website'='pie'") 
V(g)$shape = as.character(shape)

plot(g, vertex.label= NA,edge.arrow.size=0.2,layout=layout.kamada.kawai)

############################
"ERGMs of Rich-club"
############################
"read data"
dat<-read.delim("D:/Dropbox/Weibo Landscape/data/aggregate.txt", 
                header = TRUE, sep = "\t", quote="", dec=".")
att<-read.csv("D:/Dropbox/Weibo Landscape/data/Profiles 800.csv",
              header = TRUE, sep = ",", quote="", dec=".")
socialGraph<-read.csv("D:/Dropbox/Weibo Landscape/data/mediaEdgeListClean.csv",
                      header = TRUE, sep = ",")[, 2:3] ; dim(socialGraph)# 26361
m1<-subset(dat, dat$year==2012&dat$month==1&is.na(dat$reuserid)==FALSE);dim(m1)# 36869
m2<-subset(dat, dat$year==2012&dat$month==2&is.na(dat$reuserid)==FALSE);dim(m2)# 43856
m3<-subset(dat, dat$year==2012&dat$month==3&is.na(dat$reuserid)==FALSE);dim(m3)# 43856


flows<-subset(m1, m1$uid %in% att$id  & m1$reuserid %in% att$id); dim(flows) # 3804
flows<-subset(flows, flows$uid!=flows$reuserid) ;dim(flows) # 3234  , thus there are 507 self-loops

"set edge attrubutes"
socialGraph$weight<-1
names(socialGraph)<-c("reuserid", "uid", "weight") 
# here we reverse the sequence of uid and reuserid to make it merge by reuserid first, which means
# that we select the social ties sent out by reuserid to uid, thus information can flow from uid to reuserid

flows<-merge(flows, socialGraph, by=c("reuserid","uid"),all=T, incomparables=NA); dim(flows)
flows$weight[is.na(flows$weight)]<-0 
flows<-subset(flows, !is.na(flows$year)); dim(flows)
# reverse the reuserid and uid back!!!!!!!

flows<-subset(flows,select=c(uid, reuserid, year, month, rt, weight))
"assign unique ids"
# This sorts the values and assigns a unique id for each ID number
code=sort(unique(c(flows[,1],flows[,2])))  # also use it to get node attribute
# This matches the IDs of column 1 in the edgelist to the unique IDs 
flows[,1]=match(flows[,1],code) 
# This matches the IDs of column 2 in the edgelist to the unique IDs 
flows[,2]=match(flows[,2],code) 
codes<-as.data.frame(code,  stringsAsFactors=F);dim(codes)

names(codes)<-c("id")
actt<-merge(codes, att, by="id",all=F, incomparables=NA) ;dim(actt)

# get statnet object
library(statnet)
n=network(flows[,1:2],vertex.attr=NULL, 
          vertex.attrnames=NULL,
          matrix.type="edgelist",directed=TRUE) # creates an edgelist using the unique IDs
network.vertex.names(n)=code ###very important! Assigns the actual ID numbers as vertex names### 
# summary(n) # see the basic info of the network. #  density = 0.007148092 

"set node attributes"
library(car)
followers<-as.list(actt$followers_count)
friends<-as.list(actt$friends_count)
tweets<-as.list(actt$statuses_count)
fav<-as.list(actt$favourites_count)
# duration<-as.list(actt$created_at)
cat<-as.list(actt$category)
geo<-as.list(actt$province)

noneP<-c(36, 54, 65, 82, 62, 12, 22, 23, 52, 53, 14, 34, 45, 61)
acttest<-subset(actt, !(actt$province %in% noneP)  ) ; dim(acttest)
c(acttest$province, acttest$location)
set.vertex.attribute(n, "followers", followers)
set.vertex.attribute(n,"friends",friends)
set.vertex.attribute(n,"tweets",tweets)
set.vertex.attribute(n,"cat",cat) # 1 is web 1.0, 2 is web 2.0, and 0 is search engine
set.vertex.attribute(n,"geo",geo)

"set edge attributes attributes"
socialInfluence<-as.list(flows$weight)
set.edge.attribute(n, "socialInfluence", socialInfluence, e=1:length(n$mel))

#~~~~~~~~~~~~~~model estimation~~~~~~~~~~~~~~~~~~~~~~#
m1<-ergm(n~edges
         +nodeicov('followers') 
         # +nodeicov('tweets')+nodeocov('friends')+nodeocov('')
         +nodematch('cat',diff=T)
         +dyadcov(n, 'socialInfluence')
         +mutual
         +gwdsp(fixed=F, cutoff=30)
         , calc.mcmc.se = FALSE,maxit=3,parallel=20)

#  burnin=1000, MCMCsamplesize=7000,verbose=FALSE, calc.mcmc.se = FALSE,maxit=3,parallel=5)

summary(m1)

gest <- logLik(m1, add=TRUE,parallel=10)
# Deviances, AIC, and BIC now shown:
summary(gest)
data.frame(lapply(m1[1],exp))

