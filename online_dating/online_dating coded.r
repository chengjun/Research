
# ergm of online dating data
# WANG, Chengjun
# 20111115


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~combine data~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# f<-read.csv("D:/cityu/dating website/download_data/dataprofile_f.csv",
#  head=FALSE,na.string='NA')
# m<-read.csv("D:/cityu/dating website/download_data/data/profile_m.csv",
#  head=FALSE,na.string='NA')
# date<-rbind(m,f)
# write.csv(date, file="D:/cityu/dating website/download_data/data/date.csv")  
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~read data~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
date<-read.csv("D:/cityu/dating website/download_data/data/date.csv",
 head=TRUE,na.string='NA')
all<-read.table("D:/cityu/dating website/download_data/data/train.txt",
 head = TRUE, sep = "", dec = ".")
#~~~~~~~~~~~~~~~~~~~~~~~~sample from population~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
sample<-data.frame(sample(date$Uid, 10000, replace = FALSE, prob = NULL))

library(gregmisc) 

name<-rename.vars(sample, c("sample.date.Uid..10000..replace...FALSE..prob...NULL."), c("Uid"))
subdate<-merge(date, name, by="Uid")
suball=subset(all,all$USER_ID_A%in%name[,1]&all$USER_ID_B%in%name[,1])
#^_^ note:only both node A and node B are sampling node, will this link be involved#
dim(suball)
hist(table(suball$USER_ID_A),breaks=100)
write.csv(suball, file="d:/cityu/dating website/download_data/data/suball.csv")  
# write.csv(subdate, file="d:/cityu/dating website/download_data/data/subdate.csv")  
#~~~~~~~~~~~~~~~~~~~~~~data convertion~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# read a .csv file
# This sorts the values and assigns a unique id for each ID number
code=sort(unique(c(suball[,1],suball[,2]))) 
# This matches the IDs of column 1 in the edgelist to the unique IDs 
suball[,1]=match(suball[,1],code) 
# This matches the IDs of column 2 in the edgelist to the unique IDs 
suball[,2]=match(suball[,2],code) 
# ^_^ you also should subset subdate
# not everyone you select interacts with other people
subdate=subset(subdate,subdate$Uid%in%code)
#~~~~~~~~~~~~~~~~~~~~~1. create vertex attributes used for ERGM~~~~~~~~~~~~~~~~~~~~~~~#
library(car)
subdate$hou_re<-recode(subdate$house,"0=0; else=1")
subdate$aut_re<-recode(subdate$auto,"0=0; else=1")
subdate$chi_re<-recode(subdate$children,"0=0; else=1")
subdate$ind_re<-recode(subdate$industry,"0=0; else=1")
subdate$nat_re<-recode(subdate$nation,"0=0; else=1")
subdate$ava_re<-recode(subdate$avater,"0=0; else=1")
subdate$bel_re<-recode(subdate$belief,"0=0; else=1")

income<-list(subdate$income)
education<-list(subdate$education)
status<-list(subdate$status)
subdate$trustlevel<-subdate$level+1
trustlevel<-list(subdate$trustlevel)
height<-list(subdate$height)
birth_year<-list(subdate$birth_year)
subdate$age<-2011-subdate$birth_year
age<-list(subdate$age)
register_time<-list(subdate$register_time)
subdate$female<-as.numeric(subdate$sex) #1 as female, 2 as male.
female<-list(subdate$female)
privacy<-list(subdate$privacy)
avatar<-list(subdate$avatar)
ms_mobile<-list(subdate$ms_mobile)
match_certified<-list(subdate$match_certified)
match_avatar<-list(subdate$match_avatar)
login_count<-list(subdate$login_count)
hou_re<-list(subdate$hou_re)
aut_re<-list(subdate$aut_re)
chi_re<-list(subdate$chi_re)
ind_re<-list(subdate$ind_re)
nat_re<-list(subdate$nat_re)
ava_re<-list(subdate$ava_re)
bel_re<-list(subdate$bel_re)

#~~~~~~~~~~~~~~~~~~~~~~~~~~2. creates an edgelist using the unique IDs~~~~~~~~~~~~~~~~~~~~~~~#
library(ergm)

n=network(suball,matrix.type="edgelist",directed=TRUE,
 vertex.attr=c(age,income,education,status,trustlevel,height,birth_year,register_time,
 ms_mobile,match_certified,login_count,match_avatar,privacy,avatar,female,hou_re,'aut_re','chi_re','ind_re','nat_re',
'ava_re','bel_re'),
 vertex.attrnames=c('age','income','education','status','trustlevel','height','birth_year',
 'register_time','ms_mobile','match_certified','login_count','match_avatar','privacy','avatar','female','hou_re',
  'aut_re','chi_re','ind_re','nat_re','ava_re','bel_re')) 


#~~~~~~~~~~~~~~~~~~3. Assigns the actual ID numbers as vertex names~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
network.vertex.names(n)=code      #summary(n)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ergm~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# install.packages("statnet") #
library("statnet")
memory.limit(2000)  # set limit to 2GB

wpp<-ergm(n~edges+nodefactor('aut_re')+nodefactor('chi_re')+
 nodefactor('ind_re')+nodefactor('nat_re')+nodefactor('ava_re')+ nodefactor('bel_re')+
 mutual+gwesp,
 burnin=15000,MCMCsamplesize=30000,verbose=FALSE)
summary(wpp)

mcmc.diagnostics(wpp) 
m1<-logLik(wpp, add=TRUE)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~simulation~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
m1.sim<-simulate(m1,nsim=10)
m1.sim$networks[[1]]
plot(m1.sim$networks[[1]])
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~goodness of fit~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
m1.gof<-gof(m1,GOF=~idegree+distance+espartners+triadcensus,
 verbose=TRUE, interval=5e+4, seed=111)
par(mfrow=c(2,2))
plot(m1.gof)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~assortativeness~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
act<-as.data.frame(table(all$USER_ID_A))
pop<-as.data.frame(table(all$USER_ID_B))
as<-merge(act,pop, by="Var1", all=T)
hist(pop$Freq, breaks=500)
hist(act$Freq, breaks=500)
# as[ is.na(as) ] <- 0 # replace NA with 0.
# write.csv(as, file="D:/cityu/dating website/download_data/data/as.csv")
# plot.
plot(as$Freq.x,as$Freq.y,xlab="Activity",ylab="Popularity",type = "p", col = "black", lwd=2,main = "")

myfit<-lm(log(as$Freq.y)~log(as$Freq.x),data=as)
summary(myfit)
plot(log(as$Freq.x),log(as$Freq.y),xlab="Activity",ylab="Popularity")
abline(myfit, col = "green",lwd=3)

hist(as$Freq.x)
cor(log(as$Freq.x),log(as$Freq.y),use = "everything",method=c("pearson")) # why it doesn't work


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~plot~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
income<-n%v%'income'
education<-n%v%'education'
status<-n%v%'status'
plot(n, vertex.cex=income/20,vertex.col=education,vertex.sides=status+3)



