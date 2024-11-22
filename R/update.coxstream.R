#' Update the Streaming Cox model with new data.
#'
#' `r lifecycle::badge('experimental')`
#' @param object A \code{"coxstream"} object.
#' @param data A data frame containing the variables in the model.
#' @param ... Unused.
#'
#' @return An object of class \code{"coxstream"}.
#' @export
update.coxstream <- function(object, data, ...) {
  idx_col <- object$idx_col
  formula <- object$formula
  time_stored <- object$time_stored

  mf <- model.frame(formula, data)
  # Load time and status from formula and data
  y <- model.response(mf)
  time <- y[, 1]
  delta <- y[, 2]
  names(time) <- names(delta) <- data[[idx_col]]

  # The patients that are already stored and the new patients
  patients_stored <- names(time_stored)
  patients_overlap <- intersect(patients_stored, data[[idx_col]])
  patients_new <- data[[idx_col]][!data[[idx_col]] %in% patients_overlap]

  # Select the stored survival times that overlap with the new patients
  time_overlap <- time_stored[patients_overlap]

  # Update the stored survival times
  time_stored[patients_overlap] <- time[patients_overlap]
  # Select the survival patients in the overlaped stored survival times
  delta_overlap <- delta[patients_overlap]
  patients_remove <- names(delta_overlap[delta_overlap == 1])
  time_stored <- time_stored[!names(time_stored) %in% patients_remove]
  time_new <- time[data[[idx_col]] %in% patients_new & delta == 0]
  time_stored <- c(time_stored, time_new)
  time_stored <- sort(time_stored)

  # Load X from formula and data
  x <- model.matrix(formula, data)
  x <- x[, -1] # Remove the intercept column
  rownames(x) <- data[[idx_col]]

  sorted <- order(time)
  x <- x[sorted, ]
  time <- time[sorted]
  delta <- delta[sorted]

  theta_prev <- object$theta_prev
  hess_prev <- object$hess_prev

  sr <- optimx::snewton(
    theta_prev,
    fn = fn, gr = gr, hess = hess, x = x, time = time,
    delta = delta, degree = object$degree, boundary = object$boundary,
    theta_prev = theta_prev, hess_prev = hess_prev, time_overlap = time_overlap
  )

  object$theta_prev <- sr$par
  object$hess_prev <- hess(
    sr$par,
    x = x, time = time, delta = delta, degree = object$degree,
    boundary = object$boundary, theta_prev = theta_prev, hess_prev = hess_prev,
    time_overlap = time_overlap
  )
  object$time_stored <- time_stored
  object$n_passes <- object$n_passes + length(patients_new)
  class(object) <- "coxstream"
  return(object)
}
