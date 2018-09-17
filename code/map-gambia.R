library(geoR)
data("gambia")

dat1 <- gambia[gambia$x < 400000 & gambia$y < 1475000, ]
dat1$area <- "A1"
dat2 <- gambia[gambia$x < 400000 & gambia$y > 1475000, ]
dat2$area <- "A2"
dat3 <- gambia[gambia$x > 480000 & gambia$x < 530000, ]
dat3$area <- "A3"

# 65 个村子的位置
# unique(gambia[, c("x", "y")])

dat_coord <- unique(gambia[gambia$x > 530000, c("x", "y")])

id5 <- c(
  "295", "404", "1980", "1924", "1788", "1076",
  "1045", "1", "142", "1533", "1457"
)
dat5 <- gambia[gambia$x %in% dat_coord[id5, 1], ]
dat5$area <- "A5"

id4 <- setdiff(row.names(dat_coord), id5)
dat4 <- gambia[gambia$x %in% dat_coord[id4, 1], ]
dat4$area <- "A4"
# 带 area 标记的数据集
new_gambia <- rbind.data.frame(dat1, dat2, dat3, dat4, dat5)

# dim(new_gambia)
# head(new_gambia)
# plot(y~x,data = new_gambia)
# text(new_gambia$x,new_gambia$y,labels = new_gambia$area)


pdf(file = "gambia-map.pdf", width = 7, height = 6.5)
# svg(file = "gambia-map.svg", width = 7, height = 6.5)

par(mar = c(4.1, 4.1, 0.5, 0.5))
gb <- gambia.borders / 1000 # 行政边界
gd <- gambia[, 1:2] / 1000 # 村庄位置
plot(gb,
  ty = "l", asp = 1, xlab = "W-E (kilometres)",
  ylab = "N-S (kilometres)"
)
points(gd, pch = 19, cex = 0.5)
r1b <- gb[gb[, 1] >= 340 & gb[, 1] < 400, ]
r2b <- gb[gb[, 1] >= 480 & gb[, 1] < 530, ]
r3b <- gb[gb[, 1] >= 560, ]

r1bn <- zoom.coords(r1b, 1.7, xoff = 10, yoff = -90)
lines(r1bn)
r2bn <- zoom.coords(r2b, 1.7, xoff = 20, yoff = 90)
lines(r2bn)
r3bn <- zoom.coords(r3b, 1.7, xoff = -20, yoff = -90)
lines(r3bn)

r1d <- gd[gd[, 1] >= 340 & gd[, 1] < 400, ]
r2d <- gd[gd[, 1] >= 480 & gd[, 1] < 530, ]
r3d <- gd[gd[, 1] >= 560, ]
r1dn <- zoom.coords(r1d, 1.7, xoff = 10, yoff = -90)

r1dn <- zoom.coords(r1d, 1.7,
  xlim.o = range(r1b[, 1], na.rm = TRUE),
  ylim.o = range(r1b[, 2], na.rm = TRUE), xoff = 10, yoff = -90
)
points(r1dn, pch = 19, cex = 0.5)

r2dn <- zoom.coords(r2d, 1.7,
  xlim.o = range(r2b[, 1], na.rm = TRUE),
  ylim.o = range(r2b[, 2], na.rm = TRUE), xoff = 20, yoff = 90
)
points(r2dn, pch = 19, cex = 0.5)

r3dn <- zoom.coords(r3d, 1.7,
  xlim.o = range(r3b[, 1], na.rm = TRUE),
  ylim.o = range(r3b[, 2], na.rm = TRUE), xoff = -20, yoff = -90
)
points(r3dn, pch = 19, cex = 0.5)

rc1n <- rect.coords(r1bn, xzoom = 1.05, lty = 2)
rc2n <- rect.coords(r2bn, xzoom = 1.05, lty = 2)
rc3n <- rect.coords(r3bn, xzoom = 1.05, lty = 2)
text(c(380, 580, 450), c(1340, 1340, 1590),
  c("Western", "Eastern", "Central"),
  cex = 1.5
)
text(c(360, 360, 500, 600, 600),
  c(1450, 1510, 1480, 1455, 1510),
  c("Area 1", "Area 2", "Area 3", "Area 4", "Area 5"),
  cex = 1.0
)

arrows(380, 1453, 380, 1432, angle = 15, length = 0.1)
arrows(580, 1455, 580, 1427, angle = 15, length = 0.1)
arrows(520, 1525, 520, 1551, angle = 15, length = 0.1)
dev.off()

# Building a "village-level" data frame
ind <- paste("x", gambia[, 1], "y", gambia[, 2], sep = "")
village <- gambia[!duplicated(ind), c(1:2, 7:8)]
village$prev <- as.vector(tapply(gambia$pos, ind, mean))
plot(village$green, village$prev)
