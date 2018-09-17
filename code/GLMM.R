# Background
# The estimation process for GLMM is difficult. 
# In GLMM, the (marginal) likelihood to be maximized does not have a simple closed-form expression. 
# This is because the likelihood expression is obtained 
# by integrating or averaging over the distribution of the random effects. 
# This integrating over random effects is intractable.

# Therefore various approximation methods were developed.

# The adaptive Gaussian quadrature method is replaces the integration 
# over the entire range of random effects with summations at representative quadrature points.
# This can be made arbitrarily accurate by increasing quadrature points to be considered, 
# but in the higher dimensional case (many random effects), 
# it becomes computational burdensome. 真的在算积分

# Another approximation is to approximate the integrand that is integrated 
# over the random effects, so that the marginal likelihood has a closed form. 
# This is called the Laplace approximation 
# and corresponds to an adaptive Gaussian quadrature with only one quadrature point.  近似积分

# The penalized quasi-likelihood (PQL) method approximate the model 
# for the outcome (conditional mean given a random effect and an error) 
# by a linear mixed effects model. 
# The outcome variable and the error are transformed to fit this configuration. 
# The transformed outcome variable is called the pseudo-data. 
# Estimation of the psuedo-data and the parameters of interest are iterated until convergence.

# Becoming increasing popular is the Markov Chain Monte Carlo method, 
# which enables sampling from a distribution that does not have a closed form expression. 
# Given the convergence of the stationary distribution of a sufficiently long MCMC chain 
# and the law of large numbers, 
# the originally intractable integration is numerically achieved (Monte Carlo integration).

library(haven)
library(tidyr)
library(dplyr)


epi <- haven::read_sas("http://www.hsph.harvard.edu/fitzmaur/ala2e/epilepsy.sas7bdat")
names(epi) <- tolower(names(epi))
epi
# epilepsy data
saveRDS(epi,"epi.RDS")
# 数据来源
# Thall, P.F. and Vail, S.C. (1990). Some covariance models for
# longitudinal count data with overdispersion. Biometrics, 46, 657-671,


## Wide to long conversion
epiL <- gather_(epi, key_col = "time", value_col = "y", gather_cols = paste0("y", 0:4)) %>%
  mutate(time = as.numeric(gsub("y", "", .$time))) %>%
  arrange(id, time)

## Add observation time (offset)
epiL$T[epiL$time == 0] <- 8
epiL$T[epiL$time != 0] <- 2
epiL$logT <- log(epiL$T)
epiL

# Generalized estimating equation
library(geepack)
geeglm1 <- geeglm(formula   = y ~ time + trt + time:trt,
                  family    = poisson(link = "log"),
                  id        = id,
                  offset    = logT,
                  data      = epiL,
                  corstr    = "ar1",
                  scale.fix = FALSE)
summary(geeglm1)



# glmmPQL (Penalized Quasi-Likelihood)

# This method did not converge.
library(MASS)
glmmPQL1 <- glmmPQL(fixed = y ~ time + trt + time:trt + offset(logT),
                    random = ~ 1 + time | id,
                    family = poisson,
                    data = epiL)


# lme4 (Laplace Approximation)

library(lme4)
glmerLaplace <- glmer(formula = y ~ time + trt + time:trt + (1 + time | id) + offset(logT),
                      data = epiL,
                      family = poisson(link = "log"),
                      nAGQ = 1)
summary(glmerLaplace)

# glmmML (Adaptive Gaussian Quadrature)
# Only one random effect (random intercept) is allowed. So it doesn’t fit the purpose here.
library(glmmML)
glmmML1 <- glmmML(formula = y ~ time + trt + time:trt + offset(logT),
                  family = poisson,
                  data = epiL,
                  cluster = id)
summary(glmmML1)

# brms (Markov Chain Monte Carlo via Stan)
## 使用stan软件包
## Set mc.cores, and it will parallelize
options(mc.cores = parallel::detectCores())
library(brms)
brm1 <- brm(formula = y ~ time + trt + time:trt + (1 + time | id) + offset(logT),
            data = epiL,
            family = "poisson")
(summ_brm1 <- summary(brm1))

plot(brm1)

# rstanarm (Markov Chain Monte Carlo via Stan)

## This also parallelizes if mc.cores is set.
options(mc.cores = parallel::detectCores())
library(rstanarm)
stan_glmer1 <- stan_glmer(formula = y ~ time + trt + time:trt + (1 + time | id),
                          offset = epiL$logT,
                          data = epiL,
                          family = poisson(link = "log"))
stan_glmer1


plot(stan_glmer1)


# glmmstan (Markov Chain Monte Carlo via Stan)


# library(devtools)
# install_github("norimune/glmmstan")
library(glmmstan)
glmmstan1 <- glmmstan(y ~ time + trt + time:trt + (1 + time | id),
                      data = epiL,
                      ## Use raw offset variable not log(T)
                      offset = "T",
                      family = "poisson")


# Yet another Stan frontend. It is also only available on Github. The grammer is essentially that of lme4.

# MCMCglmm (Markov Chain Monte Carlo via CSparse)

library(MCMCglmm)
MCMCglmm1 <- MCMCglmm(fixed = y ~ time + trt + time:trt + offset(logT),
                      ## us() also estimate the covariance, but it failed to run.
                      ## idh() does not estimate the covariance.
                      random = ~ idh(1 + time):id,
                      family = "poisson",
                      data = epiL)
summary(MCMCglmm1)

# glmm (Monte Carlo-Maximum Likelihood)
library(glmm)
glmm1 <- glmm(fixed = as.integer(y) ~ time + trt + time:trt,
              random = ~ 0 + time,
              data = epiL,
              family.glm = poisson.glmm,
              m = 10^4,
              varcomps.names = c("(Intercept)"))

# Summary of results from model that run.


parNames <- c("Intercept","Time","Trt","Trt_Time","VarRanInt","VarRanSlTime","CovRan")

## Add the SAS (AGQ) results
coefs <- data.frame(SAS_AGQ = c(Intercept = 1.0707,
                                Time = -0.0004,
                                Trt = 0.0513,
                                Trt_Time = -0.3065,
                                VarRanInt = 0.5010,
                                VarRanSlTime = 0.2334,
                                CovRan = 0.0541))

cbind(coefs,
      
      lme4_Lap = c(coef(summary(glmerLaplace))[,1],
                   diag(summary(glmerLaplace)$varcor$id),
                   summary(glmerLaplace)$varcor$id[1,2]),
      
      brms_MCMC = c(summ_brm1$fixed[,1],
                    summ_brm1$random$id[1:2,1]^2,
                    summ_brm1$random$id[3,1]),
      
      stanarm = c(stan_glmer1$stan_summary[1:4,"mean"],
                  ## Unclear how to extract these
                  c(0.74,0.22)^2, 0.09),
      
      MCMCglmm = c(summary(MCMCglmm1)$solutions[,1],
                   summary(MCMCglmm1)$Gcovariances[,1],
                   NA),
      
      geepack = c(coef(geeglm1), rep(NA,3)))
