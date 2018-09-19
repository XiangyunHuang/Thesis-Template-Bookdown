library(methods)
set.seed(2018)
library(ggplot2)
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
# https://github.com/yihui/knitr-examples/blob/master/085-pdfcrop.Rnw

options(
  digits = 3,
  citation.bibtex.max = 999,
  bitmapType = "cairo",
  stringsAsFactors = FALSE,
  repos = "https://mirrors.tuna.tsinghua.edu.cn/CRAN/",
  knitr.graphics.auto_pdf = FALSE,
  tikzDefaultEngine = "xetex",
  tikzXelatexPackages = c(
    getOption("tikzXelatexPackages"),
    "\\usepackage[colorlinks, breaklinks]{hyperref}",
    "\\usepackage{color,tikz}",
    "\\usepackage[active,tightpage,xetex]{preview}",
    "\\PreviewEnvironment{pgfpicture}",
    "\\usepackage{amsmath,amsfonts,mathrsfs}"
  )
)

is_on_travis = identical(Sys.getenv("TRAVIS"), "true")
is_online = curl::has_internet()
