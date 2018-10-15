# 基于 Stan 模拟二维平稳空间高斯过程 协方差函数为 Matern 族

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

colnames(plt_df) <- c("d1","d2","f")


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
  labels = formatC(round(samps$f[1,], digits = 2), format = "f", 
                   digits = 2, drop0trailing = FALSE), 
  xpd = TRUE
)
dev.off()


### data

library(geoR)
library(geoRglm)
set.seed(371)
sim <- grf(grid = expand.grid(x = seq(0, 1, l = 8), 
                              y = seq(0, 1, l = 8)), 
           cov.pars = c(2, 0.2),cov.model = "mat", kappa = 1.5) 
# sigmasq = 2  phi = 0.2
sim$lambda <- exp(0.5 + sim$data)	# alpha = 0.5 
sim$data <- rpois(length(sim$data), lambda = sim$lambda) 

fit_sim_pois_gp <- stan_model('code/fit_sim_pois_gp_matern.stan')

sim_pois_data <- list(N = 64, x = as.matrix(dist(expand.grid(seq(0, 1, l = 8),
                                                         seq(0, 1, l = 8)))),
                  COVFN = 2, y = sim$data)

samp_sim_pois <- sampling(fit_sim_pois_gp, data = sim_pois_data, cores = 1, chains = 1, 
         iter = 2000, control = list(adapt_delta = 0.95))


samp_sim_pois

sim_pois_stan <- extract(samp_sim_pois, permuted = TRUE)

alpha = c(sapply(sim_pois_stan["alpha"], mean), 
          sapply(sim_pois_stan["alpha"], var),
          sapply(sim_pois_stan["alpha"], quantile, 
                 probs = c(2.5, 25, 50, 75, 97.5) / 100))

phi = c(sapply(sim_pois_stan["phi"], mean), 
        sapply(sim_pois_stan["phi"], var),
        sapply(sim_pois_stan["phi"], quantile, 
               probs = c(2.5, 25, 50, 75, 97.5) / 100))

sigmasq = c(sapply(sim_pois_stan["sigmasq"], mean), 
            sapply(sim_pois_stan["sigmasq"], var),
            sapply(sim_pois_stan["sigmasq"], quantile, 
                   probs = c(2.5, 25, 50, 75, 97.5) / 100))

df = data.frame(alpha = alpha, phi = phi, sigmasq = sigmasq)

knitr::kable(cbind(c(0.5,0.2,2.0),t(df),rep(64,3)), 
             col.names = c("true","mean","var",paste0(c(2.5, 25, 50, 75, 97.5),"%"),"N"), 
             digits = 3, format = "markdown", padding = 2)


knitr::kable(summary(samp_sim_pois)$summary[c("alpha","phi","sigmasq"),], digits = 3, format = "markdown", padding = 2)


