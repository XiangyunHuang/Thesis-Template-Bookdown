
# 计算 n 维半径为 1 的超球的体积
ball_vol <- function(n) {
  V <- rep(0, 100)
  if (n == 1) {
    V[1] <- 2 
    return(V[n])
  }
  if (n == 2) {
    V[2] <- pi 
    return(V[n])
  }
  if (n == 3) {
    V[3] <- 4 / 3 * pi
    return(V[n])
  }
  if (n > 3) { # 递归计算超球体积
    V[n] <- 2 * integrate(function(theta) ball_vol(n - 1) * cos(theta)^(n), lower = 0, upper = pi / 2)$value
    return(V[n])
  }
}

# 10 维时 超立方体内的超内切球的体积占比大约是0.2%

set.seed(2018)
euclidean_length <- function(u) sqrt(sum(u * u))
M <- 1e5
N_MAX <- 10
Pr_inside <- rep(NA, N_MAX)
for (N in 1:N_MAX) {
  y <- matrix(runif(M * N, -0.5, 0.5), M, N)
  inside <- 0
  for (m in 1:M) {
    if (euclidean_length(y[m, ]) < 0.5) {
      inside <- inside + 1
    }
  }
  Pr_inside[N] <- inside / M
}
df = data.frame(dims = 1:N_MAX, volume = Pr_inside)
print(df, digits=6)


# 单位超立方体内的超球的体积随维数的变化
library(ggplot2)
ggplot(df, aes(x = dims, y = Pr_inside)) +
  scale_x_continuous(breaks = c(1, 3, 5, 7, 9)) +
  geom_point() +
  ylab("volume of inscribed hyperball") +
  xlab("dimensions") +
  theme_minimal()

