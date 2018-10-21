elevation <- read.table(file = "data/NOTREDAM.TXT", header = T)

with(elevation, {
  plot(North.South ~ East.West, frame.plot = F, pch = 16)
  text(
    x = East.West, y = North.South,
    labels = Elevation, adj = c(0, 0), xpd = 1
  )
})

library(nlme)

m1 <- gls(Elevation ~ 1, data = elevation) 

Variogram(m1, form = ~ North.South + East.West)

plot(Variogram(m1,
  form = ~North.South + East.West,
  data = elevation, resType = "normalized"
), sigma = 1)

m2 <- update(m1, corr = corExp(3.5,
  form = ~North.South + East.West,
  nugget = FALSE
))

library(spaMM)
