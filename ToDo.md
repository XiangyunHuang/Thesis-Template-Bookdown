分别使用低秩近似算法 (LR)， 蒙特卡罗最大似然算法 (MCML)， 贝叶斯 MCMC 算法 (MCMC) 和贝叶斯 STAN-MCMC 算法 (STAN-MCMC) 估计模型的参数。与 Stan 比较

## 线性混合效应模型 {#Linear-Mixed-Effects-Models}

模型结构，参数估计，惩罚最小二乘和广义最小二乘
极大似然估计和限制极大似然估计 lme4 包 [@Bates2015]
剖面似然估计 profile 似然

## 空间线性混合效应模型

Kriging 插值 [@gstat2004;@gstat2016]
gstat: Spatial and Spatio-Temporal Geostatistical Modelling, Prediction and Simulation

MCMC 方法应用于 GLMM 模型 [@MCMCglmm2010]

在依据似然函数做统计推断的情况下，必须解决高维积分的问题，解决高维积分的两条路：采用拉普拉斯近似方法近似积分，蒙特卡罗方法求积分

<!-- Pairwise likelihood inference [@Pairwise2005] data cloning algorithm [@Baghishani2011] Approximate Monte Carlo EM Gradient [@Hosseini2016]-->

[重新安排逻辑顺序第三章: 空间广义线性混合效应模型]{.todo}

---
Exponential family: 

$$
f(y;\theta,\phi) = \exp[(a(y) b(\theta) + c(\theta))/f(\phi) + d(y,\phi)]
$$

Poisson (with $\lambda \to \theta$, $x \to y$) ($\phi=1$):

\begin{equation*}
\begin{split}
f(y,\theta) & = \exp(-\theta) \theta^y/(y!) \\
            & = \exp\left( \underbrace{y}_{a(y)} 
                           \underbrace{\log \theta}_{b(\theta)} + 
                           \underbrace{(-\theta)}_{c(\theta)} + 
                           \underbrace{(- \log(y!))}_{d(y)} \right)
\end{split} (\#eq:another-exp-fam)
\end{equation*}

---
## 极大似然估计 {#maximum-likelihood-estimates}

书本定义和性质，在后续章节介绍限制极大似然 Restricted Maximum likelihood, 简称 REML

惩罚拟似然 Penalized Quasi-Likelihood, 简称 PQL 和边际拟似然 Marginal Quasi-Likelihood, 简称 MQL

Profile Maximal Likelihood, 简称 PML

Penalized maximum likelihood estimates are calculated using optimization methods such as the limited memory Broyden-Fletcher-Goldfarb-Shanno algorithm.

BFGS 拟牛顿法和采样器 https://bookdown.org/rdpeng/advstatcomp

---

后面每个模型及参数设置都要详细说明，包括模拟过程要对应到前面的算法步骤，分不同的样本量n=50,70,90和参数设置$\phi,\sigma^2,\tau^2$取不同的值做模拟，

|$\hat\beta_0(std,rmse)$| 一个位置有三个值，估计值、对应的标准差和均方误差，好好思考下大表格要怎么放，markdown语法下的表格怎么做，|$\hat\phi(std,rmse)$,$\hat\sigma^2(std,rmse)$|


<!-- Table: (\#tab:simulation-norm) 正态分布情形下的数值模拟比较 -->

<!-- |    参数       | 真值 |  估计  |    | | CPU (s) | -->
<!-- | :----------------: | :----------------: | :----------------: | :----------------: | :-----------: | :---------------: | :-------------: | :----------------: | -->
<!-- | $\beta_{0}$   | 1.977 | 1.016 | 0.803 | 21.937 | 0.857 | 0.960 | 298.250 | -->
<!-- | $\beta_{1}$   | 1.966 | 1.007 | 0.796 | 28.172 | 1.365 | 0.516 | 464.420 | -->
<!-- | $\beta_{2}$   | 1.958 | 1.007 | 0.796 | 38.114 | 1.159 | 0.970 | 634.720 | -->
<!-- | $\sigma^2$    | 1.935 | 1.008 | 0.796 | 44.317 | 3.916 | 0.264 | 326.780 | -->
<!-- | $\phi$        | 1.00  | 1.05  | 0.80  | 0.14   |  1.68 | 0.94  | 238.05  | -->

<!-- \begin{table}[!h] -->
<!-- \begin{center} -->
<!-- \caption{ 100个数据集的模拟结果：估计，标准差和估计的均方误差 \label{tab:binomal-LRvsMCML}} -->
<!-- \setlength{\tabcolsep}{2pt} -->
<!-- \vspace{0.1in} -->

<!-- \begin{tabular}{lcccccccccc} -->
<!--  \hline -->
<!--   参数 &  真值 & \multicolumn{3}{c}{LR8$^*$} & \multicolumn{3}{c}{LR16$^*$} &  -->
<!--  \multicolumn{3}{c}{MCML} \\ -->
<!--   \cmidrule(r){3-5}  \cmidrule(r){6-8} \cmidrule(r){9-11} -->
<!--  \noalign{\smallskip}  -->
<!--                 &      & 估计   & 标准差 & 均方误差 & 估计   & 标准差 & 均方误差   & 估计  & 标准差 & 均方误差 \\  -->
<!--    \hline -->
<!--    $\beta_{0}$  & -1.0 & -1.837 & 0.118  &  0.592   & -1.259 & 0.126  & 0.110      & -1.086 & 0.294   &  0.103 \\  -->
<!--    $\beta_{1}$  & 1.0  & 1.143  & 0.071  &  0.133   & 1.291  & 0.073  & 0.063      & 0.989  & 0.072   &  0.049 \\  -->
<!--    $\beta_{2}$  & 0.5  & 0.413  & 0.025  &  0.073   & 0.241  & 0.026  & 0.014      & 0.339  & 0.012   &  0.012 \\  -->
<!--    $\sigma^2$   & 1.0  & 0.528  & 0.177  &  4.060   & 0.499  & 0.090  & 0.060      & 0.268  & 0.405   &  0.013 \\  -->
<!--    $\phi$       & 1.0  & 0.478  & 0.052  &  0.131   & 0.110  & 0.041  & 0.007      & 0.073  & 0.167   &  0.007 \\  -->
<!--    \hline -->
<!--  \end{tabular} -->
<!-- \end{center} -->
<!-- \vspace{0.05in} -->

<!-- * LR8/LR16：低秩近似算法分别使用 $8\times 8$ 和 $16\times 16$ 个采样点， -->

<!-- \end{table} -->


<!-- \begin{table} -->
<!-- \begin{center} -->
<!-- \caption{ 100 个数据集的模拟结果：估计，标准差和估计的均方误差 \label{tab:binomal-MCMCvsSTAN}} -->
<!-- \setlength{\tabcolsep}{2pt} -->
<!-- \vspace{0.1in} -->

<!-- \begin{tabular}{lccccccc} -->
<!--  \hline -->
<!--   参数 &  真值 & \multicolumn{3}{c}{贝叶斯MCMC} & \multicolumn{3}{c}{贝叶斯STAN-MCMC}  \\ -->
<!--   \cmidrule(r){3-5}  \cmidrule(r){6-8}  -->
<!--  \noalign{\smallskip}  -->
<!--                 &     & 估计  & 标准差 & 均方误差 & 估计  & 标准差 & 均方误差 \\  -->
<!--    \hline -->
<!--    $\beta_{0}$  & -1.0 & -1.239 & 0.848 &  0.777   & -1.225 & 0.248  & 0.112      \\  -->
<!--    $\beta_{1}$  & 1.0  & 0.985 & 0.052  &  2.941e-03   & 1.026  & 0.054  & 3.607e-03      \\  -->
<!--    $\beta_{2}$  & 0.5  & 0.519 & 0.019  &  7.422e-04   & 0.503  & 0.016  & 2.649e-04      \\  -->
<!--    $\sigma^2$   & 1.0  & 0.803 & 0.521  &  0.310   & 0.322  & 0.283  & 0.540      \\  -->
<!--    $\phi$       & 1.0  & 0.182 & 0.069  &  0.673   & 0.514  & 0.322  & 0.341      \\  -->
<!--    \hline -->
<!--  \end{tabular} -->
<!-- \end{center} -->
<!-- \end{table} -->

<!-- \begin{table} -->
<!-- \begin{center} -->
<!-- \caption{ 100个数据集的模拟结果：估计，标准差和估计的均方误差 \label{tab:possion-LRvsMCML}} -->
<!-- \setlength{\tabcolsep}{2pt} -->
<!-- \vspace{0.1in} -->

<!-- \begin{tabular}{lcccccccccc} -->
<!--  \hline -->
<!--   参数 &  真值 & \multicolumn{3}{c}{LR8} & \multicolumn{3}{c}{LR16} &  -->
<!--  \multicolumn{3}{c}{MCML} \\ -->
<!--   \cmidrule(r){3-5}  \cmidrule(r){6-8} \cmidrule(r){9-11} -->
<!--  \noalign{\smallskip}  -->
<!--                 &     & 估计  & 标准差 & 均方误差 & 估计  & 标准差 & 均方误差 & 估计  & 标准差 & 均方误差 \\  -->
<!--    \hline -->
<!--    $\beta_{0}$  & -1.0 & -1.837 & 0.118  &  0.592   & -1.259 & 0.126  & 0.110      & -1.086 & 0.294   &  0.103 \\  -->
<!--    $\beta_{1}$  & 1.0  & 1.143  & 0.071  &  0.133   & 1.291  & 0.073  & 0.063      & 0.989  & 0.072   &  0.049 \\  -->
<!--    $\beta_{2}$  & 0.5  & 0.413  & 0.025  &  0.073   & 0.241  & 0.026  & 0.014      & 0.339  & 0.012   &  0.012 \\  -->
<!--    $\sigma^2$   & 1.0  & 0.528  & 0.177  &  4.060   & 0.499  & 0.090  & 0.060      & 0.268  & 0.405   &  0.013 \\  -->
<!--    $\phi$       & 1.0  & 0.478  & 0.052  &  0.131   & 0.110  & 0.041  & 0.007      & 0.073  & 0.167   &  0.007 \\  -->
<!--    \hline -->
<!--  \end{tabular} -->
<!-- \end{center} -->
<!-- \end{table} -->


<!-- \begin{table} -->
<!-- \begin{center} -->
<!-- \caption{ 100个数据集的模拟结果：估计，标准差和估计的均方误差 \label{tab:possion-MCMCvsSTAN}} -->
<!-- \setlength{\tabcolsep}{2pt} -->
<!-- \vspace{0.1in} -->

<!-- \begin{tabular}{lccccccc} -->
<!--  \hline -->
<!--   参数 &  真值 & \multicolumn{3}{c}{贝叶斯MCMC} & \multicolumn{3}{c}{贝叶斯STAN-MCMC}  \\ -->
<!--   \cmidrule(r){3-5}  \cmidrule(r){6-8}  -->
<!--  \noalign{\smallskip}  -->
<!--                 &     & 估计  & 标准差 & 均方误差 & 估计  & 标准差 & 均方误差 \\  -->
<!--    \hline -->
<!--    $\beta_{0}$  & -1.0 & -5.430 & 0.562  &  1.994   & -2.060 & 0.825  & 1.805    \\  -->
<!--    $\beta_{1}$  & 1.0  & 0.942 & 0.082  &  0.110   & 1.113  & 0.311  & 0.109    \\  -->
<!--    $\beta_{2}$  & 0.5  & 0.591 & 0.039  &  0.992   & 0.563  & 0.066  & 8.463e-03     \\  -->
<!--    $\sigma^2$   & 1.0  & 0.415 & 0.264  &  0.412   & 0.830  & 0.497  & 0.276    \\  -->
<!--    $\phi$       & 1.0  & 0.514 & 0.492  &  0.478   & 0.392  & 0.223  & 0.418    \\  -->
<!--    \hline -->
<!--  \end{tabular} -->
<!-- \end{center} -->
<!-- \end{table} -->

<!-- 为什么要做这个数据分析，数据要介绍清楚，模型的各个部分要介绍清楚， MCML/PrevMap  ML/Low-Rank 比较 -->
<!-- 在实际数据情况下，哪个模型好，另一方面介绍，模型结论是什么，什么对流行度/感染程度 影响大，哪个影响小，变量影响程度可以用 P值是否显著来表达， -->


<!-- Table: (\#tab:rongelap-estimation1) MCML算法估计模型的参数 -->

<!-- | 参数        | 估计        | 标准差      |   P 值      | -->
<!-- | :---------: | :--------:  | :---------: | :------:    | -->
<!-- | $\beta_{0}$ |  7.641      | 0.172       | 1.582e-14   | -->
<!-- | $\sigma^2$  | 0.295       | 0.643       | -           | -->
<!-- | $\phi$      | 103.075     | 1.812e+44   | -           | -->

<!-- Table: (\#tab:rongelap-estimation2) 贝叶斯 MCMC 算法估计模型的参数 -->

<!-- | 参数        | 估计        | 标准差      |   均方误差  | -->
<!-- | :---------: | :--------:  | :---------: | :------:    | -->
<!-- | $\beta_{0}$ | 7.988       | 0.062       | 5.095e-03   | -->
<!-- | $\sigma^2$  | 0.380       | 0.048       | 3.926e-03   | -->
<!-- | $\phi$      | 16.440      | 7.828       | 6.391e-02   | -->

<!-- Table: (\#tab:rongelap-estimation3) 贝叶斯STAN-MCMC算法估计模型的参数 -->

<!-- | 参数        | 估计        | 标准差      |   均方误差  | -->
<!-- | :---------: | :--------:  | :---------: | :------:    | -->
<!-- | $\beta_{0}$ | 8.697       | 0.028       | 5.563e-03   | -->
<!-- | $\sigma^2$  | 0.812       | 0.017       | 1.390e-03   | -->
<!-- | $\phi$      | 10.893      | 5.302       | 4.754e-02   | -->

<!-- 比较表 \@ref(tab:rongelap-estimation2) 和表 \@ref(tab:rongelap-estimation3)，发现贝叶斯 STAN-MCMC 算法与贝叶斯 MCMC 算法相比，在均方误差的意义下效果稍好一点。 -->

<!-- Table: (\#tab:rongelap-without-nugget-effect) 不带块金效应的模型 \@ref(eq:rongelap-without-nugget-effect) 参数估计和 95\% 的置信区间 -->

<!-- | 参数            |   2.5\%分位点   |   97.5\%分位点  |   均值 (mean)  |  中位数 (median)  | -->
<!-- | :-------------- | :-------------: | :-------------: | :------------: | :---------------: | -->
<!-- | $\beta_0$       |    1.674000     |     1.989000    |    1.830112    |   -0.077961       | -->
<!-- | $\sigma$        |    0.488595     |     0.594607    |    0.539014    |   -0.077961       | -->

使用贝叶斯 MCMC 算法和 STAN-MCMC 算法计算 Poisson-SGLMM 模型的参数，比较效果。

冈比亚儿童疟疾流行强度的空间分布
[MCMC 和 INLA 比较]{.todo}


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
- HMC 算法 NUTS 算法  STAN 包  adnuts  R 实现
- MCML 算法  PrevMap 实现
- MCEM 算法 [@Zhang2002On]  C++ 实现 [@nimble2017] <https://r-nimble.org/>

> 蒙特卡罗最大似然方法：马尔科夫链蒙特卡罗方法模拟空间随机效应的条件分布，获得似然函数的蒙特卡罗积分近似，然后极大化这个近似，获得参数的估计，即为 MCML 

Hoffman, M. D. and Gelman, A. (2014). The No-U-Turn Sampler: adaptively setting path lengths in Hamiltonian Monte Carlo. Journal of Machine Learning Research. 15:1593–1623.

近似似然函数方法：

> 本质是近似空间随机效应的高维积分 [@Pinheiro1995]

- 拉普拉斯近似似然函数  INLA 实现
- Low-Rank 低秩近似  PrevMap 实现
- 拉普拉斯近似 Constant of Laplace approximation https://stats.stackexchange.com/questions/353716
- 鞍点近似 saddlepoint approximation https://stats.stackexchange.com/questions/191492
- REML 限制极大似然估计 Testing environmental and genetic effects in the presence of spatial autocorrelation [@spaMM2014]



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


## 贝叶斯因子 {#bayes-factors}

https://rpubs.com/lindeloev/bayes_factors 
https://discourse.mc-stan.org/t/inf-bayes-factor-using-brms/5792



## 排版有关的考量

同一本书，引用不同的地方，参考文献的条目需要重复添加吗，只是页码范围不同

中英文简称：分层线性模型 (Hierarchical linear Model，简称 HLM，又称多层线性模型，Multilevel Linear Model)
模型名称多样性格式参照 线性混合效应模型

协方差函数还是自相关函数还是核函数要统一一下

四种颜色: darkorange dodgerblue grey Darkgrey

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
