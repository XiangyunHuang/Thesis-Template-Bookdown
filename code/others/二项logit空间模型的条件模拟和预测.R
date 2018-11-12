### Name: binom.krige
### Title: Conditional Simulation and Prediction for the Binomial-logit
###   Spatial model

library(geoR)
library(geoRglm)

set.seed(1234)
data(b50)
# First we scale the algorithm, and study how well the chain is mixing.
# 调参数
test <- binom.krige(b50,
  krige = list(cov.pars = c(1, 1), beta = 1),
  mcmc.input = mcmc.control(S.scale = 0.2, thin = 1)
)
# logistic distribution 的分位数  模拟 S(x) 
plot(qlogis(test$prevalence[45, ]), type = "l")
acf(qlogis(test$prevalence[45, ]), type = "correlation", plot = TRUE)

# 预测
# Now we make prediction (we decide to thin to every 10, which is the default),
# where we now use S.scale = 0.7.
test2 <- binom.krige(b50,
  locations = cbind(c(0.5, 0.5, 1, 1), c(0.4, 1, 0.4, 1)),
  krige = krige.glm.control(cov.pars = c(1, 1), beta = 1),
  mcmc.input = mcmc.control(S.scale = 0.7)
)
image(test2)
contour(test2)

# 模拟数据
y9 <- grf(grid = expand.grid(x = seq(1, 3, l = 3),
                             y = seq(1, 3, l = 3)),
          cov.pars = c(0.1, 0.2))
y9$data <- rbinom(9, prob = plogis(y9$data), size = 1:9)
y9$units.m <- 1:9
model2 <- krige.glm.control(cov.pars = c(1, 1), beta = 1)
test2 <- binom.krige(y9,
  locations = cbind(c(0.5, 0.5), c(1, 0.4)),
  krige = model2, mcmc.input = mcmc.control(S.scale = 0.5, thin = 1, n.iter = 10),
  output = list(sim.predict = TRUE)
)

model2.u <- krige.glm.control(cov.pars = c(1, 1), type.krige = "ok")
test2.unif.beta <- binom.krige(y9,
  krige = model2.u,
  mcmc.input = list(S.scale = 0.5, thin = 1, n.iter = 10)
)

model2 <- krige.glm.control(cov.pars = c(1, 1), beta = 1, aniso.pars = c(1, 2))
test2 <- binom.krige(y9,
  locations = cbind(c(0.5, 0.5, 1, 1), c(0.4, 1, 0.4, 1)),
  krige = model2, mcmc.input = list(S.scale = 0.5, thin = 1, n.iter = 10)
)

image(test2)
contour(test2)
