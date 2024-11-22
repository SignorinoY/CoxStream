fn <- function(
    theta, x, time, delta, degree, boundary,
    theta_prev, hess_prev, time_overlap) {
  p <- ncol(x)
  q <- degree + 1
  alpha <- theta[1:q]
  beta <- theta[(q + 1):(q + p)]

  l1 <- (theta - theta_prev) %*% hess_prev %*% (theta - theta_prev) / 2

  parms <- list(alpha = alpha, degree = degree, boundary = boundary)
  cbh <- as.matrix(deSolve::ode(
    y = 0, times = c(0, time), func = basehaz, parms = parms, method = "ode45"
  ))[-1, -1, drop = FALSE]

  eta <- x %*% beta
  b <- splines2::bpoly(
    time,
    degree = degree, Boundary.knots = boundary, intercept = TRUE
  )

  l2 <- sum(cbh * exp(eta) - delta * (b %*% alpha + eta))

  if (length(time_overlap) > 0) {
    cbh_overlap <- as.matrix(deSolve::ode(
      y = 0, times = c(0, time_overlap), func = basehaz, parms = parms,
      method = "ode45"
    ))[-1, -1, drop = FALSE]
    eta_overlap <- eta[names(time_overlap), ]
    l3 <- -sum(cbh_overlap * exp(eta_overlap))
  } else {
    l3 <- 0
  }

  as.numeric(l1 + l2 + l3)
}
