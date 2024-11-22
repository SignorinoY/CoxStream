hess <- function(
    theta, x, time, delta, degree, boundary,
    theta_prev, hess_prev, time_overlap, lambda = 0.1) {
  p <- ncol(x)
  q <- degree + 1
  alpha <- theta[1:q]
  beta <- theta[(q + 1):(q + p)]

  hess1 <- hess_prev

  parms <- list(alpha = alpha, degree = degree, boundary = boundary)
  cbh <- deSolve::ode(
    y = 0, times = c(0, time), func = basehaz, parms = parms, method = "ode45"
  )[-1, ][, -1]
  dcbh <- deSolve::ode(
    y = rep(0, q), times = c(0, time), func = basehaz.grad, parms = parms,
    method = "ode45"
  )[-1, ][, -1]
  d2cbh <- deSolve::ode(
    y = rep(0, q * q), times = c(0, time), func = basehaz.hess,
    parms = parms, method = "ode45"
  )[-1, ][, -1]
  eta <- (x %*% beta)[, 1]
  d2alpha <- matrix(colSums(sweep(d2cbh, 1, exp(eta), "*")), nrow = q)
  d2beta <- t(x) %*% diag(exp(eta) * cbh) %*% x
  dalph_dabeta <- t(dcbh) %*% diag(exp(eta)) %*% x
  hess2 <- cbind(rbind(d2alpha, t(dalph_dabeta)), rbind(dalph_dabeta, d2beta))
  hess2 <- as.matrix(hess2)

  if (length(time_overlap) > 0) {
    cbh_overlap <- deSolve::ode(
      y = 0, times = c(0, time_overlap), func = basehaz, parms = parms,
      method = "ode45"
    )[-1, ][, -1]
    dcbh_overlap <- deSolve::ode(
      y = rep(0, q), times = c(0, time_overlap), func = basehaz.grad,
      parms = parms, method = "ode45"
    )[-1, ][, -1]
    d2cbh_overlap <- deSolve::ode(
      y = rep(0, q * q), times = c(0, time_overlap), func = basehaz.hess,
      parms = parms, method = "ode45"
    )[-1, ][, -1]
    eta_overlap <- eta[names(time_overlap)]
    d2alpha_overlap <- matrix(
      colSums(sweep(d2cbh_overlap, 1, exp(eta_overlap), "*")),
      nrow = q
    )
    d2beta_overlap <- t(x[names(time_overlap), ]) %*%
      diag(exp(eta_overlap) * cbh_overlap) %*% x[names(time_overlap), ]
    dalph_dabeta_overlap <- t(dcbh_overlap) %*%
      diag(exp(eta_overlap)) %*% x[names(time_overlap), ]
    hess3 <- -cbind(
      rbind(d2alpha_overlap, t(dalph_dabeta_overlap)),
      rbind(dalph_dabeta_overlap, d2beta_overlap)
    )
    hess3 <- as.matrix(hess3)
  } else {
    hess3 <- 0
  }

  hess1 + hess2 + hess3
}
