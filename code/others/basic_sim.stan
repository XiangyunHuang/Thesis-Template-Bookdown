// saved as basic_sim.stan
parameters {
  real scale;
}
generated quantities {
  vector[100] x; 
  vector[100] y; 

  for(i in 1:100) x[i] = normal_rng(100, 15);
  for(i in 1:100) y[i] = scale * x[i];
}
