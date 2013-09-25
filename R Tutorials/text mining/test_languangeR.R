# http://www.ualberta.ca/~baayen/software.html
# 2013 Sep 22 Cheng-Jun Wang

library(languageR)
library(lme4)

data(beginningReaders)
names(beginningReaders)

bg.lmer = lmer(LogRT ~ReadingScore + poly(OrthLength, 2, raw=TRUE) + 
                       LogFrequency + LogFamilySize +
                       (1|Word) + (1|Subject)+(0+OrthLength|Subject) +
                       (0+LogFrequency|Subject), data = beginningReaders)

mcmc = pvals.fnc(bg.lmer, nsim=1000, withMCMC=TRUE)

par(mfrow=c(2,2), mar=c(5,5,1,1))
plotLMER.fnc(bg.lmer, mcmcMat=mcmc$mcmc, fun=exp, ylabel = "RT (ms)")

acf.fnc(beginningReaders, x="LogRT")

source("http://bioconductor.org/biocLite.R")
biocLite(c("graph", "RBGL", "Rgraphviz"))

library(graph)
library(RBGL)
library(Rgraphviz)
source("D:/github/Research/R Tutorials/CBO.R")

mr = as.matrix(read.csv("D:/github/Research/R Tutorials/CBO.csv", sep = ","， row.names=1, stringsAsFactor = F) )
mr
# Figure 1
par(mfrow=c(1,1), mar=c(5,5,1,1))

plot(mr)                          
mr[mr==""] <- 0
mr[mr=="yes"] <- 1
mr[mr=="-"] <- 0
colnames(mr) <- rownames(mr)
                
mG = as(mr, "graphNEL")

print(mG)
isConnected(mG)

# figure not shown
nAttrs = list()
nAttrs$label <- colnames(mr)
node$fontsize

plot(mG, attrs = list(node = list(shape = "ellipse", fixedsize = FALSE, fontsize = 30, 
                                  label = nAttrs$label, fillcolor = "lightblue"),
                      edge = list(arrowsize=0.5)) )                               
plot.new() 

getDefaultAttrs()

