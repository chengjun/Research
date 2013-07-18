# Time series analysis for occupy wall street
# tweets, search query, news coverage, and stock market
# chengjun wang
# 20120429@caberra

ows<-read.csv("D:/Research/Dropbox/tweets/wapor_assessing online opinion/TimeSeriesOWS.csv", header=T, sep=",")
dat<-ows[1:112, 2:7]
names(dat)<-c("query", "news", "stock", "tweet", "disapprove", "approve")
# write.csv(dat, "D:/Research/Dropbox/tweets/wapor_assessing online opinion/TimeSeriesOWS.csv")
#~~~~~~~~ols regression~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
reg<-lm(dat$tweet~dat$query+dat$news+dat$stock)
summary(reg)

cor(dat, use="complete.obs", method="kendall") 

# Correlations with significance levels
library(Hmisc)
rcorr(as.matrix(dat)) 

#~~~~~~~~~~~~~~~~log transformation~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
hist(dat)
hist(dat$tweet, breaks=100)
hist(log(dat$tweet), breaks=100)
# 
data<-dat
data$tweet<-log(data$tweet)
data$query<-log(data$query)
data$news<-log(data$news)

dats<-data.frame(scale(data))
dats$date<-c(1:length(dats$query))
write.csv(dats, "D:/Research/Dropbox/tweets/wapor_assessing online opinion/ScaleOWS.csv")

#
plot(dats$query~dats$date, col="black",  type = "l", xlab="date", ylab="measures")
lines(dats$news~dats$date, col="red")
lines(dats$stock~dats$date, col="green")
lines(dats$tweet~dats$date, col="blue")
lines(dats$disapprove~dats$date, col="purple")
#~~~~~~~~~~~~~~parralel test~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
tw<-data.frame(ows$TotalTweets, ows$ReTweets,ows$X.tags,ows$X.tags.1)
names(tw)<-c("totalTweets", "retweet", "discussion", "hashtag")

plot(tw$retweet~tw$totalTweets, col="blue",  type = "l", xlab="date", ylab="measures")
lines(tw$discussion~tw$totalTweets, col="red")
lines(tw$hashtag~tw$totalTweets, col="green")

#~~~~~~~replacing each NA with interpolated values~~~~~~~~~~~#
data<-na.approx(dat, method = "linear", na.rm = FALSE) # library(tseries)
scaleData<-scale(data)
scaleData<-data.frame(scaleData)
scaleData$negativeStock<-scaleData$stock*(-1)
write.csv(scaleData, "D:/Research/Dropbox/tweets/wapor_assessing online opinion/ScaleOWSNoMissings.csv")

#~~~~~~~~~~unit root test~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
library(tseries)
dt<-as.data.frame(dats)
adf.test(dt$query)# p-value = 0.06592 # 不平稳，有趋势项。自己跟自己的过去有关系。
adf.test(dt$news)# p-value = 0.04 stationary # 随机的，跟之前没关系。短期的投机心理的。
pp.test(dt$news) # p-value = 0.01 stationary
# reject ho, and news does not contain a unit root
adf.test(dt$stock)# p-value = 0.3 # 不平稳，有趋势项。自己跟自己的过去有关系。

adf.test(dt$tweet)# p-value = 0.01 stationary
pp.test(dt$tweet)# p-value = 0.01 stationary # 随机的，跟之前没关系。
# reject ho, and tweet does not contain a unit root
pp.test(dt$disapprove) # 0.01, 随机的，跟之前没关系。短期的投机心理的。
#~~~~~~~~~cointegration test~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
po.test(cbind(dt$stock, dt$tweet)) # 0.15 not cointegrated
po.test(cbind(dt$stock, dt$news)) # 0.15
po.test(cbind(dt$stock, dt$query)) # 0.15
po.test(cbind(dt$tweet, dt$news)) # 0.01 integrated
po.test(cbind(dt$tweet, dt$query)) # 0.01 integrated
po.test(cbind(dt$news, dt$query)) # 0.01 integrated
# for all the variables
po.test(cbind(dt$news, dt$query, dt$stock, dt$tweet)) 
# 0.01 integrated!!! 有一种120天的长期关系存在。
po.test(cbind(log(dt$tweet), dt$disapprove)) # 0.01
#~~~~~~~~~~~~~~~auto-regression~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
library(vars)
data<-dats[,1:5]

var.1c <- VAR(data, p = 1, type = "const")
coef(var.1c)
acf(resid(var.1c)[, 1])
acf(resid(var.1c)[, 3])


var.2c <- VAR(data, p = 2, type = "const")
coef(var.2c)

US.pred <- predict(data, n.ahead = 4)
GNP.pred <- ts(US.pred$fcst$GNP[, 1], st = 1988, fr = 4)
M1.pred <- ts(US.pred$fcst$M1[, 1], st = 1988, fr = 4)
ts.plot(cbind(window(GNP, start = 1981), GNP.pred), lty = 1:2)
ts.plot(cbind(window(M1, start = 1981), M1.pred), lty = 1:2)
#~~~~~~~~~~~~~VECM: control error-correction-term~~~~~~~~~~~~#
library(urca)
# Conducts the Johansen procedure on a given data set. 
sjd.vecm<- ca.jo(data.frame(data), ecdet = "const", type="eigen", K=2, spec="longrun", season=NULL) 
# spec="longrun"
# K	 The lag order of the series (levels) in the VAR.
# ecdet  ‘none’ for no intercept in cointegration, ‘const’ for constant term in cointegration
# and ‘trend’ for trend variable in cointegration.

# OLS regression of VECM
sjd.vecm.ols <- cajools(sjd.vecm)
summary(sjd.vecm.ols)

# OLS retricted VECM regression 
sjd.vecm.rls<-cajorls(sjd.vecm,r=2) 
# r An integer, signifiying the cointegration rank.
summary(sjd.vecm.rls$rlm) 
sjd.vecm.rls$beta 

# 'ect' is shorthand for error-correction-term
# 'sd' signify seasonal dummy
# 'LRM.dl1' is the lagged first difference of the variable 'LRM' 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#















