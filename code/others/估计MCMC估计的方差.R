# estimation of the variance of a Markov Chain Monte Carlo estimate.

library(geoR)
library(geoRglm)

data(p50)
# asympvar 用来估计方差  Asymptotic Variance 见 [@Geyer1992]

test <- pois.krige(p50, krige = krige.glm.control(cov.pars = c(1,1), beta = 1),
                   mcmc.input = mcmc.control(S.scale = 0.5, n.iter = 100, thin = 1))
asympvar(test$intensity[45,])
ass <- asympvar(test$intensity[1:10,], type = "pos")


