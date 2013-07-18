# reanalysis of ows tweets for emotion's influence
# chengjun wang
# 20120701 @ cmc

#####################################################################################
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~equality and powerlaw distribution~~~~~~~~~~~~~~~#
#####################################################################################
inter<-read.csv("D:/Dropbox/tweets/data_delete after you download/OccupyWallstreetInterData.csv", header = T, sep = ",", dec = ".")
#~~~~~~~~~~~~~~~~~~~~~~~interaction network~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
data.frame(table(inter$day))
d924<-subset(inter, inter$Day == "2011-09-24" )
d925<-subset(inter, inter$Day == "2011-09-25" )
d926<-subset(inter, inter$Day == "2011-09-26" )
d927<-subset(inter, inter$Day == "2011-09-27" )
d928<-subset(inter, inter$Day == "2011-09-28" )
d929<-subset(inter, inter$Day == "2011-09-29" )
d930<-subset(inter, inter$Day == "2011-09-30" )
d101<-subset(inter, inter$Day == "2011-10-01" )
d102<-subset(inter, inter$Day == "2011-10-02" )
d103<-subset(inter, inter$Day == "2011-10-03" )
d104<-subset(inter, inter$Day == "2011-10-04" )
d105<-subset(inter, inter$Day == "2011-10-05" )
d106<-subset(inter, inter$Day == "2011-10-06" )
d107<-subset(inter, inter$Day == "2011-10-07" )
d108<-subset(inter, inter$Day == "2011-10-08" )
d109<-subset(inter, inter$Day == "2011-10-09" )

library(igraph) # install.packages("igraph")
g924<-as.data.frame(cbind(as.character(d924$From.User), as.character(d924$To.User)))
g925<-as.data.frame(cbind(as.character(d925$From.User), as.character(d925$To.User)))
g926<-as.data.frame(cbind(as.character(d926$From.User), as.character(d926$To.User)))
g927<-as.data.frame(cbind(as.character(d927$From.User), as.character(d927$To.User)))
g928<-as.data.frame(cbind(as.character(d928$From.User), as.character(d928$To.User)))
g929<-as.data.frame(cbind(as.character(d929$From.User), as.character(d929$To.User)))
g930<-as.data.frame(cbind(as.character(d930$From.User), as.character(d930$To.User)))
g101<-as.data.frame(cbind(as.character(d101$From.User), as.character(d101$To.User)))
g102<-as.data.frame(cbind(as.character(d102$From.User), as.character(d102$To.User)))
g103<-as.data.frame(cbind(as.character(d103$From.User), as.character(d103$To.User)))
g104<-as.data.frame(cbind(as.character(d104$From.User), as.character(d104$To.User)))
g105<-as.data.frame(cbind(as.character(d105$From.User), as.character(d105$To.User)))
g106<-as.data.frame(cbind(as.character(d106$From.User), as.character(d106$To.User)))
g107<-as.data.frame(cbind(as.character(d107$From.User), as.character(d107$To.User)))
g108<-as.data.frame(cbind(as.character(d108$From.User), as.character(d108$To.User)))
g109<-as.data.frame(cbind(as.character(d109$From.User), as.character(d109$To.User)))

gall<-as.data.frame(cbind(as.character(inter$From.User), as.character(inter$To.User)))

# reciprocity(g_all) # 0.004667965
# assortativity.degree (g_all, directed = TRUE) # -0.01295559
# 16.8% is the percent of overlap between senders and receivers.
	
	n<-gall
      n<-graph.data.frame(n, directed=T, vertices=NULL) 
	dall <- degree(n, mode="all") # chang it to mode = c("all", "out", "in")
	'alpha-all'; power.law.fit(dall, xmin=20)

	din <- degree(n, mode="in") # chang it to mode = c("all", "out", "in")
	'alpha-in'; power.law.fit(din, xmin=20)

	dout <- degree(n, mode="out") # chang it to mode = c("all", "out", "in")
	'alpha-out'; power.law.fit(dout, xmin=20)

res <- power.law.fit(dall, xmin=20) 
confint(res)  # confidence level
plfit(dall) # use this function you should refer to the code chunk below.
# plfit(dall)
# $xmin [1] 2 $alpha [1] 1.9 $ D [1] 0.01702849

ks.test(x,y)
data<-data.frame(table(dall))
names(data)<-c("x", "y")
ks.test(data$x, data$y)

# clustering coefficient
transitivity(n, type= "global", vids=NULL, weights=NULL, isolates="zero") 

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~# 
ddd <- degree.distribution(n, mode="all", cumulative=TRUE)
plot(ddd, log="xy", xlab="Degree (Alpha=2.067)", ylab="Probability",
     col=1, main="")
lines(10:500, 10*(10:500)^(-coef(alpha_all)+1))
 
# save data
setwd("D:/")
savePlot(filename = "Nonlinear preferential attachment",
         type = c( "tiff"),
         device = dev.cur(),
         restoreConsole = TRUE)

###############################################################################
#  KS Test of power law distribution 
# from http://tuvalu.santafe.edu/~aaronc/powerlaws/
###############################################################################
library(VGAM)   # zeta function

# test zone 

x <- (1-runif(10000))^(-1/(2.5-1))
plfit(x)

###############################################################################
#
# PLFIT fits a power-law distributional model to data.
#
#    PLFIT(x) estimates x_min and alpha according to the goodness-of-fit
#    based method described in Clauset, Shalizi, Newman (2007). x is a
#    vector of observations of some quantity to which we wish to fit the
#    power-law distribution p(x) ~ x^-alpha for x >= xmin.
#    PLFIT automatically detects whether x is composed of real or integer
#    values, and applies the appropriate method. For discrete data, if
#    min(x) > 1000, PLFIT uses the continuous approximation, which is
#    a reliable in this regime.
#
#    The fitting procedure works as follows:
#    1) For each possible choice of x_min, we estimate alpha via the
#       method of maximum likelihood, and calculate the Kolmogorov-Smirnov
#       goodness-of-fit statistic D.
#    2) We then select as our estimate of x_min, the value that gives the
#       minimum value D over all values of x_min.
#
#    Note that this procedure gives no estimate of the uncertainty of the
#    fitted parameters, nor of the validity of the fit.
#
#    Example:
#       x <- (1-runif(10000))^(-1/(2.5-1))
#       plfit(x)
#
#
# Version 1.0   (2008 February)
# Version 1.1   (2008 February)
#    - correction : division by zero if limit >= max(x) because the unique R function do no sort
#                   and the matlab function do...
# Version 1.1   (minor correction 2009 August)
#    - correction : lines 230 zdiff calcul was wrong when xmin=0 (thanks to Naoki Masuda)
#    - gpl version updated to v3.0 (asked by Felipe Ortega)
# Version 1.2 (2011 August)
#    - correction for method "limit" thanks to David R. Pugh 
#      xmins <- xmins[xmins<=limit] is now xmins <- xmins[xmins>=limit]
#    - "fixed" method added for xmins from David R. Pugh
#    - modifications by Alan Di Vittorio:
#       - correction : zdiff calculation was wrong when xmin==1
#       - the previous zdiff correction was incorrect
#       - correction : x has to have at least two unique values
#       - additional discrete x input test : discrete x cannot contain the value 0
#       - added option to truncate continuous xmin search when # of obs gets small
#
# Copyright (C) 2008,2011 Laurent Dubroca laurent.dubroca_at_gmail.com 
# (Stazione Zoologica Anton Dohrn, Napoli, Italy)
# Distributed under GPL 3.0 
# http://www.gnu.org/copyleft/gpl.html
# PLFIT comes with ABSOLUTELY NO WARRANTY
# Matlab to R translation based on the original code of Aaron Clauset (Santa Fe Institute)
# Source: http://www.santafe.edu/~aaronc/powerlaws/
#
# Notes:
#
# 1. In order to implement the integer-based methods in Matlab, the numeric
#    maximization of the log-likelihood function was used. This requires
#    that we specify the range of scaling parameters considered. We set
#    this range to be seq(1.5,3.5,0.01) by default. This vector can be
#    set by the user like so,
#
#       a <- plfit(x,"range",seq(1.001,5,0.001))
#
# 2. PLFIT can be told to limit the range of values considered as estimates
#    for xmin in two ways. First, it can be instructed to sample these
#    possible values like so,
#
#       a <- plfit(x,"sample",100)
#
#    which uses 100 uniformly distributed values on the sorted list of
#    unique values in the data set. Alternatively, it can simply omit all
#    candidates below a hard limit, like so
#
#       a <- plfit(x,"limit",3.4)
#
#    In the case of discrete data, it rounds the limit to the nearest
#    integer.
#
#     Finally, if you wish to force the threshold parameter to take a specific value 
#     (useful for bootstrapping), simply call plfit() like so
#       
#       a <- plfit(x,"fixed",3.5)
#
# 3. When the input sample size is small (e.g., < 100), the estimator is
#    known to be slightly biased (toward larger values of alpha). To
#    explicitly use an experimental finite-size correction, call PLFIT like
#    so
#
#       a <- plfit(x,finite=TRUE)
#
# 4. For continuous data, PLFIT can return erroneously large estimates of 
#    alpha when xmin is so large that the number of obs x >= xmin is very 
#    small. To prevent this, we can truncate the search over xmin values 
#    before the finite-size bias becomes significant by calling PLFIT as
#    
#       a = plfit(x,nosmall=TRUE);
#    
#    which skips values xmin with finite size bias > 0.1.
#
###############################################################################
plfit<-function(x=rpareto(1000,10,2.5),method="limit",value=c(),finite=FALSE,nowarn=FALSE,nosmall=FALSE){
   #init method value to NULL	
   vec <- c() ; sampl <- c() ; limit <- c(); fixed <- c()
###########################################################################################
#
#  test and trap for bad input
#
   switch(method, 
     range = vec <- value,
     sample = sampl <- value,
     limit = limit <- value,
     fixed = fixed <- value,
     argok <- 0)
   
   if(exists("argok")){stop("(plfit) Unrecognized method")}

   if( !is.null(vec) && (!is.vector(vec) || min(vec)<=1 || length(vec)<=1) ){
     print(paste("(plfit) Error: ''range'' argument must contain a vector > 1; using default."))
     vec <- c()
   }
   if( !is.null(sampl) && ( !(sampl==floor(sampl)) ||  length(sampl)>1 || sampl<2 ) ){
     print(paste("(plfit) Error: ''sample'' argument must be a positive integer > 2; using default."))
     sample <- c()
   }
   if( !is.null(limit) && (length(limit)>1 || limit<1) ){
     print(paste("(plfit) Error: ''limit'' argument must be a positive >=1; using default."))
     limit <- c()
   }
   if( !is.null(fixed) && (length(fixed)>1 || fixed<=0) ){
     print(paste("(plfit) Error: ''fixed'' argument must be a positive >0; using default."))
     fixed <- c() 
   }   

#  select method (discrete or continuous) for fitting and test if x is a vector
   fdattype<-"unknow"
   if( is.vector(x,"numeric") ){ fdattype<-"real" }
   if( all(x==floor(x)) && is.vector(x) ){ fdattype<-"integer" }
   if( all(x==floor(x)) && min(x) > 1000 && length(x) > 100 ){ fdattype <- "real" }
   if( fdattype=="unknow" ){ stop("(plfit) Error: x must contain only reals or only integers.") }

#
#  end test and trap for bad input
#
###########################################################################################

###########################################################################################
#
#  estimate xmin and alpha in the continuous case
#
   if( fdattype=="real" ){

    xmins <- sort(unique(x))
    xmins <- xmins[-length(xmins)]

    if( !is.null(limit) ){
      xmins <- xmins[xmins>=limit]
    } 
    if( !is.null(fixed) ){
      xmins <- fixed
    }
    if( !is.null(sampl) ){ 
      xmins <- xmins[unique(round(seq(1,length(xmins),length.out=sampl)))]
    }
 
    dat <- rep(0,length(xmins))
    z   <- sort(x)
    
    for( xm in 1:length(xmins) ){
      xmin <- xmins[xm]
      z    <- z[z>=xmin]
      n    <- length(z)
      # estimate alpha using direct MLE
      a    <- n/sum(log(z/xmin))
      # truncate search if nosmall is selected
      if( nosmall ){
       if((a-1)/sqrt(n) > 0.1){
           dat <- dat[1:(xm-1)]
           print(paste("(plfit) Warning : xmin search truncated beyond",xmins[xm-1]))
           break
       }
      }
      # compute KS statistic
      cx   <- c(0:(n-1))/n
      cf   <- 1-(xmin/z)^a
      dat[xm] <- max(abs(cf-cx))
    }
 
    D     <- min(dat)
    xmin  <- xmins[min(which(dat<=D))]
    z     <- x[x>=xmin]
    n     <- length(z)
    alpha <- 1 + n/sum(log(z/xmin))

    if( finite ){
      alpha <- alpha*(n-1)/n+1/n # finite-size correction
    }
    if( n<50 && !finite && !nowarn){
      print("(plfit) Warning : finite-size bias may be present")
    }

   }
#
#  end continuous case
#
###########################################################################################

###########################################################################################
#
#  estimate xmin and alpha in the discrete case
#
   if( fdattype=="integer" ){

    if( is.null(vec) ){ vec<-seq(1.5,3.5,.01) } # covers range of most practical scaling parameters
    zvec <- zeta(vec)

    xmins <- sort(unique(x))
    xmins <- xmins[-length(xmins)]

    if( !is.null(limit) ){
      limit <- round(limit)
      xmins <- xmins[xmins>=limit]
    } 

    if( !is.null(fixed) ){
      xmins <- fixed
    }

    if( !is.null(sampl) ){ 
      xmins <- xmins[unique(round(seq(1,length(xmins),length.out=sampl)))]
    }

    if( is.null(xmins) || length(xmins) < 2){
      stop("(plfit) error: x must contain at least two unique values.")
    }

    if(length(which(xmins==0) > 0)){
      stop("(plfit) error: x must not contain the value 0.")
    }

    xmax <- max(x)
     dat <- matrix(0,nrow=length(xmins),ncol=2)
       z <- x
    for( xm in 1:length(xmins) ){
      xmin <- xmins[xm]
      z    <- z[z>=xmin]
      n    <- length(z)
      # estimate alpha via direct maximization of likelihood function
      #  vectorized version of numerical calculation
      # matlab: zdiff = sum( repmat((1:xmin-1)',1,length(vec)).^-repmat(vec,xmin-1,1) ,1);
      if(xmin==1){
        zdiff <- rep(0,length(vec))
      }else{
       zdiff <- apply(rep(t(1:(xmin-1)),length(vec))^-t(kronecker(t(array(1,xmin-1)),vec)),2,sum)
      }
      # matlab: L = -vec.*sum(log(z)) - n.*log(zvec - zdiff);
      L <- -vec*sum(log(z)) - n*log(zvec - zdiff);
      I <- which.max(L)
      # compute KS statistic
      fit <- cumsum((((xmin:xmax)^-vec[I])) / (zvec[I] - sum((1:(xmin-1))^-vec[I])))
      cdi <- cumsum(hist(z,c(min(z)-1,(xmin+.5):xmax,max(z)+1),plot=FALSE)$counts/n)
      dat[xm,] <- c(max(abs( fit - cdi )),vec[I])
    }
    D     <- min(dat[,1])
    I     <- which.min(dat[,1])
    xmin  <- xmins[I]
    n     <- sum(x>=xmin)
    alpha <- dat[I,2]

    if( finite ){
      alpha <- alpha*(n-1)/n+1/n # finite-size correction
    }
    if( n<50 && !finite && !nowarn){
      print("(plfit) Warning : finite-size bias may be present")
    }

   }
#
#  end discrete case
#
###########################################################################################

#  return xmin, alpha and D in a list
   return(list(xmin=xmin,alpha=alpha,D=D))
}

######################################################################################
#~~~~~~~~~~~~~~~~~~~~~emotion and stability, equality~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
######################################################################################

sd16<-read.csv("D:/Dropbox/tweets/writing/Figures and Tables/ows_sd16.csv", header = T, sep = ",", dec = ".")

# the aggregated emotion
sumemo<-function(n){
     see<-sum(sd16$emotion1[n],sd16$emotion2[n],sd16$emotion3[n],sd16$emotion4[n],sd16$emotion5[n],
    sd16$emotion6[n],sd16$emotion7[n],sd16$emotion8[n],sd16$emotion9[n],sd16$emotion10[n],sd16$emotion11[n],
    sd16$emotion12[n],sd16$emotion13[n],sd16$emotion14[n],sd16$emotion15[n],sd16$emotion16[n])
   return(see)}
sd16$emotion_sum<-sapply(c(1:length(sd16[,1])), sumemo)


# the aggregated number of tweets
sumem<-function(n){
   ss<-sum(sd16$num1[n],sd16$num2[n],sd16$num3[n],sd16$num4[n],sd16$num5[n],
    sd16$num6[n],sd16$num7[n],sd16$num8[n],sd16$num9[n],sd16$num10[n],sd16$num11[n],
    sd16$num12[n],sd16$num13[n],sd16$num14[n],sd16$num15[n],sd16$num16[n])
   return(ss)}
sd16$emotion_num<-sapply(c(1:length(sd16[,1])), sumem)

# average emotion
sd16$emotion_mean<-sd16$emotion_sum/sd16$emotion_num

# the aggregated stand deviation of tweets
sde<-function(n){
   ss<-c(sd16$num1[n],sd16$num2[n],sd16$num3[n],sd16$num4[n],sd16$num5[n],
    sd16$num6[n],sd16$num7[n],sd16$num8[n],sd16$num9[n],sd16$num10[n],sd16$num11[n],
    sd16$num12[n],sd16$num13[n],sd16$num14[n],sd16$num15[n],sd16$num16[n])
   sdd<-sd(ss)
   return(sdd)}
sd16$discussion_sd<-sapply(c(1:length(sd16[,1])), sde)

# the correlation between emotion_mean and discussion_sd
cor((sd16$emotion_mean), (sd16$discussion_sd))  # cor -0.007174954
cor.test(log(sd16$emotion_mean+1), log(sd16$discussion_sd+1))  # cor 0.05024871 

library(Hmisc)
#  emotion and stability
rcorr(as.matrix(data.frame(sd16$emotion_mean, sd16$discussion_sd)),type="pearson") # p =0.2557 
#  emotion and equality
rcorr(as.matrix(data.frame(sd16$emotion_mean, sd16$emotion_num)),type="pearson") # p =0.4211 



plot((sd16$emotion_mean), (sd16$discussion_sd))

plot(log(sd16$discussion_sd+1)~log(sd16$emotion_mean+1))
reg<-lm(log(sd16$discussion_sd+1)~log(sd16$emotion_mean+1))
summary(reg)
abline(reg)
text(1000,60,"R-squared: 0.82")
############################################################################################
# redraw
############################################################################################
ind16<-read.csv("D:/Dropbox/tweets/writing/Figures and Tables/OWSCorr.csv", header = T, sep = ",", dec = ".")
names(ind16) <- c("id","To.User","Sep24","Sep25","Sep26","Sep27","Sep28","Sep29","Sep30","Oct1","Oct2","Oct3","Oct4","Oct5","Oct6","Oct7","Oct8","Oct9")

corr <- cor(ind16[,3:18])

library(corrplot) # install.packages("corrplot")
corrplot(corr, method = "circle", type = c("full"))

setwd("D:/")
savePlot(filename = "Stability of Conversation Receiver",
         type = c( "tiff"),
         device = dev.cur(),
         restoreConsole = TRUE)

outd16<-read.csv("D:/Dropbox/tweets/writing/Figures and Tables/OWSCorrout16.csv", header = T, sep = ",", dec = ".")
names(outd16) <- c("id","From.User","Sep24","Sep25","Sep26","Sep27","Sep28","Sep29","Sep30","Oct1","Oct2","Oct3","Oct4","Oct5","Oct6","Oct7","Oct8","Oct9")

corr <- cor(outd16[,3:18])
corrplot(corr, method = "circle", type = c("full"))

setwd("D:/")
savePlot(filename = "Stability of Conversation Initiator",
         type = c( "tiff"),
         device = dev.cur(),
         restoreConsole = TRUE)

###############################################################
#
###############################################################

sampleId<-sample(inter$Twitter.ID, 200, replace = FALSE, prob = NULL)
validityCheck<-subset(inter, inter$Twitter.ID%in%sampleId)

write.csv(validityCheck, "D:/Dropbox/tweets/data_delete after you download/OccupyWallstreetValidityCheckData.csv")
















