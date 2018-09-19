# Ubuntu 18.04.1 安装依赖

# sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
# sudo apt-get update
# sudo apt-get install libudunits2-dev libgdal-dev libgeos-dev libproj-dev liblwgeom-dev

# 安装 R 包
lapply(c(
  "geostatsp", "mapmisc", "rgdal",
  "sp", "RColorBrewer"
), function(pkg) {
  if (system.file(package = pkg) == "") install.packages(pkg)
})
# Loaloa

## 喀麦隆及周边地区地图 loaloa 数据集中的采样位置

library("geostatsp")
library("mapmisc")
library("RColorBrewer")
library("rgdal")

data("loaloa")
africaTiles <- openmap(loaloa)
# 下载 shp 文件
if (!file.exists("world.zip")) {
  download.file(
    "http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_countries_lakes.zip",
    "world.zip"
  )
}
# 解压
unzip("world.zip")
theFiles <- unzip("world.zip", list = TRUE)
theFiles <- grep("\\.shp$", theFiles$Name, value = TRUE)
# 读取 shp 文件
worldCountries <- readOGR(".", gsub("\\.shp$", "", theFiles),
  verbose = FALSE
)
worldCountries <- worldCountries[worldCountries$CONTINENT == "Africa", ]
worldUTM <- spTransform(worldCountries, loaloa@proj4string)

# plot data 保存图片
pdf(file = "map-loaloa.pdf", width = 8, height = 4)
# loaloaPlot  fig.height=4,fig.width=10
map.new(loaloa, 0.6)
plot(africaTiles, add = TRUE) # openmap 做背景图
plot(ltLoa, add = TRUE)
plot(worldUTM, add = TRUE, border = "grey80", lwd = 2) # 边界线
points(loaloa, pch = 3, col = "#FF0000CC", cex = 1.25) # 采样点
# 添加图例
theLegend <- levels(ltLoa)[[1]]
theLegend <- theLegend[theLegend$ID != 0, ]
commonValues <- order(theLegend$Freq, decreasing = TRUE)[1:10]
# 标注 10 种陆地类型景观
legend("right",
  fill = theLegend[commonValues, "col"],
  border = NA, bty = "n", title = "Land type",
  legend =
    substr(theLegend[commonValues, "label"], 1, 28),
  inset = -0.6, xpd = TRUE
)
dev.off()
