#' Extract the coefficients from \code{coxstream} object
#'
#' @param object An object of class \code{"coxstream"}.
#' @param ... Unused.
#'
#' @return a vector of coefficients.
#' @export
coef.coxstream <- function(object, ...) {
  if (!inherits(object, "coxstream")) {
    stop("object must be of class 'coxstream'")
  }
  return(object$theta_prev)
}
