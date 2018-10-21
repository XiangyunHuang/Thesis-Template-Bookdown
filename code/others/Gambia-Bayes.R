library(PrevMap)

data(gambia)
head(gambia)
str(gambia)
class(gambia)

ID.coords <- create.ID.coords(gambia, coords = ~x + y)

units.m <- 1
n.subset <- dim(gambia)[1]
# 研究 control.mcmc 各参数的含义 其实就是研究算法，确定合适的初始值

# Set the MCMC control parameters
control.mcmc <- control.mcmc.Bayes(
  n.sim = 10000, burnin = 2000, thin = 5,
  h.theta1 = 0.05, h.theta2 = 0.05,
  L.S.lim = c(1, 50), epsilon.S.lim = c(0.01, 0.02),
  start.beta = rep(1.5,6), start.sigma2 = 1, start.phi = 0.15,
  start.nugget = NULL, start.S = rep(0, n.subset)
)

# phi 和 sigma^2  使用对数正态先验 log-normal prior

cp <- control.prior(
  beta.mean = 0, beta.covar = 1,
  log.normal.phi = c(log(0.15), 0.05),
  log.normal.sigma2 = c(log(1), 0.1)
)

fit.Gambia.Bayes <- binomial.logistic.Bayes(
  formula = pos ~ age + netuse + treated + green + phc,
  coords = ~x + y, units.m = ~ units.m, ID.coords = ID.coords,
  data = gambia, control.prior = cp,
  control.mcmc = control.mcmc, kappa = 2
)


