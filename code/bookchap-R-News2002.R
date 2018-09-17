# The commands for the example in Diggle, Ribeiro Jr and Christensen (2003) [bookchapter], 
# and Christensen and Ribeiro Jr (2002) [R-news].
# WARNING: RUNNING THIS IS VERY TIME-CONSUMING AND MEMORY-DEMANDING
library(geoR)
library(geoRglm)

## Simulating data
sim <- grf(grid = expand.grid(x = seq(0.0555, 0.944444, l = 8), y = seq(0.0555, 0.944444, l = 8)), 
           cov.pars = c(0.5, 0.2))
attr(sim, "class") <- "geodata"
sim$units.m <- rep(4, 64)
sim$prob <- exp(sim$data) / (1 + exp(sim$data))
sim$data <- rbinom(64, size = sim$units.m, prob = sim$prob)

## Visualising the data and the (unobserved) random effects
par(mfrow = c(1, 2), mar = c(2.3, 2.5, .5, .7), mgp = c(1.5, .6, 0), cex = 0.6)
plot(c(0, 1), c(-0.1, 1), type = "n", xlab = "Coordinate X", ylab = "Coordinate Y")
text(sim$coords[, 1], sim$coords[, 2], format(round(sim$prob, digits = 2)), cex = 0.9)
plot(c(0, 1), c(-0.1, 1), type = "n", xlab = "Coordinate X", ylab = "Coordinate Y")
text(sim$coords[, 1], sim$coords[, 2], format(sim$data), cex = 1.1)
points(sim$coords[c(1, 29), ], cex = 5.5)

## Setting input options and running the function
prior.sim <- prior.glm.control(
  beta.prior = "normal", beta = 0, beta.var = 1, phi.prior = "exponential", phi = 0.2,
  phi.discrete = seq(0.005, 0.3, l = 60), sigmasq.prior = "sc.inv.chisq", 
  df.sigmasq = 5, sigmasq = 0.5
)
mcmc.sim <- mcmc.control(S.scale = 0.05, phi.scale = 0.015, thin = 100, burn.in = 10000)
pred.grid <- expand.grid(x = seq(0.0125, 0.9875, l = 40), y = seq(0.0125, 0.9875, l = 40))
out.sim <- output.glm.control(sim.predict = TRUE)
run.sim <- binom.krige.bayes(sim, locations = pred.grid, prior = prior.sim, 
                             mcmc.input = mcmc.sim, output = out.sim)

## Autocorrelations
par(mfrow = c(3, 2), mar = c(2.3, 2.5, .5, .7), mgp = c(1.5, .6, 0), cex = 0.6)
plot(run.sim$posterior$sim[1, ], type = "l", ylab = "S(0.056, 0.056)")
acf(run.sim$posterior$sim[1, ], main = "")
plot(run.sim$posterior$sim[29, ], type = "l", ylab = "S(0.563, 0.436)")
acf(run.sim$posterior$sim[29, ], main = "")
plot(run.sim$posterior$phi.s, type = "l", ylab = "phi")
acf(run.sim$posterior$phi.s, main = "")

## Plot of timeseries
par(mfrow = c(3, 1), mar = c(2.3, 2.5, .5, .7), mgp = c(1.5, .6, 0), cex = 0.6)
plot(run.sim$posterior$sim[1, ], type = "l", ylab = "S(0.056, 0.056)")
plot(run.sim$posterior$sim[29, ], type = "l", ylab = "S(0.563, 0.436)")
plot(run.sim$posterior$phi.s, type = "l", ylab = "phi")

## Predictions
sim.predict <- apply(run.sim$pred$sim, 1, mean)
sim.predict.var <- apply(run.sim$pred$sim, 1, var)
par(mfrow = c(1, 2), mar = c(2.3, 2.5, .5, .7), mgp = c(1.5, .6, 0), cex = 0.6)
image(
  x = sim.predict, locations = pred.grid, values = sim.predict, 
  col = gray(seq(1, 0, l = 30)),
  x.leg = c(0.1, 0.9), y.leg = c(-0.12, -0.07), cex.leg = 0.7, 
  xlab = "Coordinate X", ylab = "Coordinate Y"
)
image(
  x = sim.predict.var, locations = pred.grid, 
  values = sim.predict.var, col = gray(seq(1, 0, l = 30)),
  x.leg = c(0.1, 0.9), y.leg = c(-0.12, -0.07), cex.leg = 0.7, 
  xlab = "Coordinate X", ylab = "Coordinate Y"
)
