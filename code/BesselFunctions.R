pdf(file = "bessel.pdf",width = 7*1.5,height = 3*1.5)

# 贝塞尔函数图像
par(mfrow = c(1,2),mar = c(2.1, 3.1, 0.5, 1.5))
x0 <- 2^(-20:10)
nus <- c(0:5, 10, 20)
x <- seq(0, 4, length.out = 501)

plot(x0, x0^-8,
  log = "xy", xaxt = "n",
  yaxt = "n", type = "n", ann = FALSE, panel.first = grid()
) # x 和 y 轴都取对数

axis(1,
  at = c(1e-08, 1e-06, 1e-04, 1e-02, 1, 1e+02),
  labels = expression(10^-8, 10^-6, 10^-4, 10^-2, 1, 10^2)
)
axis(2,
  at = c(1e-16, 1, 1e+16, 1e+32, 1e+48),
  labels = expression(10^-16, 1, 10^16, 10^32, 10^48), las = 1
)

cols <- terrain.colors(9) # RColorBrewer::brewer.pal(9,name = "Set3")
for (i in seq(length(nus)))
  lines(x0, besselK(x0, nu = nus[i]), col = cols[i], lwd = 2)
legend("topright",legend = paste("nu=", nus),col = cols, lwd = 2)

# 数据变化范围太大，因此横纵坐标轴都取了以10为底的对数，数据可以紧凑的在一张图内展示
x <- seq(0, 40, length.out = 801)
x <- x[x > 0]
plot(x, x,
  ylim = c(1e-18, 1e11), log = "y", yaxt = "n",
  type = "n", ann = FALSE, panel.first = grid()
)
axis(2,
  at = c(1e-19, 1e-12, 1e-05, 1e+02, 1e+09),
  labels = expression(10^-19, 10^-12, 10^-5, 10^2, 10^9), las = 1
)

for (i in seq(length(nus)))
  lines(x, besselK(x, nu = nus[i]), col = cols[i], lwd = 2)
legend("topright", legend = paste("nu=", nus), col = cols, lwd = 2)

dev.off()
