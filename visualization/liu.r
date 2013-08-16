# 刘耀彬:R软件制作图形的问题


# 见我发给你《中国经济评论》的论文，最后传导机制部分，作者用了
# 局部多重分析法得到图形，该图反映的是三维效果，
# 横轴是机制变量，
# 纵轴是经济增长与采矿的多重分析法系数。

# 现在R文件包中有这个，但是我怎么也到不到类似这样的图形。


#　现在我做的工作是研究城市化进程中的资源诅咒：
# 一是做城市化增长与城市化原始水平的关系，但是由4个机制变量控制，形成4个图；
# 二是做城市化增长与矿业水平的关系，也是由4个机制变量控制。
#--------------load data-----------------#

city = read.csv("d:/github/Research/visualization/city3.csv", header = T, sep = ",")
library(locpol)
c1 = locpol(urbangroth~mining, city, xeval= city$mining); dim(c1$lpFit)

#---------1th plot -----------------------#
d = data.frame(city$mining, city$urbangroth)
dev <- sqrt(c1$CIwidth * c1$lpFit$var/c1$lpFit$xDen)
maxY = max(  c1$lpFit[,c1$Y]+ 2*dev  )
minY = min(  c1$lpFit[,c1$Y]- 2*dev  )
plot(d, type = "n", xlab = "Mining", ylab = "Economic growth", cex.lab=1.5, ylim = c(minY, maxY))
points(c1$lpFit[,c1$X],c1$lpFit[,c1$Y],type="l",lwd = 2, col="blue")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]+ 2*dev,type="l",lty = 2,lwd = 2, col="green")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]- 2*dev,type="l",lty = 2,lwd = 2, col="green")
#----------2nd plot-----------------------#
orderId = order(city$mining)
city2 = city[with(city, orderId), ]
city2 = data.frame(city2, c1$lpFit)
city2$LOGmanufactural = log(city2$manufactural)
c21 = locpol(urbangroth1~LOGmanufactural, city2, xevalLen = 167) # can't be computed for 
c22 = locpol(urbangroth1~RD, city2, xevalLen = 167)
c23 = locpol(urbangroth1~eduction, city2, xevalLen = 167)
c24 = locpol(urbangroth1~openness, city2, xevalLen = 167)


# plot 21
c1 = c21 # change here
dev <- sqrt(c21$CIwidth * c21$lpFit$var/c21$lpFit$xDen)
maxY = max(  c21$lpFit[,c21$Y]+ 2*dev )
minY = min(  c21$lpFit[,c21$Y]- 2*dev )

plot(city2$urbangroth1~city2$LOGmanufactural, # Change here
      type = "n", xlab = "Manufactural(Log)", # Change here
	ylab = "Coefficient", main = "Economic growth", cex.lab=1.5, cex.main = 2, cex.axis = 1.5,
      ylim = c(minY, maxY )    )
points(c1$lpFit[,c1$X],c1$lpFit[,c1$Y],type="l",lwd = 2, col="blue")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]+ 2*dev,type="l",lty = 2,lwd = 2, col="green")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]- 2*dev,type="l",lty = 2,lwd = 2, col="green")

# plot 22
c21 = c22
c1 = c22 

dev <- sqrt(c21$CIwidth * c21$lpFit$var/c21$lpFit$xDen)
maxY = max(  c21$lpFit[,c21$Y]+ 2*dev )
minY = min(  c21$lpFit[,c21$Y]- 2*dev )

plot(city2$urbangroth1~city2$RD, # Change here
      type = "n", xlab = "R&D", # Change here
	ylab = "Coefficient", main = "Economic growth", cex.lab=1.5, cex.main = 2, cex.axis = 1.5, 
      ylim = c(minY, maxY )    )
points(c1$lpFit[,c1$X],c1$lpFit[,c1$Y],type="l",lwd = 2, col="blue")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]+ 2*dev,type="l",lty = 2,lwd = 2, col="green")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]- 2*dev,type="l",lty = 2,lwd = 2, col="green")

# plot 23
c21 = c23
c1 = c23

dev <- sqrt(c21$CIwidth * c21$lpFit$var/c21$lpFit$xDen)
maxY = max(  c21$lpFit[,c21$Y]+ 2*dev )
minY = min(  c21$lpFit[,c21$Y]- 2*dev )

plot(city2$urbangroth1~city2$eduction, # Change here
      type = "n", xlab = "Education", # Change here
	ylab = "Coefficient", main = "Economic growth", cex.lab=1.5, cex.main = 2, cex.axis = 1.5,
      ylim = c(minY, maxY )    )
points(c1$lpFit[,c1$X],c1$lpFit[,c1$Y],type="l",lwd = 2, col="blue")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]+ 2*dev,type="l",lty = 2,lwd = 2, col="green")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]- 2*dev,type="l",lty = 2,lwd = 2, col="green")

# plot 24
c21 = c24
c1 = c24


dev <- sqrt(c21$CIwidth * c21$lpFit$var/c21$lpFit$xDen)
maxY = max(  c21$lpFit[,c21$Y]+ 2*dev )
minY = min(  c21$lpFit[,c21$Y]- 2*dev )

plot(city2$urbangroth1~city2$openness, # Change here
      type = "n", xlab = "Openness", # Change here
	ylab = "Coefficient", main = "Economic growth", cex.lab=1.5, cex.main = 2, cex.axis = 1.5,
      ylim = c(minY, maxY )    )
points(c1$lpFit[,c1$X],c1$lpFit[,c1$Y],type="l",lwd = 2, col="blue")
dev <- sqrt(c1$CIwidth * c1$lpFit$var/c1$lpFit$xDen)
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]+ 2*dev,type="l",lty = 2,lwd = 2, col="green")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]- 2*dev,type="l",lty = 2,lwd = 2, col="green")
##

     2 * dev
 

# names(c1) # see what the locpol returns
# confInterval(c1$lpFit) # it doesn't work
# residuals(c1)
# names(c1$lpFit) # see what lpFit returns
# [1] "mining"      "urbangroth"  "urbangroth1" "xDen"        "var"  
# Data frame with the local polynomial fit contains:
# covariate, response, derivatives estimation, X density estimation, and variance estimation.
# Variance is the average of the squared differences from the Mean.
# SD is the square root of the Variance. 
# c1$lpFit[,c1$X]
# c1$lpFit[,c1$Y]
# bw	Smoothing parameter, bandwidth.
