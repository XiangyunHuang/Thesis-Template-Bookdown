
lapply(c('loo', 'inline', 'Rcpp', 'coda', 
         'BH', 'RcppEigen', 'RInside', 'RUnit', 
         'ggplot2', 'gridExtra', 'knitr', 'rmarkdown'), function(pkg) {
  if (system.file(package = pkg) == "") install.packages(pkg)
})


git clone --depth=1 --branch=develop git@github.com:XiangyunHuang/cmdstan.git
cd cmdstan
git submodule update --init --recursive

make build -j2 # make build-mpi -j2

make examples/bernoulli/bernoulli

examples/bernoulli/bernoulli sample data file=examples/bernoulli/bernoulli.data.R

bin/stansummary output.csv

