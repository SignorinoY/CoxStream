gr <- function(
    theta, x, time, delta, degree, boundary,
    theta_prev, hess_prev, time_overlap) {
  p <- ncol(x)
  q <- degree + 1
  alpha <- theta[1:q]
  beta <- theta[(q + 1):(q + p)]

  dtheta1 <- as.vector(hess_prev %*% (theta - theta_prev))

  parms <- list(alpha = alpha, degree = degree, boundary = boundary)
  cbh <- deSolve::ode(
    y = 0, times = c(0, time), func = basehaz, parms = parms, method = "ode45"
  )[-1, ][, -1]
  dcbh <- deSolve::ode(
    y = rep(0, q), times = c(0, time), func = basehaz.grad, parms = parms,
    method = "ode45"
  )[-1, ][, -1]

  b <- splines2::bpoly(
    time,
    degree = degree, Boundary.knots = boundary, intercept = TRUE
  )
  eta <- (x %*% beta)[, 1]
  dalpha <- colSums(dcbh * exp(eta) - b * delta)
  dbeta <- colSums(x * (cbh * exp(eta) - delta))
  dtheta2 <- c(dalpha, dbeta)


  if (length(time_overlap) > 0) {
    cbh_overlap <- deSolve::ode(
      y = 0, times = c(0, time_overlap), func = basehaz, parms = parms,
      method = "ode45"
    )[-1, ][, -1]
    dcbh_overlap <- deSolve::ode(
      y = rep(0, q), times = c(0, time_overlap), func = basehaz.grad,
      parms = parms, method = "ode45"
    )[-1, ][, -1]
    eta_overlap <- eta[names(time_overlap)]
    dalpha <- colSums(dcbh_overlap * exp(eta_overlap))
    dbeta <- colSums(x[names(time_overlap), ] * cbh_overlap * exp(eta_overlap))
    dtheta3 <- -c(dalpha, dbeta)
  } else {
    dtheta3 <- 0
  }

  dtheta1 + dtheta2 + dtheta3
}
