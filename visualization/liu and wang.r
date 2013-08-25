# 刘耀彬:R软件制作图形的问题
# 2013 Aug 20
# chengjun @ cmc, cityu of hk


#--------------load data-----------------#
library(locpol)

#########################################################
#
#             Part 1: Minging
#
#########################################################


#---------1th plot -----------------------#
city = read.csv("d:/github/Research/visualization/city3.csv", header = T, sep = ",")
c1 = locpol(urbangroth~mining, city, xeval= city$mining); dim(c1$lpFit

d1 = data.frame(city$mining, city$urbangroth)
dev <- sqrt(c1$CIwidth * c1$lpFit$var/c1$lpFit$xDen)
maxY = max(  c1$lpFit[,c1$Y]+ 2*dev  )
minY = min(  c1$lpFit[,c1$Y]- 2*dev  )
plot(d1, type = "n", xlab = "Mining", ylab = "Economic growth", cex.lab=1.5, ylim = c(minY, maxY))
points(c1$lpFit[,c1$X],c1$lpFit[,c1$Y],type="l",lwd = 2, col="blue")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]+ 2*dev,type="l",lty = 2,lwd = 2, col="green")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]- 2*dev,type="l",lty = 2,lwd = 2, col="green")

#----------2nd plot-----------------------#
orderId1 = order(city$mining)
city1 = city[with(city, orderId1), ]
city1 = data.frame(city1, c1$lpFit)
city1$manufacturallog = log(city1$manufactural)

c11 = locpol(urbangroth1~manufacturallog, city1, xevalLen = 167) # can't be computed for 
c12 = locpol(urbangroth1~RD, city1, xevalLen = 167)
c13 = locpol(urbangroth1~eduction, city1, xevalLen = 167)
c14 = locpol(urbangroth1~openness, city1, xevalLen = 167)

# plot 11
c1 = c11 # change here
dev <- sqrt(c11$CIwidth * c11$lpFit$var/c11$lpFit$xDen)
maxY = max(  c11$lpFit[,c11$Y]+ 2*dev )
minY = min(  c11$lpFit[,c11$Y]- 2*dev )

plot(city1$urbangroth1~city1$manufacturallog, # Change here
      type = "n", xlab = "log(Manufacture)", # Change here
	ylab = "Coefficient", main = "", cex.lab=1.5, cex.main = 2, cex.axis = 1.5,
      ylim = c(minY, maxY)    )
points(c1$lpFit[,c1$X],c1$lpFit[,c1$Y],type="l",lwd = 2, col="blue")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]+ 2*dev,type="l",lty = 2,lwd = 2, col="green")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]- 2*dev,type="l",lty = 2,lwd = 2, col="green")

# plot 12
c11= c12
c1 = c12 

dev <- sqrt(c11$CIwidth * c11$lpFit$var/c11$lpFit$xDen)
maxY = max(  c11$lpFit[,c11$Y]+ 2*dev )
minY = min(  c11$lpFit[,c11$Y]- 2*dev )

plot(city1$urbangroth1~city1$RD, # Change here
      type = "n", xlab = "R&D", # Change here
	ylab = "Coefficient", main = "", cex.lab=1.5, cex.main = 2, cex.axis = 1.5, 
      ylim = c(minY, maxY )    )
points(c1$lpFit[,c1$X],c1$lpFit[,c1$Y],type="l",lwd = 2, col="blue")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]+ 2*dev,type="l",lty = 2,lwd = 2, col="green")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]- 2*dev,type="l",lty = 2,lwd = 2, col="green")

# plot 13
c11 = c13
c1 = c13

dev <- sqrt(c11$CIwidth * c11$lpFit$var/c11$lpFit$xDen)
maxY = max(  c11$lpFit[,c11$Y]+ 2*dev )
minY = min(  c11$lpFit[,c11$Y]- 2*dev )

plot(city1$urbangroth1~city1$eduction, # Change here
      type = "n", xlab = "Education", # Change here
	ylab = "Coefficient", main = "", cex.lab=1.5, cex.main = 2, cex.axis = 1.5,
      ylim = c(minY, maxY)    )
points(c1$lpFit[,c1$X],c1$lpFit[,c1$Y],type="l",lwd = 2, col="blue")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]+ 2*dev,type="l",lty = 2,lwd = 2, col="green")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]- 2*dev,type="l",lty = 2,lwd = 2, col="green")

# plot 14
c11 = c14
c1 = c14


dev <- sqrt(c11$CIwidth * c11$lpFit$var/c11$lpFit$xDen)
maxY = max(  c11$lpFit[,c11$Y]+ 2*dev )
minY = min(  c11$lpFit[,c11$Y]- 2*dev )

plot(city1$urbangroth1~city1$openness, # Change here
      type = "n", xlab = "Openness", # Change here
	ylab = "Coefficient", main = "", cex.lab=1.5, cex.main = 2, cex.axis = 1.5,
      ylim = c(minY, maxY )    )
points(c1$lpFit[,c1$X],c1$lpFit[,c1$Y],type="l",lwd = 2, col="blue")
dev <- sqrt(c1$CIwidth * c1$lpFit$var/c1$lpFit$xDen)
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]+ 2*dev,type="l",lty = 2,lwd = 2, col="green")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]- 2*dev,type="l",lty = 2,lwd = 2, col="green")

#####################################################
#
#          Part 2: The second part
#
#####################################################

city = read.csv("d:/github/Research/visualization/city3.csv", header = T, sep = ",")

city$urb1997log = log(city$urb1997)

c2 = locpol(urbangroth~urb1997log, city, xeval= city$urb1997log); dim(c2$lpFit)

d2 = data.frame(city$urb1997log, city$urbangroth)
dev <- sqrt(c2$CIwidth * c2$lpFit$var/c2$lpFit$xDen)
maxY = max(  c2$lpFit[,c2$Y]+ 2*dev  )
minY = min(  c2$lpFit[,c2$Y]- 2*dev  )
plot(d2, type = "n", xlab = "log(Urban GDP in 1997)", 
	ylab = "Economic growth", main = "", cex.lab=1.5, ylim = c(minY, maxY))
points(c2$lpFit[,c2$X],c2$lpFit[,c2$Y],type="l",lwd = 2, col="blue")
lines(c2$lpFit[,c2$X],c2$lpFit[,c2$Y]+ 2*dev,type="l",lty = 2,lwd = 2, col="green")
lines(c2$lpFit[,c2$X],c2$lpFit[,c2$Y]- 2*dev,type="l",lty = 2,lwd = 2, col="green")

# second plot
orderId2 = order(city$urb1997log)
city2 = city[with(city, orderId2), ]
city2 = data.frame(city2, c2$lpFit)
city2$manufacturallog = log(city2$manufactural)

c21 = locpol(urbangroth1~manufacturallog, city2, xevalLen = 167) # can't be computed for 
c22 = locpol(urbangroth1~RD, city2, xevalLen = 167)
c23 = locpol(urbangroth1~eduction, city2, xevalLen = 167)
c24 = locpol(urbangroth1~openness, city2, xevalLen = 167)


# plot 21
c1 = c21 # change here
c11 = c21
city1 = city2

dev <- sqrt(c11$CIwidth * c11$lpFit$var/c11$lpFit$xDen)
maxY = max(  c11$lpFit[,c11$Y]+ 2*dev )
minY = min(  c11$lpFit[,c11$Y]- 2*dev )

plot(city1$urbangroth1~city1$manufacturallog, # Change here
      type = "n", xlab = "log(Manufacture)", # Change here
	ylab = "Coefficient", main = "", cex.lab=1.5, cex.main = 2, cex.axis = 1.5,
      ylim = c(minY, maxY)    )
points(c1$lpFit[,c1$X],c1$lpFit[,c1$Y],type="l",lwd = 2, col="blue")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]+ 2*dev,type="l",lty = 2,lwd = 2, col="green")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]- 2*dev,type="l",lty = 2,lwd = 2, col="green")

# plot 22
c11= c22
c1 = c22 
city1 = city2

dev <- sqrt(c11$CIwidth * c11$lpFit$var/c11$lpFit$xDen)
maxY = max(  c11$lpFit[,c11$Y]+ 2*dev )
minY = min(  c11$lpFit[,c11$Y]- 2*dev )

plot(city1$urbangroth1~city1$RD, # Change here
      type = "n", xlab = "R&D", # Change here
	ylab = "Coefficient", main = "", cex.lab=1.5, cex.main = 2, cex.axis = 1.5, 
      ylim = c(minY, maxY )    )
points(c1$lpFit[,c1$X],c1$lpFit[,c1$Y],type="l",lwd = 2, col="blue")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]+ 2*dev,type="l",lty = 2,lwd = 2, col="green")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]- 2*dev,type="l",lty = 2,lwd = 2, col="green")

# plot 23
c11 = c23
c1 = c23
city1 = city2

dev <- sqrt(c11$CIwidth * c11$lpFit$var/c11$lpFit$xDen)
maxY = max(  c11$lpFit[,c11$Y]+ 2*dev )
minY = min(  c11$lpFit[,c11$Y]- 2*dev )

plot(city1$urbangroth1~city1$eduction, # Change here
      type = "n", xlab = "Education", # Change here
	ylab = "Coefficient", main = "", cex.lab=1.5, cex.main = 2, cex.axis = 1.5,
      ylim = c(minY, maxY)    )
points(c1$lpFit[,c1$X],c1$lpFit[,c1$Y],type="l",lwd = 2, col="blue")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]+ 2*dev,type="l",lty = 2,lwd = 2, col="green")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]- 2*dev,type="l",lty = 2,lwd = 2, col="green")

# plot 24
c11 = c24
c1 = c24
city1 = city2


dev <- sqrt(c11$CIwidth * c11$lpFit$var/c11$lpFit$xDen)
maxY = max(  c11$lpFit[,c11$Y]+ 2*dev )
minY = min(  c11$lpFit[,c11$Y]- 2*dev )

plot(city1$urbangroth1~city1$openness, # Change here
      type = "n", xlab = "Openness", # Change here
	ylab = "Coefficient", main = "", cex.lab=1.5, cex.main = 2, cex.axis = 1.5,
      ylim = c(minY, maxY )    )
points(c1$lpFit[,c1$X],c1$lpFit[,c1$Y],type="l",lwd = 2, col="blue")
dev <- sqrt(c1$CIwidth * c1$lpFit$var/c1$lpFit$xDen)
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]+ 2*dev,type="l",lty = 2,lwd = 2, col="green")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]- 2*dev,type="l",lty = 2,lwd = 2, col="green")


#----------------------save figures-------------------------------~#

## to save Tiff with dpi 2000

png("D:/Fig1_Mining.png", 
	width=12, height=4, pointsize = 10,
	units="in", res=400) 
par(mfrow=c(1,5))


png("D:/Fig2_Urb1997.png", 
	width=12, height=4, pointsize = 10,
	units="in", res=400) 
par(mfrow=c(1,5))

# stop saving figure
dev.off()


###################################################################
#
#
###################################################################
library(minerva)
library(igraph)

data(mtcars)
mic = mine(mtcars)$MIC
corel = cor(mtcars)
# 保存图片格式
png("d:/mic_graph4.png", 
    width=8, height=8, 
    units="in", res=300)

par(mfrow=c(2,2))

#-----plot the mic networks--------------#
g <- graph.adjacency(mic, mode="undirected", weighted=TRUE ,diag=FALSE)
# full mic network
V(g)$name = names(mtcars)
edge = (E(g)$weight*5)
V(g)$label.cex = 2
plot(g, layout = layout.circle, edge.color="grey", edge.width= edge, vertex.size = 1, 
		xlab = "Full MIC Network")
# strong-mic network
g1 <- delete.edges(g, which(   E(g)$weight < mean( E(g)$weight)  )   )
l1<-layout.fruchterman.reingold(g1)
edge1 = (E(g1)$weight*5)
V(g1)$label.cex = 2
E(g1)$curved <- TRUE
plot(g1, layout = l1, edge.color="grey",
         edge.width= edge1, vertex.size = 5, , xlab = "Strong MIC Network")
# correlation network
g2 <- graph.adjacency(corel, mode="undirected", weighted=TRUE ,diag=FALSE)
V(g2)$name = names(mtcars)
edge2 = abs(E(g2)$weight*5)
V(g2)$label.cex = 2
plot(g2, layout = layout.circle, edge.color=ifelse(E(g2)$weight > 0, "grey","red"),
		 edge.width= edge, vertex.size = 1, xlab = "Full Correlation Network")

g3 <- delete.edges(g2, which(   abs(E(g2)$weight) < mean( abs(E(g2)$weight))  )   )
l2<-layout.fruchterman.reingold(g3)
edge3 = abs(E(g3)$weight*5)
V(g3)$label.cex = 2
E(g3)$curved <- TRUE
plot(g3, layout = l2, edge.color=ifelse(E(g3)$weight > 0, "blue","red"), 
         edge.width= edge1, vertex.size = 5, xlab = "Strong Correlation Network")
#------------------------------------------#

# 结束保存图片
dev.off()



