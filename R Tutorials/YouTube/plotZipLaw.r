top<-read.csv("D:/google drive/Google Drive/Youtube/Data/topCatPeak.csv", header = T, sep=',', stringsAsFactors=F)
attach(top)

# v<-as.data.frame(table(top$TOTAL_VIEW))
# names(v)<-c("var", "freq")
v<-TOTAL_COMM+1

par(mfrow=c(1,1))

#~~~~~~~~~~~~~~~~~~~one example of DGBD~~~~~~~~~~~~~~~~~~~~~~~~#
a=TOTAL_VIEW
ra=rank(-a)
plot(ra,a/sum(as.numeric(a)),log="y")

LY=log(a+1)
LIR<-log(length(a)+1-ra)
LR<-log(ra)
reg<-lm(LY~LIR+LR)
co=coef(reg)
xx=c(1:length(a))
yy=exp(co[[1]])*(length(a)+1-xx)^co[[2]]*xx^co[[3]]
lines(xx,yy,col="red")
#~~~~~~~~~~~~~~~~~~~~Zipf-Mandrot~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
f=TOTAL_VIEW  
r=rank(-f)

plot(f,r, log="x", xlab="Value", ylab= "Rank")
zmf<-function(x, m, alpha){
	1+(1+m*x)^(-alpha)}
zmf(r, m=-2, alpha=100)
curve(zmf(x, m=-2, alpha=-1),
	log="y", 
	from=min(r), 
	to=max(r),
	col='blue',
	add=TRUE)

LF<-log(f-1)
LR<-log(1+m*r) # since m is parameter, it could not be solved using ols

nls(log(f-1) ~ -N*(1+M * r),
  control = nls.control(maxiter = 1000, tol = 1e-05, minFactor = 1/4096,printEval = FALSE, warnOnly = FALSE),
  start = list(M= max(f), M=3, N=0.8))

comment<-data.frame(f, r)
write.csv(comment, "d:/comment.csv")
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
list1<- TOTAL_VIEW
v<-sort(list1, decreasing = T)
r<-length(list1)+1-rank(v)
plot(r,v, log="y")

plotZipfLaw<-function(list){
	v<-sort(list, decreasing = T)
	r<-length(list)+1-rank(v)
      points(r,v, log="y")
	}
par(mfrow=c(1,1))
plotZipfLaw(TOTAL_VIEW+1)
plotZipfLaw(TOTAL_COMM+1)
plotZipfLaw(TOTAL_FAVS+1)
plotZipfLaw(TOTAL_RATS+1)




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
