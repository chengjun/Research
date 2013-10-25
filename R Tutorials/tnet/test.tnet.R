# tnet rich-club 
# Chengjun Wang
# 2013 Oct 25


library(tnet)

## Load sample data
sample <- cbind(
  i=c(1,1,2,2,2,2,3,3,4,5,5,6),
  j=c(2,3,1,3,4,5,1,2,2,2,6,5),
  w=c(4,2,4,4,1,2,2,4,1,2,1,1))
## Run the function
rcw = weighted_richclub_w(sample, rich="k", reshuffle="weights")