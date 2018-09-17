# 广义线性混合效应模型
# P.324 333
# http://www.highstat.com/index.php/mixed-effects-models-and-extensions-in-ecology-with-r
Birdies <- read.table(file = "C:/YourDirectory/Blahblah.txt", header = TRUE, dec = ".")
library(AED)
data(DeerEcervi)
DeerEcervi$Ecervi.01 <- DeerEcervi$Ecervi
DeerEcervi$Ecervi.01[DeerEcervi$Ecervi>0] <-1
DeerEcervi$fSex <- factor(DeerEcervi$Sex)
DeerEcervi$CLength <- DeerEcervi$Length - mean(DeerEcervi$Length)
DeerEcervi$fFarm <- factor(DeerEcervi$Farm)

library(geepack)
DE.gee <- geeglm(Ecervi.01 ~ CLength * fSex, data = DeerEcervi, family = binomial, id = Farm, corstr = "exchangeable")
summary(DE.gee)

DE.glm <- glm(Ecervi.01 ~ CLength * fSex + fFarm, data = DeerEcervi, family = binomial)
drop1(DE.glm, test = "Chi")

library(MASS)
DE.PQL <- glmmPQL(Ecervi.01 ~ CLength * fSex, random = ~ 1 | fFarm, family = binomial, data = DeerEcervi)
summary(DE.PQL)

library(lme4)
DE.lme4 <- lmer(Ecervi.01 ~ CLength * fSex + (1 | fFarm), family = binomial, data = DeerEcervi)
summary(DE.lme4)

library(glmmML)
DE.glmmML <- glmmML(Ecervi.01 ~ CLength * fSex, cluster = fFarm, family = binomial,data = DeerEcervi)
summary(DE.glmmML)
