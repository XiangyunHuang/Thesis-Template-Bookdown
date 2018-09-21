# 小麦产量实验 Yields from a randomized complete block design
# 空间样本变差
library(nlme)
data(Wheat2) # Wheat Yield Trials
head(Wheat2)
str(Wheat2)

pdf(file = "Yields-Block.pdf", width = 10, height = 6)
plot(Wheat2)
dev.off()

m1 <- gls(yield ~ variety - 1, data = Wheat2) #

Variogram(m1, form = ~latitude + longitude)

pdf(file = "Yields-Variogram.pdf", width = 8, height = 6)
plot(Variogram(m1,
  form = ~latitude + longitude,
  data = Wheat2
), sigma = 1, grid = TRUE, smooth = TRUE
)

plot(Variogram(m1,
  form = ~latitude + longitude,
  maxDist = 32
), xlim = c(0, 32), sigma = 1, grid = TRUE, smooth = TRUE)
dev.off()

m2 <- update(m1, corr = corSpher(c(31, 0.2), form = ~latitude + longitude, nugget = TRUE))
m2

Wheat2$res <- as.numeric(residuals(m2))
plot(Variogram(m2, form = ~latitude + longitude, data = Wheat2),
  sigma = 1, grid = TRUE, scales = list(col = "black")
)



Wheat2$res <- as.numeric(residuals(m1))

library(ggplot2)
ggplot(Wheat2, aes(longitude, latitude, colour = res)) +
  geom_point(size = 5) + scale_color_gradient2()
