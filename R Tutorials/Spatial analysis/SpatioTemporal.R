# spatial-temporal analysis
# chengjun wang
# 2013 Oct 26

library(SpatioTemporal)
library(plotrix)
library(maps)

data(mesa.data.raw, package="SpatioTemporal")

names(mesa.data.raw)

##extract matrix of observations (missing marked by NA)
obs.mat <- mesa.data.raw$obs
head(obs.mat)

##optionally observations can be given as a data.frame
obs <- data.frame(obs=c(obs.mat),
                  date=rep(rownames(obs.mat), dim(obs.mat)[2]),
                  ID=rep(colnames(obs.mat), each=dim(obs.mat)[1]))
##force date-format
obs$date <- as.Date(obs$date)

##drop unobserved
obs <- obs[!is.na(obs$obs),,drop=FALSE]

##create a 3D-array for the spatio-temporal covariate
ST <- array(mesa.data.raw$lax.conc.1500, dim =
              c(dim(mesa.data.raw$lax.conc.1500),1))
dimnames(ST) <- list(rownames(mesa.data.raw$lax.conc),
                     colnames(mesa.data.raw$lax.conc),
                     "lax.conc.1500")
##or use a list of matrices
ST.list <- list(lax.conc.1500=mesa.data.raw$lax.conc.1500)

###########################
## create STdata object ##
###########################
##Create the data-object
mesa.data <- createSTdata(obs.mat, mesa.data.raw$X, n.basis=2,
                          SpatioTemporal=ST)
mesa.data.2 <- createSTdata(obs, mesa.data.raw$X, n.basis=2,
                            SpatioTemporal=ST.list)

##This should yield equal structures,
##which are also the same as data(mesa.data)
all.equal(mesa.data, mesa.data.2)

###########################
## create STmodel object ##
###########################
##define land-use covariates, for intercept and trends
LUR <- list(~log10.m.to.a1+s2000.pop.div.10000+km.to.coast,
            ~km.to.coast, ~km.to.coast)
##and covariance model
cov.beta <- list(covf="exp", nugget=FALSE)
cov.nu <- list(covf="exp", nugget=~type, random.effect=FALSE)
##which locations to use
locations <- list(coords=c("x","y"), long.lat=c("long","lat"), others="type")
##create object
mesa.model <- createSTmodel(mesa.data, LUR=LUR, ST="lax.conc.1500",
                            cov.beta=cov.beta, cov.nu=cov.nu,
                            locations=locations)

##This should be the same as the data in data(mesa.model)


##create vector of initial values
dim <- loglikeSTdim(mesa.model)
x.init <- cbind(c( rep(2, dim$nparam.cov-1), 0),
                c( rep(c(1,-3), dim$m+1), -3, 0))
rownames(x.init) <- loglikeSTnames(mesa.model, all=FALSE)

## Not run: 
##estimate parameters
est.mesa.model <- estimate(mesa.model, x.init, hessian.all=TRUE)

## End(Not run)

##time consuming estimation, load pre-computed results instead
# data(est.mesa.model)

#estimation results
print(est.mesa.model)

##compare the estimated parameters for the two starting points
est.mesa.model$summary$par.all
##and values of the likelihood (and convergence info)
est.mesa.model$summary$status

##extract the estimated parameters and approximate uncertainties
x <- coef(est.mesa.model)

##compare estimated parameters
##plot the estimated parameters with uncertainties
par(mfrow=c(1,1),mar=c(13.5,2.5,.5,.5))
with(x, plot(par, ylim=range(c(par-1.96*sd, par+1.96*sd)),
             xlab="", xaxt="n"))
with(x, points(par - 1.96*sd, pch=3))
with(x, points(par + 1.96*sd, pch=3))

abline(h=0, col="grey")
##add axis labels
axis(1, 1:length(x$par), rownames(x), las=2)

## Not run: 
##example using a few fixed parameters
x.fixed <- coef(est.mesa.model)$par
x.fixed[c(1,2,5:9)] <- NA
est.fix <- estimate(mesa.model, x.init, x.fixed, type="p")

## End(Not run)

