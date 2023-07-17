# Converts arguments into a list to be used as a query.
#
# @param \\dots
# -  algorithm algorithm to use (phmmer, hmmscan, hmmsearch or jackhmmer)
# - seq protein sequence as a string or an alignment
#  (@seealso HMMERutils::format_AAStringSet_into_hmmer_string())
# - hmmdb a string with a hmmdb (for hmmscan)
# - seqdb a string with seqdb (for phmmer, hmmsearch or jackhmmer)
# - timeout_in_seconds an integer with the number of
# seconds to wait before exits.
params_into_query_list <- function(...) {
    dots <- rlang::list2(...)
    c("algorithm", "seq") %>%
        purrr::every(~ . %in% names(dots)) %>%
        stopifnot()
    dots
}

# Get the HMER URL for each algorithm.
#
# @param algorithm a string with the algorithm name.
get_api_search_url <- function(algorithm) {
    path <- paste("Tools/hmmer/search", algorithm, sep = "/")
    httr::modify_url("https://www.ebi.ac.uk/", path = path)
}
# Get the HMER URL for the output files
#
# @param uuid unique identifier for each result in HMMER.
# @param format a string with the file extension ("fullfasta", "json", "xml"...)
create_download_url_for_hmmer <- function(uuid, format) {
    paste0(
        "https://www.ebi.ac.uk/Tools/hmmer/download/",
        uuid,
        "/score?format=",
        format
    )
}

# Post query to HMMER and returns the httr response.
#
# @param query a query list (@seealso HMMERutils::params_into_query_list())
post_query <- function(query) {
    tmp <- tempfile()
    timeout_in_seconds <- query %>%
        purrr::pluck("timeout_in_seconds", .default = 120)
    body <- query[c("seq", "hmmdb", "seqdb")] %>%
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

# Parses results from HMMER into a tibble.
#
# @param results list with results (@seealso HMMERutils::post_query())
parse_results_into_tbl <- function(results) { # nolint
    tibble::tibble(
        "algorithm" = purrr::pluck(results, "algo", .default = NA),
        "uuid" = purrr::pluck(results, "uuid", .default = NA),
        "stats" = list(purrr::pluck(results, "stats", .default = NA)),
        "hits" = purrr::pluck(results, "hits", .default = NA)
    ) %>%
        tidyr::unnest_wider("stats", names_sep = ".") %>%
        tidyr::unnest_wider("hits", names_sep = ".") %>%
        dplyr::mutate("hits.evalue" = fix_evalue_column(.[["hits.evalue"]])) # nolint
}

# Fix E-value column which sometimes can be a list, a character vector
#   or a numeric vector.
# @param column E.value column
fix_evalue_column <- function(column) {
    if (is.list(column)) {
        column <- purrr::flatten_chr(column)
    }
    as.numeric(column)
}

# Post a query into HMMER for different algorithms and
#  returns a tibble with the results.
#
# @param \\dots
# -  algorithm algorithm to use (phmmer, hmmscan, hmmsearch or jackhmmer)
# - seq protein sequence as a string or an alignment
#  (@seealso HMMERutils::format_AAStringSet_into_hmmer_string())
# - hmmdb a string with a hmmdb (for hmmscan)
# - seqdb a string with seqdb (for phmmer, hmmsearch or jackhmmer)
# - timeout_in_seconds an integer with the number of
# seconds to wait before exits.
search_in_hmmer <- function(...) { # nolint
    r <- params_into_query_list(...) %>%
        post_query()
    if (r$status != 200) {
        return(NULL)
    }
    r %>%
        httr::content() %>%
        purrr::pluck("results") %>%
        parse_results_into_tbl()
}

# Converts an AAStringSet into plain text so
# HMMER can read it.
#
# @param AAStringSet an AASTRingSet from Biostrings.
format_AAStringSet_into_hmmer_string <- function(AAStringSet) { # nolint
    AAStringSet %>%
        as.character() %>%
        (function(x) {
            paste0(">", names(x)) %>%
                paste("\n", x, collapse = "\n")
        })
}
