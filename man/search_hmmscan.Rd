% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/search_hmmscan.R
\name{search_hmmscan}
\alias{search_hmmscan}
\title{hmmscan search of a protein sequence against a profile-HMM database.}
\usage{
search_hmmscan(
  seqs,
  seq_names = NULL,
  dbs = "pfam",
  verbose = TRUE,
  timeout = 180
)
}
\arguments{
\item{seqs}{A character vector containing the sequences of the query or
any other object that can be converted to that.}

\item{seq_names}{A character vector containing the names of the sequences.
If \code{seqs} is a named vector it will overwrite them. If not specified, they
will not be taken into account.}

\item{dbs}{A character vector containing the target databases. Frequently
used databases are \code{pfam}, \code{tigrfam} \code{gene3d}, \code{superfamily}, \code{pirsf} and
\code{treefam}, but a complete and updated list is available at
\url{https://www.ebi.ac.uk/Tools/hmmer/}.}

\item{verbose}{A logical, if TRUE details of the download process is printed.}

\item{timeout}{Set maximum request time in seconds.}
}
\value{
An \code{AnnotatedDataFrame}, consisting of 2 parts, a nested DataFrame
with the search hashes, the download links of all available files and
of the HMMER page where the results are hosted, and the metadata
associated to this DataFrame. Although all available results are available
here, we recommend using the \code{extract_from_HMMER_data_tbl} function
to preprocess the data.
}
\description{
hmmscan search of a protein sequence against a profile-HMM database.
}
\examples{
path_to_example_fasta <- system.file(
 "extdata/fasta_seq_example.fa",
 package = "HMMERutils")
seqs <- Biostrings::readAAStringSet(path_to_example_fasta)
hmmscan_tbl <- search_hmmscan(
 seqs = seqs,
 dbs = "pfam",
 verbose = FALSE)
hmmscan_tbl
Biobase::varMetadata(hmmscan_tbl)
}
