安装编译器

# https://gcc.gnu.org/projects/cxx-status.html#cxx14
# 安装 Scientific Linux distribution 发行版的安装源
# https://www.softwarecollections.org/en/docs/
sudo yum install centos-release-scl-rh centos-release-scl
# 更新源
sudo yum update

# 安装新版 gcc 5.3.1 完全支持 C++ 14 特性
sudo yum install \
  devtoolset-4-gcc \
  devtoolset-4-gcc-c++ \
  devtoolset-4-gcc-gfortran

# 设置 gcc/g++/gfortran 环境变量
source /opt/rh/devtoolset-4/enable

编辑 `~/.bashrc` 添加上一行

sudo yum install \
  devtoolset-6-gcc \
  devtoolset-6-gcc-c++ \
  devtoolset-6-gcc-gfortran

sudo yum install \
  devtoolset-7-gcc \
  devtoolset-7-gcc-c++ \
  devtoolset-7-gcc-gfortran
  
# gcc 4.9
sudo yum install \
  devtoolset-3-gcc \
  devtoolset-3-gcc-c++ \
  devtoolset-3-gcc-gfortran
  
# https://discourse.mc-stan.org/t/do-not-install-rstan-2-17-4-from-cran/5822
  
安装 rstan 包

# 创建配置文件
dotR <- file.path(Sys.getenv("HOME"), ".R")
if (!file.exists(dotR)) dir.create(dotR)
MAKEVARS <- file.path(dotR, "Makevars")
if (!file.exists(MAKEVARS)) file.create(MAKEVARS)

cat(
  "\nCXXFLAGS=-O3 -mtune=native -march=native -Wno-unused-variable -Wno-unused-function  -Wno-macro-redefined",
  file = MAKEVARS, 
  sep = "\n", 
  append = TRUE
)

# g++ 较新版本
cat("\nCXXFLAGS+=-flto -Wno-unused-local-typedefs", 
    file = MAKEVARS, sep = "\n", append = TRUE)

# 关掉一些与 Stan 无关的警告	
cat("\nCXXFLAGS += -Wno-ignored-attributes -Wno-deprecated-declarations", 
    file = MAKEVARS, sep = "\n", append = TRUE)

# 查看配置结果
cat(readLines(MAKEVARS), sep = "\n")	

# 安装 rstan
Sys.setenv(MAKEFLAGS = "-j2") 
install.packages("rstan", configure.vars = "CXXFLAGS += fPIC")

CXX14FLAGS += -g -O2 -pedantic -g0 -fPIC

R-devel
x86_64 Fedora 28 Linux
GCC 8.1 (C, C++, Fortran)

configured with no options, config.site:
CFLAGS="-g -O2 -Wall -pedantic -mtune=native"
FFLAGS="-g -O2 -mtune=native -Wall -pedantic"
FCFLAGS=$FFLAGS
CXXFLAGS="-g -O2 -Wall -pedantic -mtune=native"
JAVA_HOME=/usr/lib/jvm/jre-11

Because the Fedora pandoc does not support https://, pandoc 2.2.3.2 from the 
pandoc distribution site is used.

