return_HMMER_API_search_url<- function(algorithm){
  path <- paste("Tools/hmmer/search", algorithm, sep = "/")
  httr::modify_url("https://www.ebi.ac.uk/", path = path)
}

construct_query_object <- function(algorithm, db, input, timeout_in_seconds){
  is_against_HMM_db <- algorithm == "hmmscan"
  query_object <- list(
    algorithm = algorithm,
    url = return_HMMER_API_search_url(algorithm),
    timeout_in_seconds = timeout_in_seconds,
    body = list(
      seq = input
    )
  )
  if (is_against_HMM_db) {
    query_object$body$hmmdb <- db
  }
  if (!is_against_HMM_db) {
    query_object$body$seqdb<- db
  }
  class(query_object) <- "query_object"
  return(query_object)
}
post_HMMER_api_search <- function(query_object){
  tmp <- tempfile()
  r <- httr::POST(
    url = query_object$url, body = query_object$body,
    httr::accept("text/xml"),
    httr::write_disk(tmp), httr::progress(),
    httr::timeout(query_object$timeout_in_seconds))
  httr::message_for_status(r)
  r$algorithm <- query_object$algorithm
  return(r)
}



