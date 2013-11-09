# Youtube dataset
# http://www.vod.dcc.ufmg.br/traces/youtime/data/
# chengjun wang
# 20120317


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~read and clean data~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# top<-read.csv("D:/Micro-blog/Youtube/TubeOverTime/top/dao/dao.csv", header=T, sep=",", stringsAsFactors=F)
# clean data
# top<-subset(top, top$EVENT_TYPE!="[]")
#~~~~~crawling category\author\duration information using python~~~~~~~~~~~~~~~~#
# top<-read.csv("D:/Micro-blog/Youtube/TubeOverTime/top/dao/top.csv", header=T, sep=",", stringsAsFactors=F)
# write.csv(id<-top[,2], "C:/Python27/weibo/youtube/id.csv", quote = F, row.names = F)
# write.csv(id<-top[2470:2480,2], "C:/Python27/weibo/youtube/id_test.csv", quote = F, row.names = F)
# cat<-read.csv( "C:/Python27/weibo/youtube/saveCat.csv", sep = ",", quote = "|", header = FALSE)
# names(cat)<-c("X.ID", "author","category", "duration")
# dim(TopData)  11386 24% are set as private or delete
# topcat<-merge(top, cat, by="X.ID",all = TRUE, incomparables=NA );dim(topcat)
# write.csv(topcat, "D:/Micro-blog/Youtube/TubeOverTime/top/dao/topcat.csv")
#~~~~~~~~~~~~~~~~Load Data~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
top<-read.csv("D:/google drive/Google Drive/Youtube/Data/topCatPeak.csv", header = T, sep=',', stringsAsFactors=F)
attach(top)
# write.csv(top, "D:/Research/Youtube/TubeOverTime/top/dao/topCatPeak.csv")
## recommendation
# top$feo<-top[,21]   # External: First embedded on 
# top$fev<-top[,22]   # External: First embedded view
# top$frf<-top[,24]   # External: First referrer from
# top$fvfa<-top[,31]  # FEATURED: First view from ad
# top$ffvv<-top[,23]  # FEATURED: First featured video view
# top$frflv<-top[,28] # INTERNAL: First referrer from Related Video ????
# top$frfy<-top[,29]  # INTERNAL: First referrer from YouTube
## mobile
# top$fvfmd<-top[,32] # MOBILE: First view from a mobile device 
## search
# top$frfgs<-top[,26] # SEARCH : First referrer from Google??
# top$frfgvs<-top[,27]# SEARCH : First referrer from Google Video??
# top$frfys<-top[,30] # SEARCH : First referrer from YouTube search 
## social
# top$fvocp<-top[,33] # SOCIAL: First view on a channel page
# top$frfsm<-top[,25] # SOCIAL: First referrer from a subscriber??
## viral
# top$ov<-top[,34]    # VIRAL: Other / Viral
###############################################################################
#                        Replace NA by Interpolation                          #
###############################################################################
data<-na.approx(dat, method = "linear", na.rm = FALSE) # library(tseries)

#~~~~~~~~~~~~~~~~~~~~~~recode diffusion channels~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
top$external<-top$feo+top$fev+top$frf
top$featured<-top$fvfa+top$ffvv
top$internal<-top$frfy+top$frflv
top$mobile<-top$fvfmd

top$recommend<-top$external+top$featured+top$internal
top$search<-top$frfgs+top$frfgvs+top$frfys
top$social<-top$fvocp+top$frfsm #+top$ov
top$viral<-top$ov
#~~~~~~~~~~~~~~~~~~~~~~recode video categories~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
data.frame(table(top$category))
top$category[is.na(top$category)]<-0

top$copyright<-ifelse(top$category=="0", 1, 0)
top$sportsEtc<-ifelse(top$category=="Animals"
	|top$category=="Autos"
	|top$category=="Games"
	|top$category=="People"
	|top$category=="Sports"
	|top$category=="Travel",
	 1, 0)

top$movieEtc<-ifelse(top$category=="Comedy"
	|top$category=="Film"
	|top$category=="Movies"
	|top$category=="Music"
	|top$category=="Shows"
	|top$category=="Trailers",
	 1, 0)

top$edu<-ifelse(top$category=="Education", 1, 0)
top$entertainment<-ifelse(top$category=="Entertainment", 1, 0)
top$howto<-ifelse(top$category=="Howto", 1, 0)
top$ngo<-ifelse(top$category=="Nonprofit", 1, 0)
top$tech<-ifelse(top$category=="Tech", 1, 0)
top$news<-ifelse(top$category=="News", 1, 0)
table(top$copyright)

piec<-data.frame(table(top$category))
piec$Var1[piec$Var1=="0"]<-"Copyright_protected"
piec$Var1[is.na(piec$Var1)==TRUE]<-"Copyright_protected"

slices <- piec$Freq
lbls <- piec$Var1

pie(slices, labels = lbls, main="Pie Chart of Countries")
pie(slices,labels = lbls, col=rainbow(length(lbls)),
  	 main="Pie Chart of Countries")
###############################################################################
#                                                                             #
#                     Origin of burst in Public Attention                     #
#                                                                             #
###############################################################################
## Distribution of burst
hist(top$peak,freq = F, breaks=50, xlab= "Peak Fraction", ylab= "Probability (%)", main='')
# to save Tiff with dpi 2000
tiff("d:/burst.tif", 
	width=5, height=5, 
	units="in", res=500,
	compression = "lzw") #c("none", "rle", "lzw", "jpeg", "zip")
# stop saving figure
dev.off()


library(QuantPsyc)
library(car)
# top<-subset(top, top$social!=0&top$search!=0&top$recommend!=0) # the problem of too many zeros!!!!

## regression of burst 1
regb1<-lm(log(top$peak)~log(top$DAYS) 
	+log(top$TOTAL_VIEW+1)+log(top$TOTAL_COMM+1)+log(top$TOTAL_FAVS+1)+log(top$TOTAL_RATS+1)
      +log(top$recommend+1)+log(top$search+1) + log(top$social+1)
	+top$copyright+top$sportsEtc+top$movieEtc+top$edu+top$entertainment+top$howto+top$ngo+top$tech) # baseline is top$news
summary(regb1)
as.data.frame(lm.beta(regb1)) 
vif(regb1)

## regression of burst 1
regb1<-lm(log(top$peak)~log(top$DAYS) 
	+log(top$TOTAL_VIEW+1)
      +log(top$recommend+1)+log(top$search+1) + log(top$social+1)
	+top$copyright+top$sportsEtc+top$movieEtc+top$edu+top$entertainment+top$howto+top$ngo+top$tech) # baseline is top$news
summary(regb1)
as.data.frame(lm.beta(regb1)) 
vif(regb1)

## regression of burst 3
regb1.1<-lm(log(top$peak)~log(top$DAYS) +log(top$TOTAL_VIEW+1)
	 +log(top$TOTAL_COMM+1)
	 +log(top$TOTAL_RATS+1)
	+log(top$TOTAL_FAVS+1)
      + log(top$social+1)
	+log(top$recommend+1)+log(top$search+1) # +log(top$ov+1)
	+top$copyright+top$sportsEtc+top$movieEtc+top$edu+top$entertainment+top$howto+top$ngo+top$tech) # baseline is top$news
summary(regb1.1)
as.data.frame(lm.beta(regb1.1)) 
vif(regb1.1)


library(lmSupport)# install.packages("lmSupport")
lm.sumSquares ( regb1 )
library(relaimpo)# install.packages("relaimpo")
 regb1r<-calc.relimp.lm(log(top$peak)~log(top$DAYS) 
	+log(top$TOTAL_VIEW+1)+log(top$TOTAL_COMM+1)+log(top$TOTAL_FAVS+1)+log(top$TOTAL_RATS+1)
      +log(top$recommend+1)+log(top$search+1) + log(top$social+1)
	+top$copyright+top$sportsEtc+top$movieEtc+top$edu+top$entertainment+top$howto+top$ngo+top$tech) # baseline is top$news

## regression of burst 2
regb2<-lm(log(top$peak)~ log(top$DAYS) 
	+log(top$TOTAL_VIEW+1)+log(top$TOTAL_COMM+1)+log(top$TOTAL_FAVS+1)+log(top$TOTAL_RATS+1)
	+log(top$external+1)+ log(top$featured+1) 
	+log(top$internal+1) + log(top$mobile+1) +log(top$search+1)
	+ log(top$social+1) + log(top$viral+1) 
	+top$copyright+top$sportsEtc+top$movieEtc+top$edu+top$entertainment+top$howto+top$ngo+top$tech) # baseline is top$news
summary(regb2)
as.data.frame(lm.beta(regb2)) # library(QuantPsyc)
vif(regb2)
####################################################################################
#
#                       scaling relationship
#
####################################################################################
regcv<-lm(log(top$TOTAL_COMM+1)~log(top$TOTAL_VIEW+1))
regfv<-lm(log(top$TOTAL_FAVS+1)~log(top$TOTAL_VIEW+1))
regrv<-lm(log(top$TOTAL_RATS+1)~log(top$TOTAL_VIEW+1))



#get the coefficients and draw the line 
coc<-coef(lm(log(top$TOTAL_COMM+1)~log(top$TOTAL_VIEW+1))) 
#get the coefficients and draw the line 
cof<-coef(lm(log(top$TOTAL_FAVS+1)~log(top$TOTAL_VIEW+1))) 
x<-seq(from=min(log(top$TOTAL_VIEW+1)),to=max(log(top$TOTAL_VIEW+1)), length=100) 
yf<-(cof[2]*x)+cof[1] 
#get the coefficients and draw the line 
cor<-coef(lm(log(top$TOTAL_RATS+1)~log(top$TOTAL_VIEW+1))) 
yr<-(cor[2]*x)+cor[1] 

summary(regcv)[[9]];summary(regfv)[[9]];summary(regrv)[[9]];coc[[2]];cof[[2]];cor[[2]]
[1] 0.5087839
[1] 0.7141166
[1] 0.6239208

[1] 0.6831629
[1] 0.8300731
[1] 0.794341
plot(log(top$TOTAL_COMM)~log(top$TOTAL_VIEW), pch=3, col="blue", xlab="Views (LOG)", ylab="Activities (LOG)")
points(log(top$TOTAL_FAVS)~log(top$TOTAL_VIEW), pch=2, col="red")
points(log(top$TOTAL_RATS)~log(top$TOTAL_VIEW), pch=4, col="purple")

abline(regcv, lty=1,lwd=2,  pch=0)
lines(x,yf, lty=3, lwd=2)
lines(x,yr,lty=5, lwd=2)

legend("topleft", c("Comments  R Square=0.51 b=0.68", "Favorites     R Square=0.71 b=0.83", "Ratings        R Square=0.62 b=0.79"),
	col = c( "blue","red",  "purple"),
	cex=0.9, pch= c(3, 2,4) , lty=c(1, 3, 5))


## to save Tiff with dpi 2000
tiff("d:/scaling_views.tif", 
	width=7, height=6, 
	units="in", res=500,
	compression = "lzw") #c("none", "rle", "lzw", "jpeg", "zip")
png("d:/rank-order-popularity.png", 
	width=5, height=4, 
	units="in", res=700)

dev.off()
############################################################################
#~~~~~~~~~~~~~~regression of recommendation, search, and social~~~~~~~~~~~~#
############################################################################
# views
regv<-lm(log(top$TOTAL_VIEW+1)~ log(top$DAYS)+ log(top$recommend+1)
	+log(top$search+1) + log(top$social+1)+top$peak)
summary(regv)
as.data.frame(lm.beta(regv)) # library(QuantPsyc)
vif(regv)
# comment
regc<-lm(log(top$TOTAL_COMM+1)~ log(top$DAYS)+ log(top$recommend+1)
	+log(top$search+1) + log(top$social+1)+top$peak)
summary(regc)
as.data.frame(lm.beta(regc)) # library(QuantPsyc)
vif(regc)
# favorite
regf<-lm(log(top$TOTAL_FAVS+1)~ log(top$DAYS)+ log(top$recommend+1)
	+log(top$search+1) + log(top$social+1)+top$peak)
summary(regf)
as.data.frame(lm.beta(regf)) # library(QuantPsyc)
vif(regf)
# ratings
regr<-lm(log(top$TOTAL_RATS+1)~ log(top$DAYS)+ log(top$recommend+1)
	+log(top$search+1) + log(top$social+1)+top$peak)
summary(regr)
as.data.frame(lm.beta(regr)) # library(QuantPsyc)
vif(regr)
# lifetime
regl<-lm(log(top$DAYS)~log(top$recommend+1)
	+log(top$search+1) + log(top$social+1)+log(top$peak) )
summary(regl)
as.data.frame(lm.beta(regl)) # library(QuantPsyc)
vif(regl)
#~~~~~~~~~~~Plot the distribution using log scale on both axes (1)~~~~~~~~~~~~~~~~~~~~#
> dim(subset(top, top$DAYS<10))
[1] 3530   40
> dim(subset(top, top$DAYS<9))
[1] 3056   40
> dim(subset(top, top$DAYS<8))
[1] 2524   40
> dim(subset(top, top$DAYS<7))
[1] 2128   40
vh <- hist((top$TOTAL_VIEW), plot=F, breaks=1000000)
c <- hist(top$TOTAL_COMM, plot=F, breaks=1000)
f <- hist(top$TOTAL_FAVS, plot=F, breaks=1000)
r <- hist(top$TOTAL_RATS, plot=F, breaks=1000)
d <- hist(log(top$DAYS), plot=F, breaks=1000)
# par(mfrow=c(2,3))
plot(vh$density, log="xy", type='h', lwd=10, lend=2)

plot((vh$density), log="xy", pch=20, col="blue", 
    main=" ", lty=1, #pch=1,
    xlab="Total Views", ylab="Probability") 

vt<-as.data.frame(table(top$TOTAL_VIEW))
names(vt)<-c("var", "freq")

plot(vt$freq~vt$

points(c$density, log="xy", pch=20, col="blue", 
    main=" ", type='p',pch=2, # col='red',# lty=2, 
    xlab="Total Comments", ylab="Probability") 

lines(f$density, log="xy", pch=20, col="blue", 
    main=" ", lty=3,
    xlab="Total Favorites", ylab="Probability") 
lines(r$density, log="xy", pch=20, col="blue", 
    main=" ", lty=4,
    xlab="Total Rates", ylab="Probability") 
lines(d$density, log="y", pch=20, col="blue", 
    main=" ", lty=5, 
    xlab="Lifetime", ylab="Probability") 
par(mfrow=c(1,1))
hist(top$peak, freq = F, breaks=40, ylim = range(0,3.5),
   xlab='Peak Fraction', main = paste("Histogram of" , 'Peak Fraction'))
#~~~~~~~~~~~Plot the distribution using log scale on both axes (2)~~~~~~~~~~~~~~~~~~~~~#
v<-as.data.frame(table(top$TOTAL_VIEW))
names(v)<-c("var", "freq")
# v$rank<-rank(1/v$freq , ties.method = "random" )
v$rank<-rank((as.numeric(as.character(v$var))), ties.method = "random" )


c<-as.data.frame(table(top$TOTAL_COMM))
names(c)<-c("var", "freq")
# c$rank<-rank(1/c$freq , ties.method = "random" )
c$rank<-rank((as.numeric(as.character(c$var))), ties.method = "random" )

f<-as.data.frame(table(top$TOTAL_FAVS))
names(f)<-c("var", "freq")
# f$rank<-rank(1/f$freq , ties.method = "random" )
f$rank<-rank((as.numeric(as.character(f$var))), ties.method = "random" )

r<-as.data.frame(table(top$TOTAL_RATS))
names(r)<-c("var", "freq")
# r$rank<-rank(1/r$freq , ties.method = "random" )
r$rank<-rank((as.numeric(as.character(r$var))), ties.method = "random" )

d<-as.data.frame(table(top$DAYS))
names(d)<-c("var", "freq")
# d$rank<-rank(1/d$freq , ties.method = "random" )
d$rank<-rank((as.numeric(as.character(d$var))), ties.method = "random" )

#~~~~~~~~~~~~~~~~~plot rank-ordered distribution~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
plot((c$freq)~(c$rank), log = "xy", type='b',pch=2, col='green', lty=1, ylim=c(1, 2000), xlim=c(1, 20000), 
	xlab= 'Rank', ylab="Freqency")
points((v$rank),(v$freq), type='b',pch=0, col='purple', lty=1)   # views is not long tail
points((f$freq)~(f$rank), type='b',pch=3, col='blue', lty=1)   # favorites
points((r$freq)~(r$rank), type='b',pch=4, col='yellow', lty=1) # rating
points((d$freq)~(d$rank), type='b',pch=17, col='red', lty=1)    # lifetime
# add a legend 
legend(500, 1000, c("Lifetime", "Ratings", "Favorites", "Comments", "Views"),
	col = c("red", "yellow", "blue", "green", "purple"),
	cex=0.9,pch= c(17, 4, 3, 2, 0 ) , lty=1)


## to save Tiff with dpi 2000
tiff("d:/rank-ordered-popularity.tif", 
	width=5, height=4, 
	units="in", res=700,
	compression = "lzw") #c("none", "rle", "lzw", "jpeg", "zip")
png("d:/rank-order-popularity.png", 
	width=5, height=4, 
	units="in", res=700)

dev.off()
#~~~~~~~~~~~~~~~~~plot popularity distribution~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
plot((d$freq)/sum(d$freq)~(as.numeric(as.character(d$var))+1),log = "xy", type='b',pch=17, col='red', lty=1, xlim=c(1, 100000000), 
	xlab= 'Popularity', ylab="Probability")# lifetime
points((c$freq)/sum(c$freq)~(as.numeric(as.character(c$var))), type='b',pch=2, col='green', lty=1)    # comment
points((v$freq)/sum(v$freq)~(as.numeric(as.character(v$var))+1), type='b',pch=0, col='purple', lty=1)   # views is not long tail
points((f$freq)/sum(f$freq)~(as.numeric(as.character(f$var))+1), type='b',pch=3, col='blue', lty=1)   # favorites
points((r$freq)/sum(r$freq)~(as.numeric(as.character(r$var))+1), type='b',pch=4, col='yellow', lty=1) # rating
# add a legend 
legend(100000, 0.01, c("Lifetime", "Favorites", "Comments","Ratings", "Views"),
	col = c("red",  "blue", "green","yellow", "purple"),
	cex=0.9,pch= c(17,  3, 2,4, 0 ) , lty=1)


## to save Tiff with dpi 2000
tiff("d:/popularity_distribution.tif", 
	width=5, height=4, 
	units="in", res=700,
	compression = "lzw") #c("none", "rle", "lzw", "jpeg", "zip")
png("d:/popularity_distribution.png", 
	width=5, height=4, 
	units="in", res=700)

dev.off()

#~~~~~~~~~~~~~~~~~plot popularity distribution with log~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
vl<-as.data.frame(table(log(top$TOTAL_VIEW+0.000001)))
names(vl)<-c("var", "freq")

cl<-as.data.frame(table(log(top$TOTAL_COMM+0.000001)))
names(cl)<-c("var", "freq")

fl<-as.data.frame(table(log(top$TOTAL_FAVS+0.000001)))
names(fl)<-c("var", "freq")

rl<-as.data.frame(table(log(top$TOTAL_RATS+0.000001)))
names(rl)<-c("var", "freq")

dl<-as.data.frame(table(log(top$DAYS+0.000001)))
names(dl)<-c("var", "freq")


plot((dl$freq)/sum(dl$freq)~(as.numeric(as.character(dl$var))), type='b',pch=17, col='red', lty=1, xlim=c(1, 5000), 
	xlab= 'Popularity', ylab="Probability")# lifetime
points((cl$freq)/sum(cl$freq)~(as.numeric(as.character(c$var))), type='b',pch=2, col='green', lty=1)    # comment
points((vl$freq)/sum(vl$freq)~(as.numeric(as.character(v$var))+1), type='b',pch=0, col='purple', lty=1)   # views is not long tail
points((fl$freq)/sum(fl$freq)~(as.numeric(as.character(f$var))+1), type='b',pch=3, col='blue', lty=1)   # favorites
points((rl$freq)/sum(rl$freq)~(as.numeric(as.character(r$var))+1), type='b',pch=4, col='yellow', lty=1) # rating
# add a legend 
legend(100000, 0.01, c("Lifetime", "Favorites", "Comments","Ratings", "Views"),
	col = c("red",  "blue", "green","yellow", "purple"),
	cex=0.9,pch= c(17,  3, 2,4, 0 ) , lty=1)


## to save Tiff with dpi 2000
tiff("d:/popularity_distribution.tif", 
	width=5, height=4, 
	units="in", res=700,
	compression = "lzw") #c("none", "rle", "lzw", "jpeg", "zip")
png("d:/popularity_distribution.png", 
	width=5, height=4, 
	units="in", res=700)

dev.off()


####################################################################################################


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~the myth of lifetime~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
plot(log(top$peak/top$DAYS)~log(top$DAYS) )
regpt<-lm(log(top$peak/top$DAYS)~log(top$DAYS) )
summary(regpt)
# see mathematica

#~~~~~~~~~~~~~Plot Non-linear Plot for Linear Regression in R~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
http://www.apsnet.org/EDCENTER/ADVANCED/TOPICS/ECOLOGYANDEPIDEMIOLOGYINR/DISEASEPROGRESS/Pages/NonlinearRegression.aspx

# 1. coeficient of nonlinear regression
co=coef(lm(log(top$peak)~log(top$DAYS)+log(top$recommend+1)
	+log(top$search+1) + log(top$social+1))) 

## to save Tiff with dpi 2000
tiff("d:/test5.tif", 
	width=5, height=5, 
	units="in", res=1200,
	compression = "lzw") #c("none", "rle", "lzw", "jpeg", "zip")


# 2. scatter plot
plot(
      (top$social),
	(top$peak),
	type='p',col='grey',
	xlab="Social Influence", ylab="Peak Fraction", 
      pch=0, 
	main=""
	)

text(0.4, 9, "R Square = 0.84")

# 4. plot the fitted curve
curve(
	exp(co[[1]]+co[[2]]*mean(log(top$DAYS))
	+co[[3]]*(mean(log(top$recommend+1)))
	+co[[4]]*(mean(log(top$search+1)))
	+co[[5]]*log(x+1)   ),
       from=min((top$social)),
       to=max((top$social)),
       add=TRUE,
       col='red'
)

# stop saving figure
dev.off()
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~regression~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# views
regv<-lm(log(top$TOTAL_VIEW+1)~ log(top$DAYS)+ log(top$external+1)+ log(top$featured+1)+ 
	log(top$internal+1) + log(top$mobile+1) +log(top$search+1) + log(top$social+1) + log(top$viral+1) )
summary(regv)
as.data.frame(lm.beta(regv)) # library(QuantPsyc)
# comment
regc<-lm(log(top$TOTAL_COMM+1)~ log(top$DAYS)+ log(top$external+1)+ log(top$featured+1)+ 
	log(top$internal+1) + log(top$mobile+1) +log(top$search+1) + log(top$social+1) + log(top$viral+1) )
summary(regc)
as.data.frame(lm.beta(regc)) # library(QuantPsyc)
# favorite
regf<-lm(log(top$TOTAL_FAVS+1)~ log(top$DAYS)+ log(top$external+1)+ log(top$featured+1)+ 
	log(top$internal+1) + log(top$mobile+1) +log(top$search+1) + log(top$social+1) + log(top$viral+1) )
summary(regf)
as.data.frame(lm.beta(regf)) # library(QuantPsyc)
# ratings
regr<-lm(log(top$TOTAL_RATS+1)~ log(top$DAYS)+ log(top$external+1)+ log(top$featured+1)+ 
	log(top$internal+1) + log(top$mobile+1) +log(top$search+1) + log(top$social+1) + log(top$viral+1) )
summary(regr)
as.data.frame(lm.beta(regr)) # library(QuantPsyc)
#~~~~~~~~~~~~~~~~~~~~~~Introduction~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# dim(top) 17127 18
data.frame(names(top))
# ID: The id of the video. This is a basic Youtube id with 11 characters, for example: abc_12g4567
# DAYS: The number of days of information available for the video.
# UPLOAD_DATE: The date the video was uploaded (in seconds since Jan 1 1970)
# FIRST_DATE: The initial date where any information was available, this will always be UPLOAD_DATE - 1
# LAST_DATE: The final date where any information was available, this can be also be viewed as the date which we collected the video
#:)# head((top$LAST_DATE-top$UPLOAD_DATE)/86400)== head(top$DAYS-1)
# TOTAL_VIEW: Total amount of views
# TOTAL_COMM: Total amount of comments
# TOTAL_FAVS: Total amount of favorites
# TOTAL_RATS: Total amount of ratings
# TOTAL_AVGR: Average rating of the video (we collected videos befor Youtube is like/dislike, when ratings were starts)
# VIEW_DATA: An array of the cumulative number of views, this will begin with 0 and end in TOTAL_VIEW
# COMM_DATA: An array of the cumulative number of comments, this will begin with 0 and end in TOTAL_COMM
# FAVS_DATA: An array of the cumulative number of favorites, this will begin with 0 and end in TOTAL_FAVS
# RATS_DATA: An array of the cumulative number of ratings, this will begin with 0 and end in TOTAL_RATS
# AVGR_DATA: An array of the average rating per point, this will begin with 0 and end in TOTAL_AVGR
# EVENT_TYPES: An array of the different referrers types which lead users to videos. For example, First referral from Google search
# EVENT_DATES: An array of the dates of each of the referrers above
# EVENT_VIEWS: An array of the amount of views of each of the referrers above 
head(top$X.ID)
head(top$DAYS)
head(top$UPLOAD_DATE)
head(top$FIRST_DATE)
head(top$TOTAL_VIEW)
#~~~~~~~~~~~~~~~~~~endogenous_subcritical~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
topp<-subset(top, top$peak<=0.05)
summary(topp$DAYS)
summary(topp$TOTAL_VIEW)
hist(log(topp$TOTAL_VIEW/topp$DAYS), main='', breaks=30, xlab= 'Average Views  (Log)')
hist(log(topp$TOTAL_VIEW/topp$DAYS), main='', breaks=30, xlab= 'Average Views  (Log)')

par(mfrow=c(1,1))
plot(log(topp$peak/topp$DAYS)~log(topp$DAYS), col='grey', ylab='Peak Fraction Normalized by Lifetime (Log)', xlab='Lifetime  (Log)')
plot((topp$peak/topp$DAYS)~(topp$DAYS), col='grey', ylab='Peak Fraction Normalized by Lifetime', xlab='Lifetime')

 top$cat<-top$peak
 top$cat[top$cat>0.8]='red'
 top$cat[top$cat<=0.8&top$cat>0.2]='green'
 top$cat[top$cat<=0.2&top$cat>0.05]='yellow'
 top$cat[top$cat<=0.05]='blue'
plot(log(top$peak/top$DAYS)~log(top$DAYS), col=top$cat, ylab='Peak Fraction Normalized by Lifetime (Log)', xlab='Lifetime  (Log)')
plot((top$peak/top$DAYS)~(top$DAYS), col=top$cat, ylab='Peak Fraction Normalized by Lifetime', xlab='Lifetime')
plot((top$peak)~(top$DAYS), col=top$cat, ylab='Peak Fraction', xlab='Lifetime')
plot(log(top$peak)~log(top$DAYS), col=top$cat, ylab='Peak Fraction  (Log)', xlab='Lifetime (Log)')

#
plot((top$peak)~(top$DAYS), col=log(top$TOTAL_VIEW)/2, ylab='Peak Fraction', xlab='Lifetime')

plot(log(top$TOTAL_VIEW)~log(top$DAYS), xlab='Lifetime (Log)', ylab='Total Views (Log)', col=top$cat, main='')

plot(log(top$TOTAL_VIEW)~log(top$DAYS), xlab='Lifetime (Log)', ylab='Total Views (Log)', col=top$peak*7, main='')

#
plot(log(top$peak)~log(top$TOTAL_VIEW), col=top$cat, ylab='Peak Fraction Normalized by Lifetime (Log)', xlab='Lifetime  (Log)')
plot(log(top$peak/top$DAYS)~log(top$TOTAL_VIEW), col=top$cat, ylab='Peak Fraction Normalized by Lifetime (Log)', xlab='Lifetime  (Log)')


#~~~~~~~~~~~~~~~~~~~~~~~~~~~popularity of videos~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
layout(matrix(1:2,1,2))
layout(matrix(1:1,1,1))

# TOTAL_VIEW, TOTAL_COMM, TOTAL_FAVS, TOTAL_RATS
plot(log(top$TOTAL_VIEW)~log(top$TOTAL_COMM))
plot(log(top$TOTAL_VIEW)~log(top$TOTAL_FAVS))
plot(log(top$TOTAL_VIEW)~log(top$TOTAL_RATS))
plot(log(top$TOTAL_FAVS)~log(top$TOTAL_RATS))
pop<-data.frame(log(top$TOTAL_VIEW+1), log(top$TOTAL_COMM+1), log(top$TOTAL_FAVS+1), log(top$TOTAL_RATS+1) )
plot(pop)

cor(pop, use="complete.obs", method="kendall") 
cor(pop)
cov(pop)

library(corrgram)
corrgram(pop, order=TRUE, lower.panel=panel.pts, # panel.pts, panel.pie, panel.shade, panel.ellipse, panel.conf.
  upper.panel=panel.pie, text.panel=panel.txt,
  main=" ")

library(corrplot) # install.packages("corrplot")
names(pop)<-c("Views","Comments", "Favorites", "Ratings" )
popc <- cor(pop)
corrplot(popc, method = "pie",type = c("upper"), add = F)
corrplot(popc, method = "number",type = c("full"), add = T)

reg<-lm(pop[,1]~pop[,2]+pop[,3]+pop[,4] )
summary(reg)
#~~~~~~~~~~~~~~~~~~~~~~~~~~get the growth curve~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
topp<-subset(top, top$DAYS>=100) #  3549

findGrowth<-function(n){
       time <- 1:top$DAYS[n]
       # Tdelt <- (1:100) / 10
       nt=nchar(top$VIEW_DATA[n])
       growth=substring(top$VIEW_DATA[n], 2, nt-1)
       growth=paste(unlist(strsplit(growth,split=" ")), collapse="")
       cumGrowth=as.numeric(unlist(strsplit(growth, ",")))     
       # difGrowth <- diff(cumGrowth, lag = 1, differences = 1)
	 id=rep(top$X.ID[n], top$DAYS[n])
       growthLine<-data.frame(cbind(time, cumGrowth, as.character(id)))
       return(growthLine)}

gcc <- do.call(rbind, lapply(c(1:5),findGrowth))

as.data.frame(do.call(rbind, your_list))


gc <- do.call(rbind, lapply(c(1:length(top$X.ID)),findGrowth))
gc$cumGrowth<-as.numeric(levels(gc$cumGrowth)[gc$cumGrowth])
gc$time<-as.numeric(levels(gc$time)[gc$time])
write.csv(gc, "D:/Research/Youtube/TubeOverTime/top/dao/growthCurve.csv", row.names=F)

plot(as.numeric(levels(gc$cumGrowth)[gc$cumGrowth]), as.numeric(levels(gc$time)[gc$time]))
re<-lm(as.numeric(levels(gc$cumGrowth)[gc$cumGrowth])~as.numeric(levels(gc$time)[gc$time]))
summary(re)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~plot cdf~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
topf<-subset(top, top$M!=0)

topz<-subset(top, top$M==0)
zero<-data.frame(topz$DAYS, topz$M)

# the largest growth http://www.youtube.com/watch?v=_OBlgSz8sSM&feature=youtu.be
time <- if( top$DAYS[392] <= 100) 1:top$DAYS[392] else seq(1, top$DAYS[392],by= (top$DAYS[392]-1)/(100-1))
t=time/top$DAY[392]
nt=nchar(top$VIEW_DATA[392])
growth=substring(top$VIEW_DATA[392], 2, nt-1)
growth=paste(unlist(strsplit(growth,split=" ")), collapse="")

cumGrowth=as.numeric(unlist(strsplit(growth, ","))) 
cf=cumGrowth/max(cumGrowth)

difGrowth <- c(0, diff(cumGrowth, lag = 1, differences = 1)) 
df=difGrowth/max(cumGrowth)

peak=max(difGrowth)/max(cumGrowth)
dat = data.frame(t, difGrowth)
pt<-subset(dat$t, dat$difGrowth==max(difGrowth))


plot(pt,peak,col="blue",pch=20,xlab="time",ylab="normalized peak views", type='b', xlim=c(0, 1), ylim=c(0, 1)) 
# plot(t,cf,col="blue",pch=20,xlab="cumulative time",ylab="Growth Curve") 
# plot(t,df,col="red",pch=20,xlab="cumulative time",ylab="PDF", xlim=c(0, 1), ylim=c(0, 1)) 
# text(0.5, 1, 'Days < 10')

# plot(0 , 0,col="blue",pch=20,xlab="time",ylab="normalized peak views", type='b', xlim=c(0, 1), ylim=c(0, 0.2)) 
# text(0.5, 0.1, 'Peak Faction < 0.1')

# plot(time,cumGrowth,col="blue",pch=20,xlab="cumulative time",ylab="cumulative frequency") 

# only 100 cf 326 ct
# top1<-subset(top, top$DAYS > 0)  

# top1<-subset(top, top$peak < 0.2&top$peak > 0.1 )  
   top1<-subset(top, top$peak <  0.1 )  

plotGrowthCurves=function(n){
	 time <- if( top1$DAYS[n] <= 100) 1:top1$DAYS[n] else seq(1, top1$DAYS[n],by= (top1$DAYS[n]-1)/(100-1))
       t=time/top1$DAY[n]
       nt=nchar(top1$VIEW_DATA[n])
       growth=substring(top1$VIEW_DATA[n], 2, nt-1)
       growth=paste(unlist(strsplit(growth,split=" ")), collapse="")
       cumGrowth=as.numeric(unlist(strsplit(growth, ","))) 
       cf=cumGrowth/max(cumGrowth) 

	 difGrowth <- c(0, diff(cumGrowth, lag = 1, differences = 1)) 
	 df=difGrowth/max(cumGrowth)

	 peak=max(difGrowth)/max(cumGrowth)
	 dat = data.frame(t, difGrowth)
	 pt<-subset(dat$t, dat$difGrowth==max(difGrowth))[1]
       # return(pt)
       try(suppressWarnings(     
		# points( t, df, col=sample(c(1:151),1),pch=20, type='b')  ))  # b
       	points( pt,peak,col=sample(c(1:1000),1),pch=20, type='p') ))
}

sapply(list<-sample(c(1:length(top1$DAY)), 100), plotGrowthCurves)
sapply(c(1:length(top1$DAYS)),plotGrowthCurves)	# length(top$DAYS)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~threshold of time series~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
library(tsDyn)

# the largest growth http://www.youtube.com/watch?v=_OBlgSz8sSM&feature=youtu.be
time <- if( top$DAYS[392] <= 100) 1:top$DAYS[392] else seq(1, top$DAYS[392],by= (top$DAYS[392]-1)/(100-1))
t=time/top$DAY[392]
nt=nchar(top$VIEW_DATA[392])
growth=substring(top$VIEW_DATA[392], 2, nt-1)
growth=paste(unlist(strsplit(growth,split=" ")), collapse="")

cumGrowth=as.numeric(unlist(strsplit(growth, ","))) 
cf=cumGrowth/max(cumGrowth)

difGrowth <- c(0, diff(cumGrowth, lag = 1, differences = 1)) 
df=difGrowth/max(cumGrowth)

peak=max(difGrowth)/max(cumGrowth)
dat = data.frame(t, difGrowth)
pt<-subset(dat$t, dat$difGrowth==max(difGrowth))

summary(star(df, mTh=c(0,1), control=list(maxit=3000)))[0]

setarTest(df, m=1, thDelay = 0, nboot=10, trim=0.1, test=c("1vs", "2vs3"), hpc=c("none", "foreach"),check=T)

library(tseries)
terasvirta.test(as.ts(df), lag = 1, type = c("Chisq","F"),scale = TRUE)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bursts demise along time~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
plot(top$peak~top$DAYS, col='grey', ylab='Peak Fraction', xlab='Days')
par(mfrow=c(1,2))
plot(log(top$peak)~log(top$DAYS), col='grey', ylab='Peak Fraction  (Log)', xlab='Days  (Log)')
plot(log(top$peak)~log(top$TOTAL_VIEW), col='grey', ylab='Peak Fraction  (Log)', xlab='Total Views  (Log)')

par(mfrow=c(1,2))
plot(log(top$peak/top$DAYS)~log(top$DAYS), col='grey', ylab='Peak Fraction Normalized by Lifetime (Log)', xlab='Lifetime  (Log)')
plot((top$peak/top$DAYS)~(top$DAYS), col='grey', ylab='Peak Fraction Normalized by Lifetime', xlab='Lifetime')


smoothScatter(log(top$peak)~log(top$TOTAL_VIEW), col = densCols(top$peak), ylab='Peak Fraction', xlab='Total Views')
smoothScatter(log(top$peak)~log(top$DAYS), col = densCols(top$peak), ylab='Peak Fraction', xlab='Lifetime')

r<-lm(log(top$peak)~log(top$DAYS)+log(top$TOTAL_VIEW)+log(top$DAYS)*log(top$TOTAL_VIEW)) # +top$duration
summary(r)
library(car)
vif(r)

r<-lm(log(top$peak/top$DAYS)~log(top$DAYS)+log(top$TOTAL_VIEW)) # +top$duration
summary(r)
library(car)
vif(r)

p <- ggplot(top,
  aes(x=DAYS, y=peak, colour=log(TOTAL_VIEW)*2))
p + geom_point()

(d <- qplot(log(DAYS), log(peak), data=top, colour=log(TOTAL_VIEW)))

# Change scale label
d + scale_colour_gradient(limits=c(5, 10))


(d <- qplot(TOTAL_VIEW, peak, data=top, colour=log(DAYS)))
# Change scale label
d + scale_colour_gradient(limits=c(5, 10))

pg <- ggplot(top, aes(DAYS, peak)) + geom_point() +
    geom_smooth(method = "loess", se = FALSE) + xlab("Days") +
    ylab("Peak Fraction")
print(pg)

library(ggplot2)
p <- ggplot(top,aes(DAYS,peak))
   p + geom_point()
p + stat_bin2d(bins = 100)

p + stat_density2d(aes(DAYS,peak), geom="polygon") +
     coord_cartesian(xlim = c(0, 1),ylim=c(0,max(top$DAYS)))+
     scale_fill_continuous(high='red2',low='blue4')
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~fit growth curve~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
findGrowth<-function(n){
	 time <- if( top$DAYS[n] <= 100) 1:top$DAYS[n] else seq(1, top$DAYS[n],by= (top$DAYS[n]-1)/(100-1))
       nt=nchar(top$VIEW_DATA[n])
       growth=substring(top$VIEW_DATA[n], 2, nt-1)
       growth=paste(unlist(strsplit(growth,split=" ")), collapse="")
       cumGrowth=as.numeric(unlist(strsplit(growth, ",")))     
       # difGrowth <- c(0, diff(cumGrowth, lag = 1, differences = 1))
	 out=try(suppressWarnings(
	 nls(cumGrowth ~ (M *  (1-exp(-(P+Q) * time) ) /(1+(Q/P)*exp(-(P+Q)*time))),
                   control = nls.control(maxiter = 1000, tol = 1e-05, minFactor = 1/4096,printEval = FALSE, warnOnly = FALSE),
                   start = list(M= max(cumGrowth), P=0.03, Q=0.38))
	  ),  silent=T)
	  if (class(out)=="try-error"){return(c(0,0,0))}
	  else {
	  coeffs=as.data.frame(coef(out))[,1]
	  # rsquare=cor(cumGrowth,(coeffs[1]*(1-exp(-(coeffs[2]+coeffs[3])*time) )/(1+(coeffs[1]/coeffs[2])*exp(-(coeffs[2]+coeffs[3])*time))))^2
	  # n= length(cumGrowth)
	  # adjustedRsquare=1-(1-rsquare)*(n-1)/(n-2) 
	  coees=(c(coeffs)) # ,n, adjustedRsquare))
	return(coees)}  }

bass <- data.frame(do.call(rbind, lapply(c(1:length(top$X.ID)),findGrowth)))  # length(top$X.ID)

test <- data.frame(do.call(rbind, lapply(c(1:10),findGrowth)))  # length(top$X.ID)
n=6
time <- if( top$DAYS[n] <= 100) 1:top$DAYS[n] else seq(1, top$DAYS[n],by= (top$DAYS[n]-1)/(100-1))
       nt=nchar(top$VIEW_DATA[n])
       growth=substring(top$VIEW_DATA[n], 2, nt-1)
       growth=paste(unlist(strsplit(growth,split=" ")), collapse="")
       cumGrowth=as.numeric(unlist(strsplit(growth, ",")))     
       difGrowth <- c(0,diff(cumGrowth, lag = 1, differences = 1))

 nls(cumGrowth ~ (M *  (1-exp(-(P+Q) * time) ) /(1+(Q/P)*exp(-(P+Q)*time))),
                   control = nls.control(maxiter = 100, tol = 1e-05, minFactor = 1/4096e1000,printEval = F, warnOnly = F),
                   start = list(M= max(cumGrowth), P=0.003, Q=0.38), trace=F)  # plinear, alg = "port"

# http://en.wikipedia.org/wiki/Shifted_Gompertz_distribution
 nls(cumGrowth ~ (M *  (1-exp(-B * time) )*exp(-N*exp(-B*time))),
                   control = nls.control(maxiter = 1000, tol = 1e-05, minFactor = 1/4096e1000,printEval = F, warnOnly = F),
                   start = list(M= max(cumGrowth), B=0.003, N=0.001), trace=F)  # plinear, alg = "port"


## Initial values are in fact the converged values
Run<-rep(1, length(time))
dat<-data.frame(Run, time, difGrowth)

Asym <- 4.5; b2 <- 2.3; b3 <- 0.7
SSgompertz(log(DNase.1$conc), Asym, b2, b3) # response and gradient
h<-getInitial(difGrowth ~ SSgompertz(time, Asym, b2, b3), data = dat)

fm2 <- nls(data$difGrowth ~ SSgompertz(log(conc), Asym, b2, b3),
           data = dat)
summary(fm2)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
Chick.1 <- ChickWeight[ChickWeight$Chick == 1, ]
Asym <- 368; xmid <- 14; scal <- 6
g<-getInitial(weight ~ SSlogis(Time, Asym, xmid, scal), data = Chick.1)
## Initial values are in fact the converged values
fm2 <- nls(weight ~ SSlogis(Time, Asym, xmid, scal), data = Chick.1)
summary(fm2)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

# http://en.wikipedia.org/wiki/Logistic_distribution
 nls(cumGrowth ~ (M ) /(1+exp(-(time-U)/S)),
                   control = nls.control(maxiter = 1000, tol = 1e-05, minFactor = 1/4096e1000,printEval = F, warnOnly = F),
                   start = list(M= max(cumGrowth), U=2.7, S=0.1), trace=F)  # plinear, alg = "port"




fm1DNase1 <- nls(cumGrowth ~ (M *  (1-exp(-(P+Q) * time) ) /(1+(Q/P)*exp(-(P+Q)*time))), dat)

summary(fm1DNase1)



names(bass)<-c('M', 'P', 'Q', 'n')
top$M<-bass$M
top$P<-bass$P
top$Q<-bass$Q
write.csv(top, "D:/Research/Youtube/TubeOverTime/top/dao/topcat.csv", row.names=F)

dim(subset(bass, bass$M!=0))

plot((top$P), (top$Q), xlab='Innovation', ylab='Imitation', col='green')
plot(bass)
plot(top$TOTAL_VIEW, top$M, col='purple', xlab='Total Views', ylab='Total Views Predicted by Bass Model') 
text(1.0e+08, 6e+07,"8433 Correctly Predicted Values")
text(1.3e+08, 1e+07,"6545 Incorrectly Predicted Values")

# dim(subset(top, top$M==0))  # [1] 5275   40
# out<-nls(difGrowth ~ M * ( ((P+Q)^2 / P) * exp(-(P+Q) * time) ) /(1+(Q/P)*exp(-(P+Q)*time))^2,
#   	  control = nls.control(maxiter = 10000, tol = 1e-05, minFactor = 1/1000000000,printEval = FALSE, warnOnly = FALSE),
#  	  start = list(M= max(difGrowth), P=0.03, Q=0.38))

install.packages('nlstools')
library(nlstools)
data(growthcurve4) 
#~~~~~~~~~~~~~~identify insufficient growth curve~~~~~~~~~~~~~~~~~~~~~~~~~~#
summary(topf$M-topf$TOTAL_VIEW)

#---------cluster analysis:Hierarchical Agglomerative----------------------#

tc3=topf[1:100, 38:40] 

tc3<- na.omit(tc3) # listwise deletion of missing
tc4 <- scale(tc3) # standardize variables 

# Ward Hierarchical Clustering
d <- dist(tc4, method = "euclidean") # distance matrix
fit <- hclust(d, method="ward")
plot(fit,xlab="Video IDs",ylab="Ward's similarity") # display dendogram
groups <- cutree(fit, k=3) # cut tree into 3 clusters
# draw dendogram with red borders around the 3 clusters
rect.hclust(fit, k=3, border="red") 

#~~~~~~~~addTheoreticalCDFs~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
ids=subset(cbind(c(1:110),tc)[,1],cbind(c(1:110),tc)[,2]!=0)
clusterIds=cbind(ids,groups)

addTheoreticalCDFs=function(n){
	if (tc[n,1]!=0){
	t1=subset(t[,1:3],t[,1]==n)
	ct=t1[,3]/max(t1[,3])
	cf=t1[,2]/max(t1[,2])
	c=sample(c(1:151),1)
	points( ct,cf,col=c,pch=20)
      lines( ct,tc[n,2]/(tc[n,2]+1/(exp(tc[n,1]*ct))),col=c)
	}
}

ids1=subset(clusterIds[,1],clusterIds[,2]==1)
ids2=subset(clusterIds[,1],clusterIds[,2]==2)
ids3=subset(clusterIds[,1],clusterIds[,2]==3)

t1=subset(t[,1:3],t[,1]==1)
ct=t1[,3]/max(t1[,3])
cf=t1[,2]/max(t1[,2])
plot(ct,cf,col="blue",pch=20,xlab="cumulative time",
ylab="cumulative frequency",type="n",main="type1")
sapply(ids1,addTheoreticalCDFs)
plot(ct,cf,col="blue",pch=20,xlab="cumulative time",
ylab="cumulative frequency",type="n",main="type2")
sapply(ids2,addTheoreticalCDFs)
plot(ct,cf,col="blue",pch=20,xlab="cumulative time",
ylab="cumulative frequency",type="n",main="type2")
sapply(ids3,addTheoreticalCDFs)

#~~~~~~~~~Information Chanell: Referer analysis~~~~~~~~~~~~~~~~~~~~~~~~#
head(top$EVENT_TYPES)
# EXTERNAL
# First embedded view
# First embedded on 
# First referrer from
# FEATURED
# First view from ad
# First featured video view
# INTERNAL
# First referrer from YouTube
# First referrer from Related Video
# MOBILE 
# First view from a mobile device 
# SEARCH
# First referrer from Google
# First referrer from YouTube search 
# First referrer from Google Video
# SOCIAL
# First referrer from a subscriber
# First view on a channel page
# VIRAL 
# Other / Viral

getUniqueType<-function(n){
       # clean the referer type
       nt=nchar(top$EVENT_TYPES[n])
       type=substring(top$EVENT_TYPES[n], 2, nt-1)
       type=paste(unlist(strsplit(type,split=" ")), collapse="")
       type=unlist(strsplit(type, ","))
       return(type)
       }

unique(unlist(as.list(sapply(c(1:length(top[,1])),getUniqueType))))

 [1] "'Firstfeaturedvideoview'"             "'Firstviewonachannelpage'"            "'FirstreferralfromYouTube'"          
 [4] "'Firstreferralfromasubscribermodule'" "'Firstembeddedon'"                    "'Firstviewfromamobiledevice'"        
 [7] "'Other/Viral'"                        "'Firstreferralfrom'"                  "'Firstreferralfromrelatedvideo'"     
[10] "'FirstreferralfromYouTubesearch'"     "'Firstembeddedview'"                  "'FirstreferralfromGooglesearch'"     
[13] "'Firstviewfromad'"                    "'FirstreferralfromGoogleVideosearch'"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
getReferer<-function(n){
       # clean the referer type
       nt=nchar(top$EVENT_TYPES[n])
       type=substring(top$EVENT_TYPES[n], 2, nt-1)
       type=paste(unlist(strsplit(type,split=" ")), collapse="")
       type=unlist(strsplit(type, ","))
       # clean the view count
       nv=nchar(top$EVENT_VIEWS[n])
       view=substring(top$EVENT_VIEWS[n], 2, nv-1)
       view=as.numeric(unlist(strsplit(view, ",")))
       # aggregate the duplicate rows
       data=data.frame(type, view)
       data<-aggregate(view, list(type),  sum)
       names(data)<-c('type','view')
       rownames(data)<- data$type
       # merge by rownames
       type<-c("'Firstfeaturedvideoview'" ,  "'Firstviewonachannelpage'" ,"'FirstreferralfromYouTube'" ,         
               "'Firstreferralfromasubscribermodule'","'Firstembeddedon'" , "'Firstviewfromamobiledevice'" ,       
               "'Other/Viral'"  , "'Firstreferralfrom'"  , "'Firstreferralfromrelatedvideo'" ,   
               "'FirstreferralfromYouTubesearch'", "'Firstembeddedview'" , "'FirstreferralfromGooglesearch'",     
               "'Firstviewfromad'" , "'FirstreferralfromGoogleVideosearch'")
       view<-c(0,0,0,0,0,0,0,0,0,0,0,0,0,0)
       dat=data.frame(type,view)
       rownames(dat)<-dat$type     
       fast <- merge(dat, data,  all=T)  
       # aggregate to get the target    
       target<-aggregate(fast$view, list(fast$type),  sum)
       names(target)<-c('type','view')
       return(target)
       }
lapply(c(1), getReferer)
referer<-data.frame(sapply(c(1:length(top[,1])), getReferer))
referer<-as.data.frame(t(as.matrix(referer)))
rownames(referer)<-NULL
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
unList<-function(n){
        l<-unlist(referer$view[n])
        return(l)
        }
test<-sapply(c(1:length(referer$view)), unList)
res<-as.data.frame(t(as.matrix(test)))
top<-data.frame(top, res)
# head(top[,19:32])
write.csv(top, "D:/Micro-blog/Youtube/TubeOverTime/top/dao/top.csv")
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# plot
pie(data$view,labels = data$type)
plot(top[,19:32])
cov(top[,19:32])

view<-top$TOTAL_VIEW/top$DAYS
plot(log(view), log(top[,19]/top$DAYS))
plot(view, top[,20]/top$DAYS)
plot(view, top[,21]/top$DAYS)
plot(view, top[,22]/top$DAYS)
plot(view, top[,23]/top$DAYS)


plot(log(top[,21]/top$DAYS),log(top$TOTAL_VIEW),xlab="First embedded on")
layout(matrix(1:1,1,1))
plot(log(top[,23]/top$DAYS),log(view),xlab="First referal from a subscriber module")

#~~~~~~~~~~~~~~~~~~~~~~regression~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
reg<-lm(view/top$DAYS~feo+fev+ffvv+frf+frfsm+frfgs+frfgvs+frflv+frfy+frfys+fvfa+fvfmd+fvocp+ov)
summary(reg)
library(QuantPsyc)# install.packages("QuantPsyc") # output standard coefficient
as.data.frame(lm.beta(reg))

# calcuate the standard regression coefficient
b.x<-coef(reg)[2]
sd.y<-sd(view/top$DAYS)
sd.x<-sd(feo)
beta.x<-b.x*sd.x/sd.y

# model diagnosis
layout(matrix(1:4,2,2))
plot(reg)

feo<-top[,21]/top$DAYS
fev<-top[,22]/top$DAYS
ffvv<-top[,23]/top$DAYS
frf<-top[,24]/top$DAYS
frfsm<-top[,25]/top$DAYS
frfgs<-top[,26]/top$DAYS
frfgvs<-top[,27]/top$DAYS
frflv<-top[,28]/top$DAYS
frfy<-top[,29]/top$DAYS
frfys<-top[,30]/top$DAYS
fvfa<-top[,31]/top$DAYS
fvfmd<-top[,32]/top$DAYS
fvocp<-top[,33]/top$DAYS
ov<-top[,34]/top$DAYS

# output standard coefficient
library(QuantPsyc)# install.packages("QuantPsyc")
as.data.frame(lm.beta(reg))

#~~~~~~~~~~~~~~~~~~~~~popularity of comment~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
comment<-top$TOTAL_COMM
regc<-lm((comment/top$DAYS)~(feo)+(fev)+(ffvv)+(frf)+(frfsm)+(frfgs)+(frfgvs)+(frflv)+(frfy)+(frfys)+(fvfa)+(fvfmd)+(fvocp)+(ov))
summary(regc)
as.data.frame(lm.beta(regc))


# as.data.frame((as.data.frame(lapply(c(1), getReferer)))[,1])
# 1                               'Firstembeddedon'
# 2                             'Firstembeddedview'
# 3                        'Firstfeaturedvideoview'
# 4                             'Firstreferralfrom'
# 5            'Firstreferralfromasubscribermodule'
# 6                 'FirstreferralfromGooglesearch'
# 7            'FirstreferralfromGoogleVideosearch'
# 8                 'Firstreferralfromrelatedvideo'
# 9                      'FirstreferralfromYouTube'
# 10               'FirstreferralfromYouTubesearch'
# 11                              'Firstviewfromad'
# 12                   'Firstviewfromamobiledevice'
# 13                      'Firstviewonachannelpage'
# 14                                  'Other/Viral'
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
favs<-top$TOTAL_FAVS
regf<-lm((favs/top$DAYS)~(feo)+(fev)+(ffvv)+(frf)+(frfsm)+(frfgs)+(frfgvs)+(frflv)+(frfy)+(frfys)+(fvfa)+(fvfmd)+(fvocp)+(ov))
summary(regf)
as.data.frame(lm.beta(regf))

value<-mean(top[,19:32])
category<-c('Firstembeddedon' , 'Firstembeddedview', 'Firstfeaturedvideoview', 'Firstreferralfrom',
  'Firstreferralfromasubscribermodule','FirstreferralfromGooglesearch','FirstreferralfromGoogleVideosearch',
  'Firstreferralfromrelatedvideo','FirstreferralfromYouTube','FirstreferralfromYouTubesearch',
  'Firstviewfromad','Firstviewfromamobiledevice','Firstviewonachannelpage','Other/Viral')
forPie<-data.frame(category, value)
pie(forPie$value,labels = forPie$category)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
rats<-top$TOTAL_RATS
regr<-lm((rats/top$DAYS)~(feo)+(fev)+(ffvv)+(frf)+(frfsm)+(frfgs)+(frfgvs)+(frflv)+(frfy)+(frfys)+(fvfa)+(fvfmd)+(fvocp)+(ov))
summary(regr)
as.data.frame(lm.beta(regr))

