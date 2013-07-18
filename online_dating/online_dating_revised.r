#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~combine data~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# f<-read.csv("D:/Micro-blog/dating website/download_data/data/profile_f.csv",
#  head=FALSE,na.string='NA')
# m<-read.csv("D:/Micro-blog/dating website/download_data/data/profile_m.csv",
#  head=FALSE,na.string='NA')
# date<-rbind(m,f)
# write.csv(date, file="D:/Micro-blog/dating website/download_data/data/date.csv")  
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~read data~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
date<-read.csv("D:/chengjun/online-dating/data/date.csv",
 head=TRUE,na.string='NA')
all<-read.table("D:/chengjun/online-dating/data/train.txt",
 head = TRUE, sep = "", dec = ".")
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~train data~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# act<-read.csv("D:/Micro-blog/dating website/download_data/data/train.csv",
# head=TRUE,na.string='NA')
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~assortativeness~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
act<-as.data.frame(table(all$USER_ID_A))
pop<-as.data.frame(table(all$USER_ID_B))
as<-merge(act,pop, by="Var1", all=T)
hist(pop$Freq, breaks=500)
hist(act$Freq, breaks=500)
# as[ is.na(as) ] <- 0 # replace NA with 0.
# write.csv(as, file="D:/Micro-blog/dating website/download_data/data/as.csv")
# plot.
plot(as$Freq.x,as$Freq.y,xlab="Activity",ylab="Popularity",type = "p", col = "black", lwd=2,main = "")

myfit<-lm(log(as$Freq.y)~log(as$Freq.x),data=as)
summary(myfit)
plot(log(as$Freq.x),log(as$Freq.y),xlab="Activity",ylab="Popularity")
abline(myfit, col = "green",lwd=3)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~click network~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
table(all$ACTION) # 184291 clicks, 48663 private messages
click=subset(all, all$ACTION=='click') 
# length(unique(click$USER_ID_A))
# length(unique(click$USER_ID_B)) 
## 14998 people clicks 28677 people's site
# length(sort(unique(c(click[,1],click[,2]))) ) 
## 35992 people made 184291 interaction.
#~~~~~~~~~~~~~~~~~~~~~~~~sample from population~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
sample<-data.frame(sample(date$Uid, 50000, replace = FALSE, prob = NULL))
library(gregmisc) # install.packages("gregmisc")
name<-rename.vars(sample, c(names(sample)), c("Uid"))
subdate<-merge(date, name, by="Uid")
dim(subdate)
suball=subset(click,click$USER_ID_A%in%name[,1]&click$USER_ID_B%in%name[,1])
dim(suball)
hist(table(suball$USER_ID_A),breaks=100)
# write.csv(subclick, file="d:/chengjun/online-dating/data/subclick.csv")  
# write.csv(subdate, file="d:/chengjun/online-dating/data/subdate.csv")  
code=sort(unique(c(suball[,1],suball[,2]))) # length(code)
subdate=subset(subdate,subdate$Uid%in%code)
dim(subdate)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~sample directly from click network~~~~~~~~~~~~~~~~~~~~#
cc<-c(1:length(click[,4]))
click$cc<-cc
sample<-sample(click$cc, 5000, replace = FALSE, prob = NULL)
subclick=subset(click,click$cc%in%sample) #dim(subclick)

namelist=sort(unique(c(subclick[,1],subclick[,2]))) 
length(namelist)
subdate=subset(date,date$Uid%in%namelist)  #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~assortativity of click network~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
act<-as.data.frame(table(click$USER_ID_A))
pop<-as.data.frame(table(click$USER_ID_B))
as<-merge(act,pop, by="Var1", all=T)
hist(pop$Freq, breaks=500)
hist(act$Freq, breaks=500)
popp<-data.frame(table(pop$Freq))
actt<-data.frame(table(act$Freq))
plot(popp[,1],popp[,2],xlab="In-degree",ylab="Frequency",type = "p", col = "black", lwd=2,main = "")
# as[ is.na(as) ] <- 0 # replace NA with 0.
# write.csv(as, file="D:/Micro-blog/dating website/download_data/data/as.csv")
# plot.
plot(as$Freq.x,as$Freq.y,xlab="Activity",ylab="Popularity",type = "p", col = "black", lwd=2,main = "")

myfit<-lm(log(as$Freq.y)~log(as$Freq.x),data=as)
summary(myfit)
plot(log(as$Freq.x),log(as$Freq.y),xlab="Activity",ylab="Popularity")
abline(myfit, col = "green",lwd=3)
#~~~~~~~~~~~~~~~~the degree distribution of click networks~~~~~~~~~~~~~~~~~~~~~~~~~~~#
powerfit<-lm(log(popp[,2])~log(as.numeric(levels(popp[,1])[popp[,1]])))
summary(powerfit)
plot(log(as.numeric(levels(popp[,1])[popp[,1]])),log(popp[,2]),
   xlab="In-degree",ylab="Frequency",type = "p", col = "black", lwd=2,main = "In-degree Distribution")
abline(powerfit, col = "gray50",lwd=3)
text(9,6,"R Squeare=0.939", col=1, adj=c(3,0.8))
##
powerfit<-lm(log(actt[,2])~log(as.numeric(levels(actt[,1])[actt[,1]])))
summary(powerfit)
plot(log(as.numeric(levels(actt[,1])[actt[,1]])),log(actt[,2]),
   xlab="Out-degree",ylab="Frequency",type = "p", col = "black", lwd=2,main = "Out-degree Distribution")
abline(powerfit, col = "gray50",lwd=3)
text(9,6,"R Squeare=0.881", col=1, adj=c(3,0.8))
#~~~~~~~~~~~~~~~~the degree distribution of subclick networks~~~~~~~~~~~~~~~~~~~~~~~~~~~#
act<-as.data.frame(table(subclick$USER_ID_A))
pop<-as.data.frame(table(subclick$USER_ID_B))
as<-merge(act,pop, by="Var1", all=T)
hist(pop$Freq, breaks=500)
hist(act$Freq, breaks=500)
popp<-data.frame(table(pop$Freq))
actt<-data.frame(table(act$Freq))

powerfit<-lm(log(popp[,2])~log(as.numeric(levels(popp[,1])[popp[,1]])))
summary(powerfit)
plot(log(as.numeric(levels(popp[,1])[popp[,1]])),log(popp[,2]),
   xlab="In-degree",ylab="Frequency",type = "p", col = "black", lwd=2,main = "In-degree Distribution")
abline(powerfit, col = "gray50",lwd=3)
text(9,6,"R Squeare=0.939", col=1, adj=c(3,0.8))


powerfit<-lm(log(actt[,2])~log(as.numeric(levels(actt[,1])[actt[,1]])))
summary(powerfit)

plot(log(as.numeric(levels(actt[,1])[actt[,1]])),log(actt[,2]),
   xlab="Out-degree",ylab="Frequency",type = "p", col = "black", lwd=2,main = "Out-degree Distribution")
abline(powerfit, col = "gray50",lwd=3)
text(9,6,"R Squeare=0.881", col=1, adj=c(3,0.8))
#~~~~~~~~~~~~~~~~~~~~~~data convertion~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# read a .csv file
# subdate<-read.csv("D:/chengjun/online-dating/data/subdate.csv",
#  head=TRUE,na.string='NA')
# subclick<-read.csv("D:/chengjun/online-dating/data/subclick.csv",
#  head=TRUE,na.string='NA')
subclick<-subclick[,1:2]
# This sorts the values and assigns a unique id for each ID number
code=sort(unique(c(subclick[,1],subclick[,2]))) 
# This matches the IDs of column 1 in the edgelist to the unique IDs 
subclick[,1]=match(subclick[,1],code) 
# This matches the IDs of column 2 in the edgelist to the unique IDs 
subclick[,2]=match(subclick[,2],code) 
subclick[1:3,]
#~~~~~~~~~~~~~~~~~~~~~~~~~~2. creates an edgelist using the unique IDs~~~~~~~~~~~~~~~~~~~~~~~#
library("statnet")
#memory.limit(2000)  # set limit to 2GB
n=network(subclick,vertex.attr=NULL, vertex.attrnames=NULL,matrix.type="edgelist",directed=TRUE) # creates an edgelist using the unique IDs
network.vertex.names(n)=code ### Assigns the actual ID numbers as vertex names###
n # 
summary(n) # see the basic info of the network.
#~~~~~~~~~~~~~~~~~~~~~1. create vertex attributes used for ERGM~~~~~~~~~~~~~~~~~~~~~~~#
library(car) # install.packages("car")
subdate$hou_re<-recode(subdate$house,"0=0; else=1")
subdate$aut_re<-recode(subdate$auto,"0=0; else=1")
subdate$chi_re<-recode(subdate$children,"0=0; else=1")
subdate$ind_re<-recode(subdate$industry,"0=0; else=1")
subdate$nat_re<-recode(subdate$nation,"0=0; else=1")
subdate$ava_re<-recode(subdate$avatar,"0=0;2=0; 1=1;3=1")  # sth is wrong.
subdate$bel_re<-recode(subdate$belief,"0=0; else=1")
subdate$ms_mobile<-recode(subdate$ms_mobile,"0=0; else=1")

income<-as.list(subdate$income)
education<-as.list(subdate$education)
status<-as.list(subdate$status)
subdate$trustlevel<-subdate$level+1
trustlevel<-as.list(subdate$trustlevel)
height<-as.list(subdate$height)
birth_year<-as.list(subdate$birth_year)
subdate$age<-2011-subdate$birth_year
age<-as.list(subdate$age)
register_time<-as.list(subdate$register_time)
subdate$female<-as.numeric(subdate$sex) #1 as female, 2 as male.
female<-as.list(subdate$female)
privacy<-as.list(subdate$privacy)
avatar<-as.list(subdate$avatar)
ms_mobile<-as.list(subdate$ms_mobile)
# match_certified<-as.list(subdate$match_certified)
# match_avatar<-as.list(subdate$match_avatar)
login_count<-as.list(subdate$login_count)
hou_re<-as.list(subdate$hou_re)
aut_re<-as.list(subdate$aut_re)
chi_re<-as.list(subdate$chi_re)
ind_re<-as.list(subdate$ind_re)
nat_re<-as.list(subdate$nat_re)
ava_re<-as.list(subdate$ava_re)
bel_re<-as.list(subdate$bel_re)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~add vertex attributes~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# vertex.attr=c(age,income,education,trustlevel, ms_mobile,login_count,
#            privacy,avatar,female,hou_re,aut_re,chi_re,ind_re,nat_re, ava_re,bel_re)
# vertex.attrnames=c('age','income','education','trustlevel', 'ms_mobile',
#            'login_count','privacy','avatar','female','hou_re',
#             'aut_re','chi_re','ind_re','nat_re','ava_re','bel_re')

set.vertex.attribute(n,"age",age)
set.vertex.attribute(n,"income",income)
set.vertex.attribute(n,"education",education)
set.vertex.attribute(n,"trustlevel",trustlevel)

set.vertex.attribute(n,"ms_mobile",ms_mobile)
set.vertex.attribute(n,"login_count",login_count)
set.vertex.attribute(n,"privacy",privacy)
set.vertex.attribute(n,"avatar",avatar)

set.vertex.attribute(n,"female",female)
set.vertex.attribute(n,"hou_re",hou_re)
set.vertex.attribute(n,"aut_re",aut_re)
set.vertex.attribute(n,"chi_re",chi_re)

set.vertex.attribute(n,"ind_re",ind_re)
set.vertex.attribute(n,"nat_re",nat_re)
set.vertex.attribute(n,"ava_re",ava_re)
set.vertex.attribute(n,"bel_re",bel_re)

table(subdate$privacy)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ergm~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# install.packages("statnet") #
library("statnet")
# memory.limit(2000)  # set limit to 2GB

m0<-ergm(n~edges+nodecov("income")+nodecov("trustlevel") +nodematch('hou_re')
  +mutual+gwesp(fixed=T, cutoff=30), 
 parallel=10)
summary(m0)
gest <- logLik(m0, add=TRUE,parallel=10)
# Deviances, AIC, and BIC now shown:
summary(gest)

h1<-ergm(n~edges +nodeicov('age')+nodeicov('education')+nodeicov('income')+nodeifactor('female')
 +nodeifactor('ava_re')+nodeifactor('privacy')
 +nodeifactor('hou_re')+nodeifactor('aut_re')+nodeifactor('chi_re')
 +nodeifactor('ind_re')+nodeifactor('bel_re')
 +gwesp(fixed=T, cutoff=30),
 MCMCsamplesize=70000,verbose=FALSE,seed=25, calc.mcmc.se = FALSE,maxit=6,
 parallel=10)
summary(h1)

h1 <- logLik(h1, add=TRUE,parallel=10) # Deviances, AIC, and BIC now shown:
summary(h1)

h23<-ergm(n~edges +nodeicov('age')+nodeicov('education')+nodeicov('income')+nodeifactor('female')
 +nodematch('ava_re',diff=T)+nodematch('privacy')
 +nodematch('hou_re',diff=T)+nodematch('aut_re',diff=T)+nodematch('chi_re',diff=T)
 +nodematch('ind_re',diff=T)+nodematch('bel_re',diff=T)
 +nodematch('ms_mobile',diff=T)+nodematch('trustlevel')
 +gwesp(fixed=T, cutoff=30),
 MCMCsamplesize=70000,verbose=FALSE, calc.mcmc.se = FALSE,maxit=6,
 parallel=10)
summary(h23)

h23 <- logLik(h23, add=TRUE,parallel=10) # Deviances, AIC, and BIC now shown:
summary(h23)

# show the exp() for the ERGM coefficients
data.frame(lapply(h1[1],exp))
data.frame(lapply(h23[1],exp))
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~simulate~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
m1.sim<-simulate(m1,nsim=10)
m1.sim$networks[[1]]
plot(m1.sim$networks[[1]])
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~goodness of fit~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
m1.gof<-gof(m1,GOF=~idegree+distance+espartners+triadcensus,
 verbose=TRUE, interval=5e+4, seed=111)
par(mfrow=c(2,2))
plot(m1.gof)
#~~~~~~~~~~~~~~~~~~~~~plot the network with attributes~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
library(igraph)# install.packages("igraph")
j<-subclick  # memberships <- list()
jj<-graph.data.frame(j, directed=TRUE, vertices=NULL)
V(jj)$color <- ifelse(subdate$female==1, "red","green")
jj$layout <- layout.fruchterman.reingold
plot(jj,vertex.size=2, vertex.label=NA,edge.arrow.size=0.3)
setwd("d:/chengjun/online-dating")
savePlot(filename = "Rplot",
         type = c( "pdf, png"),
         device = dev.cur(),
         restoreConsole = TRUE)
#~~~~~~~~~~~~~~~~~~~~~~~plot the network with attributes using statnet~~~~~~~~~~~~~~~~~~~#
plot(n,  mode = "fruchtermanreingold", 
        vertex.col=6-subdate$female, 
        #vertex.sides=1+subdate$female,#
        vertex.cex = 0.5,
        main="")
#I have to acknowledge that, igraph does much better than statnet in the apect of drawing#

#~~~~~~~~~~~~~~~~~~~~~~~~compute the degree distribution using igraph~~~~~~~~~~~~~~~~~~~~#
j<-click
library(igraph)# install.packages("igraph")
# memberships <- list()
jj<-graph.data.frame(j, directed=TRUE, vertices=NULL)
class(jj)
dd <- degree(jj, mode="in")
ddd <- degree.distribution(jj, mode="in", cumulative=TRUE)
alpha <- power.law.fit(dd, xmin=20)
alpha
plot(ddd, log="xy", xlab="degree", ylab="cumulative frequency",
     col=1, main="Nonlinear preferential attachment")
lines(10:500, 10*(10:500)^(-coef(alpha)+1))
text(100,0.2,"Alpha=2.937")

powers <- c(0.9, 0.8, 0.7, 0.6)
for (p in seq(powers)) {
  g <- barabasi.game(100000, power=powers[p])
  dd <- degree.distribution(g, mode="in", cumulative=TRUE)
  points(dd, col=p+1, pch=p+1)
}

legend(1, 1e-4, c(1,powers), col=1:5, pch=1:5, ncol=1, yjust=0, lty=0)

# save data
setwd("d:/chengjun/online-dating")
savePlot(filename = "R_hunter_plot",
         type = c( "png"),
         device = dev.cur(),
         restoreConsole = TRUE)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

