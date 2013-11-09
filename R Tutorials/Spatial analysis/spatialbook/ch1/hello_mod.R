### R code from vignette source 'hello.Rnw'
### Encoding: UTF-8
# Data: data1964al.xy



setwd("D:/github/Research/R Tutorials/Spatial analysis/spatialbook/ch1/")
###################################################
### code chunk number 8: hello.Rnw:394-397
###################################################
library(maptools)
library(maps)
library(rgdal)


###################################################
### code chunk number 9: hello.Rnw:402-436
###################################################
# load data
volc.tab = read.table("data1964al.xy")

volc.tabc = volc.tab[c(2,1)]# change the column sequence first
volc = SpatialPoints(volc.tabc) 
names(attributes(volc))　# see the names of volc's attributes
attributes(volc)$bbox
attributes(volc)$proj4string # NA, needs to set CRS

# Two kinds of projection
llCRS <- CRS("+proj=longlat +ellps=WGS84")
proj4string(volc) <- llCRS # Sets or retrieves projection attributes

prj_new = CRS("+proj=moll")
volc_proj = spTransform(volc, prj_new) # spTranform is very useful.

# load the world map from maps package
wrld <- map("world", interior=FALSE, xlim=c(-179,179), ylim=c(-89,89),
            plot=F)

wrld_p <- pruneMap(wrld, xlim=c(-179,179)) # Convert map objects to sp classes
wrld_sp <- map2SpatialLines(wrld_p, proj4string=llCRS)
wrld_proj <- spTransform(wrld_sp, prj_new)
#save(c("wrld_proj", "wrld_sp"), file = "hsd_data/wrld.RData")
#load("hsd_data/wrld.RData")
# get the grid lines
wrld_grd <- gridlines(wrld_sp, easts=c(-179,seq(-150,150,50),179.5), 
                      norths=seq(-75,75,15), ndiscr=100)
wrld_grd_proj <- spTransform(wrld_grd, prj_new)
at_sp <- gridat(wrld_sp, easts=0, norths=seq(-75,75,15), offset=0.3)
at_proj <- spTransform(at_sp, prj_new)

# plot volcanos on the world map
# Plot
par(mar=c(6, 1, 6, 1)) 
plot(wrld_p, col= "grey", type = "l", axes = F, ylab = "", xlab = "")
plot(volc, col="red", add = T, cex = 0.8, pch = 19)

# Plot
par(mfrow=c(1,1))
plot(wrld_proj, col="grey50")
plot(wrld_grd_proj, add=TRUE, lty=3, col="grey50")
points(volc_proj, cex = 1, pch = 19, col = "red")
title("Volcanos in the World")
text(coordinates(at_proj), pos=at_proj$pos, offset=at_proj$offset, 
     labels=parse(text=as.character(at_proj$labels)), cex=1)


###################################################
### code chunk number 10: hello.Rnw:573-610
###################################################
library(sp)
data(volcano)
grey_gamma <- 2.2
grys <- grey.colors(8, 0.55, 0.95, grey_gamma)

layout(matrix(c(1,2,1,3,1,4),3,2,byrow=TRUE), c(3,1))

# a
image(volcano, axes=FALSE, col=grys, asp=1, main="a")
contour(volcano, add=TRUE)
box()

# b:
image(volcano, axes=FALSE, col='white', asp=1, main="b")
library(maptools)
x2 = ContourLines2SLDF(contourLines(volcano))
plot(x2, add=TRUE)
box()

# c:
image(volcano, axes=FALSE, col='white', asp=1, main="c")
plot(x2[x2$level == 140,], add=TRUE)
box()

# d:
image(volcano, axes=FALSE, col=grys, asp=1, main="d")
x3l1 = coordinates(x2[x2$level == 160,])[[1]][[1]]
x3l2 = coordinates(x2[x2$level == 160,])[[1]][[2]]
x3 = SpatialPolygons(list(Polygons(list(Polygon(x3l1,hole=FALSE), 
                                        Polygon(x3l2,hole=TRUE)), ID=c("x"))))
plot(x3, col = '#FF8800', add = TRUE)
box()

