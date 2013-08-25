#¡¡£Ópatial  Smooth Transition AutoRegressive¡¡(STAR) modeling
# chengjun
# 2013 Aug 20


s = read.csv("d:/github/Research/visualization/Spatial econometric model/atlanta_hom/11.csv", header = T, sep = ",")

######################################################################################
# A Spatial Econometric STAR Model #
# with an Application to U.S. County Economic Growth, 1969¨C2003 #
# (c) rjgmflorax, vopede #
# Dept. of Agricultural Economics, Purdue University #
# rflorax@purdue.edu, vpede@purdue.edu #
# Date last changed: 02.14.2009 #
######################################################################################
# load libraries
library(spdep)
library(grid)
library(sem)
library(fields)
library(MASS)
library(fUtilities) # NO AVAILABLE DAMN!
library(RColorBrewer)
library(maptools)
# library(shapefiles)

#-----------------------------load data using shapefile-------------------------------------------------------------------------#
# uscnt <- readShapePoly("d:/github/Research/visualization/Spatial econometric model/atlanta_hom/rpci.shp",IDvar="ID")
#----import weights matrix and calculate eigenvalues
# weightgal <- read.gal("d:/github/Research/visualization/Spatial econometric model/atlanta_hom/atl_hom.GAL",region.id=uscnt$ID)
#---------Data source£ºhttp://lambert.nico.free.fr/tp/data/others/atlanta_hom/---------------------------------------------------#

# NAME	county name
# STATE_NAME	state name
# STATE_FIPS	state fips code (character)
# CNTY_FIPS	county fips code (character)
# FIPS	combined state and county fips code (character)
# FIPSNO	fips code as numeric variable
# HR7984	homicide rate per 100,000 (1979-84)
# HR8488	homicide rate per 100,000 (1984-88)
# HR8893	homicide rate per 100,000 (1988-93) #Choose this as y#
# HC7984	homicide count (1979-84)
# HC8488	homicide count (1984-88)
# HC8893	homicide count (1988-93)
# PO7984	population total (1979-84)
# PO8488	population total (1984-88)
# PO8893	population total (1988-93) #choose this as x first#
# PE77	police expenditures per capita, 1977
# PE82	police expenditures per capita, 1982
# PE87	police expenditures per capita, 1987
# RDAC80	resource deprivation/affluence composite variable, 1980
# RDAC85	resource deprivation/affluence composite variable, 1985
# RDAC90	resource deprivation/affluence composite variable, 1990

uscnt <- readShapePoly("d:/github/Research/visualization/Spatial econometric model/atlanta_hom/atl_hom.shp", IDvar = "FIPSNO")
weightgal <- read.gal("d:/github/Research/visualization/Spatial econometric model/atlanta_hom/atl_hom.GAL", region.id=uscnt$FIPSNO)

plot(uscnt, border="blue", axes=TRUE, las=1)
text(coordinates(uscnt), labels=row.names(uscnt), cex=0.6)

w <- nb2mat(weightgal)
ws <- nb2listw(weightgal)
v <- eigenw(ws, quiet = TRUE) # eigenvalues
vinvmin <- 1/min(v) # minimum eigenvalue
vinvmax <- 1/max(v) # maximum eigenvalue
interval <- c(vinvmin,vinvmax) # interval to set parameter space rho

#------------- define variables--------------------------------------------------#

x <- log(uscnt$PO8587)  # PO8587 # uscnt$LN_RPC_69  #----choose independent variable: population during 1989-1995
wx <- lag.listw(ws,x)
wxx <- wx*x
y <- uscnt$HR8587 # uscnt$LN_PR_0369  #---choose depedent variable:the homocide rate during 1989-1995
wy <- lag.listw(ws,y)
n <- length(x)
I <- diag(n)

#¡¡write.table(data.frame(x, y, wx), "d:/github/Research/visualization/Spatial econometric model/atlanta_hom/nlsdata.csv", 
#		row.names = F, col.names =F, sep = ",") 


##------------nls is very fragile and hard to detect the problem
## spatial STAR model, y = Xb + Xd.G(Wx;g,c) + u
funct.nls <- nls(y ~ beta0+beta1*x+(delta0+delta1*x)/(1+exp(-gamma*(wx-c)/sd(wx))),
	start = list(beta0 = 5.14218, beta1 = -0.483006, delta0 = -11.3601, delta1 = 1.1553,
gamma = 3.1540, c = 9.97903), trace = TRUE, algorithm = "port")


## you need to guess the parameters by plotting the graphs

beta0 = 4; beta1 = -0.4; delta0 = -11.3601; delta1 = 1.1553; gamma = 13.1540; c = 9.97903

beta0+beta1*x+(delta0+delta1*x)/(1+exp(-gamma*(wx-c)/sd(wx)))

plot(y~x, xlim = c(-20,20), ylim = c(-25,25))
abline(h=0, v=0, col = "gray60")
lines(beta0+beta1*x+(delta0+delta1*x)/(1+exp(-gamma*(wx-c)/sd(wx))))


##-----------------------------------------------



summary(funct.nls)
cstar <- coef(funct.nls)
e.nonlin <- resid(funct.nls)

## null and alternative specifications
# ols, non-spatial model, y = Xb + u
funct.lin <- lm(y ~ x)
summary(funct.lin)
clin <- coef(funct.lin)
bconv.Xb <- clin[2]
e.Xb <- resid(funct.lin)

# linear spatial error model, y = Xb + (I-rW)^-1 u
funct.err <- errorsarlm(y~x,data=uscnt,ws)
summary(funct.err)
cerr <- coef(funct.err)
bconv.err <- cerr[3]
e.err <- resid(funct.err)

# spatial error STAR model, y = Xb + Xd.G(Wx;g,c) + (I-rW)^-1 u
e <- e.nonlin
crit <- 0.000001
max.iter <- 100
obj.old <- 0
for (i in 1:max.iter) {
	flerr <- function(rho) {
	(-n/2)*log((1/n)*crossprod((I-rho*w)%*%e))+sum(log(1-rho*v))
	}

	fmax <- optimize(flerr,interval=interval,maximum=TRUE)
	rho <- fmax$maximum
	irwy <- y-rho*lag.listw(ws,y)
	irwx <- x-rho*lag.listw(ws,x)
	funct.errstar <- nls(irwy ~ beta0*(1-rho)+beta1*irwx+(delta0*(1-rho)+
		delta1*irwx)/(1+exp(-gamma*(wx-c)/sd(wx))),
		start = cstar, trace = FALSE, algorithm = "port")
	cstar.err <- coef(funct.errstar)
	G <- (1+exp(-cstar.err[5]*(wx-cstar.err[6])/sd(wx)))^-1
	e <- y-(cstar.err[1]+cstar.err[2]*x+(cstar.err[3]+cstar.err[4]*x)*G)
	if (abs(fmax$objective - obj.old) <= crit) break
	obj.old <- fmax$objective
}

# estimates and inference for beta, delta, gamma and c
summary(funct.errstar)
# estimate and inference for rho
sig2 <- crossprod(e-rho*lag.listw(ws,e))/n
varsig2 <- n/(2*sig2^2)
wirwi <- w%*%invIrW(ws,rho)
covsig2rho <- (1/sig2)*sum(diag(wirwi))
varrho <- (sum(diag(wirwi)))^2 + sum(diag(crossprod(wirwi)))
row1 <- c(varsig2,covsig2rho)
row2 <- c(covsig2rho,varrho)
mat <- rbind(row1,row2)
covmat <- solve(mat)
serho <- sqrt(covmat[2,2])
trho <- rho/serho
df <- n-length(cstar.err+1)
prho <- 2*pt(abs(trho),df=df,lower.tail=FALSE)
output.rho <- cbind(rho,serho,trho,prho)
print(output.rho)
## LM tests, based on linearization using first-order Taylor approximation
# LM rho = 0 given phi = 0
tr <- sum(diag(crossprod(w)))+sum(diag(w%*%w))
we <- lag.listw(ws,e.Xb)
ewe <- crossprod(e.Xb,we)
s2 <- crossprod(e.Xb)/n
LMerr.Xb <- (ewe/s2)^2/tr
pLMerr.Xb <- 1-pchisq(LMerr.Xb,df=1,ncp=0,log=FALSE)
LMerr.Xb
pLMerr.Xb
# LM phi = 0 given rho = 0
Z <- cbind(1,x,wx,wxx)
P <- Z%*%solve(crossprod(Z))%*%t(Z)
LMlin.Xb <- crossprod(e.Xb,P)%*%e.Xb/(crossprod(e.Xb)/n)
pLMlin.Xb <- 1-pchisq(LMlin.Xb,df=2,ncp=0,log=FALSE)

LMlin.Xb
pLMlin.Xb
# LM rho = phi = 0
LMerrlin.Xb <- LMerr.Xb+LMlin.Xb
pLMerrlin.Xb <- 1-pchisq(LMerrlin.Xb,df=3,ncp=0,log=FALSE)
LMerrlin.Xb
pLMerrlin.Xb
# LM phi = 0 given rho <> 0
Ztild <- Z-cerr[1]*lag.listw(ws,Z)
Ptild <- Ztild%*%solve(crossprod(Ztild))%*%t(Ztild)
LMlin.err <- crossprod(e.err,Ptild)%*%e.err/(crossprod(e.err)/n)
pLMlin.err <- 1-pchisq(LMlin.err,df=2,ncp=0,log=FALSE)
LMlin.err
pLMlin.err
# LM rho = 0 given phi <> 0
lm.nonlin <- lm(y~x+wx+wxx)
e.nonlin <- resid(lm.nonlin)
we <- lag.listw(ws,e.nonlin)
ewe <- crossprod(e.nonlin,we)
s2 <- crossprod(e.nonlin)/n
LMerr.nonlin <- (ewe/s2)^2/tr
pLMerr.nonlin <- 1-pchisq(LMerr.nonlin,df=1,ncp=0,log=FALSE)
LMerr.nonlin
pLMerr.nonlin
## Visualization
# transition function and convergence rate, -100.(ln(dydx+1)/T,
# for the spatial error STAR model
G <- (1+exp(-cstar.err[5]*(wx-cstar.err[6])/sd(wx)))^-1
aux1 <- (1+exp(-cstar.err[5]*(wx-cstar.err[6])/sd(wx)))^-2
aux2 <- cstar.err[4]+cstar.err[5]*w%*%((cstar.err[3]+cstar.err[4]*x)/sd(wx))
aux3 <- exp(-cstar.err[5]*(wx-cstar.err[6])/sd(wx))
bconv <- cstar.err[2] + (cstar.err[4]+aux2)*aux3*aux1
crate <- (-100/34)*log(1+bconv)

# map function
MAP <- function(plotvar,title,steps) {
	brks <- c(-4,0,0.25,0.5,0.75,1,1.25,1.50,1.60)
	colors <- brewer.pal(steps,"Blues")
#colors <- colors[steps:1] ## reorder colors
plot(uscnt,border="lightgray",col=colors[findInterval(plotvar,brks,all.inside=TRUE)])
	box()
	legend("bottomright",legend=leglabs(brks),fill=colors,bty="n",cex=0.7,
	y.intersp=1,x.intersp=1)
	title(x=list(title))
}
# map convergence rate and plot transition function
graph <- par(mfrow = c(2, 2))
MAP(crate,"Convergence rate (% per yr)",8)
plot(wx,G,xlab="Wx")

