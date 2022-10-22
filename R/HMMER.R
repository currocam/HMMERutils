params_into_query_list <- function(...) {
    dots <- rlang::list2(...)
    c("algorithm", "seq") %>%
        purrr::every(~ . %in% names(dots)) %>%
        stopifnot()
  dots
}

get_api_search_url <- function(algorithm) {
    path <- paste("Tools/hmmer/search", algorithm, sep = "/")
    httr::modify_url("https://www.ebi.ac.uk/", path = path)
}

post_query <- function(query) {
       tmp <- tempfile()
       timeout_in_seconds <- query %>%
        purrr::pluck("timeout_in_seconds", .default = 120)
        body <- query %>%
            .[c("seq", "hmmdb", "seqdb")] %>%
            purrr::discard(is.null)
       r <- httr::POST(
           url = get_api_search_url(query$algorithm),
           body = body,
           httr::timeout(timeout_in_seconds),
           httr::write_disk(tmp)
       )
       httr::warn_for_status(r)
       return(r)
   }

parse_results_into_list <- function(results) {
    tibble::tibble(
      "algorithm" = purrr::pluck(results, "algo", .default = NA),
      "uuid" = purrr::pluck(results, "uuid", .default = NA),
      "stats" =  list(purrr::pluck(results, "stats", .default = NA)),
      "hits" = purrr::pluck(results, "hits", .default = NA)) %>%
    tidyr::unnest_wider("stats", names_sep = ".") %>%
    tidyr::unnest_wider("hits",names_sep = ".")
}

search_in_hmmer <- function(...) {
    params_into_query_list(...) %>%
        post_query() %>%
        httr::content() %>%
        purrr::pluck("results") %>%
        parse_results_into_list()
}

format_AAStringSet_into_hmmer_string <- function(AAStringSet){
  AAStringSet %>%
    as.character() %>%
    {paste(
      collapse = "\n",
      paste0(">", names(.)),
      "\n", .
    )}
}
