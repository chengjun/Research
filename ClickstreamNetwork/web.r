# Social selection or social influence in Clickingstream
# 6/23/11
# reanalysis by chengjun 20121014 and 20131011


#############
"read data"
#############

library(statnet)
library(car)
library(igraph)
library(plyr)

setwd("D:/Chengjun/clickstream network and hyperlink network")

flow<-read.csv(paste(getwd(), "/googleflowweb20101222.csv", sep = ""), 
               header = F, sep = ",", stringsAsFactors=F)
names(flow)<-c("sender" , "receiver", "clickstream")

link<-read.csv(paste(getwd(),"/linkweb980.csv",sep = ""),
               header = T, sep = ",", stringsAsFactors=F)

att<-read.csv(paste(getwd(),"/nameurlandtraffic.csv",sep=""),
              header = T, sep = ",",stringsAsFactors=F)
# merge language
f1<-read.csv(paste(getwd(),"/finalList1.csv",sep=""),
             header = F, sep = ",",stringsAsFactors=F)
names(f1)<-c("name", "unique_visitors1", "language") 

att<-join(att, f1, by="name")

# merge category
u1<-read.csv(paste(getwd(),"/ugccode1.csv",sep=""),
             header = F, sep = ",",stringsAsFactors=F)
names(u1)<-c("name", "cat")
att<-join(att, u1, by="name")
att = att[!duplicated(att), ]; dim(att)
#########################
"prepare edge attribute"
#########################

link$hyperlink<-1
flowm<-join(flow, link, by=c("sender","receiver"), type = "full")
flows<-subset(flowm, is.na(flowm$clickstream)==FALSE)
flows$hyperlink[is.na(flows$hyperlink)]<-0
flows<-subset(flows, flows$sender!=flows$receiver) # delete self-loops

"narrow down the network"
# hist(log(flows$clickstream), freq=F,  xlab = "Clickstream (Log)", main = NULL)
# Threshold<-exp(mean(log(flows$clickstream)))
# flows<-subset(flows, flows$clickstream>Threshold);dim(flows) #  5684

# assign unique ids
code=sort(unique(c(flows[,1],flows[,2])))  # also use it to get node attribute
flows[,1]=match(flows[,1],code) 
flows[,2]=match(flows[,2],code) 
codes<-as.data.frame(code,  stringsAsFactors=F)
names(codes)<-c("name")
require(plyr)
actt<-join(codes, att, by="name") ; dim(actt) ##!!!!!!!!!!!!!!!! sequence matters now!

##################
"set vertex attributes and edge attributes"
##################
require(car)
traffic<-as.list(actt$traffic)
pagerank<-as.list(actt$pagerank)
actt$cat<-recode(actt$cat,"0=1; 1=2; 2=0",as.numeric.result=TRUE)
category<-as.list(actt$cat)
lan = actt$lan = recode(actt$language, 
                        "'english'='purple' ; 'chinese'='green'; 'japanese'='blue';
                         'german'='red'; 'russian'='brown';
                         'french'='grey'; 'korean'='yellow'; 
                         'spanish'='pink'; else='cadetblue'", 
                        as.factor.result=FALSE)

lan<-as.list(lan)

shapes = actt$shapes = recode(actt$language, 
                        "'english'='circle' ; 'chinese'='square'; 'japanese'='vrectangle';
                         'german'='crectangle'; 'russian'='csquare';
                         'french'='sphere'; 'korean'='raster'; 
                         'spanish'='pie'; else='circle'", 
                        as.factor.result=FALSE)

shapes<-as.list(shapes)

# english	507 # chinese	203 # japanese	95  # german	30
# russian	28  # french	27  # korean	26  # spanish	18

#####################
"plot the network"
#####################

require(igraph)
j<-flows[, 1:2] # memberships <- list()
jj<-graph.data.frame(j, directed=TRUE, vertices=NULL)

# 明确节点属性
name = V(jj)
V(jj)$color <- actt$lan
# V(jj)$size = size = (scale(actt$unique_visitors) + 2)*1.5; hist(size, breaks = 100); summary(size)
V(jj)$size = size = (log(actt$unique_visitors) )-11; hist(size, breaks = 100); summary(size)

E(jj)$weight = flows$clickstream
E(jj)$width <- ( log(E(jj)$weight+1)- min(log(E(jj)$weight)) )/10

nodeLabel = V(jj)$name = actt$name

# nodeLabel[which(actt$traffic <  quantile(actt$traffic, 0.5) )] = ""; table(nodeLabel)
topname = c("baidu.com","qq.com","sina.com.cn", # China
            "google.com","facebook.com","yahoo.com",
            "youtube.com","wikipedia.org","twitter.com",
            "amazon.com","bing.com","linkedin.com",
            "apple.com","ask.com", # Enlish 
            "free.fr","orange.fr", # French
            "ebay.de","amazon.de", # Germany
            "yahoo.co.jp","fc2.com", # Japanese
            "naver.com","daum.net", # Korean
            "yandex.ru","mail.ru","odnoklassniki.ru") # Russia
nodeLabel[!(nodeLabel%in%topname)] = ""
V(jj)$shape <- shapes
# mannually positioning the nodes together!!!
positions = read.csv("D:/Chengjun/clickstream network and hyperlink network/layout.csv",header=T)
positionu = positions[match(V(jj)$name,positions[,1]),]
positiond = positions[match(V(jj)$name,positions[,1]),]
lout = as.matrix(positionu[,2:3])

# set.seed(35) ## to make this reproducable
# l<-layout.fruchterman.reingold(jj) # ,params=list(weights=E(jj)$weight))
# l <-  layout.graphopt(jj)
# l <-  layout.auto(jj)

# 保存图片格式
png("d:/chengjun/clickstream network and hyperlink network/www.clickstream.network_wlf.png", 
    width=10, height=10, 
    units="in", res=700)

plot(jj, vertex.label= nodeLabel,  edge.curved=F, # vertex.frame.color="#FFFFFF",
     vertex.label.cex =1,   edge.arrow.size=0.02, layout=lout) # vertex.shape=V(jj)$shape,
legend("bottomleft", # places a legend at the appropriate place 
       c('English (506)' , 'Chinese (203)', 'Japanese (95)', 
         'German (30)',  'Russian (28)',  'French (27)','Korean (26)',
         'Spanish (18)', "Else (46)"), # puts text in the legend 
       box.lwd = 0, box.col =NA, bg = NA,
#        lwd = c(2, 2, 3, 3, 4, 4, 5),
#        lty = c(0, 0, 1, 1, 2, 2, 3),
       pch = rep(19, 9), # c(3, 3, 2, 2, 5, 5, 7), 
       pt.cex=2, cex=1.2,
       col=c('Purple','Green', 'Blue',  'Red','Brown','Grey','Yellow','Pink', 'Cadetblue')) #
# 结束保存图片
dev.off()


cols = c('Purple','Green', 'Blue',  'Red','Brown','Grey','Yellow','Pink', rep('Cadetblue', 10))
df<-sort(table(actt$language), decreasing = T)
x <- barplot(df,las=2, ylim = c(0,600), col = cols)
text(x, df, labels=df, pos=3) 

"'english'='purple' ; 'chinese'='green'; 'japanese'='blue';
'german'='red'; 'russian'='brown';
'french'='grey'; 'korean'='yellow'; 
'spanish'='pink'; else='cadetblue'", 

'Community detection for semantic network'
#####

# fc <- fastgreedy.community(jj); sizes(fc)
# fc <- walktrap.community(jj); sizes(fc)
# fc <- spinglass.community(jj); sizes(fc)
# fc <- leading.eigenvector.community(jj); sizes(fc)
# fc <-  edge.betweenness.community(jj); sizes(fc)
# fc <-  infomap.community(jj); sizes(fc)
# fc <-  multilevel.community(jj); sizes(fc) # 
# fc <-  optimal.community(jj); sizes(fc) # 

fc <-  label.propagation.community(jj); sizes(fc)
mfc = membership(fc)
for (i in 1:max(mfc)) cat("\n", i, names(mfc[mfc==i]), "\n")


V(jj)$color[which(V(jj)$name%in%names(mfc[mfc==1]))]="purple"
V(jj)$color[which(V(jj)$name%in%names(mfc[mfc==2]))]="blue"
V(jj)$color[which(V(jj)$name%in%names(mfc[mfc==3]))]="green"
V(jj)$color[which(V(jj)$name%in%names(mfc[mfc==4]))]="red"
V(jj)$color[which(V(jj)$name%in%names(mfc[mfc==5]))]="grey"
V(jj)$color[which(V(jj)$name%in%names(mfc[mfc>=6]))]="yellow"

# 保存图片格式
png("d:/chengjun/clickstream network and hyperlink network/www.clickstream.network_community_small_4.png", 
    width=10, height=10, 
    units="in", res=700)
plot(jj, vertex.label= nodeLabel,  edge.curved=F, vertex.frame.color="#FFFFFF",
     vertex.label.cex =0.6,  edge.arrow.size=0.02, layout=lout)

# 结束保存图片
dev.off()

category=NULL
for(i in 1:11){
  dd = data.frame(table(actt$website_type[which(actt$name%in%names(mfc[mfc==i]))]), stringsAsFactors = F)
  category[[i]] = cbind(tail(dd[with(dd, order(Freq)), ], 10), i)
#   print( category[[i]] )
}

category
do.call(rbind, category)

####################
'plot the Language-community graph'
####################
actt$id = rownames(actt)
lan.name = actt[,c("id", "language")]
names(lan.name) = c("sender", "sender.language")
flowsa = join(flows, lan.name, by = "sender"); dim(flowsa); head(flowsa)
names(lan.name) = c("receiver", "receiver.language")
flowsa = join(flowsa, lan.name, by = "receiver"); dim(flowsa); head(flowsa)
flowsb= flowsa[,c("sender.language", "receiver.language", "clickstream")]
flowsc<-aggregate(flowsb$clickstream, by=list(flowsb$sender.language, flowsb$receiver.language), FUN=sum)

write.csv(flowsc, "d:/chengjun/clickstream network and hyperlink network/flowsc_language_parralel.csv")
function(i){
  
}

 # memberships <- list()
g<-graph.data.frame(flowsc[, 1:2], directed = TRUE , vertices=NULL)
# 明确节点属性
V(g)$name = c("Chinese","English","Arabic", "Japanese" ,  "Korean", "Dutch",  "Czech",  "French", "German",
              "Italian", "Polish", "Portuguese", "Russian","Spanish","Thai",   "Turkish","Vietnamese")

E(g)$weight = flowsc[,3]
# E(g)$width <- ( log(E(g)$weight+1)- min(log(E(g)$weight)) ) +1
E(g)$width <- ( scale(E(g)$weight+1) ) +2

set.seed(35) ## to make this reproducable
# l<-layout.circle(g) # ,params=list(weights=E(jj)$weight))
# l <-  layout.graphopt(g)
l <-  layout.auto(g)

# 保存图片格式
png("d:/chengjun/clickstream network and hyperlink network/www.clickstream.network.Language.community7.png", 
    width=12, height=10, 
    units="in", res=700)

plot(g, # vertex.label= nodeLabel, 
     vertex.shape="circle",
     edge.curved=T,# vertex.size =5, # vertex.frame.color="#FFFFFF",
     vertex.label.cex =2,  # edge.color="black",
     edge.arrow.size=E(g)$width, layout=l) # 
dev.off()

'plot the Web2.0-community graph'

####################
'plot the web.type-community graph'
####################
actt$id = rownames(actt)
lan.name = actt[,c("id", "cat")]
names(lan.name) = c("sender", "sender.cat")
flowsa = join(flows, lan.name, by = "sender"); dim(flowsa); head(flowsa)
names(lan.name) = c("receiver", "receiver.cat")
flowsa = join(flowsa, lan.name, by = "receiver"); dim(flowsa); head(flowsa)
flowsb= flowsa[,c("sender.cat", "receiver.cat", "clickstream")]
flowsc<-aggregate(flowsb$clickstream, by=list(flowsb$sender.cat, flowsb$receiver.cat), FUN=sum)


# memberships <- list()
g<-graph.data.frame(flowsc[, 1:2], directed=TRUE,  vertices=NULL)
# 明确节点属性
V(g)$name = c("Search engine", "Web 1.0" , "Web 2.0")
# V(g)$color 
# V(jj)$size = size = (scale(actt$unique_visitors) + 2)*1.5; hist(size, breaks = 100); summary(size)
# V(jj)$size = size = (log(actt$unique_visitors) )-11; hist(size, breaks = 100); summary(size)

E(g)$weight = flowsc[,3]/c(rep(c(22, 778, 179),3 ))
E(g)$width <- log( E(g)$weight/min(E(g)$weight) )  + 2

set.seed(35) ## to make this reproducable
# l<-layout.circle(g) # ,params=list(weights=E(jj)$weight))
# l <-  layout.graphopt(g)
l <-  layout.auto(g)

# 保存图片格式
png("d:/chengjun/clickstream network and hyperlink network/www.clickstream.network.web_type.community3.png", 
    width=12, height=10, 
    units="in", res=700)

plot(g, # vertex.label= nodeLabel,  
     vertex.shape="square", 
     edge.label=round(E(g)$weight),
     edge.label.cex = 2, 
     vertex.size = 70,
     edge.curved=T, # vertex.frame.color="#FFFFFF",
     vertex.label.cex =2,   
     edge.arrow.size=E(g)$width-1, layout=l) # vertex.shape=V(jj)$shape,
dev.off()


####################
"ERGM: Data preparition"
####################

detach(package:igraph)
library(statnet)
n=network(flows[,1:2],vertex.attr=NULL, vertex.attrnames=NULL,matrix.type="edgelist",directed=TRUE) # creates an edgelist using the unique IDs
network.vertex.names(n)=code ###very important! Assigns the actual ID numbers as vertex names### 
# summary(n) # see the basic info of the network.
set.vertex.attribute(n, "traffic", traffic)
set.vertex.attribute(n,"pagerank",pagerank)
set.vertex.attribute(n,"lan",lan)
set.vertex.attribute(n,"category",category) # 1 is web 1.0, 2 is web 2.0, and 0 is search engine

# list.edge.attributes(n)
hyperlink<-as.list(flows$hyperlink)
clickstream<-as.list(flows$clickstream)

set.edge.attribute(n, "hyperlink", hyperlink, e=1:length(n$mel))
set.edge.attribute(n, "clickstream", clickstream, e=1:length(n$mel))

# set.edge.value(n, "hyperlink", hyperlink)

##################
"model estimation"
##################

m1<-ergm(n~edges
         +nodeicov('traffic')+nodeicov('pagerank')
         +nodematch('lan',diff=T)
         +nodematch('category',diff=T)
         +dyadcov(n, 'hyperlink')
         +mutual
         +gwdsp(fixed=T, cutoff=30),
         burnin=1000, MCMCsamplesize=7000,seed=250,verbose=FALSE,calc.mcmc.se = FALSE,maxit=3,parallel=8)

#  burnin=1000, MCMCsamplesize=7000, verbose=FALSE, calc.mcmc.se = FALSE,maxit=3,parallel=5)


summary(m1)

gest <- logLik(m1, add=TRUE,parallel=10)
# Deviances, AIC, and BIC now shown:
summary(gest)
data.frame(lapply(m1[1],exp))

#############
"Lingfei Wu's plot"
#############

f = read.csv("D:/Chengjun/clickstream network and hyperlink network/googleflowweb20101222.csv",header=F)
require(igraph)
j<-f[, 1:2] # memberships <- list()
jj<-graph.data.frame(j, directed=TRUE, vertices=NULL)

languageGroup = read.csv("D:/Chengjun/clickstream network and hyperlink network/finalList1.csv",header=F)
positions = read.csv("D:/Chengjun/clickstream network and hyperlink network/layout.csv",header=T)
positionu = positions[match(V(jj)$name,positions[,1]),]
positiond = positions[match(V(jj)$name,positions[,1]),]
lout = as.matrix(positionu[,2:3])

matchLanguageGroup = function(websitename){
  t = subset(languageGroup, languageGroup[,1]==websitename)
  return(t[,3])
}

matchTraffic = function(websitename){
  t = subset(languageGroup, languageGroup[,1]==websitename)
  return(t[,2])
}

lg = as.data.frame(sapply(V(jj)$name, matchLanguageGroup), stringsAsFactors = F)
tg = as.data.frame(sapply(V(jj)$name, matchTraffic), stringsAsFactors = F)
require(car)
lg$lan = recode(lg[,1], 
                "'english'='purple' ; 'chinese'='green'; 'japanese'='blue';
                'german'='red'; 'russian'='brown';
                'french'='grey'; 'korean'='yellow'; 
                'spanish'='pink'; else='black'", 
                as.factor.result=FALSE)

V(jj)$color = lg$lan
V(jj)$size = size = log(as.numeric(as.vector(tg[,1])))-10
plot(jj, layout = lout, edge.arrow.size=0.05, vertex.label = NA)

#####################
"plot the network with dropdown layout"
#####################

require(igraph)
j<-flows[, 1:2] # memberships <- list()
jj<-graph.data.frame(j, directed=TRUE, vertices=NULL)

# 明确节点属性
name = V(jj)
V(jj)$color <- actt$lan
# V(jj)$size = size = (scale(actt$unique_visitors) + 2)*1.5; hist(size, breaks = 100); summary(size)
V(jj)$size = size = (log(actt$unique_visitors) )-11; hist(size, breaks = 100); summary(size)

E(jj)$weight = flows$clickstream
E(jj)$width <- ( log(E(jj)$weight+1)- min(log(E(jj)$weight)) )/10

nodeLabel = V(jj)$name = actt$name

# nodeLabel[which(actt$traffic <  quantile(actt$traffic, 0.5) )] = ""; table(nodeLabel)
topname = c("baidu.com","qq.com","sina.com.cn", # China
            "google.com","facebook.com","yahoo.com",
            "youtube.com","wikipedia.org","twitter.com",
            "amazon.com","bing.com","linkedin.com",
            "apple.com","ask.com", # Enlish 
            "free.fr","orange.fr", # French
            "ebay.de","amazon.de", # Germany
            "yahoo.co.jp","fc2.com", # Japanese
            "naver.com","daum.net", # Korean
            "yandex.ru","mail.ru","odnoklassniki.ru") # Russia
nodeLabel[!(nodeLabel%in%topname)] = ""

# mannually positioning the nodes together!!!
positions = read.csv("D:/Chengjun/clickstream network and hyperlink network/layout.csv",header=T)
web.eng = subset(actt$name, actt$language == "english")
positions[positions$vertex %in% web.eng,3] = positions[positions$vertex %in% web.eng,3] - 300
web.ger = subset(actt$name, actt$language == "german")
positions[positions$vertex %in% web.ger,2] = positions[positions$vertex %in% web.ger,2] + 300
web.fre = subset(actt$name, actt$language == "french")
positions[positions$vertex %in% web.fre,2] = positions[positions$vertex %in% web.fre,2] + 300
positions[positions$vertex %in% web.fre,3] = positions[positions$vertex %in% web.fre,3] -100
web.rus = subset(actt$name, actt$language == "russian")
positions[positions$vertex %in% web.rus,2] = positions[positions$vertex %in% web.rus,2] - 300
web.chi = subset(actt$name, actt$language == "chinese")
positions[positions$vertex %in% web.chi,3] = positions[positions$vertex %in% web.chi,3] -500
positions[positions$vertex %in% web.chi,2] = positions[positions$vertex %in% web.chi,2] + 200
web.jap = subset(actt$name, actt$language == "japanese")
positions[positions$vertex %in% web.jap,3] = positions[positions$vertex %in% web.jap,3] -700
positions[positions$vertex %in% web.jap,2] = positions[positions$vertex %in% web.jap,2] -100
web.kor = subset(actt$name, actt$language == "korean")
positions[positions$vertex %in% web.kor,3] = positions[positions$vertex %in% web.kor,3] -1000
positionu = positions[match(V(jj)$name,positions[,1]),]
positiond = positions[match(V(jj)$name,positions[,1]),]
lout = as.matrix(positionu[,2:3])

# 保存图片格式
png("d:/chengjun/clickstream network and hyperlink network/www.clickstream.network_wlf_drop1.png", 
    width=10, height=10, 
    units="in", res=700)

plot(jj, vertex.label= nodeLabel,  edge.curved=F, # vertex.frame.color="#FFFFFF",
     vertex.label.cex =1,   edge.arrow.size=0.02, layout=lout) # vertex.shape=V(jj)$shape,
legend("bottomleft", # places a legend at the appropriate place 
       c('English (506)' , 'Chinese (203)', 'Japanese (95)', 
         'German (30)',  'Russian (28)',  'French (27)','Korean (26)',
         'Spanish (18)', "Else (46)"), # puts text in the legend 
       box.lwd = 0, box.col =NA, bg = NA,
       pch = rep(19, 9), # c(3, 3, 2, 2, 5, 5, 7), 
       pt.cex=2, cex=1.2,
       col=c('Purple','Green', 'Blue',  'Red','Brown','Grey','Yellow','Pink', 'Cadetblue')) #
# 结束保存图片
dev.off()

#############
'Descriptive analysis'
#############
flowsd<-aggregate(flows$hyperlink, by=list(flows$receiver), FUN=sum)
names(flowsd) = c("seqid","hyperlink")
seqid = data.frame(seqid = c(1:979))
flowsa = join(seqid, flowsd, by = "seqid"); dim(flowsa); head(flowsa)
actt$hyperlink = flowsa$hyperlink

plot(actt$traffic~actt$hyperlink) 
plot(log(actt$traffic)~log(actt$hyperlink))

cor(actt$traffic,actt$hyperlink, use="complete") #  0.79
cor(log(actt$traffic+1), log(actt$hyperlink+1),use="complete") # 0.54

fit = aov(clickstream~hyperlink,data=flows)
summary(fit)

fit2 = aov(traffic~cat,data=actt)
summary(fit2)


fit3 = aov(traffic~cat+cat*hyperlink + hyperlink,data=actt)
summary(fit3)


