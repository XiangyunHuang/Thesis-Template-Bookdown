fit <- stan(
  model_name = "8schools",
  model_code = readLines("code/8schools.stan"),
  data = schools_dat,
  iter = 10000, warmup = 5000, chains = 4,
  seed = 2018
)

library(rstan)
fit1 <- stan(
  file = "schools.stan",  # Stan program
  data = schools_data,    # named list of data
  chains = 4,             # number of Markov chains
  warmup = 5000,          # number of warmup iterations per chain
  iter = 10000,           # total number of iterations per chain
  cores = 2,              # number of cores (could use one per chain)
  refresh = 0             # no progress shown
)

print(fit1)
Inference for Stan model: schools.
4 chains, each with iter=10000; warmup=5000; thin=1;
post-warmup draws per chain=5000, total post-warmup draws=20000.

           mean se_mean   sd   2.5%    25%    50%    75%  97.5% n_eff Rhat
mu         8.02    0.05 5.15  -1.96   4.75   7.97  11.27  18.44  9698    1
tau        6.54    0.07 5.50   0.21   2.44   5.27   9.12  20.59  7095    1
eta[1]     0.38    0.01 0.93  -1.50  -0.23   0.40   1.01   2.17 20000    1
eta[2]     0.00    0.01 0.87  -1.73  -0.57   0.00   0.57   1.71 20000    1
eta[3]    -0.19    0.01 0.93  -1.98  -0.82  -0.20   0.42   1.65 20000    1
eta[4]    -0.03    0.01 0.88  -1.79  -0.61  -0.03   0.55   1.68 20000    1
eta[5]    -0.36    0.01 0.88  -2.05  -0.94  -0.38   0.20   1.45 15957    1
eta[6]    -0.22    0.01 0.88  -1.94  -0.81  -0.23   0.35   1.56 20000    1
eta[7]     0.33    0.01 0.89  -1.45  -0.25   0.34   0.93   2.05 20000    1
eta[8]     0.05    0.01 0.92  -1.77  -0.56   0.05   0.67   1.90 20000    1
theta[1]  11.42    0.07 8.41  -2.20   5.96  10.26  15.51  32.01 13272    1
theta[2]   7.96    0.04 6.18  -4.50   4.14   7.91  11.81  20.53 20000    1
theta[3]   6.16    0.05 7.72 -11.19   1.97   6.62  10.92  20.64 20000    1
theta[4]   7.71    0.05 6.60  -5.84   3.68   7.76  11.75  21.21 20000    1
theta[5]   5.15    0.05 6.43  -9.25   1.37   5.63   9.45  16.63 20000    1
theta[6]   6.22    0.05 6.65  -8.41   2.41   6.53  10.46  18.61 20000    1
theta[7]  10.72    0.05 6.85  -1.07   6.10  10.09  14.66  26.25 20000    1
theta[8]   8.48    0.06 7.82  -6.90   3.97   8.26  12.66  25.61 17487    1
lp__     -39.53    0.03 2.62 -45.31 -41.10 -39.31 -37.71 -35.09  5803    1

Samples were drawn using NUTS(diag_e) at Tue Oct  2 12:54:21 2018.
For each parameter, n_eff is a crude measure of effective sample size,
and Rhat is the potential scale reduction factor on split chains (at
convergence, Rhat=1).



In file included from /usr/local/lib/R/site-library/BH/include/boost/config.hpp:39:0,
                 from /usr/local/lib/R/site-library/BH/include/boost/math/tools/config.hpp:13,
                 from /usr/local/lib/R/site-library/StanHeaders/include/stan/math/rev/core/var.hpp:7,
                 from /usr/local/lib/R/site-library/StanHeaders/include/stan/math/rev/core/gevv_vvv_vari.hpp:5,
                 from /usr/local/lib/R/site-library/StanHeaders/include/stan/math/rev/core.hpp:12,
                 from /usr/local/lib/R/site-library/StanHeaders/include/stan/math/rev/mat.hpp:4,
                 from /usr/local/lib/R/site-library/StanHeaders/include/stan/math.hpp:4,
                 from /usr/local/lib/R/site-library/StanHeaders/include/src/stan/model/model_header.hpp:4,
                 from file7c64ce36fdd.cpp:8:
/usr/local/lib/R/site-library/BH/include/boost/config/compiler/gcc.hpp:186:0: warning: "BOOST_NO_CXX11_RVALUE_REFERENCES" redefined
 #  define BOOST_NO_CXX11_RVALUE_REFERENCES
 ^
<command-line>:0:0: note: this is the location of the previous definition

Gradient evaluation took 5.2e-05 seconds
1000 transitions using 10 leapfrog steps per transition would take 0.52 seconds.
Adjust your expectations accordingly!



 Elapsed Time: 0.187874 seconds (Warm-up)
               0.18156 seconds (Sampling)
               0.369434 seconds (Total)


Gradient evaluation took 2.7e-05 seconds
1000 transitions using 10 leapfrog steps per transition would take 0.27 seconds.
Adjust your expectations accordingly!



 Elapsed Time: 0.210254 seconds (Warm-up)
               0.167587 seconds (Sampling)
               0.377841 seconds (Total)


Gradient evaluation took 6.6e-05 seconds
1000 transitions using 10 leapfrog steps per transition would take 0.66 seconds.
Adjust your expectations accordingly!



 Elapsed Time: 0.198263 seconds (Warm-up)
               0.227664 seconds (Sampling)
               0.425927 seconds (Total)


Gradient evaluation took 3e-05 seconds
1000 transitions using 10 leapfrog steps per transition would take 0.3 seconds.
Adjust your expectations accordingly!



 Elapsed Time: 0.185743 seconds (Warm-up)
               0.21904 seconds (Sampling)
               0.404783 seconds (Total)

Warning messages:
1: There were 11 divergent transitions after warmup. Increasing adapt_delta above 0.8 may help. See
http://mc-stan.org/misc/warnings.html#divergent-transitions-after-warmup
2: Examine the pairs() plot to diagnose sampling problems

