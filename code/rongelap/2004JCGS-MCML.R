##
## 03-01-2005
##
## This page contains the commands used for the article
## Ole F. Christensen (2004) ``Monte Carlo maximum likelihood in model-based geostatistics''
## Journal of computational and graphical statistics 13, 702-718.

library(geoR)
library(geoRglm)
data(rongelap)

MCmle.input.fixed <- glsm.mcmc(rongelap,
  model = list(family = "poisson", link = "boxcox", cov.pars = c(2.40, 340), 
               beta = 6.2, nugget = 2.075 * 2.40, lambda = 1),
  mcmc.input = mcmc.control(S.scale = 0.5, thin = 20, burn.in = 10000)
)

## investigating mixing and convergence
library(coda)
MCmle.coda <- create.mcmc.coda(MCmle.input.fixed, mcmc.input = list(thin = 20, burn.in = 10000))
plot(MCmle.coda)
autocorr.plot(MCmle.coda)

## maximum likelihood

mcmcobj <- prepare.likfit.glsm(MCmle.input.fixed)

lik.boxcox.1.expon <- likfit.glsm(mcmcobj, ini.phi = 10, fix.nugget.rel = TRUE)
lik.boxcox.1.expon.nugget <- likfit.glsm(mcmcobj, ini.phi = 100)
lik.boxcox.1.nospatial <- likfit.glsm(mcmcobj, fix.nugget.rel = TRUE, cov.model = "pure.nugget")
lik.boxcox.1.matern1.nugget <- likfit.glsm(mcmcobj, ini.phi = 40, cov.model = "matern", kappa = 1)
lik.boxcox.1.spherical.nugget <- likfit.glsm(mcmcobj, ini.phi = 400, cov.model = "spherical", nugget.rel = 2)

## investigating other link functions
mcmcobj.mu <- prepare.likfit.glsm(MCmle.input.fixed, use.intensity = TRUE)

lik.expon.boxcox1.0 <- likfit.glsm(mcmcobj.mu, ini.phi = 150.9130915, nugget.rel = 0.1266416, lambda = 0)
lik.gaussian.boxcox1.0 <- likfit.glsm(mcmcobj.mu, cov.model = "gaussian", ini.phi = 100, nugget.rel = 0.13, lambda = 0)
lik.expon.boxcox1.05 <- likfit.glsm(mcmcobj.mu, ini.phi = 196, nugget.rel = 0.787, lambda = 0.5)
lik.expon.boxcox1.lambda <- likfit.glsm(mcmcobj.mu, ini.phi = 339.6, nugget.rel = 2.075, lambda = 1, fix.lambda = FALSE)


## profile likelihood for (phi,tausq.rel) [two-dimensional figure].
pr.lik.rongelap <- proflik.glsm(mcmcobj, lik.boxcox.1.expon.nugget,
  phi.values = seq(8, 40) * 20, nugget.rel.values = seq(1, 3, l = 21)
)
par(cex = 0.9)
plot(pr.lik.rongelap, levels = seq(-5, 1, by = 0.1), labcex = 0.55)
dev.off()

# Figure 1:
postscript("profile.phitausq.ps", height = 5, width = 6.5, horizontal = FALSE)
par(cex = 0.9)
plot(pr.lik.rongelap, levels = seq(-5, 1, by = 0.1), labcex = 0.55)
dev.off()

############ grid for prediction being defined:

## polygrid 已经包含在 geoR
## library(splancs)

ngx <- 126
ngy <- 75
temp.grid <- polygrid(seq(-6250, 0, l = ngx), seq(-3600, 100, l = ngy), 
                      borders = rongelap$borders, vec.inout = TRUE)
ng <- ngx * ngy
grid <- temp.grid$xypoly
grid.ind <- temp.grid$vec.inout
rm(temp.grid)


## prediction :

emp.mean <- apply(MCmle.input.fixed$sim, 1, mean)
emp.var <- cov(t(MCmle.input.fixed$sim))

nug.value <- lik.boxcox.1.expon.nugget$nugget.rel * lik.boxcox.1.expon.nugget$cov.pars[1]
resultat <- krige.conv(data = emp.mean - lik.boxcox.1.expon.nugget$beta, coords = rongelap$coords, 
                       locations = grid, krige = krige.control(type.krige = "sk", beta = 0, 
                                                               cov.pars = lik.boxcox.1.expon.nugget$cov.pars, 
                                                               nugget = nug.value))
rongelap.mean <- resultat$predict + lik.boxcox.1.expon.nugget$beta + 1
d0 <- loccoords(coords = rongelap$coords, locations = grid)
v0 <- ifelse(d0 > 1e-10, cov.spatial(obj = d0, cov.pars = lik.boxcox.1.expon.nugget$cov.pars), 
             lik.boxcox.1.expon.nugget$cov.pars[1] + nug.value)
invcov <- varcov.spatial(
  coords = rongelap$coords, nugget = nug.value,
  cov.pars = lik.boxcox.1.expon.nugget$cov.pars, inv = TRUE
)
AA <- t(v0) %*% invcov$inverse
rongelap.var <- diag(AA %*% emp.var %*% t(AA)) + resultat$krige.var

#### Figure 2 :

postscript("predict.ps", height = 9.0, width = 7.15, horizontal = FALSE)
par(mfrow = c(2, 1), mar = c(3, 3, 1, .75), mgp = c(2, .6, 0), cex = 0.8)
grid.mat <- rep(NA, ng)
grid.mat[grid.ind == TRUE] <- rongelap.mean
plot(cbind(c(-6200, -100), c(-3500, 50)),
  type = "n",
  xlab = "Coordinate X (m)", ylab = "Coordinate Y (m)"
)
image(resultat,
  locations = expand.grid(seq(-6250, 0, l = ngx), seq(-3600, 100, l = ngy)),
  values = grid.mat, col = gray(seq(1, 0, l = 30)),
  x.leg = c(-6000, -3000), y.leg = c(-700, -300),
  cex.leg = 0.7, add = TRUE, zlim = c(3, 13)
)

lines(rongelap$borders, lwd = 2.5)
grid.mat[grid.ind == TRUE] <- sqrt(rongelap.var)
plot(cbind(c(-6200, -100), c(-3500, 50)),
  type = "n",
  xlab = "Coordinate X (m)", ylab = "Coordinate Y (m)"
)
image(resultat,
  locations = expand.grid(seq(-6250, 0, l = ngx), seq(-3600, 100, l = ngy)),
  values = grid.mat, col = gray(seq(1, 0, l = 30)),
  x.leg = c(-6000, -3000), y.leg = c(-700, -300),
  cex.leg = 0.7, add = TRUE, zlim = c(0, 5)
)
lines(rongelap$borders, lwd = 2.5)
dev.off()

## the prediction uncertainties for data locations :

sqrt(rongelap.var)[sqrt(rongelap.var) < 1]
summary(sqrt(rongelap.var)[sqrt(rongelap.var) < 1])

## the prediction uncertainties for other locations :

sqrt(rongelap.var)[sqrt(rongelap.var) > 1]
summary(sqrt(rongelap.var)[sqrt(rongelap.var) > 1])

### prediction when assuming that tausq is measurement error

resultat2 <- krige.conv(data = emp.mean - lik.boxcox.1.expon.nugget$beta, 
                        coords = rongelap$coords, locations = grid, 
                        krige = krige.control(type.krige = "sk", beta = 0, 
                                              cov.pars = lik.boxcox.1.expon.nugget$cov.pars, 
                                              nugget = nug.value), output = output.control(signal = TRUE))
rongelap.mean2 <- resultat2$predict + lik.boxcox.1.expon.nugget$beta + 1
v0.2 <- cov.spatial(obj = d0, cov.pars = lik.boxcox.1.expon.nugget$cov.pars)
AA.2 <- t(v0.2) %*% invcov$inverse
rongelap.var2 <- diag(AA.2 %*% emp.var %*% t(AA.2)) + resultat2$krige.var

#### Figure 3 :
postscript("predict2.ps", height = 9.0, width = 7.15, horizontal = FALSE)
par(mfrow = c(2, 1), mar = c(3, 3, 1, .75), mgp = c(2, .6, 0), cex = 0.8)
grid.mat <- rep(NA, ng)
grid.mat[grid.ind == TRUE] <- rongelap.mean2
plot(cbind(c(-6200, -100), c(-3500, 50)), type = "n", 
     xlab = "Coordinate X (m)", ylab = "Coordinate Y (m)")
image(resultat2,
  locations = expand.grid(seq(-6250, 0, l = ngx), seq(-3600, 100, l = ngy)), values = grid.mat,
  col = gray(seq(1, 0, l = 30)), x.leg = c(-6000, -3000), y.leg = c(-700, -300), 
  cex.leg = 0.7, add = TRUE, zlim = c(6, 11)
)
lines(rongelap$borders, lwd = 2.5)
grid.mat[grid.ind == TRUE] <- sqrt(rongelap.var2)
plot(cbind(c(-6200, -100), c(-3500, 50)), type = "n", 
     xlab = "Coordinate X (m)", ylab = "Coordinate Y (m)")
image(resultat2,
  locations = expand.grid(seq(-6250, 0, l = ngx), seq(-3600, 100, l = ngy)), values = grid.mat,
  col = gray(seq(1, 0, l = 30)), x.leg = c(-6000, -3000), y.leg = c(-700, -300), 
  cex.leg = 0.7, add = TRUE, zlim = c(0.6, 1.5)
)
lines(rongelap$borders, lwd = 2.5)
dev.off()

## the prediction uncertainties for data locations :

sqrt(rongelap.var2)[sqrt(rongelap.var) < 1]
summary(sqrt(rongelap.var2)[sqrt(rongelap.var) < 1])

## the prediction uncertainties for other locations :

sqrt(rongelap.var2)[sqrt(rongelap.var) > 1]
summary(sqrt(rongelap.var2)[sqrt(rongelap.var) > 1])
