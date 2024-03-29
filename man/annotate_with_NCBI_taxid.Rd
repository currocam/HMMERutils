% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/annotate_with_ncbi.R
\name{annotate_with_NCBI_taxid}
\alias{annotate_with_NCBI_taxid}
\title{Retrieve the taxonomic data for a given NCBI
taxon ID using a local database or as remote data sources.}
\usage{
annotate_with_NCBI_taxid(taxid, rank_vc = NULL, mode = "remote")
}
\arguments{
\item{taxid}{A character or numeric vector
containing the target NCBI taxon ID.}

\item{rank_vc}{A character vector containing the
desired taxonomic ranks. If empty, all available
taxonomic ranges will be retrieved.}

\item{mode}{A character vector, if "local" will
use a local database instead of remote resources.
You will not have to download the database but it is slower.}
}
\value{
A DataFrame with columns \code{taxid} and taxonomic ranks.
}
\description{
Retrieve the taxonomic data for a given NCBI
taxon ID using a local database or as remote data sources.
}
\examples{
annotate_with_NCBI_taxid(7955, mode = "remote")
}
