[![Build Status](https://travis-ci.org/XiangyunHuang/Thesis-Template-Bookdown.svg?branch=master)](https://travis-ci.org/XiangyunHuang/Thesis-Template-Bookdown)
---

## 中国矿业大学（北京）论文模板

> 最好的模板就是一篇基于模板的完整论文， 其所包含的公式、图片、表格等不再是 demo， 只有把真实场景中的使用形式呈现给使用者看， 才能真的让使用者少淌些坑。

---

感谢 [Pandoc](https://github.com/jgm/pandoc)、[TinyTeX](https://github.com/yihui/tinytex)、[bookdown](https://github.com/rstudio/bookdown) 的开发者们，特别是 [John MacFarlane](https://johnmacfarlane.net/) 和 [Yihui Xie](https://yihui.name/)


## 注意

在安装完 TinyTeX 后，需要安装的 LaTeX 包

```{r}
readLines('latex/TeXLive.pkgs')
```

```
 [1] "colortbl"    "ctex"        "dvipng"      "dvips"       "dvisvgm"     "environ"    
 [7] "fancyhdr"    "fandol"      "jknapltx"    "listings"    "mathdesign"  "metalogo"   
[13] "microtype"   "ms"          "parskip"     "pdfcrop"     "pgf"         "placeins"   
[19] "preview"     "psnfss"      "realscripts" "relsize"     "rsfs"        "setspace"   
[25] "soul"        "standalone"  "subfig"      "symbol"      "tex"         "tex4ht"     
[31] "titlesec"    "tocloft"     "translator"  "trimspaces"  "ttfutils"    "type1cm"    
[37] "ucs"         "ulem"        "xcolor"      "xecjk"       "xltxtra"     "zhnumber"  
```

