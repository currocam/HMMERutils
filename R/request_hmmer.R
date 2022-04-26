request_hmmer <- function(
  seq = NULL,aln = NULL, seqdb = NULL, hmmdb = NULL,
  url, verbose = FALSE, N.TRIES = 1L) {
    curl.opts <- list(
        httpheader = "Expect:", httpheader = "Accept:text/xml",
        verbose = verbose, followlocation = TRUE)
    if (!is.null(seq)) {
        input_query <- seq
    }
    if (!is.null(aln)) {
        input_query <- aln
    }
    N.TRIES <- as.integer(N.TRIES)
    stopifnot(length(N.TRIES) == 1L, !is.na(N.TRIES))

    while (N.TRIES > 0L) {
        hmm <- tryCatch(
            RCurl::postForm(
                url, seqdb = seqdb, hmmdb = hmmdb,
                seq = input_query, style = "POST", verbose = TRUE,
                .opts = curl.opts,.checkParams = TRUE,
                .contentEncodeFun = RCurl::curlPercentEncode
            ),
            error = identity)
        if (!inherits(hmm, "error")) {
            break }
        N.TRIES <- N.TRIES - 1L
      }
    if (N.TRIES == 0L) {
        stop(
            "'getURL()' failed:",
            "\n  URL: ", url,
            "\n  seqdb: ", seqdb)
    }
    ## check results from the server
    if (!grepl("results", hmm)) {
      if (verbose) {
        message("Request to HMMER server failed")
      }
      return(NULL)
    }
    if (verbose) {
        message(
            "Content from HMMER server:\n",
            hmm
        )
    }
    return(hmm)
}
