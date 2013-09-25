##########################################
'Latent space network models'
##########################################
library(latentnet)
library(coda)
data(sampson)
# Fit the model for cluster sizes 1 through 4:
fits<-list(
  ergmm(samplike~euclidean(d=2,G=1)),
  ergmm(samplike~euclidean(d=2,G=2)),
  ergmm(samplike~euclidean(d=2,G=3)),
  ergmm(samplike~euclidean(d=2,G=4))
)
## Not run: # Optionally, plot all fits.
lapply(fits,plot)
## End(Not run) # Compute the BICs for the fits and plot them:
(bics<-reshape(
  as.data.frame(t(sapply(fits,
                         function(x)c(G=x$model$G,unlist(bic.ergmm(x))[c("Y","Z","overall")])))),
  list(c("Y","Z","overall")),idvar="G",v.names="BIC",timevar="Component",
  times=c("likelihood","clustering","overall"),direction="long"
))

with(bics,interaction.plot(G,Component,BIC,type="b",xlab="Clusters", ylab="BIC"))
# Summarize and plot whichever fit has the lowest overall BIC:
bestG<-with(bics[bics$Component=="overall",],G[which.min(BIC)])
summary(fits[[bestG]])
plot(fits[[bestG]])


monks.fit.mcmc<-as.mcmc.list(fits[3])
plot(monks.fit.mcmc)

raftery.diag(monks.fit.mcmc)          
samp.fit <- ergmm(samplike ~ euclidean(d=2, G=3)+rreceiver) # fit a latent clustering random effects model
plot(samp.fit)


data(davis)
# Fit a 2D 2-cluster fit and plot.
davis.fit<-ergmm(davis~euclidean(d=2,G=2)+rsociality)
plot(davis.fit,pie=TRUE,rand.eff="sociality")

# Refer to http://www.stat.washington.edu/raftery/Research/PDF/Handcock2007.pdf