# parrallel in R
# CHENGJUN
# 2013 Oct 26


library(foreach)

"http://cran.r-project.org/web/packages/foreach/vignettes/foreach.pdf"

x <- foreach(i=1:4, .combine='cbind') %do% rnorm(4)



library(tnet)


# Local Weighted Rich-club Effect
net <- cbind(
  i=c(1,1,2,2,2,2,3,3,4,5,5,6),
  j=c(2,3,1,3,4,5,1,2,2,2,6,5),
  w=c(4,2,4,4,1,2,2,4,1,2,1,1))

out <- weighted_richclub_w(net, rich="k", reshuffle="links", NR=1000, seed=1)

# Plot output
plot(out[,c("x","y")], type="b", log="x", 
     xlim=c(1, max(out[,"x"]+1)), ylim=c(0,max(out[,"y"])+0.5), 
     xaxs = "i", yaxs = "i", ylab="Weighted Rich-club Effect", xlab="Prominence (degree greater than)")
lines(out[,"x"], rep(1, nrow(out)))



