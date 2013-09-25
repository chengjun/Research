# ��ҫ��:R�������ͼ�ε�����


# ���ҷ����㡶�й��������ۡ������ģ���󴫵����Ʋ��֣���������
# �ֲ����ط������õ�ͼ�Σ���ͼ��ӳ������άЧ����
# �����ǻ��Ʊ�����
# �����Ǿ���������ɿ�Ķ��ط�����ϵ����

# ����R�ļ��������������������ôҲ����������������ͼ�Ρ�


#�����������Ĺ������о����л������е���Դ���䣺
# һ�������л���������л�ԭʼˮƽ�Ĺ�ϵ��������4�����Ʊ������ƣ��γ�4��ͼ��
# ���������л��������ҵˮƽ�Ĺ�ϵ��Ҳ����4�����Ʊ������ơ�
#--------------load data-----------------#
library(locpol)

city = read.csv("d:/github/Research/visualization/city3.csv", header = T, sep = ",")

city$urbangrothlog = log(city$urbangroth)
city$mininglog = log(city$mining)
city$urb1997log = log(city$urb1997)

# whether to transform 
#��c1 = locpol(urbangroth~mining, city, xeval= city$mining); dim(c1$lpFit)
# c2 = locpol(urbangroth~urb1997, city, xeval= city$urb1997); dim(c2$lpFit)


#########################################################
#
#
#########################################################

c1 = locpol(urbangrothlog~mininglog, city, xeval= city$mininglog); dim(c1$lpFit

#---------1th plot -----------------------#

d1 = data.frame(city$mininglog, city$urbangrothlog)
dev <- sqrt(c1$CIwidth * c1$lpFit$var/c1$lpFit$xDen)
maxY = max(  c1$lpFit[,c1$Y]+ 2*dev  )
minY = min(  c1$lpFit[,c1$Y]- 2*dev  )
plot(d1, type = "n", xlab = "Mining(Log))", ylab = "Economic growth (Log)", cex.lab=1.5, ylim = c(minY, maxY))
points(c1$lpFit[,c1$X],c1$lpFit[,c1$Y],type="l",lwd = 2, col="blue")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]+ 2*dev,type="l",lty = 2,lwd = 2, col="green")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]- 2*dev,type="l",lty = 2,lwd = 2, col="green")

#----------2nd plot-----------------------#
orderId1 = order(city$mininglog)
city1 = city[with(city, orderId1), ]
city1 = data.frame(city1, c1$lpFit)
city1$manufacturallog = log(city1$manufactural)

c11 = locpol(urbangrothlog1~manufacturallog, city1, xevalLen = 167) # can't be computed for 
c12 = locpol(urbangrothlog1~RD, city1, xevalLen = 167)
c13 = locpol(urbangrothlog1~eduction, city1, xevalLen = 167)
c14 = locpol(urbangrothlog1~openness, city1, xevalLen = 167)

# plot 11
c1 = c11 # change here
dev <- sqrt(c11$CIwidth * c11$lpFit$var/c11$lpFit$xDen)
maxY = max(  c11$lpFit[,c11$Y]+ 2*dev )
minY = min(  c11$lpFit[,c11$Y]- 2*dev )

plot(city1$urbangrothlog1~city1$manufacturallog, # Change here
      type = "n", xlab = "Manufactural(Log)", # Change here
	ylab = "Coefficient", main = "Economic growth (Log)", cex.lab=1.5, cex.main = 2, cex.axis = 1.5,
      ylim = c(minY, maxY*1.2 )    )
points(c1$lpFit[,c1$X],c1$lpFit[,c1$Y],type="l",lwd = 2, col="blue")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]+ 2*dev,type="l",lty = 2,lwd = 2, col="green")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]- 2*dev,type="l",lty = 2,lwd = 2, col="green")

# plot 12
c11= c12
c1 = c12 

dev <- sqrt(c11$CIwidth * c11$lpFit$var/c11$lpFit$xDen)
maxY = max(  c11$lpFit[,c11$Y]+ 2*dev )
minY = min(  c11$lpFit[,c11$Y]- 2*dev )

plot(city1$urbangrothlog1~city1$RD, # Change here
      type = "n", xlab = "R&D", # Change here
	ylab = "Coefficient", main = "Economic growth(Log)", cex.lab=1.5, cex.main = 2, cex.axis = 1.5, 
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

plot(city1$urbangrothlog1~city1$eduction, # Change here
      type = "n", xlab = "Education", # Change here
	ylab = "Coefficient", main = "Economic growth(Log)", cex.lab=1.5, cex.main = 2, cex.axis = 1.5,
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

plot(city1$urbangrothlog1~city1$openness, # Change here
      type = "n", xlab = "Openness", # Change here
	ylab = "Coefficient", main = "Economic growth(Log)", cex.lab=1.5, cex.main = 2, cex.axis = 1.5,
      ylim = c(minY, maxY )    )
points(c1$lpFit[,c1$X],c1$lpFit[,c1$Y],type="l",lwd = 2, col="blue")
dev <- sqrt(c1$CIwidth * c1$lpFit$var/c1$lpFit$xDen)
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]+ 2*dev,type="l",lty = 2,lwd = 2, col="green")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]- 2*dev,type="l",lty = 2,lwd = 2, col="green")

#####################################################
#
#  The second part
#
#####################################################

c2 = locpol(urbangrothlog~urb1997log, city, xeval= city$urb1997log); dim(c2$lpFit)

# first plot

d2 = data.frame(city$urb1997log, city$urbangrothlog)
dev <- sqrt(c2$CIwidth * c2$lpFit$var/c2$lpFit$xDen)
maxY = max(  c2$lpFit[,c2$Y]+ 2*dev  )
minY = min(  c2$lpFit[,c2$Y]- 2*dev  )
plot(d2, type = "n", xlab = "Urban growth in 1997 (Log))", ylab = "Economic growth (Log)", cex.lab=1.5, ylim = c(minY, maxY))
points(c2$lpFit[,c2$X],c2$lpFit[,c2$Y],type="l",lwd = 2, col="blue")
lines(c2$lpFit[,c2$X],c2$lpFit[,c2$Y]+ 2*dev,type="l",lty = 2,lwd = 2, col="green")
lines(c2$lpFit[,c2$X],c2$lpFit[,c2$Y]- 2*dev,type="l",lty = 2,lwd = 2, col="green")

# second plot
orderId2 = order(city$urb1997log)
city2 = city[with(city, orderId2), ]
city2 = data.frame(city2, c2$lpFit)
city2$manufacturallog = log(city2$manufactural)

c21 = locpol(urbangrothlog1~manufacturallog, city2, xevalLen = 167) # can't be computed for 
c22 = locpol(urbangrothlog1~RD, city2, xevalLen = 167)
c23 = locpol(urbangrothlog1~eduction, city2, xevalLen = 167)
c24 = locpol(urbangrothlog1~openness, city2, xevalLen = 167)


# plot 21
c1 = c21 # change here
c11 = c21
city1 = city2

dev <- sqrt(c11$CIwidth * c11$lpFit$var/c11$lpFit$xDen)
maxY = max(  c11$lpFit[,c11$Y]+ 2*dev )
minY = min(  c11$lpFit[,c11$Y]- 2*dev )

plot(city1$urbangrothlog1~city1$manufacturallog, # Change here
      type = "n", xlab = "Manufactural(Log)", # Change here
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

plot(city1$urbangrothlog1~city1$RD, # Change here
      type = "n", xlab = "R&D", # Change here
	ylab = "Coefficient", main = "", cex.lab=1.5, cex.main = 2, cex.axis = 1.5, 
      ylim = c(minY, maxY )    )
points(c1$lpFit[,c1$X],c1$lpFit[,c1$Y],type="l",lwd = 2, col="blue")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]+ 2*dev,type="l",lty = 2,lwd = 2, col="green")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]- 2*dev,type="l",lty = 2,lwd = 2, col="green")

# plot 23
c11 = c13
c1 = c13
city1 = city2

dev <- sqrt(c11$CIwidth * c11$lpFit$var/c11$lpFit$xDen)
maxY = max(  c11$lpFit[,c11$Y]+ 2*dev )
minY = min(  c11$lpFit[,c11$Y]- 2*dev )

plot(city1$urbangrothlog1~city1$eduction, # Change here
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

plot(city1$urbangrothlog1~city1$openness, # Change here
      type = "n", xlab = "Openness", # Change here
	ylab = "Coefficient", main = "", cex.lab=1.5, cex.main = 2, cex.axis = 1.5,
      ylim = c(minY, maxY )    )
points(c1$lpFit[,c1$X],c1$lpFit[,c1$Y],type="l",lwd = 2, col="blue")
dev <- sqrt(c1$CIwidth * c1$lpFit$var/c1$lpFit$xDen)
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]+ 2*dev,type="l",lty = 2,lwd = 2, col="green")
lines(c1$lpFit[,c1$X],c1$lpFit[,c1$Y]- 2*dev,type="l",lty = 2,lwd = 2, col="green")


#----------------------save figures-------------------------------~#

## to save Tiff with dpi 2000

png("D:/WangFig1.png", 
	width=12, height=4, pointsize = 10,
	units="in", res=400) 
par(mfrow=c(1,5))


# stop saving figure
dev.off()


