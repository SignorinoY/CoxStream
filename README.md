
<!-- README.md is generated from README.Rmd. Please edit that file -->

# CoxStream

<!-- badges: start -->

[![R-CMD-check](https://github.com/SignorinoY/CoxStream/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/SignorinoY/CoxStream/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/SignorinoY/CoxStream/graph/badge.svg)](https://app.codecov.io/gh/SignorinoY/CoxStream)
<!-- badges: end -->

The goal of CoxStream is to …

## Installation

You can install the development version of CoxStream like so:

``` r
# install.packages("pak")
pak::pak("SignorinoY/CoxStream")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(CoxStream)
#> Loading required package: survival

formula <- Surv(time, status) ~ X1 + X2 + X3 + X4 + X5
fit <- coxstream(
  formula, sim[sim$batch_id == 1, ],
  degree = 6, boundary = c(0, 3), idx_col = "patient_id"
)
for (batch in 2:10) {
  fit <- update(fit,  sim[sim$batch_id == batch, ])
}
summary(fit)
#> Call:
#> coxstream(formula = formula, data = sim[sim$batch_id == 1, ], 
#>     degree = 6, boundary = c(0, 3), idx_col = "patient_id")
#> 
#>       coef exp(coef)      se     z      p    
#> X1 0.99429   2.70279 0.05158 19.28 <2e-16 ***
#> X2 1.01869   2.76957 0.05358 19.01 <2e-16 ***
#> X3 1.01620   2.76267 0.05405 18.80 <2e-16 ***
#> X4 0.90315   2.46736 0.05193 17.39 <2e-16 ***
#> X5 1.04018   2.82974 0.05141 20.23 <2e-16 ***
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#>    exp(coef) exp(-coef) lower .95 upper .95
#> X1 2.7028    0.3700     2.4429    2.9903   
#> X2 2.7696    0.3611     2.4935    3.0762   
#> X3 2.7627    0.3620     2.4850    3.0714   
#> X4 2.4674    0.4053     2.2286    2.7317   
#> X5 2.8297    0.3534     2.5585    3.1297
```

## Code of Conduct

Please note that the CoxStream project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
