library(scholar)
library(ggplot2)

setwd("D:/github/Research/R Tutorials/citation analysis")

####
"Get profile"
####

id <- 'B7vSqZsAAAAJ'
feynman <- get_profile(id)

####
"Compare scholars"
####

ids = c("q41vFFQAAAAJ", "DRCZyOYAAAAJ", ,"NLGq07QAAAAJ", "A9-9VKsAAAAJ", "iF4HlRQAAAAJ")
# Compare their career trajectories, based on year of first citation
df <- compare_scholar_careers(ids)

ggplot(df, aes(x=career_year, y=cites, colour=name)) + geom_line(aes(linetype=name), size = 1.5) + theme_bw()

png(paste(getwd(), "/lab.Member.academic_tragectory.png", sep = ""), 
    width=10, height=6, 
    units="in", res=300)

ggplot(df, aes(x=career_year, y=cites, colour=name)) + geom_line(size = 1.5) + theme_bw()

dev.off()

#####
"Predict h-index"
#####

h_index = NULL
for (i in ids) h_index[[i]] =  predict_h_index(i)

