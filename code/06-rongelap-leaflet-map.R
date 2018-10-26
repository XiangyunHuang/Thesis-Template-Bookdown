# 加载数据
data(rongelap, package = "geoRglm")
# 改变数据结构
dat <- cbind.data.frame(rongelap$coords, rongelap$data, rongelap$units.m)
colnames(dat) <- c("x", "y", "data", "units.m")
# 转化空间坐标
library(sp)
library(rgdal)
sps <- SpatialPoints(dat[, c("x", "y")], proj4string = CRS("+proj=utm +zone=28"))
spst <- spTransform(sps, CRS("+proj=longlat +datum=WGS84"))
dat[, c("long", "lat")] <- coordinates(spst)

# 单位时间内放射的粒子数目
library(leaflet)
pal <- colorBin("viridis", bins = c(0, 3, 6, 9, 12, 15, 20), reverse = TRUE)
leaflet(dat) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addCircles(lng = ~long, lat = ~lat, color = ~pal(data / units.m)) %>%
  addLegend("bottomright",
    pal = pal, values = ~data / units.m,
    title = "放射强度"
  ) %>%
  addScaleBar(position = c("bottomleft"))

