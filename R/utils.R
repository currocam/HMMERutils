#' Download a file using a temp file (it should work in every OS).
#'
#' @param url a string with an URL.
download_file <- function(url) {
  temp <- tempfile()
  url %>% utils::download.file(temp, mode = "wb", method = "libcurl")
  return(temp)
}