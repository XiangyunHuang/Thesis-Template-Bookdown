
# The empirical covariogram in Christensen, M<U+00F8>ller and Waagepetersen (2000)
# for the Poisson-log normal model can be calculated
# using the function covariog.

covar <- covariog(rongelap, uvec = c((1:20) * 40))

# Theoretical and empirical variograms can be plotted
# and visually compared. For example, the figure below shows the estimated covariogram,
# a theoretical covariogram model (which in fact was estimated)
# and an envelope (2.5 and 97.5 percent quantiles)
# based on simulating the covariogram for the model having parameters given in parms.R.

parmR <- list(cov.model = "powered.exponential", kappa = 0.843, cov.pars = c(0.31, 6702 / 61.9), beta = 1.836)
class(parmR) <- "covariomodel"
konvol <- covariog.model.env(rongelap, obj.covariog = covar, model.pars = parmR)
plot(covar, envelope.obj = konvol)
lines(parmR, max.dist = 800, lty = 1)
