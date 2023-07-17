# Download a file using a temp file (it should work in every OS).
#
# @param url a string with an URL.
download_file <- function(url) { # nolint
    temp <- tempfile()
    url %>% utils::download.file(temp, mode = "wb", method = "libcurl")
    return(temp)
}

check_if_url <- function(urls) {
    purrr::map_lgl(
        urls,
        purrr::possibly(
            Negate(httr::http_error),
            otherwise = FALSE
        )
    )
}

convert_input_seq <- function(seq) {
    seq <- as.character(seq)
    if (all(file.exists(seq)) || all(check_if_url(seq))) {
        seq <- Biostrings::readAAStringSet(seq)
    }
    as.character(seq)
}
