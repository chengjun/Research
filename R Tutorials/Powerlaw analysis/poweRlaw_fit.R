# powerlaw fit and plot
# Chengjun @cmc, 2013 Nov 1




# install.packages("poweRlaw")

library(poweRlaw)

##############################################################
# Load data and create distribution object #
##############################################################
data(moby)
m = displ$new(moby)

m$getXmin()
m$getPars()

estimate_xmin(m, pars = seq(1.5, 2.5, 0.1))


m$setXmin(2)
m$setPars(2)

estimate_pars(m)$pars; m$pars

plot(m)
lines(m)

##############################################################
#Load data and create distribution object #
##############################################################
data("native_american")
data("us_american")

m_na = displ$new(native_american$Cas)
m_us = displ$new(us_american$Cas)

est_na = estimate_xmin(m_na, pars = seq(1.5, 2.5, 0.001))
est_us = estimate_xmin(m_us, pars = seq(1.5, 2.5, 0.001))

m_na$setXmin(est_na)
m_us$setXmin(est_us)

plot(m_na, pch = 0)
lines(m_na)

## Don't create a new plot Just store the output
d = plot(m_us, draw = FALSE)
points(d$x, d$y, col = 2, pch = 1)
lines(m_us, col = 2)

legend("topright", # places a legend at the appropriate place 
       c(as.character(m_na$pars), as.character(m_us$pars)), # puts text in the legend 
       box.lwd = 0, box.col =NA, bg = NA,
       pt.cex = c(1, 1), cex = 1,
       lwd = c(1, 1),lty = c(0, 0),
       pch=c(0, 1), col=c('black','red')) #


