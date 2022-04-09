request_hmmer <- function(seq = NULL,
    aln = NULL,
    seqdb = NULL,
    hmmdb = NULL,
    url,
    verbose = FALSE) {
    curl.opts <- list(
        httpheader = "Expect:",
        httpheader = "Accept:text/xml",
        verbose = verbose,
        followlocation = TRUE
    )

    if (!is.null(seq)) {
        input_query <- seq
    }
    if (!is.null(aln)) {
        input_query <- aln
    }

    hmm <- RCurl::postForm(
        url,
        seqdb = seqdb,
        hmmdb = hmmdb,
        seq = input_query,
        style = "POST",
        .opts = curl.opts,
        .contentEncodeFun = RCurl::curlPercentEncode,
        .checkParams = TRUE
    )

    ## check results from the server
    if (!grepl("results", hmm)) {
        stop("Request to HMMER server failed")
    }
    if (verbose) {
        message(
            "Content from HMMER server:\n",
            hmm
        )
    }
    return(hmm)
}
