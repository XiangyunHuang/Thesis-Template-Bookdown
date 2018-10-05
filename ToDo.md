---
一方面为了方便自己写论文就直接全文，另一方面我的同学都是拿之前师兄师姐那传下来的论文替换，反而少了不少功夫，他们只需对照源文件和输出文件之间的效果，就可决定用哪种公式，图代码

确实需要删掉很多内容，我设想使用者对 bookdown 了解的比较少，让他们照着样子替换比自己写要更加容易和安全一些。毕竟

https://slides.yihui.name/gif/latex-tweak.gif

他们习惯了替换师兄师姐的论文，格式排版什么的也就在那几天学。

我会在之后一边写论文一边修改

谢谢 益辉和 的建议
---

## STAN 框架

比较详细地介绍 微分几何 如何做 HMC 

MCSE 蒙特卡罗标准误差 有效样本 Rhat 等量

为什么用 分位点而不用 RMSE 均方误差  均方偏差 MS

RgoogleMaps [@Loecher2015] 获取卫星图像

eight schools 数据集下载地址

https://stat.columbia.edu/~gelman/arm/examples/schools/

<https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started>

M-H/Gibbs

<https://alexey.radul.name/ideas/2017/inference-by-quadrature/>

吉布斯采样器 [@Ritter1992] 基于采样的方法计算边际密度 [@Gelfand1990]

- https://github.com/ourcodingclub/CC-Stan-intro
- https://github.com/ourcodingclub/CC-Stan-2
- http://mc-stan.org/users/documentation/tutorials.html

Exact sparse CAR models in Stan
http://mc-stan.org/users/documentation/case-studies/mbjoseph-CARStan.html

二项空间模型，经验变换后响应变量视为高斯分布，从而变成线性模型

高斯过程 协方差矩阵的 QR 分解 [@Bates1988]

A theory of statistical models for Monte Carlo integration 蒙特卡罗积分 [@Kong2003]
蒙特卡罗积分的统计模型理论

蒙特卡罗最大似然积分的收敛性 [@Geyer1994On] 

介绍 Gibbs， M-H 和 NUTS 采样器以及 R 语言实现 [@Gelman2013]

2002 年 Venables, W. N. 和 Ripley, B. D. 实现惩罚拟似然估计
检验环境和基因效应在空间相关性中的存在性 [@spaMM2014]， 流行现象的时空分析 [@surveillance2017]。 

关于 GLMM 和 LMM 的材料 notesdown repo 下的 issues


# 先验分布

- non-informative prior 无信息先验
- vague/flat/diffuse priors 模糊/扁平/漫射，扩散

An uninformative prior or diffuse prior expresses vague or general information about a variable
https://en.wikipedia.org/wiki/Prior_probability#Uninformative_priors

《SAS 手册》贝叶斯先验分布章节

stackexchange <https://stats.stackexchange.com/questions/7497/is-a-vague-prior-the-same-as-a-non-informative-prior>
维基百科 <https://en.wikipedia.org/wiki/Prior_probability>

《高等数理统计》 无信息先验分布 page 368--372

先验、似然和后验
https://m-clark.github.io/bayesian-basics/example.html

Bayesian Statistics
https://statswithr.github.io/book


## 文献综述

大大加长


# 数值模拟和数据分析

马尔科夫链蒙特卡罗方法：

- 随机游走 MH 算法  spBayes 实现
- Langevin-Hastings 算法 geoRglm geoCount 实现
- HMC 算法 NUTS 算法  STAN 实现
- MCML 算法  PrevMap 实现
- MCEM 算法 [@Zhang2002On]  C++ 实现 [@nimble2017] <https://r-nimble.org/>

蒙特卡罗最大似然方法：马尔科夫链蒙特卡罗方法模拟空间随机效应的条件分布，获得似然函数的蒙特卡罗近似

Hoffman, M. D. and Gelman, A. (2014). The No-U-Turn Sampler: adaptively setting path lengths in Hamiltonian Monte Carlo. Journal of Machine Learning Research. 15:1593–1623.

adnuts  R 语言版本实现的 NUTS 算法

近似似然函数方法：其实是近似高维积分

近似方法 [@Pinheiro1995]

- 拉普拉斯近似似然函数  INLA 实现
- Low-Rank 低秩近似  PrevMap 实现
- 拉普拉斯近似 Constant of Laplace approximation https://stats.stackexchange.com/questions/353716
- 鞍点近似 saddlepoint approximation https://stats.stackexchange.com/questions/191492
- 限制极大似然估计 REML

Testing environmental and genetic effects in the presence of spatial autocorrelation [@spaMM2014]

## 空间统计三大块：空间点模式分析、地质统计、离散空间过程

以具体例子介绍这三个统计概念的区别和联系

```{r spatial-point-patterns,fig.cap="空间点模式",fig.subcap=c("立体透视图","平面 image 图"),out.width="45%",echo=FALSE}
knitr::include_graphics(path = c(
  "figures/spatial-point-patterns-1.png",
  "figures/spatial-point-patterns-2.png"
))
```

另一种表示方式是平面的 image 图像


## 高斯马尔科夫随机场

高斯马尔科夫随机场 (Gaussian Markov Random Fields，简称 GMRF) 是一个随机向量服从多元正态分布，并且随机向量具有马尔科夫性，即 $x_i \perp x_j | \mathbf{x}_{-ij},i\neq j$，其中记号 $-ij$ 表示除了 $i$ 和 $j$ 以外的其它所有元素。

分析，模拟和预测空间过程 [@RandomFields2015]


## 基于 Stan 建模的模型诊断

http://mc-stan.org/users/documentation/case-studies/divergences_and_bias.html


## 基于 Stan 的 R 包

```r
tools::dependsOnPkgs('rstan',installed = available.packages())
```
```
 [1] "adnuts"          "BANOVA"          "bayesLopod"      "beanz"          
 [5] "bmlm"            "BMSC"            "breathteststan"  "brms"           
 [9] "clinDR"          "CopulaDTA"       "ctsem"           "DeLorean"       
[13] "dfped"           "dfpk"            "dgo"             "DrBats"         
[17] "edstan"          "eggCounts"       "evidence"        "fergm"          
[21] "gastempt"        "ggfan"           "glmmfields"      "gppm"           
[25] "GPRMortality"    "hBayesDM"        "HCT"             "idealstan"      
[29] "idem"            "JMbayes"         "MADPop"          "MCMCvis"        
[33] "MIXFIM"          "projpred"        "prophet"         "RBesT"          
[37] "rstanarm"        "rstansim"        "shinystan"       "survHE"         
[41] "themetagenomics" "tmbstan"         "trialr"          "varian"         
[45] "walker"          "ESTER"           "pollimetry"      "psycho"         
[49] "tidyposterior"   "walkr"           "tidymodels"     
```

## 与地质统计相关的 R 包

FastGP: Efficiently Using Gaussian Processes with Rcpp and RcppEigen

Contains Rcpp and RcppEigen implementations of matrix operations useful for Gaussian process models, such as the inversion of a symmetric Toeplitz matrix, sampling from multivariate normal distributions, evaluation of the log-density of a multivariate normal vector, and Bayesian inference for latent variable Gaussian process models with elliptical slice sampling (Murray, Adams, and MacKay 2010).

sgeostat: An Object-Oriented Framework for Geostatistical Modeling in S+

An Object-oriented Framework for Geostatistical Modeling in S+ containing functions for variogram estimation, variogram fitting and kriging as well as some plot functions. Written entirely in S, therefore works only for small data sets in acceptable computing time.

sparseLTSEigen: RcppEigen back end for sparse least trimmed squares regression

Use RcppEigen to fit least trimmed squares regression models with an L1 penalty in order to obtain sparse models.

hBayesDM: hierarchical Bayesian modeling of Decision-Making tasks 任务决策的贝叶斯分层建模 <https://github.com/CCS-Lab/hBayesDM> <https://rpubs.com/CCSL/hBayesDM> 


## 贝叶斯因子 {#bayes-factors}

https://rpubs.com/lindeloev/bayes_factors 
https://discourse.mc-stan.org/t/inf-bayes-factor-using-brms/5792



## 排版有关的考量

同一本书，引用不同的地方，参考文献的条目需要重复添加吗，只是页码范围不同

中英文简称：

分层线性模型 (Hierarchical linear Model，简称 HLM，又称多层线性模型，Multilevel Linear Model)
模型名称多样性格式参照 线性混合效应模型

协方差函数还是自相关函数还是核函数要统一一下

## 统一图形风格

四种颜色: darkorange dodgerblue grey Darkgrey


## 贝叶斯数据分析 {#bayesian-data-analysis}

以一个广义线性模型为例说明贝叶斯数据分析的过程。模拟数据集 logit 来自 R包 **mcmc**，它包含5个变量，一个响应变量 y 和四个预测变量 x1，x2，x3，x4。频率派的分析可以用这样几行 R 代码实现

```{r frequentist-analysis,echo=TRUE}
library(mcmc)
data(logit)
fit <- glm(y ~ x1 + x2 + x3 + x4, data = logit, 
           family = binomial(), x = TRUE)
summary(fit)
```

现在，我们想用贝叶斯的方法来分析同一份数据，假定5个参数（回归系数）的先验分布是独立同正态分布，且均值为 0，标准差为 2。

该广义线性模型的对数后验密度（对数似然加上对数先验）可以通过下面的 R 命令给出

```{r echo=TRUE}
x <- fit$x
y <- fit$y
lupost <- function(beta, x, y) {
  eta <- as.numeric(x %*% beta)
  logp <- ifelse(eta < 0, eta - log1p(exp(eta)), -log1p(exp(-eta)))
  logq <- ifelse(eta < 0, -log1p(exp(eta)), -eta - log1p(exp(-eta)))
  logl <- sum(logp[ y == 1]) + sum(logq[y == 0])
  return(logl - sum(beta^2) / 8)
}
```

为了防止溢出 (overflow) 和巨量消失 (catastrophic cancellation)，计算 $\log(p)$ 和 $\log(q)$ 使用了如下技巧

\begin{align*}
p &= \frac{\exp(\eta)}{1 + \exp(\eta)} = \frac{1}{1 + \exp(- \eta)} \\
q &= \frac{1}{1 + \exp(\eta)} = \frac{\exp(- \eta)}{1 + \exp(- \eta)}
\end{align*}

然后对上式取对数

\begin{align*}
\log(p) &= \eta - \log(1 + \exp(\eta)) = - \log(1 + \exp(- \eta)) \\
\log(q) &= - \log(1 + exp(\eta)) = - \eta - \log(1 + \exp(-\eta))
\end{align*}

为防止溢出，我们总是让 exp 的参数取负数，也防止在 $|\eta|$ 很大时巨量消失。比如，当 $\eta$ 为很大的正数时，

\begin{align*}
p & \approx  1  \\
q & \approx  0 \\
\log(p) & \approx  - \exp(-\eta) \\
\log(q) & \approx  - \eta - \exp(-\eta)
\end{align*}

当 $\eta$ 为很小的数时，使用 R 内置的函数 log1p 计算，当 $\eta$ 为大的负数时，情况类似^[更加精确的计算 $\log(1-\exp(-|a|)), |a| \ll 1$ 可以借助 **Rmpfr** 包 <https://r-forge.r-project.org/projects/rmpfr/>]。

有了上面这些准备，现在可以运行随机游走 Metropolis 算法模拟后验分布

```{r echo=TRUE}
set.seed(2018)
beta.init <- as.numeric(coefficients(fit))
fit.bayes <- metrop(obj = lupost, initial = beta.init, 
                    nbatch = 1e3, blen = 1, nspac = 1, x = x, y = y)
names(fit.bayes)
fit.bayes$accept
```

这里使用的 metrop 函数的参数说明如下：

- 自编的 R 函数 lupost 计算未归一化的 Markov 链的平稳分布（后验分布）的对数密度；
- beta.init 表示 Markov 链的初始状态；
- Markov 链的 batches；
- x,y 是提供给目标函数 lupost 的额外参数

---------------------------------------------------


## 其它概率编程框架

什么是 probabilistic programming language

PyMC3

NIMBLE [@nimble2017]

## INLA 框架

集成嵌套拉普拉斯近似 (Integrated Nested Laplace Approximations，简称 INLA)

介绍模型 https://www.flutterbys.com.au/stats/tut/tut12.9.html

INLA software can handle thousands of Gaussian latent variables, but only up to 15 hyperparameters, because INLA software uses CCD for hyperparameters. If MCMC is used for hyperparameters, then it’s possible to handle more hyperparameters. For example, GPstuff allows use of MCMC instead of CCD for hyperparameters, and Daniel Simpson would like to get Laplace approximation to Stan so that he could handle thousands of hyperparameters.

INLA 软件能处理上千个高斯随机效应，但最多只能处理 15 个超参数，因为 INLA 使用 CCD 处理超参数，如果使用 MCMC 处理超参数，就有可能处理更多的超参数，如 GPstuff 使用 MCMC 而不是 CCD 处理超参数，Daniel Simpson 想把 Laplace approximation 带入 Stan，这样他就可以处理上千个超参数

## 修正的第三类贝塞尔函数

```r
exp(0.5)*besselK(0.5,20)
besselK(0.5,20,expon.scaled = T)
```
