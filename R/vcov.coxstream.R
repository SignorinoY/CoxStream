#' Variance-covariance method for \code{coxstream} object
#'
#' @param object An object of class \code{"coxstream"}.
#' @param ... Unused.
#'
#' @return A matrix of the variance-covariance matrix of the coefficients.
#' @export
vcov.coxstream <- function(object, ...) {
  if (!inherits(object, "coxstream")) {
    stop("object must be of class 'coxstream'")
  }
  return(solve(object$hess_prev))
}
