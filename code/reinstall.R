# 重装 R 包
db <- installed.packages()
db <- as.data.frame(db, stringsAsFactors = FALSE)
db[db$Built < "3.6.0", "Package"]

# install.packages(db[db$Built < "3.6.0", "Package"])

# rvcheck

install.packages('rvcheck')

check_cran('StanHeaders')
# 输出
# ## StanHeaders is out of date...
# ## try
# install.packages("StanHeaders")
# $package
# [1] "StanHeaders"
# 
# $installed_version
# [1] "2.17.2"
# 
# $latest_version
# [1] "2.18.0"
# 
# $up_to_date
# [1] FALSE

check_cran('rstan')
# package is up-to-date release version
# $package
# [1] "rstan"
# 
# $installed_version
# [1] "2.17.4"
# 
# $latest_version
# [1] "2.17.4"
# 
# $up_to_date
# [1] TRUE

# 查看历史 R 包
devtools::install_github('metacran/crandb')
library(crandb)
releases()
