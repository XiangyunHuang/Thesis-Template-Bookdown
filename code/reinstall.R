# 重装 R 包
db <- installed.packages()
db <- as.data.frame(db, stringsAsFactors = FALSE)
db[db$Built < "3.5.1", "Package"]