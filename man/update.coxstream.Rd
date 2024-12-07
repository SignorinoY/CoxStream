% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/update.coxstream.R
\name{update.coxstream}
\alias{update.coxstream}
\title{Update the \code{coxstream} with new data.}
\usage{
\method{update}{coxstream}(object, data, degree = "auto", ...)
}
\arguments{
\item{object}{A \code{coxstream} object.}

\item{data}{A data frame containing the variables in the model.}

\item{degree}{An integer representing the degree of the Bernstein polynomial,
or a string specifying the degree of the Bernstein polynomial as a function
of the number of patients, "auto", which is calculated as
\eqn{\lceil N^{1/4} + 2 \rceil}, where \eqn{N} is the number of the unique
survival times.}

\item{...}{Additional arguments (not used).}
}
\value{
An object of class \code{coxstream}.
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}}
}
