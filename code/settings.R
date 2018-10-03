```{r,include=FALSE,eval=!is_on_travis}
lapply(c(
  "formatR", "sp", "svglite", "sf",
  "ggplot2", "gridExtra", "PrevMap", "geoR",
  "geoRglm", "rstan", "rstanarm", "brms"
), function(pkg) {
  if (system.file(package = pkg) == "") install.packages(pkg)
})
```