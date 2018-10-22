library(geoR)
library(geoRglm)
data(rongelap)

# sigmasq = 2.40 phi=340 
# tausq = 2.075 * 2.40 = 2.075* sigmasq
MCmle.input.fixed <- glsm.mcmc(rongelap,
                               model = list(family = "poisson", link = "boxcox", cov.pars = c(2.40, 340), 
                                            beta = 6.2, nugget = 2.075 * 2.40, lambda = 1),
                               mcmc.input = mcmc.control(S.scale = 0.5, thin = 20, burn.in = 10000)
)

## investigating mixing and convergence 诊断收敛性
library(coda)
MCmle.coda <- create.mcmc.coda(MCmle.input.fixed, mcmc.input = list(thin = 20, burn.in = 10000)) 
# 样本序列 = 1000 = 20000/20
plot(MCmle.coda)
autocorr.plot(MCmle.coda)

## maximum likelihood 
mcmcobj <- prepare.likfit.glsm(MCmle.input.fixed)
# 极大似然 不做 box-cox 变换 lambda = 1
lik.boxcox.1.expon.nugget <- likfit.glsm(mcmcobj, ini.phi = 100) 

beta = 6.188
sigmasq = 2.403
phi =  338.365539370923 = 338.365
tausq.rel =  2.05279810010003 = 2.0528
log-likelihood =  0.0022337659216447 = 2.234*10^{-3}

# 估计 phi 和 tau^2 的策略 
# phi 160--800 间隔 20  tau^2_{R} = tau^2/sigma^2  1 到 3 化成 21分

## profile likelihood for (phi,tausq.rel) [two-dimensional figure].
# 33*21
pr.lik.rongelap <- proflik.glsm(mcmcobj, lik.boxcox.1.expon.nugget,
                                phi.values = seq(8, 40) * 20, 
                                nugget.rel.values = seq(1, 3, l = 21)
)

# 更宽的似然曲面
# Figure 1: 关于方差成分 phi 和 tau^2 的剖面似然曲面 

pr.lik.rongelap <- proflik.glsm(mcmcobj, lik.boxcox.1.expon.nugget,
                                phi.values = seq(5, 40) * 20, 
                                nugget.rel.values = seq(0.5, 4.5, l = 201)
)
pdf("profile-phitausq.pdf")
par(cex = 0.9,mar=c(4.5,4.5,0.5,0.5))
plot(pr.lik.rongelap, levels = seq(-5, 1, by = 0.05), labcex = .55)
dev.off()

# 每个站点的预测和方差
emp.mean <- apply(MCmle.input.fixed$sim, 1, mean)
emp.var <- cov(t(MCmle.input.fixed$sim))

# S(x) 模拟过程和 profile 似然实现过程
# geoRglm.Rcheck/00_pkg_src/geoRglm/man/ proflik.glsm.Rd glsm.mcmc.Rd

