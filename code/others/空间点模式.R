library(spatstat)
M <- persp(bei.extra$elev,
           theta = -45, phi = 18, expand = 7,
           border = NA, apron = TRUE, shade = 0.3,
           box = FALSE, visible = TRUE, # colmap = terrain.colors,
           main = ""
)

perspPoints(bei,
            Z = bei.extra$elev, M = M, pch = 16, cex = 0.3 # , col = "red"
)
plot(bei.extra$elev,show.all=FALSE,ribbon=FALSE,axes = FALSE,
     ribside = "bottom",ann = FALSE, col = gray.colors
)
plot(bei, add = TRUE, pch = 16, cex = 0.3,axes = FALSE)
