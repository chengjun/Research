# meta analysis of news diffusion
# chengjun wang
# 20120312


meta<-read.table("D:/Dropbox Loop/News diffusion/writings/60 years of news diffusion reveiw/meta data.txt",
                     as.is = !stringsAsFactors, header = T, sep = "")
#~~~~~~~~~~~~~~~~~~~~~bubbleplot~~~~~~~~~~~~~~~~~~~~#
# refer to http://flowingdata.com/2010/11/23/how-to-make-bubble-charts/
SampleSize<-as.numeric(levels(meta$Sample_size)[meta$Sample_size])

Media_effect<-(levels(meta$Media_effect)[meta$Media_effect])
Social_Influence<-(levels(meta$Social_Influence)[meta$Social_Influence])
Diffusion_Extent<-(levels(meta$diffusion_Extent)[meta$diffusion_Extent])

MediaEffect<-as.numeric(sub("%", "", Media_effect))/100
SocialInfluence<-as.numeric(sub("%", "", Social_Influence))/100
DiffusionExtent<-as.numeric(sub("%", "", Diffusion_Extent))/100

radius <- sqrt( SampleSize*10000 )

# for media effect
symbols(MediaEffect, DiffusionExtent, circles=radius,
        inches=0.35, fg="white", bg="red", 
        xlab="Media Effect", ylab="Diffusion Extent")
text(MediaEffect, DiffusionExtent, SampleSize, cex=0.65)
# for social influence
symbols(SocialInfluence, DiffusionExtent, circles=radius,
        inches=0.35, fg="white", bg="red", 
        xlab="Social Influence", ylab="Diffusion Extent")
text(SocialInfluence, DiffusionExtent, SampleSize, cex=0.65)

#~~~~~~~~~~~~~~~~~~~~~plot3d~~~~~~~~~~~~~~~~~~~~~~~~#
# install.packages("scatterplot3d")
library(scatterplot3d) 
names(meta)
# as.numeric(levels(size)[size])
meta$Media_effect
meta$Social_Influence
meta$diffusion_Extent
# as.numeric("10%") # this is a new problem.
# percent_vec = paste(1:100, "%", sep = "")
# as.numeric(sub("%", "", percent_vec))
# http://stackoverflow.com/questions/8329059/how-to-convert-character-of-percentage-into-numeric-in-r

Media_effect<-(levels(meta$Media_effect)[meta$Media_effect])
Social_Influence<-(levels(meta$Social_Influence)[meta$Social_Influence])
diffusion_Extent<-(levels(meta$diffusion_Extent)[meta$diffusion_Extent])

Media_effect<-as.numeric(sub("%", "", Media_effect))/100
Social_Influence<-as.numeric(sub("%", "", Social_Influence))/100
diffusion_Extent<-as.numeric(sub("%", "", diffusion_Extent))/100

scatterplot3d(Media_effect,Social_Influence,diffusion_Extent, pch=16, highlight.3d=TRUE,
  type="h", main="3D Scatterplot")
# fit <- lm(mpg ~ wt+disp) 
# s3d$plane3d(fit)

library(rgl)
plot3d( diffusion_Extent,Media_effect, Social_Influence, col="red", size=3)

library(Rcmdr) # install.packages("rgl")
scatter3d(Media_effect, Social_Influence, diffusion_Extent)