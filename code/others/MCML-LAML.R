##########################################################################################
## Script 2: Comparing Laplace and MClikelihood through rongelap data ####################
##########################################################################################
## Analysis of rongelap data comparing Laplace and MC Likelihood #########################
## Author: Wagner Hugo Bonat LEG/UFPR ####################################################
## Date: 23/05/2013 ######################################################################
##########################################################################################
# load("rongelap.RData")
## Loading extra packages
require(geoR)
require(geoRglm)
require(Matrix)
require(bbmle)

## Loading extra functions
#source("functions.R")
source("functionssglmm.R")
## Loading rongelap data
data(rongelap)
plot(rongelap)

## Transforming to data frame object
data <- data.frame(rongelap$data, rongelap$coords, offset = rongelap$units.m)
names(data) <- c("y", "coord.X", "coord.Y","offset")

## We will fit eight model to compare the results from Laplace approximation by function glgm() and MC likelihood by function likfit.glsm() from package geoRglm.
## The diferrence between the models are the correlation function (matern and spherical), smooth parameter the matern function (kappa = 0.5, 1.5 and 2.5) and the presence or no the nugget.

##########################################################################################
## Fitting several models ################################################################
##########################################################################################

##########################################################################################
## Fit 2 - kappa = 0.5 with nugget #######################################################
##########################################################################################

## Obtain initial values
initial2 = start.values.glgm(y ~ 1, family="poisson", data= data, 
                             coords = data[,2:3],nugget=TRUE,offset = data$offset)
initial2[3] <- log(50)

fit2 <- glgm(y ~ 1, cov.model = "matern", kappa = log(0.5), inits = initial2, data=data,
             coords = data[,2:3], nugget=TRUE, family="poisson", offset=data$offset,
             method.optim = "BFGS", method.integrate = "NR")

## point estimates
summary.glgm(fit2)

##########################################################################################
## Fitting the same models with geoRglm by MC likelihood #################################
##########################################################################################

## Initial points
beta = initial2[1]
sigma2 <- exp(initial2[2])
phi <- 50

## Tunning the algorithm 调算法参数
mcmc.1 <- list(cov.pars = c(sigma2, phi), beta = 6.2, nugget = 2.075 * 2.40, 
               link = "log", beta = beta, family = "poisson")
S.prop <- mcmc.control(S.scale = 0.1, thin = 10)

tune.S <- glsm.mcmc(rongelap, model = mcmc.1, mcmc.input = S.prop)

# 拟合模型
S.control <- mcmc.control(S.scale = 0.5, thin = 20, burn.in = 10000)

S.sims <- glsm.mcmc(rongelap, model = mcmc.1, mcmc.in = S.control)
lik.control <- prepare.likfit.glsm(S.sims)

mc.fit2 <- likfit.glsm(lik.control, ini.phi=50, fix.nugget.rel = FALSE)
mc.fit2

