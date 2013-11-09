# spatial data analysis using R
# 2013 Nov 8 @ amoy
# cheng-jun wang


###########
"Download all the R scripts"
###########
ASDAR_BOOK <- "http://www.asdar-book.org/book2ed"
chapters <- c("hello", "cm", "vis", "die", "cm2",
              "std", "sppa", "geos", "lat", "dismap")
# setwd() # move to download folder
for (i in chapters) {
  fn <- paste(i, "mod.R", sep="_")
  download.file(paste(ASDAR_BOOK, fn, sep = "/"), fn)
}
list.files()




library(maps)

state.map = map("state", plot = F, fill = T )
IDs = sapply(strsplit(state.map$names, ":"), function(x) x[1])

library(maptools)
state.sp = map2SpatialPolygons(state.map, IDs = IDs, 
                               proj4string = CRS("+proj=longlat +ellps=WGS84"))



#####
"p60 plot with sp"
#####

library(sp)
data(meuse)

coordinates(meuse) = c("x", "y") # sets spatial coordinates to create spatial data
plot(meuse); title("points")

cc = coordinates(meuse)
m.sl = SpatialLines(
  list(
    Lines(list(Line(cc)), "line1")
    )
  )
plot(m.sl); title("lines")













