library(ggplot2)
library(StanHeaders)
library(rstan)
load(file = "data/eight_schools.RData")
schools_sim <- extract(fit, permuted = TRUE)

pdf(file = "posterior_mu_tau.pdf", width = 8, height = 6)
par(mfrow = c(1, 2), mar = c(4, 4, 2, 2))
hist(schools_sim$mu, col = "lightblue", border = "white",xlab = expression(mu),main = "")
abline(v = mean(schools_sim$mu), col = "darkorange", lwd = 2)
hist(schools_sim$tau, col = "lightblue", border = "white",xlab = expression(tau),main = "")
abline(v = mean(schools_sim$tau), col = "darkorange", lwd = 2)
# hist(schools_sim$lp__, col = "lightblue", border = "white",xlab = "lp__",main = "")
# abline(v = mean(schools_sim$lp__), col = "darkorange", lwd = 2)
dev.off()

pdf(file = "pairs_mu_tau_lp.pdf", width = 8, height = 6)
pairs(fit, pars = c("mu", "tau", "lp__"), log = TRUE, las = 1) # tau will have logarithmic axes
dev.off()

# trace plot 追踪迭代过程
params_tau <- as.data.frame(extract(fit, permuted=FALSE))
names(params_tau) <- gsub("chain:1.", "", names(params_tau), fixed = TRUE)
names(params_tau) <- gsub("[", ".", names(params_tau), fixed = TRUE)
names(params_tau) <- gsub("]", "", names(params_tau), fixed = TRUE)
params_tau$iter <- 1:5000

pdf(file = "trace_log_tau.pdf", width = 8, height = 6)
par(mar = c(4, 4, 0.5, 0.5))
plot(params_tau$iter, log(params_tau$tau), col="darkorange", pch=16, cex=0.8,
     xlab="Iteration", ylab="log(tau)",ylim = c(-6,4))
dev.off()

# 热身后，发散序列占比
divergent <- get_sampler_params(fit, inc_warmup=FALSE)[[1]][,'divergent__']
sum(divergent)
sum(divergent) / 5000
