
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
data <- sim[sim$batch == 1, ]
fit <- coxstream(
  formula, data,
  degree = 4, boundary = c(0, 3), idx_col = "patient_id"
)
for (batch in 2:10) {
  data <- sim[sim$batch_id == batch, ]
  fit <- update(fit, data)
}
summary(fit)
#> Call:
#> coxstream(formula = formula, data = data, degree = 4, boundary = c(0, 
#>     3), idx_col = "patient_id")
#> 
#>       coef exp(coef)      se     z      p    
#> X1 0.96863   2.63433 0.05107 18.97 <2e-16 ***
#> X2 0.99687   2.70979 0.05355 18.61 <2e-16 ***
#> X3 0.99165   2.69567 0.05368 18.47 <2e-16 ***
#> X4 0.88256   2.41709 0.05205 16.96 <2e-16 ***
#> X5 1.01819   2.76817 0.05093 19.99 <2e-16 ***
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#>    exp(coef) exp(-coef) lower .95 upper .95
#> X1 2.6343    0.3796     2.3834    2.9117   
#> X2 2.7098    0.3690     2.4398    3.0097   
#> X3 2.6957    0.3710     2.4265    2.9948   
#> X4 2.4171    0.4137     2.1827    2.6767   
#> X5 2.7682    0.3612     2.5052    3.0587
```

## Code of Conduct

Please note that the CoxStream project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
