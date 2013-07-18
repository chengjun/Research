library(googleVis)
df <- data.frame(Address = c("City university of Hong kong", "18 Tat Hong Avenue"),
                 Tip = c("Main Campus", "CMC & Residence Hall"))
mymap <- gvisMap(df, "Address", "Tip", options = list(showTip = TRUE, mapType = "normal",
                 enableScrollWheel = TRUE))
plot(mymap) # preview
setwd("d:/micro-blog/digg/")
cat(mymap$html$chart, file="gvisMap.html")