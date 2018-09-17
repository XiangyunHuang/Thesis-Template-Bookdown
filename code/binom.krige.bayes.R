# The following short demonstation was presented at my Ph.D. viva in Aalborg, December 2001. 
# [a few minor changes have been made since then, to accomodate changes in R, geoR and geoRglm].
# WARNING: RUNNING THIS IS VERY TIME-CONSUMING
## 
## 1. Simulating data 
## 

sim <- grf(grid = expand.grid(x = seq(1.1, 7.1, l = 7), y = seq(1.1, 7.1, l = 7)), cov.pars = c(0.1, 2)) 
sim$units.m <- rep(4,49) 
sim$data <- rbinom(49, size = rep(4,49), prob = exp(sim$data)/(1+exp(sim$data))) 

## 2. Visualising the data 
## 
plot(sim$coords, type = "n") 
text(sim$coords[,1], sim$coords[,2], format(sim$data), cex=1.5)

## 3. Setting input options 

sim.pr <- prior.glm.control(phi.discrete = seq(0.05, 3, l=60)) 
sim.mcmc <- mcmc.control(S.scale = 0.1, phi.scale = 0.04, burn.in=10000) 
grid <- expand.grid(x = seq(1, 7, l = 51), y = seq(1, 7, l = 51)) 

run.sim <- binom.krige.bayes(sim, locations = grid, prior = sim.pr, mcmc.input = sim.mcmc) 

## inspecting output 
names(run.sim)
names(run.sim$posterior) 
names(run.sim$posterior$phi) 

par(mfrow=c(2,2), mar=c(2.3,2.5,.5,.7), mgp=c(1.5,.6,0), cex=0.6) 
plot(run.sim$posterior$phi$sample,type="l") 
acf(run.sim$posterior$phi$sample) 
plot(run.sim$posterior$sim[1,],type="l") 
acf(run.sim$posterior$sim[1,]) 

## Predictions 
## 

names(run.sim$predictive)

## 
## Plotting predictions 
## 
image(run.sim, locations = grid, values = run.sim$pred$median ) 


