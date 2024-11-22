gr <- function(
    theta, x, time, delta, degree, boundary,
    theta_prev, hess_prev, time_overlap) {
  p <- ncol(x)
  q <- degree + 1
  alpha <- theta[1:q]
  beta <- theta[(q + 1):(q + p)]

  dtheta1 <- as.vector(hess_prev %*% (theta - theta_prev))

  parms <- list(alpha = alpha, degree = degree, boundary = boundary)
  cbh <- as.matrix(deSolve::ode(
    y = 0, times = c(0, time), func = basehaz, parms = parms, method = "ode45"
  ))[-1, -1, drop = FALSE]
  dcbh <- as.matrix(deSolve::ode(
    y = rep(0, q), times = c(0, time), func = basehaz.grad, parms = parms,
    method = "ode45"
  ))[-1, -1, drop = FALSE]

  b <- splines2::bpoly(
    time,
    degree = degree, Boundary.knots = boundary, intercept = TRUE
  )
  eta <- (x %*% beta)[, 1]
  dalpha <- colSums(dcbh * exp(eta) - b * delta)
  dbeta <- t(cbh * exp(eta) - delta) %*% x
  dtheta2 <- c(dalpha, dbeta)


  if (length(time_overlap) > 0) {
    cbh_overlap <- as.matrix(deSolve::ode(
      y = 0, times = c(0, time_overlap), func = basehaz, parms = parms,
      method = "ode45"
    ))[-1, -1, drop = FALSE]
    dcbh_overlap <- as.matrix(deSolve::ode(
      y = rep(0, q), times = c(0, time_overlap), func = basehaz.grad,
      parms = parms, method = "ode45"
    ))[-1, -1, drop = FALSE]
    eta_overlap <- eta[names(time_overlap)]
    x_overlap <- x[names(time_overlap), , drop = FALSE]
    dalpha <- colSums(dcbh_overlap * exp(eta_overlap))
    dbeta <- t(cbh_overlap * exp(eta_overlap)) %*% x_overlap
    dtheta3 <- -c(dalpha, dbeta)
  } else {
    dtheta3 <- 0
  }

  dtheta1 + dtheta2 + dtheta3
}
