#~~~~~~~~~~~~~~~~~~~~~~~~~change to posixlt format time~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# digg <- read.csv(file= "d:/micro-blog/digg/digg_votes1.csv", head=FALSE,na.string='NA')
# names(digg)<-c("time", "user_id", "news_id")
# digg$date<-as.POSIXct(digg$time, origin="1970-01-01")
# as.POSIXct(head(digg$time), origin="1970-01-01", format="%Y-%m-%d %H")
# write.csv(digg, file="d:/micro-blog/digg/digg_diffusion.csv")
# digg$date1<-as.character(digg$date)
# digg$date1<-strptime(digg$date1, "%Y-%m-%d %H")  ## %Y must not be %y!
#~~~~~~~~~~~~~~~~~turn to posixlt format time based on hours unit~~~~~~~~~~~~~~~~~~~~~~~~#
# digg <- read.table(file= "d:/micro-blog/digg/digg_diffusion_aggr.txt", head=T,sep = ",", na.string='NA')
# names(digg)<-c("news_id","date", "num_sum", "hour", "hour_num")
# time<-paste(digg$date, digg$hour)  #farily good coding trick#
# digg$time<-as.POSIXlt(time)
# write.csv(digg, file="d:/micro-blog/digg/digg_diffusion_data_for_gvisAnnotatedTimeLine.csv")
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~visualize data~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
digg<-read.csv(file= "d:/micro-blog/digg/digg_diffusion_data_for_gvisAnnotatedTimeLine.csv", head=T,sep = ",")
digg1<-subset(digg, digg$news_id==1)

digg50<-subset(digg, digg$news_id<=50)  #Select data 
digg50$news_id<-as.character(digg50$news_id)
library(googleVis)
AnnoTimeLine  <- gvisAnnotatedTimeLine(digg50, datevar="time",
                           numvar="num_sum", idvar="news_id",
                           titlevar="", annotationvar="",
                           options=list(displayAnnotations=TRUE,
                             legendPosition='newRow',
                             width=1000, height=600)
                           )
# Display chart
plot(AnnoTimeLine) 
setwd("d:/micro-blog/digg/")
cat(AnnoTimeLine$html$chart, file="AnnoTimeLine_digg50.html")

# another way to Create Google Gadget
cat(createGoogleGadget(AnnoTimeLine), file="annotimeline.xml")

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
digg50$time<-as.numeric(digg50$time)

library("googleVis")

digg_50<- gvisMotionChart(digg50, idvar="news_id", timevar="time", options=list(width=1024, height=768))
plot(digg_50)

setwd("d:/r/facebookapp")
cat(twitter_app$html$chart, file="twitter_app.html")


as.POSIXct(as.character(numeric_time), origin="1970-01-01", format="%Y-%m-%d %H:%M:%S")
#~~~~~~~~~~~~~~~~~~~~~~~~~~log-log plot of hourly diffusion~~~~~~~~~~~~~~~~~~~#
# Since log-normal distributions normally look better with log-log axes,
# let's use the plot function with points to show the distribution.
# Get the distribution without plotting it using tighter breaks
h <- hist(digg$num_sum, plot=F, breaks=c(seq(0,max(digg$num_sum)+1, .1)))
# Plot the distribution using log scale on both axes, and use blue points
plot(h$counts, log="xy", pch=20, col="blue",
	main="Log-normal distribution",
	xlab="Value", ylab="Frequency")
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~References~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
strptime(y, "%m/%d/%y %H:%M:%S")
as.Date(head(z), "%m/%d/%y %H:%M:%S")

## Julian Day Number (JDN, http://en.wikipedia.org/wiki/Julian_day)
## is the number of days since noon UTC on the first day of 4317 BC.
julian(Sys.Date(), -2440588) # for a day
floor(as.numeric(julian(Sys.time())) + 2440587.5) # for a date-tim

## read in date/time info in format 'm/d/y h:m:s'
dates <- c("02/27/92", "02/27/92", "01/14/92", "02/28/92", "02/01/92")
times <- c("23:03:20", "22:29:56", "01:03:30", "18:21:03", "16:56:26")
x <- paste(dates, times)
strptime(x, "%m/%d/%y %H:%M:%S")

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~digg plot of social attentions~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# enlightened by Hubermans's work on social attentions
digg1<-subset(digg, digg$news_id==1)
dig=digg1$num_sum
digs=cumsum(dig)
lndigs=log(digs)
l=length(lndigs)
lngrowths=lndigs[2:l]-lndigs[1:l-1]
plot(cbind(c(1:(l-1))^(0.4),lngrowths),col=sample(c(1:500),1),
	xlim=c(1,388),ylim=c(0.00001,5),pch=20,type="n",log="xy")


decayplot=function(n){
digg1<-subset(digg, digg$news_id==n)
dig=digg1$num_sum
digs=cumsum(dig)
lndigs=log(digs)
l=length(lndigs)
lngrowths=lndigs[2:l]-lndigs[1:l-1]
lines(cbind(c(1:(l-1))^0.4,lngrowths),col=sample(c(1:100),1),pch=20)
}

sapply(c(1:20),decayplot)

sapply(c(1:3553),decayplot)
