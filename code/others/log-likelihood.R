# 以单参数指数分布为例说明 对数似然函数若为凸函数，
# 则极大化对数似然获得的参数估计值为最大似然值，具有全局最优性，然而在空间混合效应模型中，
# 关于参数的对数似然函数不满足这一点，而且由于没有显式表达式，无法直接获得似然曲面，
# 通常的做法是在初值附近离散参数获得一组初值，往往有成千上万对参数值，
# 将每组参数放入对数似然函数中进行迭代以获得多个局部极值点，
# 再根据参数的剖面似然曲面选择最优的参数初值和似然函数的极大值

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

