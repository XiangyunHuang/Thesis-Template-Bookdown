library(methods)
set.seed(2018)
# 加载依赖
library(ggplot2)
library(StanHeaders)
library(rstan)
# 设置环境
is_on_travis = identical(Sys.getenv("TRAVIS"), "true")
is_online = curl::has_internet()

options(mc.cores = if(is_on_travis) 4 else 2)
rstan_options(auto_write = TRUE)

data(rongelap,package="geoRglm")
rongelap_pois_stan <- stan_model("code/stan/06-rongelap_pois.stan")

rongelap_pois_data <- list(
  N = 157, x = as.matrix(dist(rongelap$`coords`)),
  COVFN = 1, y = rongelap$data, units = rongelap$units.m
)

rongelap_pois_fit <- sampling(rongelap_pois_stan,
                              data = rongelap_pois_data, 
                              init = 0,
                              cores = 2, chains = 2,
                              iter = 2000, control = list(adapt_delta = 0.95, max_treedepth = 15)
)

rongelap_pois_fit

rongelap_pois_samp <- extract(rongelap_pois_fit, permuted = TRUE)

alpha <- c(
  sapply(rongelap_pois_samp["alpha"], mean),
  sapply(rongelap_pois_samp["alpha"], var),
  sapply(rongelap_pois_samp["alpha"], quantile,
         probs = c(2.5, 25, 50, 75, 97.5) / 100
  )
)

phi <- c(
  sapply(rongelap_pois_samp["phi"], mean),
  sapply(rongelap_pois_samp["phi"], var),
  sapply(rongelap_pois_samp["phi"], quantile,
         probs = c(2.5, 25, 50, 75, 97.5) / 100
  )
)

sigmasq <- c(
  sapply(rongelap_pois_samp["sigmasq"], mean),
  sapply(rongelap_pois_samp["sigmasq"], var),
  sapply(rongelap_pois_samp["sigmasq"], quantile,
         probs = c(2.5, 25, 50, 75, 97.5) / 100
  )
)

df <- data.frame(alpha = alpha, phi = phi, sigmasq = sigmasq)

knitr::kable(cbind(c(0.5, 0.2, 2.0), t(df), rep(100, 3)),
             col.names = c("true", "mean", "var", paste0(c(2.5, 25, 50, 75, 97.5), "%"), "N"),
             digits = 3, format = "markdown", padding = 2
)
