library(geoR)
library(geoRglm)
set.seed(371)
sim <- grf(grid = expand.grid(x = seq(0, 1, l = 8), 
                              y = seq(0, 1, l = 8)), 
			cov.pars = c(2, 0.2),cov.model = "mat", kappa = 1.5) 
# sigmasq = 2  phi = 0.2
sim$lambda <- exp(0.5 + sim$data)	# alpha = 0.5 
sim$data <- rpois(length(sim$data), lambda = sim$lambda) 

pdf(file = "poisson-without-nugget-geoRglm.pdf",width = 8,height = 4)
par(mfrow = c(1, 2), mar = c(2.3, 2.5, .5, .7), mgp = c(1.5, .6, 0), cex = 1)
plot(c(-0.1, 1.1), c(-0.1, 1.1), type = "n", xlab = "Horizontal Coordinate", ylab = "Vertical Coordinate")
text(sim$coords[,1], sim$coords[,2], format(sim$lambda, digits = 1), cex = 0.8) 

plot(c(-0.1, 1.1), c(-0.1, 1.1), type = "n", xlab = "Horizontal Coordinate", ylab = "Vertical Coordinate") 
text(sim$coords[,1], sim$coords[,2], format(sim$data)) 
dev.off()

# 调参数
# First we need to tune the algorithm by scaling the proposal variance so
# that acceptance rate is approximately 60 percent (optimal acceptance rate
# for Langevin-Hastings algorithm). This is done by trial and error.
set.seed(371)
mcc.tune <- mcmc.control(S.scale = 0.014, phi.scale = 0.15, thin = 100, n.iter = 5000)
# 50 个样本
pgc.tune <- prior.glm.control(
  phi.prior = "uniform", phi = 0.2,
  phi.discrete = seq(0, 2, by = 0.02),
  tausq.rel = 0
)
pkb.tune <- pois.krige.bayes(sim, prior = pgc.tune, mcmc.input = mcc.tune)
# 全量迭代模拟
set.seed(371)
mcmc.sim <- mcmc.control(S.scale = 0.025, phi.scale = 0.1, thin = 100, 
                         n.iter = 110000, burn.in = 10000, phi.start = 0.2)
prior.sim <- prior.glm.control(
  phi.prior = "exponential", phi = 0.2,
  phi.discrete = seq(0, 2, by = 0.02)
)
pred.grid <- expand.grid(x = seq(0.0125, 0.9875, l = 4), y = seq(0.0125, 0.9875, l = 4)) 
out.sim <- output.glm.control(sim.predict = TRUE)
# 很费时间
run.sim <- pois.krige.bayes(sim, locations = pred.grid, prior = prior.sim, 
                             mcmc.input = mcmc.sim, output = out.sim)

true_value  <- c(0.5,0.2,2.0)

mean(run.sim$posterior$beta$sample) - 

df <- data.frame(
  beta = c(mean(run.sim$posterior$beta$sample), 
           var(run.sim$posterior$beta$sample), 
           quantile(run.sim$posterior$beta$sample, probs = c(2.5, 25, 50, 75, 97.5) / 100)),
  phi = c(mean(run.sim$posterior$phi$sample), 
          var(run.sim$posterior$phi$sample), 
          quantile(run.sim$posterior$phi$sample, probs = c(2.5, 25, 50, 75, 97.5) / 100)),
  sigmasq = c(mean(run.sim$posterior$sigmasq$sample), 
              var(run.sim$posterior$sigmasq$sample), 
              quantile(run.sim$posterior$sigmasq$sample, probs = c(2.5, 25, 50, 75, 97.5) / 100))
)

knitr::kable(cbind(c(0.5,0.2,2.0) ,t(df), rep(64,3)),
             col.names = c("true","mean","var","2.5%","25%","50%","75%","97.5%","N"),
             digits = 3,format = "markdown", padding = 2)

							 

							 
							 
							 
							 
							 
							 
							 
							 
							 
							 
							 
							 
# http://gbi.agrsci.dk/~ofch/geoRglm/Intro/books.html
# 关于模拟							 
# p50 数据集来自 geoRglm 
# sigmasq = 0.1  phi = 1.0  alpha = 1 tausq = 0 kappa = 0.5
# 指数型协方差函数 

data(p50)
cp <- expand.grid(x = seq(0, 9, l = 10), y = seq(0, 9, l = 10)) 
plot(c(0,9),c(0,9),type="n")
text(cp[,1], cp[,2], p50$data, cex = 1.5)

set.seed(1234)
## MCMC with fixed phi
prior.5 <- prior.glm.control(phi.prior = "fixed", phi = 0.1)
mcmc.5 <- mcmc.control(S.scale = 0.01, thin = 1)
test.5 <- pois.krige.bayes(p50, prior = prior.5, mcmc.input = mcmc.5)
par(mfrow=c(1,2))
hist(test.5)
## Now chose S.scale (Acc-rate=0.60 is preferable).
mcmc.5.new <- mcmc.control(S.scale = 0.08, thin = 100)
test.5.new <- pois.krige.bayes(p50,
               locations = t(cbind(c(2.5,3.5),c(-6,3.5),c(2.5,-3.5),c(-6,-3.5))), 
               prior = prior.5, mcmc.input = mcmc.5.new, 
               output = list(threshold = 10, quantile = c(0.49999,0.99)))
image(test.5.new)
persp(test.5.new)
## MCMC with random phi.

## Note here that we can start with the S.scale from above.
mcmc.6 <- mcmc.control(S.scale = 0.08, n.iter = 2000, thin = 100, 
                       phi.scale = 0.01)
prior.6 <- prior.glm.control(phi.discrete = seq(0.02, 1, 0.02))
test.6 <- pois.krige.bayes(p50, prior = prior.6, mcmc.input = mcmc.6)
## Acc-rate=0.60 , acc-rate-phi = 0.25-0.30  are preferable


mcmc.6.new <- mcmc.control(S.scale=0.08, n.iter = 400000, thin = 200,
                       burn.in = 5000, phi.scale = 0.12, phi.start = 0.5)
prior.6 <- prior.glm.control(phi.prior = "uniform", 
               phi.discrete = seq(0.02, 1, 0.02))
test.6.new <- pois.krige.bayes(p50, 
                 locations = t(cbind(c(2.5,3.5), c(-60,-37))), 
                 prior = prior.6, mcmc.input = mcmc.6.new)
par(mfrow=c(3,1))
hist(test.6.new)

df <- data.frame(
  beta = c(mean(test.6.new$posterior$beta$sample), 
           var(test.6.new$posterior$beta$sample), 
           quantile(test.6.new$posterior$beta$sample, probs = c(2.5, 25, 50, 75, 97.5) / 100)),
  phi = c(mean(test.6.new$posterior$phi$sample), 
          var(test.6.new$posterior$phi$sample), 
          quantile(test.6.new$posterior$phi$sample, probs = c(2.5, 25, 50, 75, 97.5) / 100)),
  sigmasq = c(mean(test.6.new$posterior$sigmasq$sample), 
              var(test.6.new$posterior$sigmasq$sample), 
              quantile(test.6.new$posterior$sigmasq$sample, probs = c(2.5, 25, 50, 75, 97.5) / 100))
)

knitr::kable(t(df), col.names = c("mean","var","2.5%","25%","50%","75%","97.5%"),
             digits = 3,format = "markdown", padding = 2)

						 
