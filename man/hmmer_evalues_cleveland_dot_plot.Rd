% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hmmer_evalues_cleveland_dot_plot.R
\name{hmmer_evalues_cleveland_dot_plot}
\alias{hmmer_evalues_cleveland_dot_plot}
\title{A Cleveland dot plot with the evalues of the domains and sequences.}
\usage{
hmmer_evalues_cleveland_dot_plot(data, threshold = 0.001)
}
\arguments{
\item{data}{A Data Frame obtained with HMMERutils}

\item{threshold}{A numeric vector of one with a maximum allowed value
of evalue to draw a line.}
}
\value{
A ggplot2 object.
}
\description{
A Cleveland dot plot with the evalues of the domains and sequences.
}
\examples{
data("phmmer_2abl")

hmmer_evalues_cleveland_dot_plot(
    phmmer_2abl,
    threshold = 0.001
)

}
