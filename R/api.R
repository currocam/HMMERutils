hmmer_request <- function(
    algo, ..., seq = NULL, hmmdb = NULL, seqdb = NULL, max_tries = 5) {
  if (length(c(seqdb, hmmdb)) != 1) {
    stop("You must specify either a seqdb or a hmmdb, not both.")
  }
  body <- list(
    ...,
    seq = seq,
    hmmdb = hmmdb,
    seqdb = seqdb
  ) |>
    purrr::compact()

  user_agent_string <- "HMMERutils (https://github.com/currocam/HMMERutils)"
  httr2::request("https://www.ebi.ac.uk/Tools/hmmer/search") |>
    httr2::req_user_agent(user_agent_string) |>
    httr2::req_headers("Accept" = "application/json") |>
    httr2::req_url_path_append(algo) |>
    httr2::req_retry(max_tries = max_tries) |>
    httr2::req_body_json(body)
}

resp_get_uuid <- function(req) {
  purrr::chuck(req, "url") |>
    stringr::str_split("/") |>
    purrr::chuck(1, 7)
}

req_perform_custom <- function(r) {
  response <- httr2::req_perform(r, path = tempfile())
  Sys.sleep(15)
  response
}


multi_req_perform_custom <- function(requests) {
  f <- purrr::possibly(req_perform_custom, otherwise = NULL, quiet = FALSE)
  responses <- purrr::map(requests, f)
  names(responses) <- purrr::map(responses, "url") |> as.character()
  responses
}

add_fullfasta <- function(data, uuid) {
  fasta <- uuid |>
    create_download_url_for_hmmer("fullfasta") |>
    download_file() |>
    Biostrings::readAAStringSet()
  tibble::tibble(hits.name = names(fasta), hits.fullfasta = as.character(fasta)) |>
    dplyr::full_join(data, by = "hits.name")
}
