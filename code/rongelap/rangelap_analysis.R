# 原始数据绘制

# rongelap <- read.table(url(
#   paste("http://www.leg.ufpr.br/lib/exe/fetch.php/",
#     "pessoais:paulojus:mbgbook:datasets:rongelap.txt",
#     sep = ""
#   )
# ), header = TRUE)

rongelap <- read.table("code/rongelap/rongelap.txt", header = TRUE)


# rongelap_coastline <- read.table(url(
#   paste("http://www.leg.ufpr.br/lib/exe/fetch.php/",
#     "pessoais:paulojus:mbgbook:datasets:rongelap-coastline.txt",
#     sep = ""
#   )
# ), header = TRUE)

rongelap_coastline <- read.table("code/rongelap/rongelap-coastline.txt", header = TRUE)

library(spdep)
coordinates(rongelap) = ~ cX + cY

pdf(file = "rongelap.pdf")
par(mar = c(4.1, 4.1, 0.5, 0.5))
plot(c(-7000, 1000), c(-4000, 1000), type = "n", xlab = "X Coord",ylab = "Y Coord")
plot(rongelap, add = T)
lines(rongelap_coastline)
# coordinate 坐标
dev.off()


range(rongelap_coastline$cX)
range(rongelap_coastline$cY)


#########################################################

library(glmmBUGS)
library(R2OpenBUGS)
library(rgdal)

data("rongelapUTM")
library(sp)
plot(rongelapUTM)
rongelapBorderLL <- raster::getData("GADM", country = "MHL", level = 0)

rongelapBorderUTM <- spTransform(rongelapBorderLL, CRS(proj4string(rongelapUTM)))
plot(rongelapBorderUTM, add = TRUE) # 添加边界

# http://rgooglemaps.r-forge.r-project.org/QuickTutorial.html
# https://pakillo.github.io/R-GIS-tutorial/#rgooglemaps

###########################################################

rongelapUTM$logOffset <- log(rongelapUTM$time)
rongelapUTM$site <- seq(1, length(rongelapUTM$time))

forBugs <- glmmBUGS(
  formula = count + logOffset ~ 1, family = "poisson",
  data = rongelapUTM@data, effects = "site", spatial = rongelapUTM,
  priors = list(phisite = "dgamma(100,1)")
)

startingValues <- forBugs$startingValues
startingValues$phi$site <- 100

source("getInits.R")

start.tic <- proc.time()
rongelapUTMResult <- bugs(forBugs$ragged, getInits,
  parameters.to.save = names(getInits()),
  model.file = "model.txt", n.chain = 4, n.iter = 2000, n.burnin = 1000, n.thin = 5,
  debug = FALSE, OpenBUGS.pgm = "C:/Program Files (x86)/OpenBUGS/OpenBUGS323/OpenBUGS.exe",
  working.directory = getwd()
)
(mcmc_time <- proc.time() - start.tic) # 程序运行时间
# user  system elapsed
# 1.02    0.17 4342.82 # 1个半小时

# DIC is an estimate of expected predictive error (lower deviance is better) 偏差越小越好
save.image("C:\\Users\\xy-huang\\Documents\\rongelap\\rongelap-OpenBUGS-glmmBUGS.RData")
# Reparametrise bugs output
# Undoes the parametrisation used in writeBugsModel,
# and gives the original names to random effect levels.
source("C:\\Users\\xy-huang\\Documents\\rongelap\\restoreParams.r")
rongelapUTMParams <- restoreParams(rongelapUTMResult, forBugs$ragged)
# Error in if (dim(result$betas)[3] == 1) { : argument is of length zero

checkChain(rongelapUTMParams)

# library('spdep')
# library(RandomFields)
# https://www.rdocumentation.org/packages/glmmBUGS/versions/2.0/topics/CondSimuPosterior
# Uses the function CondSimu in the RandomFields package.
# CondSimu 被抛弃了
# rongelapUTMParams$siteGrid = CondSimuPosterior(rongelapUTMParams, rongelapUTM, gridSize=100)
rongelapUTMSummary <- summaryChain(rongelapUTMParams)

# plot posterior probabilities of being above average
# image(rongelapUTMSummary$siteGrid$pgt0)

#####################################################################################
# on linux
library(glmmBUGS)
library(R2OpenBUGS)

data(rongelapUTM)
rongelapUTM$logOffset <- log(rongelapUTM$time)
rongelapUTM$site <- seq(1, length(rongelapUTM$time))

forBugs <- glmmBUGS(
  formula = count + logOffset ~ 1, family = "poisson",
  data = rongelapUTM@data, effects = "site", spatial = rongelapUTM,
  priors = list(phisite = "dgamma(100,1)")
)

startingValues <- forBugs$startingValues
startingValues$phi$site <- 100

source("getInits.R")

rongelapUTMResult <- bugs(forBugs$ragged, getInits,
  parameters.to.save = names(getInits()),
  model.file = "model.txt", n.chain = 2, n.iter = 20000, n.burnin = 10000, n.thin = 2,
  debug = FALSE,
  working.directory = getwd()
)

rongelapUTMParams <- restoreParams(rongelapUTMResult, forBugs$ragged)
checkChain(rongelapUTMParams)
