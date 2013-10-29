# tnet rich-club 
# Chengjun Wang
# 2013 Oct 25


library(tnet)

#####
"The weighted rich-club effect"
#####

# weighted_richclub_w(net, rich="k", reshuffle="weights", NR=1000, nbins=30, seed=NULL, directed=NULL)
# Returns a table with the fraction of phi(observed) over phi(null) for each k or s in the dataset.

# Global Weighted Rich-club Effect
# Load the neural network of the c. elegans worm
data(tnet)
net <- cbind(
  i=c(1,1,2,2,2,2,3,3,4,5,5,6),
  j=c(2,3,1,3,4,5,1,2,2,2,6,5),
  w=c(4,2,4,4,1,2,2,4,1,2,1,1))

# Calculate the weighted rich-club coefficient using degree as a prominence parameter and link-reshuffled random networks
# out <- weighted_richclub_w(celegans.n306.net, rich="k", reshuffle="links", NR=1000, seed=1)
out <- weighted_richclub_w(net, rich="s", reshuffle="links", NR=1000, seed=1)

# Plot output
plot(out[,c("x","y")], type="b", log="x", 
     xlim=c(1, max(out[,"x"]+1)), ylim=c(0,max(out[,"y"])+0.5), 
     xaxs = "i", yaxs = "i", ylab="Weighted Rich-club Effect", xlab="Prominence (degree greater than)")
lines(out[,"x"], rep(1, nrow(out)))

# Local Weighted Rich-club Effect
# Load the above sample network

# Define prominence parameter (node 1 (A), 2 (B) and 3 (C) are designated as prominent)
prominence <- c(1,1,1,0,0,0)

# Run function
outl = weighted_richclub_local_w(net, prominence)

############
"Identifies growth mechanisms responsible for tie generation in longitudinal networks"
############
## Load sample data
t <- c('2007-09-12 13:45:00', 
       '2007-09-12 13:46:31',
       '2007-09-12 13:47:54',
       '2007-09-12 13:48:21',
       '2007-09-12 13:49:27',
       '2007-09-12 13:58:14',
       '2007-09-12 13:52:17',
       '2007-09-12 13:56:59');
i <- c(1,1,2,3,1,3,1,1);
j <- c(2,3,1,2,4,2,3,4);
w <- c(1,1,1,1,1,1,1,1);
sample <- data.frame(t, i, j, w);

t1 = OnlineSocialNetwork.n1899.net
t2 = OnlineSocialNetwork.n1899.lnet
## Run the function
gt2 = growth_l(t2, effects="indegree", nstrata=2)

#####
"Convert to igraph object"
#####

g = tnet_igraph(sample, type="weighted one-mode tnet")