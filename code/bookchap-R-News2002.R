# The commands for the example in Diggle, Ribeiro Jr and Christensen (2003) [bookchapter], 
# and Christensen and Ribeiro Jr (2002) [R-news].
# WARNING: RUNNING THIS IS VERY TIME-CONSUMING AND MEMORY-DEMANDING
library(geoR)
library(geoRglm)

set.seed(2018)
## Simulating data 二项分布
sim <- grf(grid = expand.grid(x = seq(0.0555, 0.944444, l = 8), y = seq(0.0555, 0.944444, l = 8)), 
           cov.pars = c(0.5, 0.2)) # kappa = 0.5, nugget = 0 
# cov.pars 依次是 sigma^2 (partial sill) 和 phi (range parameter)
attr(sim, "class") <- "geodata"
sim$units.m <- rep(4, 64) # 64 个采样点 每个采样点的观察值服从二项分布，其值分别取 0,1,2,3
sim$prob <- exp(sim$data) / (1 + exp(sim$data))
sim$data <- rbinom(64, size = sim$units.m, prob = sim$prob)

## Visualising the data and the (unobserved) random effects 空间效应或者说平稳高斯过程

pdf(file = "binom-without-nugget-geoRglm.pdf",width = 8,height = 4)
par(mfrow = c(1, 2), mar = c(2.3, 2.5, .5, .7), mgp = c(1.5, .6, 0), cex = 1)
plot(c(0, 1), c(-0.1, 1), type = "n", xlab = "Horizontal Coordinate", ylab = "Vertical Coordinate")
text(sim$coords[, 1], sim$coords[, 2], format(round(sim$prob, digits = 2)), cex = 0.9)
plot(c(0, 1), c(-0.1, 1), type = "n", xlab = "Horizontal Coordinate", ylab = "Vertical Coordinate")
text(sim$coords[, 1], sim$coords[, 2], format(sim$data), cex = 1.1)
points(sim$coords[c(1, 29), ], cex = 5.5)
dev.off()

## Setting input options and running the function 各参数先验设置
## beta.prior 均值向量参数 beta 的先验分布为正态分布，且先验分布中的参数分别是均值 beta 和标准差 beta.var
## phi.prior 范围参数 phi 的先验分布是 exponential 指数分布 且先验分布的均值 phi = 0.2
## phi.discrete  表示 support points for the discretisation of the prior for the parameter phi.
## 默认 tausq.rel = 0 无块金效应
## sigma^2 的先验分布是 sc.inv.chisq (scaled inverse-chi^2 prior distribution) 逆卡方分布 自由度为 5
# sigmasq 表示 Parameter in the scaled inverse-chi^2 prior distribution for sigma^2
prior.sim <- prior.glm.control(
  beta.prior = "normal", beta = 0, beta.var = 1, phi.prior = "exponential", phi = 0.2,
  phi.discrete = seq(0.005, 0.3, l = 60), sigmasq.prior = "sc.inv.chisq", 
  df.sigmasq = 5, sigmasq = 0.5
)

## MCMC 使用 Langevin-Hastings 利用了 proposal distribution 中的梯度信息，
## 相比 random walk Metropolis 算法，在应用中有更好的效果
mcmc.sim <- mcmc.control(S.scale = 0.05, phi.scale = 0.015, thin = 100, burn.in = 10000)
pred.grid <- expand.grid(x = seq(0.0125, 0.9875, l = 40), y = seq(0.0125, 0.9875, l = 40)) 
# 预测位置 40 x 40 = 1600 个
out.sim <- output.glm.control(sim.predict = TRUE)
# 很费时间
run.sim <- binom.krige.bayes(sim, locations = pred.grid, prior = prior.sim, 
                             mcmc.input = mcmc.sim, output = out.sim)

# 模拟过程的诊断
## Autocorrelations 
pdf(file = "binom-without-nugget-geoRglm-acf.pdf",width = 6,height = 8)
par(mfrow = c(3, 2), mar = c(2.3, 2.5, .5, .7), mgp = c(1.5, .6, 0), cex = 0.6)
plot(run.sim$posterior$sim[1, ], type = "l", ylab = "S(0.056, 0.056)")
acf(run.sim$posterior$sim[1, ], main = "")
plot(run.sim$posterior$sim[29, ], type = "l", ylab = "S(0.563, 0.436)")
acf(run.sim$posterior$sim[29, ], main = "")
plot(run.sim$posterior$phi$sample, type = "l", ylab = "phi")
acf(run.sim$posterior$phi$sample, main = "")
dev.off()

## Plot of timeseries
# 任意取两个位置观察其后验分布
pdf(file = "binom-without-nugget-geoRglm-ts.pdf",width = 6,height = 9)
par(mfrow = c(3, 1), mar = c(2.3, 2.5, .5, .7), mgp = c(1.5, .6, 0), cex = 0.6)
plot(run.sim$posterior$sim[1, ], type = "l", ylab = "S(0.056, 0.056)")
plot(run.sim$posterior$sim[29, ], type = "l", ylab = "S(0.563, 0.436)")
plot(run.sim$posterior$phi$sample, type = "l", ylab = "phi")
dev.off()

## Predictions
sim.predict <- apply(run.sim$pred$simulations, 1, mean)
sim.predict.var <- apply(run.sim$pred$simulations, 1, var)

pdf(file = "binom-without-nugget-geoRglm-pred.pdf",width = 6,height = 3)
par(mfrow = c(1, 2), mar = c(2.3, 2.5, .5, .7), mgp = c(1.5, .6, 0), cex = 0.6)
# 1600 个点的预测值
image(
  x = run.sim, locations = pred.grid, values.to.plot = sim.predict, 
  col = gray(seq(1, 0, l = 30)),
  x.leg = c(0.1, 0.9), y.leg = c(-0.12, -0.07), cex = 1.0, 
  xlab = "Coordinate X", ylab = "Coordinate Y"
)
# 预测值对应的方差
image(
  x = run.sim, locations = pred.grid, 
  values = sim.predict.var, col = gray(seq(1, 0, l = 30)),
  x.leg = c(0.1, 0.9), y.leg = c(-0.12, -0.07), cex = 1.0, 
  xlab = "Coordinate X", ylab = "Coordinate Y"
)
dev.off()
