# chengjun wang
# 20110823@common room of hall 8
# weibo search about 738 weibos of Gaddafi lasting for 4 minutes

#~~~~~~~~~~~~~~~~~read data~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
kzf<-read.csv("D:/ROST/ROSTAPIOauth/kzf.csv",header = T)
#~~~~~~~transmissons VS comments~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
transmission_comment<-lm(kzf[,11]~kzf[,12])
summary(transmission_comment)
plot(kzf[,12],kzf[,11], xlab="comments", ylab="transmissions")
abline(transmission_comment)
cor(kzf[,11],kzf[,12])
# it's clear that the weibo gets more comments if it gets more transmissions.
#~~~~~~~~~~~~~~who is popular~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
names(kzf) # names is very useful for seeing the header.
data.frame(table(kzf[,8]))  # number of transmissions
length(kzf[,8])
# the number of transmissions 738-476=262
pie(table(kzf[,8]))
transmission<-subset(kzf, kzf[,8]!="ÎÞ")
pie(table(transmission[,8]))
unique(transmission[,8]) # the one who are transmited
pie(transmission[,11])   # see the picture in this dataset
pie(table((subset(transmission, transmission[,10]=="FALSE"))[,8]))
# not accurate
#~~~~~~~~~~~~~~~~~transmission network~~~~~~~~~~~~~~~~~~~~~~~~~#
#^_^£¡£¡£¡from source to transmiters, the mediators are ignored#
t<-data.frame(cbind(as.character(transmission[,8]),as.character(transmission[,2])))
lcp<-subset(t,t[,1]=="Àî³ÐÅô")
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# detach("package:igraph")
# detach("package:statnet")
library(statnet)
# help(plot.network)

n=network(t,vertex.attr=NULL, vertex.attrnames=NULL,
  matrix.type="edgelist",directed=TRUE) 
plot(n)
plot(n, label=network.vertex.names(n))
#~~~~~~~~~~~multiple transmission by one user~~~~~~~~~~~#
tt<-as.matrix(table(t))
m=as.matrix(tt)
net=network(m,matrix.type="adjacency",directed=T,
     ignore.eval=FALSE, names.eval="value") 
gplot(net,gmode="graph",mode="fruchtermanreingold",
    edge.lwd=net%e%'value',vertex.cex=3,vertex.sides=20)

#~~~~~~~~~~visualizing using igraph~~~~~~~~~~~~~~~~~~~~~#
library(igraph)
g<-graph.data.frame(t)
# popularity<-as.data.frame(table(t[,1]))
# vertex<-as.numeric(V(g)$name)
# V(g)$size <- popularity
# V(g)$color <- rainbow(10)[log(sizes)]
plot(g, layout=layout.fruchterman.reingold,
     vertex.color="#ff0000", vertex.frame.color="#ff0000", 
     edge.color="#555555", vertex.size=2, edge.size=1,
     vertex.label.dist=0, vertex.label.cex=0.8, 
     vertex.label=V(g)$name, vertex.label.font=0.8,
     edge.arrow.size=0.01 )

#########################################################
# 
#                  
#
#########################################################

# split a list by blank using strsplit~~~~~~~~~~~~~~~~~#
words<-strsplit(as.character(kzf[,3]), " ")
# extract strings by regular expressions~~~~~~~~~~~~~~~#
library(gsubfn)  # load package
rt<-strapply(words, paste("\\w*", "@", "\\w*", sep = ""), c, combine = list,simplify = T)
#~~~~~~~~~~~~~~~~~~transmission by RT~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# embed(unlist(rt[2]), 2)[, 2:1] # this also works.

Transmission_words<-function(n){
   l<-unlist(rt[n])
   if (!is.null(l)) # rt[6] is a NULL, so i add if esle conditions.
   m<-matrix(c(l[-length(l)], l[-1]), ncol=2)
   else m<-NULL
   return(m)  
   }

 tw<-sapply(c(1:length(rt)),Transmission_words)  
 list_tw<-tw[!unlist(lapply(tw, is.null))]
 edgelist_tw<-as.data.frame(do.call(rbind, list_tw))
# from source to transmiters, the mediators are ignored#

#~~~~~~~~~~~~~~~~~~~~~~~~plot~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# detach("package:igraph")
# detach("package:statnet")
library(statnet)
# help(plot.network)

n_tw=network(edgelist_tw,vertex.attr=NULL, vertex.attrnames=NULL,
  matrix.type="edgelist",directed=TRUE) 
plot(n_tw)

n_tc=network(edgelist_tc,vertex.attr=NULL, vertex.attrnames=NULL,
  matrix.type="edgelist",directed=TRUE) 
plot(n_tc)

plot(n, label=network.vertex.names(n))

