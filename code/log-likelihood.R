set.seed(1234)
n <- 20 # 随机数的个数
x <- rexp(n, rate = 5) # 服从指数分布的随机数
m <- 40 # 网格数
mv <- seq(mean(x) - 1.5 * sd(x) / sqrt(n),
  mean(x) + 1.5 * sd(x) / sqrt(n),
  length.out = m
)
sv <- seq(0.8 * sd(x), 1.5 * sd(x), length.out = m)
z <- matrix(NA, m, m)
loglikelihood <- function(b) -sum(dnorm(x, b[1], b[2], log = TRUE))

for (i in 1:m)
  for (j in 1:m)
    z[i, j] <- -loglikelihood(c(mv[i], sv[j]))

jet.colors <- colorRampPalette(c("gray100", "gray40"))
nbcol <- 100
color <- jet.colors(nbcol)
zfacet <- z[-1, -1] + z[-1, -m] + z[-m, -1] + z[-m, -m]
facetcol <- cut(zfacet, nbcol)

persp(mv, sv, z,
  xlab = "\n mu", ylab = "\n sigma",
  zlab = "\n log-likelihood",  border = "lightgray",
  phi = 35, theta = -30, col = "grey" # , col = color[facetcol]
) -> res
?persp
points() # col = "black"
# 添加初始迭代点 初值 样本均值和方差 真实值和算法迭代获得的近似值
xE <- c(-10,10); xy <- expand.grid(xE, xE)
points(trans3d(xy[,1], xy[,2], 6, pmat = res), col = "black", pch = 16) # 画四个点
# 标记点 step0 step1 x0 \hat{x} x
# 指数，正态分布 泊松，二项分布 参数之间的关系  均值和方差之间的关系





