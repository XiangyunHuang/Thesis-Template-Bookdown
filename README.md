[![Build Status](https://travis-ci.com/XiangyunHuang/Thesis-Template-Bookdown.svg?branch=master)](https://travis-ci.com/XiangyunHuang/Thesis-Template-Bookdown) [![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable) ![Repo Size](https://img.shields.io/github/repo-size/XiangyunHuang/Thesis-Template-Bookdown.svg) ![GitHub](https://img.shields.io/github/license/XiangyunHuang/Thesis-Template-Bookdown.svg)

---

## 中国矿业大学（北京）论文模板

这个模版（非官方）是为中国矿业大学（北京）的研究生排版硕士学位论文服务的。

The template is used for Master Thesis of China University of Mining and Technology, Beijing.

论文同时部署在 Github Pages 和 bookdown.org 上，在线预览链接分别是 <https://xiangyunhuang.github.io/Thesis-Template-Bookdown> 和 <https://bookdown.org/xiangyun/Thesis-Template-Bookdown/>  

---

> 最好的模板就是一篇基于模板的完整论文， 其所包含的公式、图片、表格等不再是 demo。 只有把真实场景中的使用形式呈现给使用者看， 才能真的让使用者少淌些坑。

---

感谢 [Pandoc](https://github.com/jgm/pandoc)、[TinyTeX](https://github.com/yihui/tinytex)、[bookdown](https://github.com/rstudio/bookdown) 的开发者们，特别是 [John MacFarlane](https://johnmacfarlane.net/) 和 [Yihui Xie](https://yihui.name/)

---

软件要求

- TinyTeX: latest
- Pandoc: 2.3.1 及以上
- rmarkdown: 1.11
- bookdown: 0.11

测试平台

- Ubuntu 14.04.5 (64位)
- Ubuntu 18.04.1 (64位)
- Windows 8.1 (64位)
- CentOS 7 (64位) 与 Pandoc 2.3 及以上

---

### How to Use it 如何使用该模版 

我假设你已经安装好了 [Git](https://git-scm.com/)、 [R](https://www.r-project.org/) 和 [RStudio](https://www.rstudio.com/)

1. 克隆模版到本地

```bash
git clone --depth=1 --branch=master https://github.com/XiangyunHuang/Thesis-Template-Bookdown.git
```

2. 用 RStudio 打开 `Thesis-Template-Bookdown.Rproj` 文件

---

> 下面是模版在各个系统上可能遇到的问题及解决方案

### 1. 中英文字体

Windows 系统自带新罗马字体和 Arial 字体，在 Ubuntu 系统上需要安装 Windows 下的两款字体 Times New Roman 和 Arial

```bash
sudo apt install ttf-mscorefonts-installer
```

在安装的过程中会自动下载字体，如果下载失败，就从网站 <https://sourceforge.net/projects/corefonts/files/the%20fonts/final/> 手动下载字体，存放到 `fonts/` 文件夹下，执行

```bash
sudo dpkg-reconfigure ttf-mscorefonts-installer
```

在弹出的窗口中填写字体所在路径，如 `fonts/`，安装完成后，刷新字体

```bash
sudo fc-cache -fsv
```

安装等宽字体 Inconsolata 显示代码

```bash
sudo apt install fonts-inconsolata
```

最终英文字体设置如下

```yaml
mainfont: Times New Roman
sansfont: Arial
monofont: Inconsolata
```

> 推荐的方式是将相关中英文字体放在一块，拷贝到 Ubuntu/CentOS 系统上

```bash
sudo mkdir /usr/share/fonts/truetype/win/
sudo cp Thesis-Template-Bookdown/fonts/* /usr/share/fonts/truetype/win/
sudo fc-cache -fsv
```

### 2. 安装 Pandoc

Pandoc 在 Windows 和 Ubuntu 系统上提供了安装包，唯独 CentOS 系统上没有，需要用户自己编译（CentOS 系统包管理器带的 Pandoc 版本太低不能用）。Pandoc 源码可以从 Github 仓库中下载 <https://github.com/jgm/pandoc/releases/>，下面介绍安装最新版 Pandoc 的过程

1. 安装 stack

```bash
curl -sSL https://s3.amazonaws.com/download.fpcomplete.com/centos/7/fpco.repo | sudo tee /etc/yum.repos.d/fpco.repo
sudo yum -y install stack zlib-devel
```

2. 下载 pandoc 源文件，也可以克隆 Pandoc's repo

```bash
wget https://github.com/jgm/pandoc/releases/download/2.3/pandoc-2.3-linux.tar.gz
```

3. 解压 `pandoc-2.3-linux.tar.gz`

```bash
tar -xzf pandoc-2.3-linux.tar.gz
```

4. 安装依赖和 Pandoc

```bash
cd pandoc-2.3
stack setup # 安装 ghc 8.4.3 等依赖
stack install
stack install pandoc-citeproc
```

5. 配置路径

```bash
sudo vi /etc/profile
export PATH=$HOME/.local/bin:$PATH
source /etc/profile
```

如果你安装了 zsh 和 [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) ，再将这行 `export PATH=$HOME/.local/bin:$PATH` 放在 `.zshrc` 里。

### 3. 关于 Pandoc

R Markdown 文档 (\*.Rmd) 首先通过 knitr 包 [@xie2015] 编译成 Markdown 文档 (\*.md)，然后 Markdown 文档再被 Pandoc 编译成其它格式，如 LaTeX (\*.tex) 、 HTML 等，这个过程由 rmarkdown 包完成。你不需要分别安装 knitr 和 rmarkdown 两个包，因为它们被 bookdown 包 [@xie2016] 所依赖，当你安装 bookdown 的时候，会自动安装上。而 Pandoc 不是一个 R 包，所以需要单独安装，但如果你使用 RStudio IDE 的话，也不需要安装，因为 RStudio 自带了一份 Pandoc，你可以运行下面一行命令获取当前的 Pandoc 版本号

```{r}
rmarkdown::pandoc_version()
```

如果你需要 Pandoc 的新特性，觉得自带的版本比较低，你可以从 Pandoc 官网 (<http://pandoc.org>)  手动安装一个新版本。 rmarkdown 会优先使用你安装的新版本。

### 4. bookdown

安装 R 的过程请看《R语言忍者秘笈》第二章的安装与配置 <https://bookdown.org/yihui/r-ninja/setup.html>

- 从 CRAN 安装 bookdown 稳定版

```r
install.packages("bookdown")
```

- 从 Github 安装 bookdown 开发版

```r
devtools::install_github("rstudio/bookdown")
```

遇到问题先试升级

```r
# 一行命令升级所有安装的 R 包
update.packages(ask = FALSE)
```

有关 bookdown 的详细介绍请看谢益辉发布在网上的在线书 《bookdown: Authoring Books and Technical Documents with R Markdown》 <https://bookdown.org/yihui/bookdown>

### 5. LaTeX

LaTeX 只有当你需要把书转化为 PDF 格式时才会用到，从 LaTeX 官网 (<https://www.latex-project.org/get/>) 你可以学习到很多东西，如安装 LaTeX。我们强烈推荐你安装一个轻量的跨平台 LaTeX 发行版 --- [TinyTeX](https://yihui.name/tinytex/)。它基于 TeX Live，可以通过 R 包 tinytex 安装，tinytex 在之前安装 bookdown 时已经安装，所以安装 TinyTeX 你只需在 R 控制台下输入

```{r,eval=FALSE}
tinytex::install_tinytex()
```

有了 TinyTeX， 你应该再也不会看到这样的错误消息：

```latex
! LaTeX Error: File `titling.sty' not found.

Type X to quit or <RETURN> to proceed,
or enter new name. (Default extension: sty)

Enter file name: 
! Emergency stop.
<read *> 
         
l.107 ^^M

pandoc: Error producing PDF
Error: pandoc document conversion failed with error 43
Execution halted
```

上面的消息日志告诉你，说系统中缺少宏文件 `titling.sty`。 LaTeX 宏包名称通常和宏文件 `*.sty`  的名字一样，所以你可以先尝试安装 `titling` 包。如果你和 TinyTeX 一起使用，缺失的 LaTeX 包会自动安装，所以你不用担心这类问题。 

LaTeX 发行版和宏包随时间一直在更新，就像 R 软件和扩展包一样，当你遇到 LaTeX 问题的时候，可以先尝试升级 TinyTeX 发行版和 LaTeX 宏包，查看你所安装的 LaTeX 发行版

```{r,eval=FALSE}
system("pdflatex --version")
```
```{r,echo=FALSE}
cat(system("pdflatex --version", intern = TRUE),sep = "\n")
```

更新 TinyTeX 安装的宏包

```{r,eval=FALSE}
tinytex::tlmgr_update()
```

TeX Live 每年都会更新，你可能需要升级 TinyTeX 发行版，否则你不能安装和升级任何 LaTeX 包。

```r
tinytex::reinstall_tinytex()
```



---

### 版权说明

1. `images/` 目录下矿大(北京)校徽版权归学校所有

