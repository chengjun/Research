# Chengjun WANG @ CMC of City Univeristy of Hong Kong # using Lab PC of 88
# data cleaning syntax for the raw data of Ocuppying WallStreet Tweets.
# http://twitterminer.r-shief.org/owscsv/ 
# 20111210-20111227

ows<-read.csv("d:/chengjun/Twitter data/Ocuupy Wallstreet Data/OccupyWallstreetRawData.csv", header = T, sep = ",", dec = ".")
# dim(ows)  [1] 1353413      14  # names(ows)
# ows=ows[,-3]  #drop the nth column  # ows=ows[,-13]  #drop the nth column
# write.csv(ows, "d:/chengjun/Twitter data/Ocuupy Wallstreet Data/OccupyWallstreetData.csv")

#~~~~~~~~~~~~~~subset the interaction~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
inter<-subset(ows, ows[,11]!="	" )
solo<-subset(ows,  ows[,11]=="	" )
# dim(inter)  # 88601    12
write.csv(inter, "d:/chengjun/Twitter data/Ocuupy Wallstreet Data/OccupyWallstreetInterData.csv")
inter<-read.csv("/Users/wangpianpian/Dropbox/projects/tweets/data_delete after you download/OccupyWallstreetInterData.csv", header = T, sep = ",", dec = ".")
names(inter)
# class(ows[,11]) # it's factor
# ows$To.User[1:100] # compare to # inter$To.User[1:100]

#~~~~~~~~~~~~~~~~~~~~content~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
inter$Text[1:200]  # including RT and @ in the sentence. 
inter$To.User[1:200]

#~~~~~~~~~~~~~~~~~~~~~~~~temporal trend~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
plot(data.frame(table(inter$Day)))
plot(data.frame(table(ows$Day)))
(data.frame(table(ows$Day)))$Freq
(data.frame(table(solo$Day)))
# compare to the google trends
# http://www.google.com.hk/trends?q=occupy+wall+street&ctab=0&geo=all&date=2011&sort=0

plot(data.frame(table(ows$Geo)))
# class(inter$Day)
inter$day<-as.numeric(levels(inter$Day)[inter$Day])

#~~~~~~~~~~~~~~~~~~~~~~~interaction network~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
data.frame(table(inter$day))
d924<-subset(inter, inter$Day == "2011-09-24" )

library(igraph) # install.packages("igraph")
g<-as.data.frame(cbind(as.character(d924$From.User), as.character(d924$To.User)))
names(g)<-c("From.User", "To.User")
g<-graph.data.frame(g, directed=T, vertices=NULL)

summary(g)
plot(g, vertex.label= NA,edge.arrow.size=0.2, vertex.size=2, layout=layout.fruchterman.reingold )

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~compute the degree distribution using igraph~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
library(igraph)# install.packages("igraph")
# jj<-graph.data.frame(g, directed=T, vertices=NULL)

gall<-as.data.frame(cbind(as.character(inter$From.User), as.character(inter$To.User)))
names(gall)<-c("From.User", "To.User")
g_all<-graph.data.frame(gall, directed=T, vertices=NULL)
#~~~~~~~~~~~~~~~~~~~~~~~plot out-degree vs in-degree~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
oud <- as.data.frame(degree(g_all, mode="out"))
ind <- as.data.frame(degree(g_all, mode="in"))
all<-as.data.frame(degree(g_all, mode="all"))
check<-cbind(oud, ind, all)
names(check)<-c("outdegree", "indegree", "all")
che<-subset(check, check$outdegree!=0&check$indegree!=0)
# length(che[,1])/length(check[,1])  
# 16.8% is the percent of overlap between senders and receivers.
plot(check$outdegree,check$indegree, xlab="Out-Degree", ylab="In-Degree")
plot(log(check$outdegree),log(check$indegree), xlab="Out-Degree (log)", ylab="In-Degree (log)")
cor.test(log(check$outdegree+1),log(check$indegree+1))

jj<-g_all
class(jj)
dd <- degree(jj, mode="out") # chang it to mode = c("all", "out", "in", "total")
ddd <- degree.distribution(jj, mode="in", cumulative=TRUE)
alpha <- power.law.fit(dd, xmin=20)
alpha
plot(ddd, log="xy", xlab="Out-degree (Alpha=2.388)", ylab="cumulative frequency",
     col=1, main="Preferential attachment")
lines(10:500, 10*(10:500)^(-coef(alpha)+1))
 
# save data
setwd("D:/NKS &amp< SFI/")
savePlot(filename = "Nonlinear preferential attachment",
         type = c( "png"),
         device = dev.cur(),
         restoreConsole = TRUE)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sentiment analysis~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Download Hu & Liu's opinion lexicon:
# http://www.cs.uic.edu/~liub/FBS/sentiment-analysis.html
hu.liu.pos = scan(file='/Users/wangpianpian/Documents/cityu/r/sentiment analysis/opinion-lexicon-English/positive-words.txt',    what='character', comment.char=';')
hu.liu.neg = scan(file='/Users/wangpianpian/Documents/cityu/r/sentiment analysis/opinion-lexicon-English/negative-words.txt',    what='character', comment.char=';')
# Add a few twitter-specific and/or especially social movement terms:
pos.words = c(hu.liu.pos, 'upgrade') #, 'upgrade'
neg.words = c(hu.liu.neg, 'wtf', 'epicfail') #, 'wtf', 'wait','waiting', 'epicfail', 'mechanical'
# function of sentiment analysis
#  A. sum score
score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
{
    require(plyr)  # install.packages("stringr")
    require(stringr)
 
    # we got a vector of sentences. plyr will handle a list
    # or a vector as an "l" for us
    # we want a simple array ("a") of scores back, so we use
    # "l" + "a" + "ply" = "laply":
    scores = laply(sentences, function(sentence, pos.words, neg.words) {
 
        # clean up sentences with R's regex-driven global substitute, gsub():
        sentence = gsub('[[:punct:]]', '', sentence)
        sentence = gsub('[[:cntrl:]]', '', sentence)
        sentence = gsub('\\d+', '', sentence)
        # and convert to lower case:
        sentence = tolower(sentence)
 
        # split into words. str_split is in the stringr package
        word.list = str_split(sentence, '\\s+')
        # sometimes a list() is one level of hierarchy too much
        words = unlist(word.list)
 
        # compare our words to the dictionaries of positive & negative terms
        pos.matches = match(words, pos.words)
        neg.matches = match(words, neg.words)
 
        # match() returns the position of the matched term or NA
        # we just want a TRUE/FALSE:
        pos.matches = !is.na(pos.matches)
        neg.matches = !is.na(neg.matches)
 
        # and conveniently enough, TRUE/FALSE will be treated as 1/0 by sum():
        score = sum(pos.matches) + sum(neg.matches)

        return(score)
    }, pos.words, neg.words, .progress=.progress )
 
    scores.df = data.frame(score=scores, text=sentences)
    return(scores.df)
}

#  B. Positive score
pos.score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
{
    require(plyr)  # install.packages("stringr")
    require(stringr)
 
    # we got a vector of sentences. plyr will handle a list
    # or a vector as an "l" for us
    # we want a simple array ("a") of scores back, so we use
    # "l" + "a" + "ply" = "laply":
    scores = laply(sentences, function(sentence, pos.words, neg.words) {
 
        # clean up sentences with R's regex-driven global substitute, gsub():
        sentence = gsub('[[:punct:]]', '', sentence)
        sentence = gsub('[[:cntrl:]]', '', sentence)
        sentence = gsub('\\d+', '', sentence)
        # and convert to lower case:
        sentence = tolower(sentence)
 
        # split into words. str_split is in the stringr package
        word.list = str_split(sentence, '\\s+')
        # sometimes a list() is one level of hierarchy too much
        words = unlist(word.list)
 
        # compare our words to the dictionaries of positive & negative terms
        pos.matches = match(words, pos.words)
        neg.matches = match(words, neg.words)
 
        # match() returns the position of the matched term or NA
        # we just want a TRUE/FALSE:
        pos.matches = !is.na(pos.matches)
        neg.matches = !is.na(neg.matches)
 
        # and conveniently enough, TRUE/FALSE will be treated as 1/0 by sum():
        pos.score = sum(pos.matches) 

        return(pos.score)
    }, pos.words, neg.words, .progress=.progress )
 
    pos.scores.df = data.frame(pos.score =scores, text=sentences)
    return(pos.scores.df)
}

#  C. Negative score
neg.score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
{
    require(plyr)  # install.packages("stringr")
    require(stringr)
 
    # we got a vector of sentences. plyr will handle a list
    # or a vector as an "l" for us
    # we want a simple array ("a") of scores back, so we use
    # "l" + "a" + "ply" = "laply":
    scores = laply(sentences, function(sentence, pos.words, neg.words) {
 
        # clean up sentences with R's regex-driven global substitute, gsub():
        sentence = gsub('[[:punct:]]', '', sentence)
        sentence = gsub('[[:cntrl:]]', '', sentence)
        sentence = gsub('\\d+', '', sentence)
        # and convert to lower case:
        sentence = tolower(sentence)
 
        # split into words. str_split is in the stringr package
        word.list = str_split(sentence, '\\s+')
        # sometimes a list() is one level of hierarchy too much
        words = unlist(word.list)
 
        # compare our words to the dictionaries of positive & negative terms
        pos.matches = match(words, pos.words)
        neg.matches = match(words, neg.words)
 
        # match() returns the position of the matched term or NA
        # we just want a TRUE/FALSE:
        pos.matches = !is.na(pos.matches)
        neg.matches = !is.na(neg.matches)
 
        # and conveniently enough, TRUE/FALSE will be treated as 1/0 by sum():
        neg.score = sum(neg.matches) 

        return(neg.score)
    }, pos.words, neg.words, .progress=.progress )
 
    neg.scores.df = data.frame(neg.score =scores, text=sentences)
    return(neg.scores.df)
}

#~~~~try to generate three score at one time but fail~~~#
score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
{
    require(plyr)  # install.packages("stringr")
    require(stringr)
 
    # we got a vector of sentences. plyr will handle a list
    # or a vector as an "l" for us
    # we want a simple array ("a") of scores back, so we use
    # "l" + "a" + "ply" = "laply":
    scores = laply(sentences, function(sentence, pos.words, neg.words) {
 
        # clean up sentences with R's regex-driven global substitute, gsub():
        sentence = gsub('[[:punct:]]', '', sentence)
        sentence = gsub('[[:cntrl:]]', '', sentence)
        sentence = gsub('\\d+', '', sentence)
        # and convert to lower case:
        sentence = tolower(sentence)
 
        # split into words. str_split is in the stringr package
        word.list = str_split(sentence, '\\s+')
        # sometimes a list() is one level of hierarchy too much
        words = unlist(word.list)
 
        # compare our words to the dictionaries of positive & negative terms
        pos.matches = match(words, pos.words)
        neg.matches = match(words, neg.words)
 
        # match() returns the position of the matched term or NA
        # we just want a TRUE/FALSE:
        pos.matches = !is.na(pos.matches)
        neg.matches = !is.na(neg.matches)
 
        # and conveniently enough, TRUE/FALSE will be treated as 1/0 by sum():
        sum.score = sum(pos.matches) + sum(neg.matches) 
                   pos.score = sum(pos.matches)
        neg.score = sum(neg.matches)           

        return(data.frame(c(sum.score, pos.score, neg.score)))
    }, pos.words, neg.words, .progress=.progress )
 
    scores.df = data.frame(score =scores, text=sentences)
    return(scores.df)
}
sample = c("You're awesome and I love you",
     "I hate and hate and hate. So angry. Die!",
     "Impressed and amazed: you are peerless in your achievement of unparalleled mediocrity.")##   as.character(inter$Text[1:10])
#Compute
result = score.sentiment(sample, pos.words, neg.words)
inter$sentiment.score<-result$score
#~~~~try to generate three score at one time but fail~~~#


# Test
sample = c("You're awesome and I love you",
     "I hate and hate and hate. So angry. Die!",
     "Impressed and amazed: you are peerless in your achievement of unparalleled mediocrity.")##   as.character(inter$Text[1:10])
#Compute
sample=as.character(inter$Text)
sum.result = score.sentiment(sample, pos.words, neg.words)
pos.result = pos.score.sentiment(sample, pos.words, neg.words)
neg.result = neg.score.sentiment(sample, pos.words, neg.words)

inter$sum.sen.score<-sum.result$score
inter$pos.sen.score<-pos.result$pos.score
inter$neg.sen.score<-neg.result$neg.score

#inter$abs.sentiment.score<-abs(inter$sentiment.score)
# write.csv(inter, "d:/chengjun/Twitter data/Ocuupy Wallstreet Data/OccupyWallstreetInterData.csv")
# result[c(1,3), 'score']
hist(inter$sum.sen.score)
hist(inter$pos.sen.score)
hist(inter$neg.sen.score)

  # plot(data.frame(table(inter$sentiment.score)))

d924<-subset(inter, as.character(inter$Day)=="2011-09-24") 
d925<-subset(inter, as.character(inter$Day)=="2011-09-25") 
d926<-subset(inter, as.character(inter$Day)=="2011-09-26") 
d927<-subset(inter, as.character(inter$Day)=="2011-09-27") 
d928<-subset(inter, as.character(inter$Day)=="2011-09-28") 
d929<-subset(inter, as.character(inter$Day)=="2011-09-29") 
d930<-subset(inter, as.character(inter$Day)=="2011-09-30") 
d1001<-subset(inter, as.character(inter$Day)=="2011-10-01") 
d1002<-subset(inter, as.character(inter$Day)=="2011-10-02") 
d1003<-subset(inter, as.character(inter$Day)=="2011-10-03") 
d1004<-subset(inter, as.character(inter$Day)=="2011-10-04") 
d1005<-subset(inter, as.character(inter$Day)=="2011-10-05") 
d1006<-subset(inter, as.character(inter$Day)=="2011-10-06") 
d1007<-subset(inter, as.character(inter$Day)=="2011-10-07") 
d1008<-subset(inter, as.character(inter$Day)=="2011-10-08") 
d1009<-subset(inter, as.character(inter$Day)=="2011-10-09") 

h924<-data.frame(table(d924$sentiment.score))
h925<-data.frame(table(d925$sentiment.score))
h926<-data.frame(table(d926$sentiment.score))
h927<-data.frame(table(d927$sentiment.score))
h928<-data.frame(table(d928$sentiment.score))
h929<-data.frame(table(d929$sentiment.score))
h930<-data.frame(table(d930$sentiment.score))
h1001<-data.frame(table(d1001$sentiment.score))
h1002<-data.frame(table(d1002$sentiment.score))
h1003<-data.frame(table(d1003$sentiment.score))
h1004<-data.frame(table(d1004$sentiment.score))
h1005<-data.frame(table(d1005$sentiment.score))
h1006<-data.frame(table(d1006$sentiment.score))
h1007<-data.frame(table(d1007$sentiment.score))
h1008<-data.frame(table(d1008$sentiment.score))
h1009<-data.frame(table(d1009$sentiment.score))

mean(d924$sentiment.score);
mean(d925$sentiment.score);
mean(d926$sentiment.score);
mean(d927$sentiment.score);
mean(d928$sentiment.score);
mean(d929$sentiment.score);
mean(d930$sentiment.score);
mean(d1001$sentiment.score);
mean(d1002$sentiment.score);
mean(d1003$sentiment.score);
mean(d1004$sentiment.score);
mean(d1005$sentiment.score);
mean(d1006$sentiment.score);
mean(d1007$sentiment.score);
mean(d1008$sentiment.score);
mean(d1009$sentiment.score)


mean(d924$abs.sentiment.score)
mean(d925$abs.sentiment.score)
mean(d926$abs.sentiment.score)
mean(d927$abs.sentiment.score)
mean(d928$abs.sentiment.score)
mean(d929$abs.sentiment.score)
mean(d930$abs.sentiment.score)
mean(d1001$abs.sentiment.score)
mean(d1002$abs.sentiment.score)
mean(d1003$abs.sentiment.score)
mean(d1004$abs.sentiment.score)
mean(d1005$abs.sentiment.score)
mean(d1006$abs.sentiment.score)
mean(d1007$abs.sentiment.score)
mean(d1008$abs.sentiment.score)
mean(d1009$abs.sentiment.score)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~leadership analysis~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
dim(gall)
# edge pairs or points
ind<-as.data.frame(table(as.character(inter$To.User)))
names(ind)<-c("To.User", "All.Freq")

ind924<-as.data.frame(table(as.character(d924$To.User)))
names(ind924)<-c("To.User", "Freq924")
ind925<-as.data.frame(table(as.character(d925$To.User)))
names(ind925)<-c("To.User", "Freq925")
ind926<-as.data.frame(table(as.character(d926$To.User)))
names(ind926)<-c("To.User", "Freq926")
ind927<-as.data.frame(table(as.character(d927$To.User)))
names(ind927)<-c("To.User", "Freq927")


ind928<-as.data.frame(table(as.character(d928$To.User)))
names(ind928)<-c("To.User", "Freq928")
ind929<-as.data.frame(table(as.character(d929$To.User)))
names(ind929)<-c("To.User", "Freq929")
ind930<-as.data.frame(table(as.character(d930$To.User)))
names(ind930)<-c("To.User", "Freq930")

ind1001<-as.data.frame(table(as.character(d1001$To.User)))
names(ind1001)<-c("To.User", "Freq1001")
ind1002<-as.data.frame(table(as.character(d1002$To.User)))
names(ind1002)<-c("To.User", "Freq1002")
ind1003<-as.data.frame(table(as.character(d1003$To.User)))
names(ind1003)<-c("To.User", "Freq1003")
ind1004<-as.data.frame(table(as.character(d1004$To.User)))
names(ind1004)<-c("To.User", "Freq1004")
ind1005<-as.data.frame(table(as.character(d1005$To.User)))
names(ind1005)<-c("To.User", "Freq1005")
ind1006<-as.data.frame(table(as.character(d1006$To.User)))
names(ind1006)<-c("To.User", "Freq1006")
ind1007<-as.data.frame(table(as.character(d1007$To.User)))
names(ind1007)<-c("To.User", "Freq1007")
ind1008<-as.data.frame(table(as.character(d1008$To.User)))
names(ind1008)<-c("To.User", "Freq1008")
ind1009<-as.data.frame(table(as.character(d1009$To.User)))
names(ind1009)<-c("To.User", "Freq1009")
ind2<-merge(ind924, ind925, by="To.User", all = T, incomparables = NA)
ind3<-merge(ind2, ind926, by="To.User", all = T, incomparables = NA)
ind4<-merge(ind3, ind927, by="To.User", all = T, incomparables = NA)
ind5<-merge(ind4, ind928, by="To.User", all = T, incomparables = NA)
ind6<-merge(ind5, ind929, by="To.User", all = T, incomparables = NA)
ind7<-merge(ind6, ind930, by="To.User", all = T, incomparables = NA)
ind8<-merge(ind7, ind1001, by="To.User", all = T, incomparables = NA)
ind9<-merge(ind8, ind1002, by="To.User", all = T, incomparables = NA)
ind10<-merge(ind9, ind1003, by="To.User", all = T, incomparables = NA)
ind11<-merge(ind10, ind1004, by="To.User", all = T, incomparables = NA)
ind12<-merge(ind11, ind1005, by="To.User", all = T, incomparables = NA)
ind13<-merge(ind12, ind1006, by="To.User", all = T, incomparables = NA)
ind14<-merge(ind13, ind1007, by="To.User", all = T, incomparables = NA)
ind15<-merge(ind14, ind1008, by="To.User", all = T, incomparables = NA)
ind16<-merge(ind15, ind1009, by="To.User", all = T, incomparables = NA)
ind16[ is.na(ind16) ] <- 0
# write.csv(ind16, "d:/chengjun/Twitter data/Ocuupy Wallstreet Data/OWSCorr.csv")
ind16<-read.csv("d:/chengjun/Twitter data/Ocuupy Wallstreet Data/OWSCorr.csv", header = T, sep = ",", dec = ".")
names(ind16) <- c("id","To.User","Sep24","Sep25","Sep26","Sep27","Sep28","Sep29","Sep30","Oct1","Oct2","Oct3","Oct4","Oct5","Oct6","Oct7","Oct8","Oct9")

corr <- cor(ind16[,3:18])

library(corrplot) # install.packages("corrplot")
corrplot(corr, method = "circle", type = c("full"))

## circle + colorful number
corrplot(corr,type="upper",addtextlabel="no")
corrplot(corr,add=TRUE, type="lower", method="number",
	diag=T,addtextlabel="yes", addcolorlabel="right")

# test
cor.test(test$Freq924, test$Freq925)
cor.test(rank(test$Freq924), rank(test$Freq925))  # rank correlation
# reshape to merge multiple data.frames, however, it fails because the memory limits.
library(reshape) # install.packages("reshape")
list.of.data.frames = list(ind924, ind925, ind926, ind927, ind928, ind929, ind930, 
     ind1001, ind1002, ind1003, ind1004, ind1005, ind1006, ind1007, ind1008, ind1009)
point.cor<-reshape::merge_all(list.of.data.frames, by="To.User", incomparables = NA)
point.cor[ is.na(point.cor) ] <- 0
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~local hub~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

# first, using ind924 till ind1009 choose top 100 in each daily network
ind924$rank<-rank(1/rank(ind924$Freq924, na.last = TRUE, ties.method =  "random"))
ind924s<-subset(ind924, ind924$rank<=200)
ind924s$rank <- NULL
names(ind924)<-c("Edge", "Freq")
# list<-as.character(edge1000$Edge)
ind925$rank<-rank(1/rank(ind925$Freq925, na.last = TRUE, ties.method =  "random"))
ind925s<-subset(ind925, ind925$rank<=200)
ind925s$rank <- NULL
ind926$rank<-rank(1/rank(ind926$Freq926,na.last = TRUE, ties.method =  "random"))
ind926s<-subset(ind926,ind926$rank<=200)
ind926s$rank <- NULL
ind927$rank<-rank(1/rank(ind927$Freq927,na.last = TRUE, ties.method =  "random"))
ind927s<-subset(ind927,ind927$rank<=200)
ind927s$rank<- NULL
ind928$rank<-rank(1/rank(ind928$Freq928,na.last = TRUE, ties.method =  "random"))
ind928s<-subset(ind928,ind928$rank<=200)
ind928s$rank<- NULL
ind929$rank<-rank(1/rank(ind929$Freq929,na.last = TRUE, ties.method =  "random"))
ind929s<-subset(ind929,ind929$rank<=200)
ind929s$rank<- NULL
ind930$rank<-rank(1/rank(ind930$Freq930,na.last = TRUE, ties.method =  "random"))
ind930s<-subset(ind930,ind930$rank<=200)
ind930s$rank<- NULL
ind1001$rank<-rank(1/rank(ind1001$Freq1001,na.last = TRUE, ties.method =  "random"))
ind1001s<-subset(ind1001,ind1001$rank<=200)
ind1001s$rank<- NULL
ind1002$rank<-rank(1/rank(ind1002$Freq1002,na.last = TRUE, ties.method =  "random"))
ind1002s<-subset(ind1002,ind1002$rank<=200)
ind1002s$rank<- NULL
ind1003$rank<-rank(1/rank(ind1003$Freq1003,na.last = TRUE, ties.method =  "random"))
ind1003s<-subset(ind1003,ind1003$rank<=200)
ind1003s$rank<- NULL
ind1004$rank<-rank(1/rank(ind1004$Freq1004,na.last = TRUE, ties.method =  "random"))
ind1004s<-subset(ind1004,ind1004$rank<=200)
ind1004s$rank<- NULL
ind1005$rank<-rank(1/rank(ind1005$Freq1005,na.last = TRUE, ties.method =  "random"))
ind1005s<-subset(ind1005,ind1005$rank<=200)
ind1005s$rank<- NULL
ind1006$rank<-rank(1/rank(ind1006$Freq1006,na.last = TRUE, ties.method =  "random"))
ind1006s<-subset(ind1006,ind1006$rank<=200)
ind1006s$rank<- NULL
ind1007$rank<-rank(1/rank(ind1007$Freq1007,na.last = TRUE, ties.method =  "random"))
ind1007s<-subset(ind1007,ind1007$rank<=200)
ind1007s$rank<- NULL
ind1008$rank<-rank(1/rank(ind1008$Freq1008,na.last = TRUE, ties.method =  "random"))
ind1008s<-subset(ind1008,ind1008$rank<=200)
ind1008s$rank<- NULL
ind1009$rank<-rank(1/rank(ind1009$Freq1009,na.last = TRUE, ties.method =  "random"))
ind1009s<-subset(ind1009,ind1009$rank<=200)
ind1009s$rank<- NULL

list.To<-unique(factor(c(as.character(ind924s[,1]), as.character(ind924s[,1]),as.character(ind925s[,1]),as.character(ind926s[,1])
   ,as.character(ind927s[,1]),as.character(ind928s[,1]),as.character(ind929s[,1]),as.character(ind930s[,1])
   ,as.character(ind1001s[,1]), as.character(ind1002s[,1]),as.character(ind1003s[,1]),as.character(ind1004s[,1])
   ,as.character(ind1005s[,1]),as.character(ind1006s[,1])
   ,as.character(ind1007s[,1]),as.character(ind1008s[,1]),as.character(ind1009s[,1]) )))

ind924t<-subset(ind924, ind924[,1]%in%list.To)
ind925t<-subset(ind925,ind925[,1]%in%list.To)
ind926t<-subset(ind926,ind926[,1]%in%list.To)
ind927t<-subset(ind927,ind927[,1]%in%list.To)
ind928t<-subset(ind928,ind928[,1]%in%list.To)
ind929t<-subset(ind929,ind929[,1]%in%list.To)
ind930t<-subset(ind930,ind930[,1]%in%list.To)
ind1001t<-subset(ind1001,ind1001[,1]%in%list.To)
ind1002t<-subset(ind1002,ind1002[,1]%in%list.To)
ind1003t<-subset(ind1003,ind1003[,1]%in%list.To)
ind1004t<-subset(ind1004,ind1004[,1]%in%list.To)
ind1005t<-subset(ind1005,ind1005[,1]%in%list.To)
ind1006t<-subset(ind1006,ind1006[,1]%in%list.To)
ind1007t<-subset(ind1007,ind1007[,1]%in%list.To)
ind1008t<-subset(ind1008,ind1008[,1]%in%list.To)
ind1009t<-subset(ind1009,ind1009[,1]%in%list.To)
ind924t[,3]<-NULL
ind925t[,3]<-NULL
ind926t[,3]<-NULL
ind927t[,3]<-NULL
ind928t[,3]<-NULL
ind929t[,3]<-NULL
ind930t[,3]<-NULL
ind1001t[,3]<-NULL
ind1002t[,3]<-NULL
ind1003t[,3]<-NULL
ind1004t[,3]<-NULL
ind1005t[,3]<-NULL
ind1006t[,3]<-NULL
ind1007t[,3]<-NULL
ind1008t[,3]<-NULL
ind1009t[,3]<-NULL
ind2t<-merge(ind924t, ind925t, by="To.User", all = T, incomparables = NA)
ind3t<-merge(ind2t, ind926t, by="To.User", all = T, incomparables = NA)
ind4t<-merge(ind3t, ind927t, by="To.User", all = T, incomparables = NA)
ind5t<-merge(ind4t, ind928t, by="To.User", all = T, incomparables = NA)
ind6t<-merge(ind5t, ind929t, by="To.User", all = T, incomparables = NA)
ind7t<-merge(ind6t, ind930t, by="To.User", all = T, incomparables = NA)
ind8t<-merge(ind7t, ind1001t, by="To.User", all = T, incomparables = NA)
ind9t<-merge(ind8t, ind1002t, by="To.User", all = T, incomparables = NA)
ind10t<-merge(ind9t, ind1003t, by="To.User", all = T, incomparables = NA)
ind11t<-merge(ind10t, ind1004t, by="To.User", all = T, incomparables = NA)
ind12t<-merge(ind11t, ind1005t, by="To.User", all = T, incomparables = NA)
ind13t<-merge(ind12t, ind1006t, by="To.User", all = T, incomparables = NA)
ind14t<-merge(ind13t, ind1007t, by="To.User", all = T, incomparables = NA)
ind15t<-merge(ind14t, ind1008t, by="To.User", all = T, incomparables = NA)
ind16t<-merge(ind15t, ind1009t, by="To.User", all = T, incomparables = NA)
ind16t[ is.na(ind16t) ] <- 0
names(ind16t) <- c("To.User","Sep24","Sep25","Sep26","Sep27","Sep28","Sep29","Sep30","Oct1","Oct2","Oct3","Oct4","Oct5","Oct6","Oct7","Oct8","Oct9")

cort <- cor(ind16t[,2:17])

library(corrplot) # install.packages("corrplot")
corrplot(cort, method = "circle", type = c("full"))

## circle + colorful number
corrplot(cort,type="upper",addtextlabel="no")
corrplot(cort,add=TRUE, type="lower", method="number",
	diag=T,addtextlabel="yes", addcolorlabel="right")
# N of From.User is 26316, while N of To.User is 28253.


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~From User~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
out924<-as.data.frame(table(as.character(d924$From.User)))
names(out924)<-c("From.User", "Freq924")
out925<-as.data.frame(table(as.character(d925$From.User)))
names(out925)<-c("From.User", "Freq925")
out926<-as.data.frame(table(as.character(d926$From.User)))
names(out926)<-c("From.User", "Freq926")
out927<-as.data.frame(table(as.character(d927$From.User)))
names(out927)<-c("From.User", "Freq927")

out928<-as.data.frame(table(as.character(d928$From.User)))
names(out928)<-c("From.User", "Freq928")
out929<-as.data.frame(table(as.character(d929$From.User)))
names(out929)<-c("From.User", "Freq929")
out930<-as.data.frame(table(as.character(d930$From.User)))
names(out930)<-c("From.User", "Freq930")

out1001<-as.data.frame(table(as.character(d1001$From.User)))
names(out1001)<-c("From.User", "Freq1001")
out1002<-as.data.frame(table(as.character(d1002$From.User)))
names(out1002)<-c("From.User", "Freq1002")
out1003<-as.data.frame(table(as.character(d1003$From.User)))
names(out1003)<-c("From.User", "Freq1003")
out1004<-as.data.frame(table(as.character(d1004$From.User)))
names(out1004)<-c("From.User", "Freq1004")
out1005<-as.data.frame(table(as.character(d1005$From.User)))
names(out1005)<-c("From.User", "Freq1005")
out1006<-as.data.frame(table(as.character(d1006$From.User)))
names(out1006)<-c("From.User", "Freq1006")
out1007<-as.data.frame(table(as.character(d1007$From.User)))
names(out1007)<-c("From.User", "Freq1007")
out1008<-as.data.frame(table(as.character(d1008$From.User)))
names(out1008)<-c("From.User", "Freq1008")
out1009<-as.data.frame(table(as.character(d1009$From.User)))
names(out1009)<-c("From.User", "Freq1009")
out2<-merge(out924, out925, by="From.User", all = T, incomparables = NA)
out3<-merge(out2, out926, by="From.User", all = T, incomparables = NA)
out4<-merge(out3, out927, by="From.User", all = T, incomparables = NA)
out5<-merge(out4, out928, by="From.User", all = T, incomparables = NA)
out6<-merge(out5, out929, by="From.User", all = T, incomparables = NA)
out7<-merge(out6, out930, by="From.User", all = T, incomparables = NA)
out8<-merge(out7, out1001, by="From.User", all = T, incomparables = NA)
out9<-merge(out8, out1002, by="From.User", all = T, incomparables = NA)
out10<-merge(out9, out1003, by="From.User", all = T, incomparables = NA)
out11<-merge(out10, out1004, by="From.User", all = T, incomparables = NA)
out12<-merge(out11, out1005, by="From.User", all = T, incomparables = NA)
out13<-merge(out12, out1006, by="From.User", all = T, incomparables = NA)
out14<-merge(out13, out1007, by="From.User", all = T, incomparables = NA)
out15<-merge(out14, out1008, by="From.User", all = T, incomparables = NA)
out16<-merge(out15, out1009, by="From.User", all = T, incomparables = NA)
out16[ is.na(out16) ] <- 0
# write.csv(out16, "d:/chengjun/Twitter data/Ocuupy Wallstreet Data/OWSCorrout16.csv")
# out16<-read.csv("d:/chengjun/Twitter data/Ocuupy Wallstreet Data/OWSCorrout16.csv", header = T, sep = ",", dec = ".")

names(out16) <- c("From.User","Sep24","Sep25","Sep26","Sep27","Sep28","Sep29","Sep30","Oct1","Oct2","Oct3","Oct4","Oct5","Oct6","Oct7","Oct8","Oct9")

coro <- cor(out16[,2:17])

library(corrplot) # install.packages("corrplot")
corrplot(coro, method = "circle", type = c("full"))

## circle + colorful number
corrplot(coro,type="upper",addtextlabel="no")
corrplot(coro,add=TRUE, type="lower", method="number",
	diag=T,addtextlabel="yes", addcolorlabel="right")
# N of From.User is 26316, while N of To.User is 28253.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~local hub of From.User~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# first, using ind924 till ind1009 choose top 100 in each daily network
out924$rank<-rank(1/rank(out924$Freq924,	na.last	=	TRUE,	ties.method	=	"random"))
out924s<-subset(out924,	out924$rank<=200)					
out924s$rank	<-	NULL				
out925$rank<-rank(1/rank(out925$Freq925,	na.last	=	TRUE,	ties.method	=	"random"))
out925s<-subset(out925,	out925$rank<=200)					
out925s$rank	<-	NULL				
out926$rank<-rank(1/rank(out926$Freq926,na.last	=	TRUE,	ties.method	="random"))	
out926s<-subset(out926,out926$rank<=200)						
out926s$rank	<-	NULL				
out927$rank<-rank(1/rank(out927$Freq927,na.last	=	TRUE,	ties.method	=	"random"))	
out927s<-subset(out927,out927$rank<=200)						
out927s$rank<-	NULL					
out928$rank<-rank(1/rank(out928$Freq928,na.last	=	TRUE,	ties.method	=	"random"))	
out928s<-subset(out928,out928$rank<=200)						
out928s$rank<-	NULL					
out929$rank<-rank(1/rank(out929$Freq929,na.last	=	TRUE,	ties.method	=	"random"))	
out929s<-subset(out929,out929$rank<=200)						
out929s$rank<-	NULL					
out930$rank<-rank(1/rank(out930$Freq930,na.last	=	TRUE,	ties.method	=	"random"))	
out930s<-subset(out930,out930$rank<=200)						
out930s$rank<-	NULL					
out1001$rank<-rank(1/rank(out1001$Freq1001,na.last	=	TRUE,	ties.method	=	"random"))	
out1001s<-subset(out1001,out1001$rank<=200)						
out1001s$rank<-	NULL					
out1002$rank<-rank(1/rank(out1002$Freq1002,na.last	=	TRUE,	ties.method	=	"random"))	
out1002s<-subset(out1002,out1002$rank<=200)						
out1002s$rank<-	NULL					
out1003$rank<-rank(1/rank(out1003$Freq1003,na.last	=	TRUE,	ties.method	=	"random"))	
out1003s<-subset(out1003,out1003$rank<=200)						
out1003s$rank<-	NULL					
out1004$rank<-rank(1/rank(out1004$Freq1004,na.last	=	TRUE,	ties.method	=	"random"))	
out1004s<-subset(out1004,out1004$rank<=200)						
out1004s$rank<-	NULL					
out1005$rank<-rank(1/rank(out1005$Freq1005,na.last	=	TRUE,	ties.method	=	"random"))	
out1005s<-subset(out1005,out1005$rank<=200)						
out1005s$rank<-	NULL					
out1006$rank<-rank(1/rank(out1006$Freq1006,na.last	=	TRUE,	ties.method	=	"random"))	
out1006s<-subset(out1006,out1006$rank<=200)						
out1006s$rank<-	NULL					
out1007$rank<-rank(1/rank(out1007$Freq1007,na.last	=	TRUE,	ties.method	=	"random"))	
out1007s<-subset(out1007,out1007$rank<=200)						
out1007s$rank<-	NULL					
out1008$rank<-rank(1/rank(out1008$Freq1008,na.last	=	TRUE,	ties.method	=	"random"))	
out1008s<-subset(out1008,out1008$rank<=200)						
out1008s$rank<-	NULL					
out1009$rank<-rank(1/rank(out1009$Freq1009,na.last	=	TRUE,	ties.method	=	"random"))	
out1009s<-subset(out1009,out1009$rank<=200)						
out1009s$rank<-	NULL					


list.From<-unique(factor(c(as.character(out924s[,1]),	as.character(out924s[,1]),as.character(out925s[,1]),as.character(out926s[,1])					
	,as.character(out927s[,1]),as.character(out928s[,1]),as.character(out929s[,1]),as.character(out930s[,1])					
	,as.character(out1001s[,1]),	as.character(out1002s[,1]),as.character(out1003s[,1]),as.character(out1004s[,1])				
	,as.character(out1005s[,1]),as.character(out1006s[,1])					
	,as.character(out1007s[,1]),as.character(out1008s[,1]),as.character(out1009s[,1])	)))				
						
out924t<-subset(out924,	out924[,1]%in%list.From)					
out925t<-subset(out925,out925[,1]%in%list.From)						
out926t<-subset(out926,out926[,1]%in%list.From)						
out927t<-subset(out927,out927[,1]%in%list.From)						
out928t<-subset(out928,out928[,1]%in%list.From)						
out929t<-subset(out929,out929[,1]%in%list.From)						
out930t<-subset(out930,out930[,1]%in%list.From)						
out1001t<-subset(out1001,out1001[,1]%in%list.From)						
out1002t<-subset(out1002,out1002[,1]%in%list.From)						
out1003t<-subset(out1003,out1003[,1]%in%list.From)						
out1004t<-subset(out1004,out1004[,1]%in%list.From)						
out1005t<-subset(out1005,out1005[,1]%in%list.From)						
out1006t<-subset(out1006,out1006[,1]%in%list.From)						
out1007t<-subset(out1007,out1007[,1]%in%list.From)						
out1008t<-subset(out1008,out1008[,1]%in%list.From)						
out1009t<-subset(out1009,out1009[,1]%in%list.From)						
out924t[,3]<-NULL						
out925t[,3]<-NULL						
out926t[,3]<-NULL						
out927t[,3]<-NULL						
out928t[,3]<-NULL						
out929t[,3]<-NULL						
out930t[,3]<-NULL						
out1001t[,3]<-NULL						
out1002t[,3]<-NULL						
out1003t[,3]<-NULL						
out1004t[,3]<-NULL						
out1005t[,3]<-NULL						
out1006t[,3]<-NULL						
out1007t[,3]<-NULL						
out1008t[,3]<-NULL						
out1009t[,3]<-NULL						
out2t<-merge(out924t,	out925t,	by="From.User",	all	=	T,	incomparables= NA)
out3t<-merge(out2t,	out926t,	by="From.User",	all	=	T,	incomparables= NA)
out4t<-merge(out3t,	out927t,	by="From.User",	all	=	T,	incomparables= NA)
out5t<-merge(out4t,	out928t,	by="From.User",	all	=	T,	incomparables= NA)
out6t<-merge(out5t,	out929t,	by="From.User",	all	=	T,	incomparables= NA)
out7t<-merge(out6t,	out930t,	by="From.User",	all	=	T,	incomparables= NA)
out8t<-merge(out7t,	out1001t,	by="From.User",	all	=	T,	incomparables= NA)
out9t<-merge(out8t,	out1002t,	by="From.User",	all	=	T,	incomparables= NA)
out10t<-merge(out9t,	out1003t,	by="From.User",	all	=	T,	incomparables= NA)
out11t<-merge(out10t,	out1004t,	by="From.User",	all	=	T,	incomparables= NA)
out12t<-merge(out11t,	out1005t,	by="From.User",	all	=	T,	incomparables= NA)
out13t<-merge(out12t,	out1006t,	by="From.User",	all	=	T,	incomparables= NA)
out14t<-merge(out13t,	out1007t,	by="From.User",	all	=	T,	incomparables= NA)
out15t<-merge(out14t,	out1008t,	by="From.User",	all	=	T,	incomparables= NA)
out16t<-merge(out15t,	out1009t,	by="From.User",	all	=	T,	incomparables= NA)
out16t[	is.na(out16t)	]	<-	0		



names(out16t) <- c("From.User","Sep24","Sep25","Sep26","Sep27","Sep28","Sep29","Sep30","Oct1","Oct2","Oct3","Oct4","Oct5","Oct6","Oct7","Oct8","Oct9")

corout <- cor(out16t[,2:17])

library(corrplot) # install.packages("corrplot")
corrplot(corout, method = "circle", type = c("full"))

## circle + colorful number
corrplot(corout,type="upper",addtextlabel="no")
corrplot(corout,add=TRUE, type="lower", method="number",
	diag=T,addtextlabel="yes", addcolorlabel="right")
# N of From.User is 26316, while N of To.User is 28253.

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~edge correlation~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
inter$Edge<-paste(inter$From.User, inter$To.User)


edge924<-as.data.frame(table(as.character(d924$Edge)))
names(edge924)<-c("Edge", "Freq924")
edge925<-as.data.frame(table(as.character(d925$Edge)))
names(edge925)<-c("Edge", "Freq925")
edge926<-as.data.frame(table(as.character(d926$Edge)))
names(edge926)<-c("Edge", "Freq926")
edge927<-as.data.frame(table(as.character(d927$Edge)))
names(edge927)<-c("Edge", "Freq927")


edge928<-as.data.frame(table(as.character(d928$Edge)))
names(edge928)<-c("Edge", "Freq928")
edge929<-as.data.frame(table(as.character(d929$Edge)))
names(edge929)<-c("Edge", "Freq929")
edge930<-as.data.frame(table(as.character(d930$Edge)))
names(edge930)<-c("Edge", "Freq930")

edge1001<-as.data.frame(table(as.character(d1001$Edge)))
names(edge1001)<-c("Edge", "Freq1001")
edge1002<-as.data.frame(table(as.character(d1002$Edge)))
names(edge1002)<-c("Edge", "Freq1002")
edge1003<-as.data.frame(table(as.character(d1003$Edge)))
names(edge1003)<-c("Edge", "Freq1003")
edge1004<-as.data.frame(table(as.character(d1004$Edge)))
names(edge1004)<-c("Edge", "Freq1004")
edge1005<-as.data.frame(table(as.character(d1005$Edge)))
names(edge1005)<-c("Edge", "Freq1005")
edge1006<-as.data.frame(table(as.character(d1006$Edge)))
names(edge1006)<-c("Edge", "Freq1006")
edge1007<-as.data.frame(table(as.character(d1007$Edge)))
names(edge1007)<-c("Edge", "Freq1007")
edge1008<-as.data.frame(table(as.character(d1008$Edge)))
names(edge1008)<-c("Edge", "Freq1008")
edge1009<-as.data.frame(table(as.character(d1009$Edge)))
names(edge1009)<-c("Edge", "Freq1009")



edge2<-merge(edge924, edge925, by="Edge", all = T, incomparables = NA)
edge3<-merge(edge2, edge926, by="Edge", all = T, incomparables = NA)
edge4<-merge(edge3, edge927, by="Edge", all = T, incomparables = NA)
edge5<-merge(edge4, edge928, by="Edge", all = T, incomparables = NA)
edge6<-merge(edge5, edge929, by="Edge", all = T, incomparables = NA)
edge7<-merge(edge6, edge930, by="Edge", all = T, incomparables = NA)
edge8<-merge(edge7, edge1001, by="Edge", all = T, incomparables = NA)
edge9<-merge(edge8, edge1002, by="Edge", all = T, incomparables = NA)
edge10<-merge(edge9, edge1003, by="Edge", all = T, incomparables = NA)
edge11<-merge(edge10, edge1004, by="Edge", all = T, incomparables = NA)
edge12<-merge(edge11, edge1005, by="Edge", all = T, incomparables = NA)
edge13<-merge(edge12, edge1006, by="Edge", all = T, incomparables = NA)
edge14<-merge(edge13, edge1007, by="Edge", all = T, incomparables = NA)
edge15<-merge(edge14, edge1008, by="Edge", all = T, incomparables = NA)
edge16<-merge(edge15, edge1009, by="Edge", all = T, incomparables = NA)
edge16[ is.na(edge16) ] <- 0
# write.csv(edge16, "d:/chengjun/Twitter data/Ocuupy Wallstreet Data/OWSCorredge16.csv")
# edge16<-read.csv("d:/chengjun/Twitter data/Ocuupy Wallstreet Data/OWSCorredge16.csv", header = T, sep = ",", dec = ".")

# dim(edge16) == 72536
names(edge16) <- c("Edge","Sep24","Sep25","Sep26","Sep27","Sep28","Sep29","Sep30","Oct1","Oct2","Oct3","Oct4","Oct5","Oct6","Oct7","Oct8","Oct9")

cord <- cor(edge16[,2:17])
cord[10]==1
library(corrplot) # install.packages("corrplot")
corrplot(cord, method = "circle", type = c("full"))

## circle + colorful number
corrplot(cord,type="upper",addtextlabel="no")
corrplot(cord,add=TRUE, type="lower", method="number",
	diag=T,addtextlabel="yes", addcolorlabel="right")
# N of From.User is 26316, while N of To.User is 28253.
inter$Text[16] 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
edge<-as.data.frame(table(as.character(inter$Edge)))
names(edge)<-c("Edge", "Freq")

edge$rank<-rank(1/rank(edge$Freq, na.last = TRUE, ties.method =  "random"))
edge1000<-subset(edge, edge$rank<=1000)
edge1000$rank <- NULL
names(edge1000)<-c("Edge", "Freq")
list<-as.character(edge1000$Edge)

ed924<-subset(edge924, as.character(edge924$Edge)%in%list)

ed925<-subset(edge925, as.character(edge925$Edge)%in%list)
ed926<-subset(edge926, as.character(edge926$Edge)%in%list)
ed927<-subset(edge927, as.character(edge927$Edge)%in%list)
ed928<-subset(edge928, as.character(edge928$Edge)%in%list)
ed929<-subset(edge929, as.character(edge929$Edge)%in%list)
ed930<-subset(edge930, as.character(edge930$Edge)%in%list)
ed1001<-subset(edge1001, as.character(edge1001$Edge)%in%list)
ed1002<-subset(edge1002, as.character(edge1002$Edge)%in%list)
ed1003<-subset(edge1003, as.character(edge1003$Edge)%in%list)
ed1004<-subset(edge1004, as.character(edge1004$Edge)%in%list)
ed1005<-subset(edge1005, as.character(edge1005$Edge)%in%list)
ed1006<-subset(edge1006, as.character(edge1006$Edge)%in%list)
ed1007<-subset(edge1007, as.character(edge1007$Edge)%in%list)
ed1008<-subset(edge1008, as.character(edge1008$Edge)%in%list)
ed1009<-subset(edge1009, as.character(edge1009$Edge)%in%list)
ed924[,3]<-NULL
ed925[,3]<-NULL
ed926[,3]<-NULL
ed927[,3]<-NULL
ed928[,3]<-NULL
ed929[,3]<-NULL
ed930[,3]<-NULL
ed1001[,3]<-NULL
ed1002[,3]<-NULL
ed1003[,3]<-NULL
ed1004[,3]<-NULL
ed1005[,3]<-NULL
ed1006[,3]<-NULL
ed1007[,3]<-NULL
ed1008[,3]<-NULL
ed1009[,3]<-NULL
names(ed924)<-c("Edge", "Freq924")
names(ed925)<-c("Edge", "Freq925")
names(ed926)<-c("Edge", "Freq926")
names(ed927)<-c("Edge", "Freq927")
names(ed928)<-c("Edge", "Freq928")
names(ed929)<-c("Edge", "Freq929")
names(ed930)<-c("Edge", "Freq930")
names(ed1001)<-c("Edge", "Freq1001")
names(ed1002)<-c("Edge", "Freq1002")
names(ed1003)<-c("Edge", "Freq1003")
names(ed1004)<-c("Edge", "Freq1004")
names(ed1005)<-c("Edge", "Freq1005")
names(ed1006)<-c("Edge", "Freq1006")
names(ed1007)<-c("Edge", "Freq1007")
names(ed1008)<-c("Edge", "Freq1008")
names(ed1009)<-c("Edge", "Freq1009")

ed2<-merge(ed924, ed925, by="Edge", all = T, incomparables = NA)
ed3<-merge(ed2, ed926, by="Edge", all = T, incomparables = NA)
ed4<-merge(ed3, ed927, by="Edge", all = T, incomparables = NA)
ed5<-merge(ed4, ed928, by="Edge", all = T, incomparables = NA)
ed6<-merge(ed5, ed929, by="Edge", all = T, incomparables = NA)
ed7<-merge(ed6, ed930, by="Edge", all = T, incomparables = NA)
ed8<-merge(ed7, ed1001, by="Edge", all = T, incomparables = NA)
ed9<-merge(ed8, ed1002, by="Edge", all = T, incomparables = NA)
ed10<-merge(ed9, ed1003, by="Edge", all = T, incomparables = NA)
ed11<-merge(ed10, ed1004, by="Edge", all = T, incomparables = NA)
ed12<-merge(ed11, ed1005, by="Edge", all = T, incomparables = NA)
ed13<-merge(ed12, ed1006, by="Edge", all = T, incomparables = NA)
ed14<-merge(ed13, ed1007, by="Edge", all = T, incomparables = NA)
ed15<-merge(ed14, ed1008, by="Edge", all = T, incomparables = NA)
ed16<-merge(ed15, ed1009, by="Edge", all = T, incomparables = NA)

ed16[ is.na(ed16) ] <- 0

names(ed16) <- c("Edge","Sep24","Sep25","Sep26","Sep27","Sep28","Sep29","Sep30","Oct1","Oct2","Oct3","Oct4","Oct5","Oct6","Oct7","Oct8","Oct9")

cored <- cor(ed16[,2:17])
library(corrplot) # install.packages("corrplot")
corrplot(cored, method = "circle", type = c("full"))

## circle + colorful number
corrplot(cored,type="upper",addtextlabel="no")
corrplot(cored,add=TRUE, type="lower", method="number",
	diag=T,addtextlabel="yes", addcolorlabel="right")
#~~~~~~~~~~~~~~~~~~~~~~~~~~get top rank users~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# find out top 200 aggregate To.User
to<-data.frame(table(inter$To.User))
to$rank<-rank(1/rank(to$Freq, na.last=T, ties.method="random"))
to$twitter<-"http://twitter.com/"
to$web<-paste(to$twitter, to$Var1,sep="")
to$twitter<-NULL
top.to<-subset(to, to$rank<=200)
# get the top 200 aggregated From.User
from<-data.frame(table(inter$From.User))
from$rank<-rank(1/rank(from$Freq, na.last=T, ties.method="random"))
from$twitter<-"http://twitter.com/"
from$web<-paste(from$twitter, from$Var1,sep="")
from$twitter<-NULL
top.from<-subset(from, from$rank<=200)
# write.csv(top.to, "d:/chengjun/Twitter data/Ocuupy Wallstreet Data/top200to.csv")
# write.csv(top.from, "d:/chengjun/Twitter data/Ocuupy Wallstreet Data/top200from.csv")
top.to$Var1
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
top200toname<-as.character(top.to$Var1)
top200frname<-as.character(top.from$Var1)

# name:screenName:id:lastStatus:description:statusesCount:followersCount:favoritesCount:friendsCount:
# url:created:protected:verified:location:
# tuser <- getUser('geoffjentry') # one time one people
# tuser<- lookupUsers(c('geoffjentry', 'whitehouse'))      ## This requires OAuth authentication
library(twitteR)# install.packages("RCurl")
f<-function(n){
  tuser <- getUser(n) # one time one people
   # description<-tuser$description
   followersCount<-tuser$followersCount
   friendsCount<-tuser$friendsCount
   statusesCount<-tuser$statusesCount
   # favoritesCount<-tuser$favoritesCount
   m=data.frame(cbind(followersCount, friendsCount,statusesCount))
   return(m)  
   }
 to1<-sapply(top200toname[1:10],f)  
 to2<-sapply(top200toname[11:19],f)  # AntiSec_ does't exist now
 # to3<-sapply(top200toname[21:28],f)  # BPGulfLeak doesn't exist
 # to3.1<-sapply(top200toname[30],f)  #
 to3<-cbind(to3, to3.1)
 to4<-sapply(top200toname[31:40],f)  
 to5<-sapply(top200toname[41:49],f)  # diggrbiii deesn't exist
 to6<-sapply(top200toname[51:60],f)  
 to7<-sapply(top200toname[61:70],f)  
 to8<-sapply(top200toname[71:80],f)  
 to9<-sapply(top200toname[81:90],f)  
 to10<-sapply(top200toname[91:100],f)  
 to11<-sapply(top200toname[101:110],f)  
 to12<-sapply(c("MMFlint","MotherJones","MoveOn","Mruff221","msnbc","MyDixie_Wrecked",
                "NaomiAKlein","Newyorkist","NickKristof"),f)  #MrHortonscycles doesn't exist
 to13<-sapply(top200toname[121:130],f)  
 to14<-sapply(top200toname[131:140],f)  
 to15<-sapply(top200toname[141:150],f)  
 to16<-sapply(top200toname[151:160],f)  #
 to17<-sapply(top200toname[161:170],f)  #
 to18<-sapply(top200toname[171:180],f)  #
 to19<-sapply(top200toname[181:190],f)  #
 to20<-sapply(top200toname[191:200],f)  #
write.csv(to1, "D:/github/tweets/twitteR/to1.csv")
write.csv(to2, "D:/github/tweets/twitteR/to2.csv")
write.csv(to3, "D:/github/tweets/twitteR/to3.csv")
write.csv(to4, "D:/github/tweets/twitteR/to4.csv")
write.csv(to5, "D:/github/tweets/twitteR/to5.csv")
write.csv(to6, "D:/github/tweets/twitteR/to6.csv")
write.csv(to7, "D:/github/tweets/twitteR/to7.csv")
write.csv(to8, "D:/github/tweets/twitteR/to8.csv")
write.csv(to9, "D:/github/tweets/twitteR/to9.csv")
write.csv(to10, "D:/github/tweets/twitteR/to10.csv")
write.csv(to11, "D:/github/tweets/twitteR/to11.csv")
write.csv(to12, "D:/github/tweets/twitteR/to12.csv")
write.csv(to13, "D:/github/tweets/twitteR/to13.csv")
write.csv(to14, "D:/github/tweets/twitteR/to14.csv")
write.csv(to15, "D:/github/tweets/twitteR/to15.csv")
write.csv(to16, "D:/github/tweets/twitteR/to16.csv")
write.csv(to17, "D:/github/tweets/twitteR/to17.csv")
write.csv(to18, "D:/github/tweets/twitteR/to18.csv")
write.csv(to19, "D:/github/tweets/twitteR/to19.csv")
write.csv(to20, "D:/github/tweets/twitteR/to20.csv")

#~~~~~~~~~~~~~~~~~~~~~~~~~~~local hub of From.User~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# first, using ind924 till ind1009 choose top 100 in each daily network
out924$rank<-rank(1/rank(out924$Freq924,	na.last	=	TRUE,	ties.method	=	"random"))
out924s<-subset(out924,	out924$rank>=200)					
out924s$rank	<-	NULL				
out925$rank<-rank(1/rank(out925$Freq925,	na.last	=	TRUE,	ties.method	=	"random"))
out925s<-subset(out925,	out925$rank>=200)					
out925s$rank	<-	NULL				
out926$rank<-rank(1/rank(out926$Freq926,na.last	=	TRUE,	ties.method	="random"))	
out926s<-subset(out926,out926$rank>=200)						
out926s$rank	<-	NULL				
out927$rank<-rank(1/rank(out927$Freq927,na.last	=	TRUE,	ties.method	=	"random"))	
out927s<-subset(out927,out927$rank>=200)						
out927s$rank<-	NULL					
out928$rank<-rank(1/rank(out928$Freq928,na.last	=	TRUE,	ties.method	=	"random"))	
out928s<-subset(out928,out928$rank>=200)						
out928s$rank<-	NULL					
out929$rank<-rank(1/rank(out929$Freq929,na.last	=	TRUE,	ties.method	=	"random"))	
out929s<-subset(out929,out929$rank>=200)						
out929s$rank<-	NULL					
out930$rank<-rank(1/rank(out930$Freq930,na.last	=	TRUE,	ties.method	=	"random"))	
out930s<-subset(out930,out930$rank>=200)						
out930s$rank<-	NULL					
out1001$rank<-rank(1/rank(out1001$Freq1001,na.last	=	TRUE,	ties.method	=	"random"))	
out1001s<-subset(out1001,out1001$rank>=200)						
out1001s$rank<-	NULL					
out1002$rank<-rank(1/rank(out1002$Freq1002,na.last	=	TRUE,	ties.method	=	"random"))	
out1002s<-subset(out1002,out1002$rank>=200)						
out1002s$rank<-	NULL					
out1003$rank<-rank(1/rank(out1003$Freq1003,na.last	=	TRUE,	ties.method	=	"random"))	
out1003s<-subset(out1003,out1003$rank>=200)						
out1003s$rank<-	NULL					
out1004$rank<-rank(1/rank(out1004$Freq1004,na.last	=	TRUE,	ties.method	=	"random"))	
out1004s<-subset(out1004,out1004$rank>=200)						
out1004s$rank<-	NULL					
out1005$rank<-rank(1/rank(out1005$Freq1005,na.last	=	TRUE,	ties.method	=	"random"))	
out1005s<-subset(out1005,out1005$rank>=200)						
out1005s$rank<-	NULL					
out1006$rank<-rank(1/rank(out1006$Freq1006,na.last	=	TRUE,	ties.method	=	"random"))	
out1006s<-subset(out1006,out1006$rank>=200)						
out1006s$rank<-	NULL					
out1007$rank<-rank(1/rank(out1007$Freq1007,na.last	=	TRUE,	ties.method	=	"random"))	
out1007s<-subset(out1007,out1007$rank>=200)						
out1007s$rank<-	NULL					
out1008$rank<-rank(1/rank(out1008$Freq1008,na.last	=	TRUE,	ties.method	=	"random"))	
out1008s<-subset(out1008,out1008$rank>=200)						
out1008s$rank<-	NULL					
out1009$rank<-rank(1/rank(out1009$Freq1009,na.last	=	TRUE,	ties.method	=	"random"))	
out1009s<-subset(out1009,out1009$rank>=200)						
out1009s$rank<-	NULL					


list.From<-unique(factor(c(as.character(out924s[,1]),	as.character(out924s[,1]),as.character(out925s[,1]),as.character(out926s[,1])					
	,as.character(out927s[,1]),as.character(out928s[,1]),as.character(out929s[,1]),as.character(out930s[,1])					
	,as.character(out1001s[,1]),	as.character(out1002s[,1]),as.character(out1003s[,1]),as.character(out1004s[,1])				
	,as.character(out1005s[,1]),as.character(out1006s[,1])					
	,as.character(out1007s[,1]),as.character(out1008s[,1]),as.character(out1009s[,1])	)))				
						
out924t<-subset(out924,	out924[,1]%in%list.From)					
out925t<-subset(out925,out925[,1]%in%list.From)						
out926t<-subset(out926,out926[,1]%in%list.From)						
out927t<-subset(out927,out927[,1]%in%list.From)						
out928t<-subset(out928,out928[,1]%in%list.From)						
out929t<-subset(out929,out929[,1]%in%list.From)						
out930t<-subset(out930,out930[,1]%in%list.From)						
out1001t<-subset(out1001,out1001[,1]%in%list.From)						
out1002t<-subset(out1002,out1002[,1]%in%list.From)						
out1003t<-subset(out1003,out1003[,1]%in%list.From)						
out1004t<-subset(out1004,out1004[,1]%in%list.From)						
out1005t<-subset(out1005,out1005[,1]%in%list.From)						
out1006t<-subset(out1006,out1006[,1]%in%list.From)						
out1007t<-subset(out1007,out1007[,1]%in%list.From)						
out1008t<-subset(out1008,out1008[,1]%in%list.From)						
out1009t<-subset(out1009,out1009[,1]%in%list.From)						
out924t[,3]<-NULL						
out925t[,3]<-NULL						
out926t[,3]<-NULL						
out927t[,3]<-NULL						
out928t[,3]<-NULL						
out929t[,3]<-NULL						
out930t[,3]<-NULL						
out1001t[,3]<-NULL						
out1002t[,3]<-NULL						
out1003t[,3]<-NULL						
out1004t[,3]<-NULL						
out1005t[,3]<-NULL						
out1006t[,3]<-NULL						
out1007t[,3]<-NULL						
out1008t[,3]<-NULL						
out1009t[,3]<-NULL						
out2t<-merge(out924t,	out925t,	by="From.User",	all	=	T,	incomparables= NA)
out3t<-merge(out2t,	out926t,	by="From.User",	all	=	T,	incomparables= NA)
out4t<-merge(out3t,	out927t,	by="From.User",	all	=	T,	incomparables= NA)
out5t<-merge(out4t,	out928t,	by="From.User",	all	=	T,	incomparables= NA)
out6t<-merge(out5t,	out929t,	by="From.User",	all	=	T,	incomparables= NA)
out7t<-merge(out6t,	out930t,	by="From.User",	all	=	T,	incomparables= NA)
out8t<-merge(out7t,	out1001t,	by="From.User",	all	=	T,	incomparables= NA)
out9t<-merge(out8t,	out1002t,	by="From.User",	all	=	T,	incomparables= NA)
out10t<-merge(out9t,	out1003t,	by="From.User",	all	=	T,	incomparables= NA)
out11t<-merge(out10t,	out1004t,	by="From.User",	all	=	T,	incomparables= NA)
out12t<-merge(out11t,	out1005t,	by="From.User",	all	=	T,	incomparables= NA)
out13t<-merge(out12t,	out1006t,	by="From.User",	all	=	T,	incomparables= NA)
out14t<-merge(out13t,	out1007t,	by="From.User",	all	=	T,	incomparables= NA)
out15t<-merge(out14t,	out1008t,	by="From.User",	all	=	T,	incomparables= NA)
out16t<-merge(out15t,	out1009t,	by="From.User",	all	=	T,	incomparables= NA)
out16t[	is.na(out16t)	]	<-	0		



names(out16t) <- c("From.User","Sep24","Sep25","Sep26","Sep27","Sep28","Sep29","Sep30","Oct1","Oct2","Oct3","Oct4","Oct5","Oct6","Oct7","Oct8","Oct9")

corout <- cor(out16t[,2:17])

library(corrplot) # install.packages("corrplot")
corrplot(corout, method = "circle", type = c("full"))

## circle + colorful number
corrplot(corout,type="upper",addtextlabel="no")
corrplot(corout,add=TRUE, type="lower", method="number",
	diag=T,addtextlabel="yes", addcolorlabel="right")
# N of From.User is 26316, while N of To.User is 28253.

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~non-local hub of to.user~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# first, using ind924 till ind1009 choose top 100 in each daily network
ind924$rank<-rank(1/rank(ind924$Freq924, na.last = TRUE, ties.method =  "random"))
ind924s<-subset(ind924, ind924$rank>200)
ind924s$rank <- NULL
# ind924[,4]<-NULL
# names(ind924s)<-c("To.User","Freq924", "rank")

ind925$rank<-rank(1/rank(ind925$Freq925, na.last = TRUE, ties.method =  "random"))
ind925s<-subset(ind925, ind925$rank>200)
ind925s$rank <- NULL
ind926$rank<-rank(1/rank(ind926$Freq926,na.last = TRUE, ties.method =  "random"))
ind926s<-subset(ind926,ind926$rank>200)
ind926s$rank <- NULL
ind927$rank<-rank(1/rank(ind927$Freq927,na.last = TRUE, ties.method =  "random"))
ind927s<-subset(ind927,ind927$rank>200)
ind927s$rank<- NULL
ind928$rank<-rank(1/rank(ind928$Freq928,na.last = TRUE, ties.method =  "random"))
ind928s<-subset(ind928,ind928$rank>200)
ind928s$rank<- NULL
ind929$rank<-rank(1/rank(ind929$Freq929,na.last = TRUE, ties.method =  "random"))
ind929s<-subset(ind929,ind929$rank>200)
ind929s$rank<- NULL
ind930$rank<-rank(1/rank(ind930$Freq930,na.last = TRUE, ties.method =  "random"))
ind930s<-subset(ind930,ind930$rank>200)
ind930s$rank<- NULL
ind1001$rank<-rank(1/rank(ind1001$Freq1001,na.last = TRUE, ties.method =  "random"))
ind1001s<-subset(ind1001,ind1001$rank>200)
ind1001s$rank<- NULL
ind1002$rank<-rank(1/rank(ind1002$Freq1002,na.last = TRUE, ties.method =  "random"))
ind1002s<-subset(ind1002,ind1002$rank>200)
ind1002s$rank<- NULL
ind1003$rank<-rank(1/rank(ind1003$Freq1003,na.last = TRUE, ties.method =  "random"))
ind1003s<-subset(ind1003,ind1003$rank>200)
ind1003s$rank<- NULL
ind1004$rank<-rank(1/rank(ind1004$Freq1004,na.last = TRUE, ties.method =  "random"))
ind1004s<-subset(ind1004,ind1004$rank>200)
ind1004s$rank<- NULL
ind1005$rank<-rank(1/rank(ind1005$Freq1005,na.last = TRUE, ties.method =  "random"))
ind1005s<-subset(ind1005,ind1005$rank>200)
ind1005s$rank<- NULL
ind1006$rank<-rank(1/rank(ind1006$Freq1006,na.last = TRUE, ties.method =  "random"))
ind1006s<-subset(ind1006,ind1006$rank>200)
ind1006s$rank<- NULL
ind1007$rank<-rank(1/rank(ind1007$Freq1007,na.last = TRUE, ties.method =  "random"))
ind1007s<-subset(ind1007,ind1007$rank>200)
ind1007s$rank<- NULL
ind1008$rank<-rank(1/rank(ind1008$Freq1008,na.last = TRUE, ties.method =  "random"))
ind1008s<-subset(ind1008,ind1008$rank>200)
ind1008s$rank<- NULL
ind1009$rank<-rank(1/rank(ind1009$Freq1009,na.last = TRUE, ties.method =  "random"))
ind1009s<-subset(ind1009,ind1009$rank>200)
ind1009s$rank<- NULL

list.To<-unique(factor(c(as.character(ind924s[,1]), as.character(ind924s[,1]),as.character(ind925s[,1]),as.character(ind926s[,1])
   ,as.character(ind927s[,1]),as.character(ind928s[,1]),as.character(ind929s[,1]),as.character(ind930s[,1])
   ,as.character(ind1001s[,1]), as.character(ind1002s[,1]),as.character(ind1003s[,1]),as.character(ind1004s[,1])
   ,as.character(ind1005s[,1]),as.character(ind1006s[,1])
   ,as.character(ind1007s[,1]),as.character(ind1008s[,1]),as.character(ind1009s[,1]) )))

ind924t<-subset(ind924, ind924[,1]%in%list.To)
ind925t<-subset(ind925,ind925[,1]%in%list.To)
ind926t<-subset(ind926,ind926[,1]%in%list.To)
ind927t<-subset(ind927,ind927[,1]%in%list.To)
ind928t<-subset(ind928,ind928[,1]%in%list.To)
ind929t<-subset(ind929,ind929[,1]%in%list.To)
ind930t<-subset(ind930,ind930[,1]%in%list.To)
ind1001t<-subset(ind1001,ind1001[,1]%in%list.To)
ind1002t<-subset(ind1002,ind1002[,1]%in%list.To)
ind1003t<-subset(ind1003,ind1003[,1]%in%list.To)
ind1004t<-subset(ind1004,ind1004[,1]%in%list.To)
ind1005t<-subset(ind1005,ind1005[,1]%in%list.To)
ind1006t<-subset(ind1006,ind1006[,1]%in%list.To)
ind1007t<-subset(ind1007,ind1007[,1]%in%list.To)
ind1008t<-subset(ind1008,ind1008[,1]%in%list.To)
ind1009t<-subset(ind1009,ind1009[,1]%in%list.To)
ind924t[,3]<-NULL
ind925t[,3]<-NULL
ind926t[,3]<-NULL
ind927t[,3]<-NULL
ind928t[,3]<-NULL
ind929t[,3]<-NULL
ind930t[,3]<-NULL
ind1001t[,3]<-NULL
ind1002t[,3]<-NULL
ind1003t[,3]<-NULL
ind1004t[,3]<-NULL
ind1005t[,3]<-NULL
ind1006t[,3]<-NULL
ind1007t[,3]<-NULL
ind1008t[,3]<-NULL
ind1009t[,3]<-NULL
ind2t<-merge(ind924t, ind925t, by="To.User", all = T, incomparables = NA)
ind3t<-merge(ind2t, ind926t, by="To.User", all = T, incomparables = NA)
ind4t<-merge(ind3t, ind927t, by="To.User", all = T, incomparables = NA)
ind5t<-merge(ind4t, ind928t, by="To.User", all = T, incomparables = NA)
ind6t<-merge(ind5t, ind929t, by="To.User", all = T, incomparables = NA)
ind7t<-merge(ind6t, ind930t, by="To.User", all = T, incomparables = NA)
ind8t<-merge(ind7t, ind1001t, by="To.User", all = T, incomparables = NA)
ind9t<-merge(ind8t, ind1002t, by="To.User", all = T, incomparables = NA)
ind10t<-merge(ind9t, ind1003t, by="To.User", all = T, incomparables = NA)
ind11t<-merge(ind10t, ind1004t, by="To.User", all = T, incomparables = NA)
ind12t<-merge(ind11t, ind1005t, by="To.User", all = T, incomparables = NA)
ind13t<-merge(ind12t, ind1006t, by="To.User", all = T, incomparables = NA)
ind14t<-merge(ind13t, ind1007t, by="To.User", all = T, incomparables = NA)
ind15t<-merge(ind14t, ind1008t, by="To.User", all = T, incomparables = NA)
ind16t<-merge(ind15t, ind1009t, by="To.User", all = T, incomparables = NA)
ind16t[ is.na(ind16t) ] <- 0
names(ind16t) <- c("To.User","Sep24","Sep25","Sep26","Sep27","Sep28","Sep29","Sep30","Oct1","Oct2","Oct3","Oct4","Oct5","Oct6","Oct7","Oct8","Oct9")

cort <- cor(ind16t[,2:17])

library(corrplot) # install.packages("corrplot")
corrplot(cort, method = "circle", type = c("full"))
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~exclude the RT tweets~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# delte the RT, focus on pure @
test<-inter$Text[1:100]  # 16, 36, 37, 79, 91, 99
nort<-strsplit(as.character(test), "RT")  # 17, 18, 20, 38, 48, 52, 58, 61, 64, 81, 82, 84
# "please RT this video"
norta<-strsplit(as.character(inter$Text), "RT @") # 58
# "RT: @P2Action @GottaLaff 25" # try "RT: @"
# length(norta[[91]])  #
f<-function(n){
     l<-length(norta[[n]])
     return(l)  
   }
inter$RT<-sapply(c(1:length(norta)),f)  

# table(inter$RT)
# Only 4230 RT in 88601 interactions.
   1     2     3     4     5 
84371  3988   222    18     2 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Geo infor~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
 as.data.frame(table(as.character(inter$Geo)))
(levels(inter$Geo))[1:5]
 [1] ""                                                                                                                                                                                      
 [2] "a:2:{s:11:\"coordinates\";a:2:{i:0;d:-0.1287999999999999978239628717346931807696819305419921875;i:1;d:-78.4996000000000009322320693172514438629150390625;}s:4:\"type\";s:5:\"Point\";}"
 [3] "a:2:{s:11:\"coordinates\";a:2:{i:0;d:-1.2754000000000000891731133378925733268260955810546875;i:1;d:36.8010000000000019326762412674725055694580078125;}s:4:\"type\";s:5:\"Point\";}"    
 [4] "a:2:{s:11:\"coordinates\";a:2:{i:0;d:-1.283300000000000107291953099775128066539764404296875;i:1;d:36.816699999999997316990629769861698150634765625;}s:4:\"type\";s:5:\"Point\";}"      
 [5] "a:2:{s:11:\"coordinates\";a:2:{i:0;d:-1.2874000000000000998312543742940761148929595947265625;i:1;d:36.7668000000000034788172342814505100250244140625;}s:4:\"type\";s:5:\"Point\";}"    
# install.packages("geoR")# Spacial analysis is a bit too complex
#  using Yahoo!Geocoding API: developer.yahoo/maps
test<-(levels(inter$Geo)) 
length(test) # only 510 tweets with geo info
test1<-strsplit(test, "d:") # 58
# 87965 rows without geo infor
#~~~~~~~~~~~~~~~~~~~~~~~~~~~Emotion and Online Discussion~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
at<-subset(inter, inter$RT==1)
at$num<-1
at1<-aggregate(at$num, by=list(at$From.User, abs(at$sentiment.score)), FUN=sum)
names(at1)<-c("sender", "emotion", "num")
at1[,4]<-(at1[,2])*(at1[,3])
at2<-aggregate(at1[,3:4], by=list(at1[,1]), FUN=sum)
at2$emotion<-at2[,3]/at2[,2]
cor.test(at2[,2], at2[,4])
plot(log(at2[,4]+1),log(log(at2[,2]+1)))
summary(reg)
cor.test(at2[,2], at2[,3])
plot(log(at2[,3]+1),log(log(at2[,2]+1)))

plot(log(at2[,3]),(at2[,2]), xlab="Emotions (log)", ylab="Number of Tweets")


plot(at2[,3],at2[,2], xlab="Emotions", ylab="Number of Tweets")
reg<-lm((at2[,2])~(at2[,3]))
abline(reg)
text(400,800," R-squared: 0.4566")

at<-subset(inter, inter$RT==1)
at$num<-1
at1<-aggregate(at$num, by=list(at$From.User, abs(at$sentiment.score)), FUN=sum) # I use the absolute value of emotion
names(at1)<-c("sender", "emotion", "num")
at1[,4]<-(at1[,2])*(at1[,3])
at2<-aggregate(at1[,3:4], by=list(at1[,1]), FUN=sum)
at2$emotion<-at2[,3]/at2[,2]
cor.test(at2[,2], at2[,4])
plot(log(at2[,4]+1),log(log(at2[,2]+1)))
summary(reg)
cor.test(at2[,2], at2[,3])
plot(log(at2[,3]+1),log(log(at2[,2]+1)))
plot(at2[,3],at2[,2], xlab="Emotions", ylab="Number of Tweets")

plot(log(at2[,3]+1),log(at2[,2]+1), xlab="Emotions (log)", ylab="Number of Tweets")

reg<-lm(log(at2[,2]+1)~log(at2[,3]+1))
summary(reg) # 0.57

reg<-lm(log(at2[,2]+1)~log(at2[,3]+1))
summary(reg) # 0.57

cor.test(log(at2[,2]+1), log(at2[,3]+1))# 0.76
abline(reg)
text(400,800," R-squared: 0.57")


# the power law distribution of number of tweets
hist(at2[,2], breaks=10000)
f1<-data.frame(table(at2[,2]))
plot((as.numeric(f1[,1])+1),((as.numeric(f1[,2]))/(sum(f1[,2]))), xlab= "Number of Tweets", ylab= "Probability" )
plot(log(as.numeric(f1[,1])+1),log((as.numeric(f1[,2]))/(sum(f1[,2]))), xlab= "Number of Tweets", ylab= "Probability" )

# 
hist(at2[,3], breaks=10000)
f2<-data.frame(table(at2[,3]))
plot((as.numeric(f2[,1])+1),((as.numeric(f2[,2]))/(sum(f2[,2]))), xlab= "Emotion", ylab= "Probability" )
plot(log(as.numeric(f2[,1])+1),log((as.numeric(f2[,2]))/(sum(f2[,2]))), xlab="Emotion", ylab="Probability")
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~emotion extremity and discussion~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
att<-subset(inter, inter$RT==1)
att$num<-1
att1<-aggregate(at$num, by=list(at$From.User, (at$sentiment.score)), FUN=sum) # I use the absolute value of emotion
names(at1)<-c("sender", "emotion", "num")
att1[,4]<-(att1[,2])*(att1[,3])
att2<-aggregate(att1[,3:4], by=list(att1[,1]), FUN=sum)
att2$emotion<-att2[,3]/att2[,2]
cor.test(att2[,2], att2[,4])
plot(log(att2[,4]+1),log(log(att2[,2]+1)))
summary(reg)
cor.test(att2[,2], att2[,3])
plot(log(att2[,3]+500),log(log(att2[,2]+500)))

plot(log(att2[,3]+500),(att2[,2]+500), xlab="Emotions (log)", ylab="Number of Tweets")

plot(att2[,3],att2[,2], xlab="Emotions", ylab="Number of Tweets")
reg<-lm((att2[,2])~(att2[,3]))
abline(reg)
text(400,800," R-squared: 0.4566")
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~time-lag analysis~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
dt<-subset(inter, inter$RT==1&inter$Day=="2011-09-24")
dt$num<-1
dt1<-aggregate(dt$num, by=list(dt$From.User, abs(dt$sentiment.score)), FUN=sum) # I use the absolute value of emotion
names(dt1)<-c("sender", "emotion", "num")
dt1[,4]<-(dt1[,2])*(dt1[,3])
dt2<-aggregate(dt1[,3:4], by=list(dt1[,1]), FUN=sum)
names(dt2)<-c("sender", "num1", "emotion1")
cor.test(dt2[,2], dt2[,3])

plot(dt2[,3],dt2[,2], xlab="Emotions", ylab="Number of Tweets")
data1<-dt2
# use the first process to generate data2
dt<-subset(inter, inter$RT==1&inter$Day=="2011-09-25")
dt$num<-1
dt1<-aggregate(dt$num, by=list(dt$From.User, abs(dt$sentiment.score)), FUN=sum) # I use the absolute value of emotion
names(dt1)<-c("sender", "emotion", "num")
dt1[,4]<-(dt1[,2])*(dt1[,3])
dt2<-aggregate(dt1[,3:4], by=list(dt1[,1]), FUN=sum)
names(dt2)<-c("sender", "num2", "emotion2")
cor.test(dt2[,2], dt2[,3])
plot(dt2[,3],dt2[,2], xlab="Emotions", ylab="Number of Tweets")
data2<-dt2

# merge data1 with data2
data3<-merge(data1, data2, by="sender", all = T, incomparables = NULL)
data <-merge(data1, data2, by="sender" ); dim(data)  # only the overlapped part will be analyzed.
data[is.na(data)]<- 0
length(data1[,1]);length(data2[,1]);length(data3[,1]);length(data[,1])
dim(test<-subset(data2, data2$sender%in%data1$sender))

corlag<-cor(data[2:5]);corlag

library(corrplot) # install.packages("corrplot")
corrplot(corlag, method = "circle", type = c("full"))
# Use the Fast Fourier Transform to compute the several kinds of convolutions of two sequences.
q<-convolve(data$num1,data$num2,conj=TRUE,type="open")
#  Function ccf computes the cross-correlation
ccf(data$num1,data$num2)
acf(data[2:5])
#~~~~~~~~~~~~~~~~~~~~Vector autoregression~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
at<-subset(inter, inter$RT==1)
at$num<-1
myvars <- names(at) %in% c("num", "Day", "sentiment.score") 
newdata <- at[myvars]
newdata$Day<-as.character(newdata$Day)
newdata$sentiment.score<-abs(newdata$sentiment.score)
class(newdata[,1]);class(newdata[,2]);class(newdata[,3])
var<-aggregate(newdata[,2:3], by=list(newdata$Day), FUN=sum) # I use the absolute value of emotion

library(vars) # install.packages("vars")
var.2c <- VAR(var[,2:3], p = 5, type = "none")
coef(var.2c)

plot(var[,2], var[,3], xlab="Emotion (daily)", ylab="Num of Tweets (daily)")
reg1<-lm(var[,3]~var[,2])
summary(reg1)

abline(reg1)
text(4000,8000,"R-squared: 0.99")

data(Canada)
coef(VAR(Canada, p = 2, type = "none"))
VAR(Canada, p = 2, type = "const")
VAR(Canada, p = 2, type = "trend")
VAR(Canada, p = 2, type = "both")


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~emotion extremity~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
f<-function(x){
 dt<-subset(inter, inter$RT==1&inter$Day==x)
 dt$num<-1
 dt1<-aggregate(dt$num, by=list(dt$From.User, abs(dt$sentiment.score)), FUN=sum) # I use the absolute value of emotion
 names(dt1)<-c("sender", "emotion", "num")
 dt1[,4]<-(dt1[,2])*(dt1[,3])
 dt2<-aggregate(dt1[,3:4], by=list(dt1[,1]), FUN=sum)
 names(dt2)<-c("sender", "num1", "emotion1")
 y<-cor.test(dt2[,2], dt2[,3])
 return(y)
 }
  list<-c("2011-09-24","2011-09-25","2011-09-26","2011-09-27","2011-09-28",
          "2011-09-29","2011-09-30","2011-10-01","2011-10-02","2011-10-03",
          "2011-10-04","2011-10-05","2011-10-06","2011-10-07","2011-10-08","2011-10-09")
corrr<-sapply(list,f)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~emotion and sd of participation~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
f<-function(x){
 dt<-subset(inter, inter$RT==1&inter$Day==x)
 dt$num<-1
 dt1<-aggregate(dt$num, by=list(dt$From.User, dt$sum.sen.score), FUN=sum) # I use the absolute value of emotion
 names(dt1)<-c("sender", "emotion", "num")
 dt1[,4]<-(dt1[,2])*(dt1[,3]) 
 dt2<-aggregate(dt1[,3:4], by=list(dt1[,1]), FUN=sum)
 names(dt2)<-c("sender", "num1", "emotion1")
 dt2$date<-x
  return(dt2)
 }
list<-c("2011-09-24","2011-09-25","2011-09-26","2011-09-27","2011-09-28",
          "2011-09-29","2011-09-30","2011-10-01","2011-10-02","2011-10-03",
          "2011-10-04","2011-10-05","2011-10-06","2011-10-07","2011-10-08","2011-10-09")
corrr<-lapply(list,f)
class(corrr[[1]]) # it's data.frame
names(corrr[[1]])<-c("sender", "num1", "emotion1", "date1")
names(corrr[[2]])<-c("sender", "num2", "emotion2", "date2")
names(corrr[[3]])<-c("sender", "num3", "emotion3", "date3")
names(corrr[[4]])<-c("sender", "num4", "emotion4", "date4")
names(corrr[[5]])<-c("sender", "num5", "emotion5", "date5")
names(corrr[[6]])<-c("sender", "num6", "emotion6", "date6")
names(corrr[[7]])<-c("sender", "num7", "emotion7", "date7")
names(corrr[[8]])<-c("sender", "num8", "emotion8", "date8")
names(corrr[[9]])<-c("sender", "num9", "emotion9", "date9")
names(corrr[[10]])<-c("sender", "num10", "emotion10", "date10")
names(corrr[[11]])<-c("sender", "num11", "emotion11", "date11")
names(corrr[[12]])<-c("sender", "num12", "emotion12", "date12")
names(corrr[[13]])<-c("sender", "num13", "emotion13", "date13")
names(corrr[[14]])<-c("sender", "num14", "emotion14", "date14")
names(corrr[[15]])<-c("sender", "num15", "emotion15", "date15")
names(corrr[[16]])<-c("sender", "num16", "emotion16", "date16")


sd2<-merge(corrr[[1]],corrr[[2]],by="sender",all=T,incomparables= NA)
sd3<-merge(sd2, corrr[[3]],by="sender",all=T,incomparables= NA)
sd4<-merge(sd3, corrr[[4]],by="sender",all=T,incomparables= NA)
sd5<-merge(sd4, corrr[[5]],by="sender",all=T,incomparables= NA)
sd6<-merge(sd5, corrr[[6]],by="sender",all=T,incomparables= NA)
sd7<-merge(sd6, corrr[[7]],by="sender",all=T,incomparables= NA)
sd8<-merge(sd7, corrr[[8]],by="sender",all=T,incomparables= NA)
sd9<-merge(sd8, corrr[[9]],by="sender",all=T,incomparables= NA)
sd10<-merge(sd9, corrr[[10]],by="sender",all=T,incomparables= NA)
sd11<-merge(sd10, corrr[[11]],by="sender",all=T,incomparables= NA)
sd12<-merge(sd11, corrr[[12]],by="sender",all=T,incomparables= NA)
sd13<-merge(sd12, corrr[[13]],by="sender",all=T,incomparables= NA)
sd14<-merge(sd13, corrr[[14]],by="sender",all=T,incomparables= NA)
sd15<-merge(sd14, corrr[[15]],by="sender",all=T,incomparables= NA)
sd16<-merge(sd15, corrr[[16]],by="sender",all=T,incomparables= NA)
sd16[is.na(sd16)]<-0

 write.csv(sd16, "/Users/wangpianpian/Dropbox/projects/tweets/data_delete after you download/20120707ows_sd16.csv")

allstar<-subset(sd16, sd16$num1!=0&sd16$num2!=0&sd16$num3!=0&sd16$num4!=0&sd16$num5!=0
 &sd16$num6!=0&sd16$num7!=0&sd16$num8!=0&sd16$num9!=0&sd16$num10!=0&sd16$num11!=0
  &sd16$num12!=0&sd16$num13!=0&sd16$num14!=0&sd16$num15!=0&sd16$num16!=0)
sd16$emotion_sum<-sum(sd16$emotion1, sd16$emotion2, sd16$emotion3, sd16$emotion4, sd16$emotion5, sd16$emotion6,
    sd16$emotion7, sd16$emotion8, sd16$emotion9, sd16$emotion10, sd16$emotion11, sd16$emotion12, 
    sd16$emotion13, sd16$emotion14, sd16$emotion15, sd16$emotion16)
    
# the aggregated emotion
sumemo<-function(n){
     see<-sum(sd16$emotion1[n],sd16$emotion2[n],sd16$emotion3[n],sd16$emotion4[n],sd16$emotion5[n],
sd16$emotion6[n],sd16$emotion7[n],sd16$emotion8[n],sd16$emotion9[n],sd16$emotion10[n],sd16$emotion11[n],sd16$emotion12[n],sd16$emotion13[n],sd16$emotion14[n],sd16$emotion15[n],sd16$emotion16[n])
   return(see)}
sd16$emotion_sum<-sapply(c(1:length(sd16[,1])), sumemo)
head(sd16)
# the aggregated number of tweets
sumem<-function(n){
   ss<-sum(sd16$num1[n],sd16$num2[n],sd16$num3[n],sd16$num4[n],sd16$num5[n],
    sd16$num6[n],sd16$num7[n],sd16$num8[n],sd16$num9[n],sd16$num10[n],sd16$num11[n],
    sd16$num12[n],sd16$num13[n],sd16$num14[n],sd16$num15[n],sd16$num16[n])
   return(ss)}
sd16$emotion_num<-sapply(c(1:length(sd16[,1])), sumem)

# average emotion
sd16$emotion_mean<-sd16$emotion_sum/sd16$emotion_num

sde<-function(n){
   ss<-c(sd16$num1[n],sd16$num2[n],sd16$num3[n],sd16$num4[n],sd16$num5[n],
    sd16$num6[n],sd16$num7[n],sd16$num8[n],sd16$num9[n],sd16$num10[n],sd16$num11[n],
    sd16$num12[n],sd16$num13[n],sd16$num14[n],sd16$num15[n],sd16$num16[n])
   sdd<-sd(ss)
   return(sdd)}
sd16$discussion_sd<-sapply(c(1:length(sd16[,1])), sde)

cor((sd16$emotion_mean), (sd16$discussion_sd))  # cor -0.004100054
cor((sd16$emotion_mean), (sd16$emotion_num))  #-0.001887358

library(Hmisc)
#  emotion and stability
rcorr(as.matrix(data.frame(sd16$emotion_mean, sd16$discussion_sd)),type="pearson") # p = 0.516 
#  emotion and equality
rcorr(as.matrix(data.frame(sd16$emotion_mean, sd16$emotion_num)),type="pearson") # p = 0.765 
#ignore---
cor.test(sd16$emotion_sum, sd16$discussion_sd)
plot(sd16$emotion_sum, sd16$discussion_sd)

plot(sd16$emotion_sum, sd16$discussion_sd, xlab="Emotion", ylab="Standard Deviation of Tweets (daily)")
reg<-lm(sd16$discussion_sd~sd16$emotion_sum)
summary(reg)

abline(reg)
text(1000,60,"R-squared: 0.82")


#sampling
test.lexicon<-inter[sample(c(1:length(inter[,1])),  200),]
write.csv(test.lexicon, "/Users/wangpianpian/Dropbox/projects/tweets/data_delete after you download/test.lexicon.csv")
write.







