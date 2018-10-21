# 使用的软件环境
xfun::session_info(packages = c("rstan","rstansim","StanHeaders","brms"))

library(rstansim)

# 根据 basic_sim.stan 定义的模型模拟 10 个数据集
small_simulation <- simulate_data(
  file = "code/basic_sim.stan", 
  param_values = list("scale" = 2),
  vars = c("x", "y"),
  data_name = "small_sim_example",
  nsim = 10,
  path = "code/basic_sim_data/"
)

# is the data saved?
dir("code/basic_sim_data")

# is the data of the correct format?
example_data <- readRDS("code/basic_sim_data/small_sim_example_1.rds")
str(example_data)

library(ggplot2)
ggplot(as.data.frame(example_data), aes(x = x, y = y)) + 
  geom_point()

# 依赖 rstan 的 R 包
tools::dependsOnPkgs('rstan',installed = available.packages())

# [1] "adnuts"          "BANOVA"          "bayesLopod"      "beanz"           "bmlm"           
# [6] "BMSC"            "breathteststan"  "brms"            "clinDR"          "CopulaDTA"      
# [11] "ctsem"           "DeLorean"        "dfped"           "dfpk"            "dgo"            
# [16] "DrBats"          "edstan"          "eggCounts"       "evidence"        "fergm"          
# [21] "gastempt"        "ggfan"           "glmmfields"      "gppm"            "hBayesDM"       
# [26] "HCT"             "idealstan"       "idem"            "JMbayes"         "MADPop"         
# [31] "MCMCvis"         "MIXFIM"          "projpred"        "prophet"         "RBesT"          
# [36] "rstanarm"        "rstansim"        "shinystan"       "survHE"          "themetagenomics"
# [41] "tmbstan"         "trialr"          "varian"          "walker"          "ESTER"          
# [46] "psycho"          "tidyposterior"   "walkr"           "tidymodels"
