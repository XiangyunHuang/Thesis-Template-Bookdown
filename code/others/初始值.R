rm(list = ls())
# 36  alpha  phi  sigmasq

# 二项分布
b36_init_0 <- c(run.sim$posterior$beta$sample[1],
               run.sim$posterior$phi$sample[1],
               run.sim$posterior$sigmasq$sample[1], 600.12)  # 运行时间 600.12 秒

b64_init_0 <- c(run.sim$posterior$beta$sample[1],
               run.sim$posterior$phi$sample[1],
               run.sim$posterior$sigmasq$sample[1], 729.18)  # 运行时间 729.188 秒  

b81_init_0 <- c(run.sim$posterior$beta$sample[1],
               run.sim$posterior$phi$sample[1],
               run.sim$posterior$sigmasq$sample[1], 844.56)  # 运行时间 

b_init_df <- data.frame(df36 = b36_init_0, df64 = b64_init_0, df81 = b81_init_0)


# 泊松分布
p36_init_0 <- c(run.sim$posterior$beta$sample[1],
                run.sim$posterior$phi$sample[1],
                run.sim$posterior$sigmasq$sample[1], 642.66)  # 运行时间 

p64_init_0 <- c(run.sim$posterior$beta$sample[1],
                run.sim$posterior$phi$sample[1],
                run.sim$posterior$sigmasq$sample[1], 883.76)  # 运行时间 

p100_init_0 <- c(run.sim$posterior$beta$sample[1],
                run.sim$posterior$phi$sample[1],
                run.sim$posterior$sigmasq$sample[1], 1223.28)  # 运行时间 

p_init_df <- data.frame(df36 = p36_init_0, df64 = p64_init_0, df81 = p100_init_0)

saveRDS(object = p_init_df,file = "p_init_df.RDS")



