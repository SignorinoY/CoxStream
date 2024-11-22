#' Baseline hazard function
#'
#' @param t A non-negative real number specifying the time point at which to
#' evaluate the baseline hazard function.
#' @param y the initial (state) values of the ODE system, which are not used.
#' @param parms A list of parameters containing the following components:
#' \describe{
#'   \item{alpha}{The coefficients of the Bernstein polynomial.}
#'   \item{degree}{A non-negative integer specifying the degree of the
#' Bernstein polynomial.}
#'   \item{boundary}{Boundary knots at which to anchor the Bernstein polynomial}
#' }
#'
#' @return The baseline hazard function evaluated at the specified time points.
basehaz <- function(t, y, parms) {
  b <- splines2::bpoly(
    t,
    degree = parms$degree, Boundary.knots = parms$boundary, intercept = TRUE
  )
  basehaz <- exp(b %*% parms$alpha)
  if (length(basehaz) == 1) {
    return(list(basehaz))
  } else {
    return(basehaz)
  }
}
