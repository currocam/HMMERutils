get_UUID_from_html_response <- function(html_response){
  uuid <- gsub(".*https://www.ebi.ac.uk/Tools/hmmer/results/(.+)/score.*", "\\1", html_response)
  if (uuid==html_response) {
    stop("Unable to identify the UUID")
  }
  uuid
}

download_xml_file <- function(uuid, N.TRIES){
  temp <- tempfile()
    while (N.TRIES > 0L) {
      check_error <-tryCatch(
        uuid %>%
          get_xml_url()%>%
          utils::download.file(temp,method="auto"),
      error = identity)
    if (!inherits(check_error, "error")) {
      break }
    N.TRIES <- N.TRIES - 1L
  }
  if (N.TRIES == 0L) {
    stop(
      "'getURL()' failed:",
      "\n  URL: ", get_results_url(uuid)
      )
  }
  return(temp)
}

request_hmmer <- function(
  seq = NULL,aln = NULL, seqdb = NULL, hmmdb = NULL,
  url, verbose = FALSE, N.TRIES = 1L) {
    if (!is.null(seq)) {
        input_query <- seq
    }
    if (!is.null(aln)) {
        input_query <- aln
    }
    N.TRIES <- as.integer(N.TRIES)
    stopifnot(length(N.TRIES) == 1L, !is.na(N.TRIES))
    uuid <- RCurl::postForm(
      url, seqdb = seqdb, hmmdb = hmmdb,
      seq = input_query, style = "POST", verbose = TRUE,
      .contentEncodeFun = RCurl::curlPercentEncode
    )%>%
      get_UUID_from_html_response
    temp_file <- download_xml_file(uuid, N.TRIES)
    ## check results from the server
    hmm <- list("uuid" = uuid,
                "content" = temp_file)
    if (verbose) {
        message(
            "Content from HMMER server:\n",
            readLines(hmm$content, n=100)
        )
    }
    return(hmm)
}
