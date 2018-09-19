# Matern 自相关函数族
matern <- function(u, phi, kappa) {
  uphi <- u / phi
  uphi <- ifelse(u > 0, (((2^(-(kappa - 1))) / ifelse(0, Inf, gamma(kappa))) * (uphi^kappa) * besselK(x = uphi, nu = kappa)), 1)
  # uphi[u > 600 * phi] <- 0
  return(uphi)
}

library(tikzDevice)
tf <- file.path(getwd(), "figures/matern.tex")
tikz(tf, width = 6, height = 4, pointsize = 30, standAlone = TRUE)

op <- par(mfrow = c(1, 2), mar = c(4, 4, 3, .5))
## 左图
curve(matern(x, phi = 0.25, kappa = 0.5),
  from = 0, to = 2,
  xlab = "$u$", ylab = "$\\rho(u)$", lwd = 2, lty = 1,
  main = "varying  $\\kappa$ and fixed  $\\phi=0.25$"
)
curve(matern(x, phi = 0.25, kappa = 1.0), lwd = 2, lty = 2, from = 0, to = 2, add = TRUE)
curve(matern(x, phi = 0.25, kappa = 2.0),
  from = 0, to = 2, add = TRUE,
  lwd = 2, lty = 3
)
curve(matern(x, phi = 0.25, kappa = 3.0),
  from = 0, to = 2, add = TRUE,
  lwd = 2, lty = 4
)
legend("topright", c("$\\kappa=0.5$ ", " $\\kappa=1$", "$\\kappa=2$", "$\\kappa=3$"),
  lty = c(1, 2, 3, 4), lwd = c(2, 2, 2, 2)
)
## 右图 
curve(matern(x, phi = 0.2, kappa = 1.5),
  from = 0, to = 4,
  xlab = "$u$", ylab = "$\\rho(u)$", lty = 1, lwd = 2,
  main = "fixed  $\\kappa=1.5$ and varying  $\\phi$"
)
curve(matern(x, phi = 0.4, kappa = 1.5), lty = 2, lwd = 2, from = 0, to = 4, add = TRUE)
curve(matern(x, phi = 0.6, kappa = 1.5),
  from = 0, to = 4, add = TRUE,
  lwd = 2, lty = 3
)
curve(matern(x, phi = 0.8, kappa = 1.5),
  from = 0, to = 4, add = TRUE,
  lwd = 2, lty = 4
)
legend("topright", c("$\\phi=0.2$ ", " $\\phi=0.4$", "$\\phi=0.6$", "$\\phi=0.8$"),
  lty = c(1, 2, 3, 4), lwd = c(2, 2, 2, 2)
)
par(op)
dev.off()

# 在生成的 .tex 文件中加入 \usepackage{times} 图内的英文就是 Times New Roman 字体
tools::texi2dvi(tf, pdf = T)
system(paste(getOption("pdfviewer"), file.path(getwd(), "figures/matern.pdf")))

# 从图中可以看出，kappa 和 phi 对 rho 的影响趋势是一致的，都是随着它们增大而减小，
# 但是 phi 的影响更大些，固定 u = 2，比较两图，
# 可以明显地看出不同 phi 下 rho 之间的差别远大于不同 kappa 下 rho 之间的差别


## 二维图形展示 matern 族 相关性随平滑参数和尺度参数的变化

n <- 100
phi_vec <- seq(from = 0.01, to = .8, length.out = n)
kappa_vec <- seq(from = 0.1, to = 3.0, length.out = n)

# 给定 u 即相当于给定位置，看相关性 matern 值随 phi 和 kappa 的关系
# u <- seq(from = 0.01,to = 5, length.out = 1000)

dat <- data.frame(phi = rep(phi_vec, each = n), kappa = rep(kappa_vec, n))

for (i in seq(n^2)) {
  dat$value1[i] <- matern(u = 0.1, phi = dat$phi[i], kappa = dat$kappa[i])
  dat$value2[i] <- matern(u = 0.5, phi = dat$phi[i], kappa = dat$kappa[i])
  dat$value3[i] <- matern(u = 1.0, phi = dat$phi[i], kappa = dat$kappa[i])
  dat$value4[i] <- matern(u = 1.5, phi = dat$phi[i], kappa = dat$kappa[i])
  dat$value5[i] <- matern(u = 2, phi = dat$phi[i], kappa = dat$kappa[i])
  dat$value6[i] <- matern(u = 2.5, phi = dat$phi[i], kappa = dat$kappa[i])
  dat$value7[i] <- matern(u = 3.0, phi = dat$phi[i], kappa = dat$kappa[i])
  dat$value8[i] <- matern(u = 3.5, phi = dat$phi[i], kappa = dat$kappa[i])
  dat$value9[i] <- matern(u = 4, phi = dat$phi[i], kappa = dat$kappa[i])
}

# 三维数组
library(ggplot2)
library(gridExtra)
p1 <- ggplot(dat, aes(phi, kappa)) +
  geom_raster(aes(fill = value1)) +
  scale_fill_distiller(palette = "Greys", guide = FALSE) +
  labs(x = quote(bold(u) == 0.1), y = "")

p2 <- ggplot(dat, aes(phi, kappa)) +
  geom_raster(aes(fill = value2)) +
  scale_fill_distiller(palette = "Greys", guide = FALSE) +
  labs(x = quote(bold(u) == 0.5), y = "")

p3 <- ggplot(dat, aes(phi, kappa)) +
  geom_raster(aes(fill = value3)) +
  scale_fill_distiller(palette = "Greys", guide = FALSE) +
  labs(x = quote(bold(u) == 1.0), y = "")

p4 <- ggplot(dat, aes(phi, kappa)) +
  geom_raster(aes(fill = value4)) +
  scale_fill_distiller(palette = "Greys", guide = FALSE) +
  labs(x = quote(bold(u) == 1.5), y = "")

p5 <- ggplot(dat, aes(phi, kappa)) +
  geom_raster(aes(fill = value5)) +
  scale_fill_distiller(palette = "Greys", guide = FALSE) +
  labs(x = quote(bold(u) == 2.0), y = "")

p6 <- ggplot(dat, aes(phi, kappa)) +
  geom_raster(aes(fill = value6)) +
  scale_fill_distiller(palette = "Greys", guide = FALSE) +
  labs(x = quote(bold(u) == 2.5), y = "")

p7 <- ggplot(dat, aes(phi, kappa)) +
  geom_raster(aes(fill = value7)) +
  scale_fill_distiller(palette = "Greys", guide = FALSE) +
  labs(x = quote(bold(u) == 3.0), y = "")

p8 <- ggplot(dat, aes(phi, kappa)) +
  geom_raster(aes(fill = value8)) +
  scale_fill_distiller(palette = "Greys", guide = FALSE) +
  labs(x = quote(bold(u) == 3.5), y = "")

p9 <- ggplot(dat, aes(phi, kappa)) +
  geom_raster(aes(fill = value9)) +
  scale_fill_distiller(palette = "Greys", guide = FALSE) +
  labs(x = quote(bold(u) == 4.0), y = "")
# 默认按行排列
grid.arrange(p1, p2, p3, p4, p5, p6, p7, p8, p9, nrow = 3, ncol = 3)
