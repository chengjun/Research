#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~visualize data~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
digg<-read.csv(file= "d:/micro-blog/digg/digg_diffusion_data_for_gvisAnnotatedTimeLine.csv", head=T,sep = ",")
sam<-sample(digg$news_id, 120, replace = FALSE, prob = NULL)
digg120<-subset(digg, digg$news_id%in%sam)  #Select data 
dim(digg120)

digg120$news_id<-as.character(digg120$news_id)
library(googleVis)
AnnoTimeLine  <- gvisAnnotatedTimeLine(digg120, datevar="time",
                           numvar="num_sum", idvar="news_id",
                           titlevar="", annotationvar="",
                           options=list(displayAnnotations=TRUE,
                             legendPosition='newRow',
                             width=1000, height=600)
                           )
# Display chart
plot(AnnoTimeLine) 
setwd("d:/micro-blog/digg/")
cat(AnnoTimeLine$html$chart, file="AnnoTimeLine_digg120.html")