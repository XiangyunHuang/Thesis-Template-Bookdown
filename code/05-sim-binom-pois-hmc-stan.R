################################
#
# 基于 Stan 模拟二维平稳空间高斯过程 
# 协方差函数为 Matern 族
################################

d <- expand.grid(
  d1 = seq(0, 1, l = 6),
  d2 = seq(0, 1, l = 6)
)
D <- as.matrix(dist(d)) # 计算采样点之间的欧氏距离

# COVFN = 2 即 kappa = 3/2
dat_list <- list(N = 36, alpha = 0.5, sigma = sqrt(2), phi = 0.2, x = D, COVFN = 2)

sim_two_gp_matern <- stan_model("code/sim_two_gp_matern.stan")

draw <- sampling(sim_two_gp_matern,
  iter = 1, algorithm = "Fixed_param",
  chains = 1, data = dat_list,
  seed = 363360090
)

samps <- rstan::extract(draw)
plt_df <- with(samps, data.frame(x = d, f = f[1, ])) # 获得模拟数据

colnames(plt_df) <- c("d1", "d2", "f")


pdf(file = "two-dim-gp-matern.pdf")
par(mar = c(4.1, 4.1, 1.5, 0.5))
plot(c(-0.1, 1.1), c(-0.1, 1.1),
  type = "n",
  panel.first = grid(lwd = 1.5, lty = 2, col = "lightgray"),
  xlab = "Horizontal Coordinate", ylab = "Vertical Coordinate"
)
points(y = d$d1, x = d$d2, pch = 16, col = "darkorange")
text(
  y = d$d1, x = d$d2,
  labels = formatC(round(samps$f[1, ], digits = 2),
    format = "f",
    digits = 2, drop0trailing = FALSE
  ),
  xpd = TRUE
)
dev.off()


##############################
#
# 响应变量服从泊松分布 用 Stan 实现 HMC 算法
#
##############################

library(geoR)
library(geoRglm)
set.seed(371)
sim <- grf(
  grid = expand.grid(
    x = seq(0, 1, l = 10),
    y = seq(0, 1, l = 10)
  ),
  cov.pars = c(2, 0.2), cov.model = "mat", kappa = 1.5
)
# sigmasq = 2  phi = 0.2
sim$lambda <- exp(0.5 + sim$data) # alpha = 0.5
sim$data <- rpois(length(sim$data), lambda = sim$lambda)

fit_sim_pois_gp <- stan_model("code/fit_sim_pois_gp_matern.stan")

sim_pois_data <- list(
  N = 100, x = as.matrix(dist(expand.grid(
    seq(0, 1, l = 10),
    seq(0, 1, l = 10)
  ))),
  COVFN = 2, y = sim$data
)

samp_sim_pois <- sampling(fit_sim_pois_gp,
  data = sim_pois_data, cores = 1, chains = 1,
  iter = 2000, control = list(adapt_delta = 0.95)
)


samp_sim_pois

sim_pois_stan <- extract(samp_sim_pois, permuted = TRUE)

alpha <- c(
  sapply(sim_pois_stan["alpha"], mean),
  sapply(sim_pois_stan["alpha"], var),
  sapply(sim_pois_stan["alpha"], quantile,
    probs = c(2.5, 25, 50, 75, 97.5) / 100
  )
)

phi <- c(
  sapply(sim_pois_stan["phi"], mean),
  sapply(sim_pois_stan["phi"], var),
  sapply(sim_pois_stan["phi"], quantile,
    probs = c(2.5, 25, 50, 75, 97.5) / 100
  )
)

sigmasq <- c(
  sapply(sim_pois_stan["sigmasq"], mean),
  sapply(sim_pois_stan["sigmasq"], var),
  sapply(sim_pois_stan["sigmasq"], quantile,
    probs = c(2.5, 25, 50, 75, 97.5) / 100
  )
)

df <- data.frame(alpha = alpha, phi = phi, sigmasq = sigmasq)

knitr::kable(cbind(c(0.5, 0.2, 2.0), t(df), rep(100, 3)),
  col.names = c("true", "mean", "var", paste0(c(2.5, 25, 50, 75, 97.5), "%"), "N"),
  digits = 3, format = "markdown", padding = 2
)


# knitr::kable(summary(samp_sim_pois)$summary[c("alpha", "phi", "sigmasq"), ], 
#              digits = 3, format = "markdown", padding = 2)


####################################
#
# 响应变量服从二项分布 用 Stan 实现
#
####################################
library(geoR)
library(geoRglm)

set.seed(2018)

sim <- grf(
  grid = expand.grid(x = seq(0.0555, 0.944444, l = 9), y = seq(0.0555, 0.944444, l = 9)),
  cov.pars = c(0.5, 0.2), cov.model = "matern", kappa = 0.5, nugget = 0, mean = 0
)
# cov.pars 依次是 sigma^2 (partial sill) 和 phi (range parameter)
sim$units.m <- rep(4, 81) # 64 个采样点 每个采样点的观察值服从二项分布，其值分别取 0,1,2,3
sim$prob <- exp(sim$data) / (1 + exp(sim$data))
sim$data <- rbinom(81, size = sim$units.m, prob = sim$prob)

fit_sim_binom_gp <- stan_model("code/fit_sim_binom_gp_exp.stan")


sim_binom_data <- list(
  N = 81, x = as.matrix(dist(expand.grid(
    seq(0.0555, 0.944444, l = 9),
    seq(0.0555, 0.944444, l = 9)
  ))),
  COVFN = 1, y = sim$data
)

samp_sim_binom <- sampling(fit_sim_binom_gp,
  data = sim_binom_data, cores = 1, chains = 1,
  iter = 2000, control = list(adapt_delta = 0.95),
  warmup = 1000, thin = 1
)

samp_sim_binom

sim_binom_stan <- extract(samp_sim_binom, permuted = TRUE)

alpha <- c(
  sapply(sim_binom_stan["alpha"], mean),
  sapply(sim_binom_stan["alpha"], var),
  sapply(sim_binom_stan["alpha"], quantile,
    probs = c(2.5, 25, 50, 75, 97.5) / 100
  )
)

phi <- c(
  sapply(sim_binom_stan["phi"], mean),
  sapply(sim_binom_stan["phi"], var),
  sapply(sim_binom_stan["phi"], quantile,
    probs = c(2.5, 25, 50, 75, 97.5) / 100
  )
)

sigmasq <- c(
  sapply(sim_binom_stan["sigmasq"], mean),
  sapply(sim_binom_stan["sigmasq"], var),
  sapply(sim_binom_stan["sigmasq"], quantile,
    probs = c(2.5, 25, 50, 75, 97.5) / 100
  )
)

df <- data.frame(alpha = alpha, phi = phi, sigmasq = sigmasq)

knitr::kable(cbind(c(0, 0.2, 0.5), t(df), rep(81, 3)),
  col.names = c("true", "mean", "var", paste0(c(2.5, 25, 50, 75, 97.5), "%"), "N"),
  digits = 3, format = "markdown", padding = 2
)






# library(brms)
#
# sim_binom_data = data.frame(y = sim$data, units.m = 4, d1 = sim$coords[,1], d2 = sim$coords[,2])
# fit.binom_data <- brm(y | trials(units.m) ~  gp(d1, d2),
#                          data = sim_binom_data,
#                          chains = 1, thin = 1, iter = 2000, warmup = 1000,
#                          algorithm = "sampling", family = binomial()
# )
