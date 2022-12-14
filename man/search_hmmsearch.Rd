% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/search_hmmsearch.R
\name{search_hmmsearch}
\alias{search_hmmsearch}
\title{Perform a hmmsearch search of a protein alignment against a protein sequence database.}
\usage{
search_hmmsearch(
  alns,
  aln_names = NULL,
  dbs = "swissprot",
  verbose = TRUE,
  timeout = 180
)
}
\arguments{
\item{alns}{A Biostrings::AAMultipleAlignment or a list of
Biostrings::AAMultipleAlignment.}

\item{aln_names}{A character vector containing the names of the aligments.
If \code{alns} is a named list it will overwrite them. If not specified, they
will not be taken into account.}

\item{dbs}{A character vector containing the target databases. Frequently
used databases are \code{swissprot}, \code{uniprotrefprot}, \code{uniprotkb}, \code{ensembl},
\code{pdb} and \code{alphafold}, but a complete and updated list is available at
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
Perform a hmmsearch search of a protein alignment against a protein sequence database.
}
\examples{
path_to_example_aln <- system.file(
  "extdata/alignment_example.afa",
  package = "HMMERutils")
alns <- Biostrings::readAAMultipleAlignment(path_to_example_aln)
hmmsearch_tbl <- search_hmmsearch(
  alns = alns,
  dbs = "pdb",
  verbose = FALSE)
hmmsearch_tbl
Biobase::varMetadata(hmmsearch_tbl)
}
