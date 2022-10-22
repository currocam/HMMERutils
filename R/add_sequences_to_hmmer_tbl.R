add_sequences_to_hmmer_tbl <- function(
    data, extension = "fullfasta",
    max_times = 3){
  stopifnot(any("uuid" %in% colnames(data)))
  stopifnot(any("hits.name" %in% colnames(data)))
  inner_function <- purrr::insistently(
        rate = purrr::rate_backoff(max_times = max_times,),
        f = function(x){
          x$uuid %>%
            unique() %>%
            create_download_url_for_hmmer(extension) %>%
            download_file() %>%
            Biostrings::readAAStringSet() %>%
            add_AAStringSet_to_tbl(data, extension)
          })
  group_var <- rlang::sym("uuid")
  data %>%
    dplyr::group_by(!!group_var) %>%
    dplyr::group_split() %>%
    purrr::map_dfr(~purrr::possibly(inner_function, .)(.))
}
create_download_url_for_hmmer <- function(uuid, format) {
  paste0(
    "https://www.ebi.ac.uk/Tools/hmmer/download/",
    uuid,
    "/score?format=",
    format
  )
}
download_file<- function(url){
  temp <- tempfile()
  url %>% utils::download.file(temp, mode = "wb",method="libcurl")
  return(temp)
}
add_AAStringSet_to_tbl <- function(fasta, data, extension){
  col_name <- paste0("hits.", extension)
  x <- tibble::tibble("hits.name" = names(fasta))
  x[c(col_name)] <- as.character(fasta)
  data %>%
    dplyr::full_join(x)
}
