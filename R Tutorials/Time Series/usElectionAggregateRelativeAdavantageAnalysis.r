#################################################
'Relative advantage analysis of US election 2012'
#################################################
library(tseries)
library(vars)
library(urca)

setwd("D:/Research/Dropbox/US Election 2012/data/") # PC
setwd("D:/Dropbox/US Election 2012/data/") #  office pc

data<-read.csv( paste(getwd(), "/US_Election_Aggregate.csv", sep = "") , 
                header=T, sep=",",stringsAsFactors=F )
dim(data)      


data$sent = data$obama_sentiment_score/(data$obama_sentiment_score + data$romney_sentiment_score)
data$news = data$obama_media/(data$obama_media + data$romney_media)
data$query = data$obama_query/(data$obama_query + data$romney_query)
data$tweet = data$obama_mentions/(data$obama_mentions + data$romney_mentions)
data$poll = data$obama_poll/(data$obama_poll + data$romney_poll)

dt<-subset(data, select=c("sent","tweet", "query", "news", "poll"))
# dtp<-subset(data, select=c("sent","tweet", "query", "news", "poll"))

cor(dt)


# png(paste(getwd(), "/US.Aggregate.Relative.png", sep = ""), 
#     width=6, height=8, 
#     units="in", res=450)
# plot(as.ts(dtp), nc = 1, xlab = "", main='', col='red') # dt
# 
# dev.off()

##################################
'Stationary (e.g., Unit root)'
##################################

adf.test(dt$query)# p-value = 0.81 # stationary
adf.test(dt$news)# p-value = 0.44 stationary 
adf.test(dt$sent)# p-value = 0.037 
adf.test(dt$tweet)# p-value = 0.99 stationary
adf.test(dt$poll)# p-value = 0.71 stationary

N = 2
queryd<-diff(dt$query, differences = N)
newsd<-diff(dt$news, differences = N)
sentd<-diff(dt$sent, differences = N)
tweetd<-diff(dt$tweet, differences = N)
polld<-diff(dt$poll, differences = N)

adf.test(queryd) # 0.01 first difference is stationary! Good!
adf.test(newsd) # p-value = 0.01
adf.test(sentd) # 0.01 first difference is also stationary!Owesome!
adf.test(tweetd) # p-value = 0.01
adf.test(polld) # p-value = 0.01

dt<-data.frame(sentd, tweetd, queryd, newsd, polld)

####################
"Co-integration Test"
####################
"Phillips–Ouliaris Cointegration Test"
po.test(cbind(dt$sentd, dt$tweetd)) # 0.01 cointegrated
po.test(cbind(dt$sentd, dt$newsd)) # 0.01
po.test(cbind(dt$sentd, dt$queryd)) # 0.01
po.test(cbind(dt$tweetd, dt$newsd)) # 0.01 integrated
po.test(cbind(dt$tweetd, dt$queryd)) # 0.01 integrated
po.test(cbind(dt$newsd, dt$queryd)) # 0.01 integrated
po.test(cbind(dt$newsd, dt$polld)) # 0.01 cointegrated

po.test(dt)

'Phillips & Ouliaris Cointegration Test'
# The null hypothesis is that no cointegration relationship exists

for (x in c("Pz", "Pu")){
  for (y in c("none", "constant", "trend")){
    print(summary(ca.po(dt, type = x, demean = y)))
  }
}
  
"the insights gained with respect to the cointegrating relationship
verified by single-equation method are limited in the case of more than two variables."
####################
'select time lags'
####################

VARselect(dt, lag.max = 5, season = 4, type = "const") # very useful is 4

###############################
' VAR & Granger causality Test'
###############################
library(vars)

var.2c <- VAR(dt, p = 4, type = "both" ,season = 4)
summary(var.2c)

causality(var.2c, cause = "sentd")
causality(var.2c, cause = "tweetd")
causality(var.2c, cause = "queryd")
causality(var.2c, cause = "newsd")
causality(var.2c, cause = "polld")

###########################################################
##Johansen procedures for Testing of Cointegration Vectors
###########################################################
"Null Hypothesis: no integration for vectors"

'1. in tsDyn Test cointegration rank for vector systems'
library(tsDyn)

ve.jo <- VECM(dt, lag=4, include = "const",estim="ML")
for (i in 1:4) print(rank.test(ve.jo, r_null=i, type = "eigen"))

'2. in urca Test cointegration rank for vector systems'

sjd.vecm<- ca.jo(dt, ecdet = "const", type="eigen",
                 K=4, spec="longrun", season=4) 
summary(sjd.vecm)

sjd.vecm<- ca.jo(dt, ecdet = "const", type="trace",
                 K=4, spec="longrun", season=4) 
summary(sjd.vecm)

'3. in urca Inference on cointegration rank allowing for structural shift'
summary ( cajolst ( dt, season=4) )

####################################
'VECM: vector-error-correction-model'
####################################
# Mind the value of cointegrating rank r, it changes everything!!!!
sjd.vecm<- ca.jo(dt, ecdet = "const", type="eigen",
                 K=4, spec="longrun", season=4) 
sjd.vecm.rls<-cajorls(sjd.vecm,r=4) 
summary(sjd.vecm.rls$rlm) 


##################################
'Visualizing VECM'
##################################
edgelist = lapply(1:5, 
                  function(i){response = names(coef((summary(sjd.vecm.rls$rlm))[i]))
                                   coef.list = (coef((summary(sjd.vecm.rls$rlm))[i]))[[1]]                  
                                   p.value = coef.list[,"Pr(>|t|)"]  
                                   beta.value = coef.list[,"Estimate"]      
                                   beta.sig = names(beta.value[p.value <= 0.05])
                                   beta.sig.value = beta.value[p.value <= 0.05]
                                   weight = ifelse(beta.sig.value >0, "blue", "red")
                                   dfn = data.frame(beta.sig, response, weight, stringsAsFactors = F)
                                   return(dfn)
}
)

edgelist = do.call(rbind, edgelist)
edgelist[,2] = gsub("Response ", "", edgelist[,2], fixed = T)
edgelist[,2] = gsub("d.d", "", edgelist[,2], fixed = T)
edgelist[,1] = gsub("d.dl", "", edgelist[,1], fixed = T)
edgelist[,1] = gsub("\\d", "", edgelist[,1])
edgelist= subset(edgelist, edgelist$beta.sig %in%unique(edgelist$response))
edgelist[,1] = gsub("sent", "sentiment", edgelist[,1], fixed = T)
edgelist[,2] = gsub("sent", "sentiment", edgelist[,2], fixed = T)


library(igraph)                       
g <-graph.data.frame(edgelist,directed=T )
# edge.color="black"
nodesize = centralization.degree(g, mode = "in")$res 
V(g)$size = log( centralization.degree(g)$res )
E(g)$color =  edgelist$weight

# 保存图片格式
png(paste(getwd(),"/vecm.graph.relative1.png",sep=""),
            width=6, height=5, 
            units="in", res=700)
par(mar= c(0,0,0,0), 
    xaxs     = "i",
    yaxs     = "i",
    cex.axis = 2,
    cex.lab  = 2)
set.seed(34)   ## to make this reproducable
l<-layout.fruchterman.reingold(g)
plot(0, type="n", ann=FALSE, axes=FALSE, xlim=extendrange(l[,1]*3), 
     ylim=extendrange(l[,2]*3))

plot(g, layout=l, rescale=T, add=F, edge.curved=TRUE, 
     edge.lty = ifelse(edgelist$weight == "blue", 1, 2),
     vertex.shape="rectangle", 
     edge.arrow.size=0.8, 
     vertex.size=(strwidth(V(g)$name) + strwidth("oo")) * 60, 
     vertex.size2=strheight("I") * 2 * 20)
# 结束保存图片
dev.off()

# plot(g, vertex.label= V(g)$name,  edge.curved=TRUE, 
#      vertex.label.cex =1,  edge.arrow.size=0.8, 
#      edge.lty = ifelse(edgelist$weight == "blue", 1, 2), layout=l )
