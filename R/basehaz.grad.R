#' Gradient of the baseline hazard function
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
#' @return The gradient with respect to the coefficients of the baseline hazard
#' function evaluated at the specified time point.
basehaz.grad <- function(t, y, parms) {
  b <- splines2::bpoly(
    t,
    degree = parms$degree, Boundary.knots = parms$boundary, intercept = TRUE
  )
  basehaz_grad <- exp(sum(parms$alpha * b)) * b
  return(list(basehaz_grad))
}
