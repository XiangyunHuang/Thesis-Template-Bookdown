library(methods)
set.seed(2018)
# 加载依赖
library(ggplot2)

# 设置环境
is_on_travis = identical(Sys.getenv("TRAVIS"), "true")

knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  echo = FALSE,
  cache = TRUE,
  size = "scriptsize",
  out.width = "70%",
  fig.align = "center",
  fig.width = 6,
  fig.asp = 0.618
)

doc_type <- function() knitr::opts_knit$get('rmarkdown.pandoc.to')

knitr::knit_hooks$set(
  optipng = knitr::hook_optipng,
  pdfcrop = knitr::hook_pdfcrop,
  small.mar = function(before, options, envir) {
    if (before) par(mar = c(4.1, 4.1, 0.5, 0.5))  # smaller margin on top and right
  }
)

options(
  digits = 3,
  citation.bibtex.max = 999,
  bitmapType = "cairo",
  stringsAsFactors = FALSE,
  repos = "https://mirrors.tuna.tsinghua.edu.cn/CRAN/",
  knitr.graphics.auto_pdf = FALSE
)

