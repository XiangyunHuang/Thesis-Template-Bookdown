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

# pdf(file = "pairs_mu_tau_lp.pdf", width = 8, height = 6)
# rstan_gg_options(fill = "lightblue", color = "darkorange", pt_color = "darkorange")
# pairs(fit, pars = c("mu", "tau", "lp__"), log = TRUE, las = 1) # tau will have logarithmic axes
# dev.off()

# stan_trace(fit,pars=c("mu", "tau"),inc_warmup = T)

# 迭代序列的诊断分析

# trace plot 追踪迭代过程
params <- as.data.frame(extract(fit, permuted=FALSE))
names(params) <- gsub("chain:1.", "", names(params), fixed = TRUE)
names(params) <- gsub("[", ".", names(params), fixed = TRUE)
names(params) <- gsub("]", "", names(params), fixed = TRUE)
params$iter <- 1:5000

# 后验参数 mu log(tau) 的迭代序列

pdf(file = "figures/trace_mu_log_tau.pdf", width = 8, height = 6)
par(mfrow = c(2, 1),mar = c(4, 4, 0.5, 0.5))
plot(params$iter+5000, params$mu, col="lightblue", pch=16, cex=0.8,
     xlab="Iteration", ylab=expression(mu))
abline(h = mean(schools_sim$mu), col = "darkorange", lwd = 2)
plot(params$iter+5000, log(params$tau), col="lightblue", pch=16, cex=0.8,
     xlab="Iteration", ylab=expression(log(tau)),ylim = c(-6,4))
abline(h = log(mean(schools_sim$tau)), col = "darkorange", lwd = 2)
dev.off()


running_mc_means_log_tau <- sapply(1:500, function(n) mean(log(params$tau)[1:(10*n)]))
# 灰色的虚线 对数标准差 tau 蒙特卡罗均值  
# 可以看到前一阶段还不稳定，随着迭代次数的增加，均值趋于稳定

pdf(file = "figures/mcmc_mean_tau_div.pdf", width = 8, height = 3)

par(mfrow = c(1, 2),mar = c(4, 4, 0.5, 0.5))
plot(10 * (1:500)+5000, running_mc_means_log_tau,
  col = "darkorange", pch = 16, cex = 0.8, ylim = c(0, 2),
  xlab = "Iteration", ylab = "MCMC mean of log(tau)"
)
abline(h = mean(log(params$tau)), col = "grey", lty = "dashed", lwd = 3)


# 热身后，发散占比
# 5000 次迭代中有两次是发散的
divergent <- get_sampler_params(fit, inc_warmup=FALSE)[[1]][,'divergent__']
sum(divergent)
sum(divergent) / 5000

# 
params$divergent <- divergent
div_params_ncp <- params[params$divergent == 1,]
nondiv_params_ncp <- params[params$divergent == 0,]

# 图中发散的点用 蓝色标识
# par(mar = c(4, 4, 0.5, 0.5))
plot(nondiv_params_ncp$mu, log(nondiv_params_ncp$tau),
  xlab = expression(mu), ylab = expression(log(tau)),
  xlim = c(-10, 25), ylim = c(-6, 4),
  col = "Darkgrey", pch = 16, cex = 0.8
)
points(div_params_ncp$mu, log(div_params_ncp$tau),
  col = "darkorange", pch = 16, cex = .8
)

dev.off()

# HMC 诊断

check_hmc_diagnostics(fit)

# Divergences:
#   17 of 20000 iterations ended with a divergence (0.085%).
# Try increasing 'adapt_delta' to remove the divergences.
# 
# Tree depth:
#   0 of 20000 iterations saturated the maximum tree depth of 10.
# 
# Energy:
#   E-BFMI indicated no pathological behavior.

check_divergences(fit)
check_treedepth(fit)
check_energy(fit)

# 设置图片背景
rstan_ggtheme_options(panel.background = element_rect(fill = "gray"),
                      legend.position = "top")
rstan_gg_options(fill = "skyblue", color = "skyblue4", pt_color = "red")

pdf(file = "supplement/8schools-diagnostic-plot.pdf")
stan_diag(fit, information = c("sample")) # Histograms of lp__ and accept_stat (average Metropolis acceptance rate)
stan_diag(fit, information = c("stepsize")) # Violin plots showing the distributions of lp__ and 
# accept_stat at each of the sampled step sizes (one per chain)

# samp_info <- stan_diag(fit, info = 'sample') # saves the three plots in a list
# samp_info[[3]] # access just the third plot
# 
# stan_diag(fit, info = 'sample', chain = 1) # overlay chain 1

stan_par(fit,par = "mu") 
stan_rhat(fit) 
stan_ess(fit) 
stan_mcse(fit)
dev.off()


#########
# or 拟合模型
fit <- stan(
  model_name = "8schools",
  model_code = "
	// saved as 8schools.stan
	data {
	  int<lower=0> J; // number of schools 
	  real y[J]; // estimated treatment effects
	  real<lower=0> sigma[J]; // s.e. of effect estimates 
	}
	parameters {
	  real mu; // population mean
	  real<lower=0> tau; // population sd
	  real eta[J]; // school-level errors
	}
	transformed parameters {
	  real theta[J];  // schools effects
	  for (j in 1:J)
		theta[j] = mu + tau * eta[j];
	  // theta = mu + tau*eta;
	}
	model {
	  // set prior for mu or uniform prior distribution default
	  // target += normal_lpdf(mu  | 0, 10); 
	  // target += cauchy_lpdf(tau | 0, 25); # the same as mu
	  target += normal_lpdf(eta | 0, 1);
	  target += normal_lpdf(y | theta, sigma); // target distribution
	  // y ~ normal(theta, sigma);
	}
	",
  data = schools_dat,
  iter = 10000, warmup = 5000, chains = 4,
  seed = 2018
)
