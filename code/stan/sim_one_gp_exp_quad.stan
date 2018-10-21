// Sample from a Gaussian process using exponentiated quadratic covariance function.
// Fixed kernel hyperparameters: phi=0.15, sigma=sqrt(1)

data {
  int<lower=1> N;
  real<lower=0> phi;
  real<lower=0> sigma;
}
transformed data {
  vector[N] zeros;
  zeros = rep_vector(0, N);
}
model {}
generated quantities {
  real x[N];
  vector[N] f;
  for (n in 1:N)
    x[n] = uniform_rng(-2,2);
  {
    matrix[N, N] cov;
    matrix[N, N] L_cov;
    
    // cov = cov_exp_quad(x, sigma, phi);
    /* 这段代码与 cov_exp_quad 等价
    for (i in 1:(N - 1)) {
      cov[i, i] = square(sigma);
      for (j in (i + 1):N) {
        cov[i, j] = square(sigma) * exp(- square(x[i] - x[j]) * inv( 2 * square(phi) ) );
        cov[j, i] = cov[i, j];
      }
    }
    cov[N, N] = square(sigma);     
    */
    for (i in 1:(N - 1)) {
      cov[i, i] = square(sigma);
      for (j in (i + 1):N) {
        cov[i, j] = square(sigma) * exp(- square(x[i] - x[j]) * inv( square(phi) ) );
        cov[j, i] = cov[i, j];
      }
    }
    cov[N, N] = square(sigma);       
    
    for (n in 1:N)
      cov[n, n] = cov[n, n] + 1e-12;

    L_cov = cholesky_decompose(cov);
    f = multi_normal_cholesky_rng(zeros, L_cov);
  }
}
