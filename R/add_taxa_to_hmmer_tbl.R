
#' Add taxonomic information to a Data Frame obtained
#'  from HMMER with a "hits.taxid" column.
#'
#' @param data An Data Frame obtained from search function.
#' @param rank_vc A character vector containing the desired taxonomic ranks.
#' If empty, all available taxonomic ranges will be retrieved.
#' @param mode Either "local" or "remote". If "local" you will use a local
#'   database instead of remote resources.  You will not have to download the
#'   database but it is slower.
#'
#' @return A Data Frame with new taxonomic parameters.
#'
#' @examples
#' data(phmmer_2abl)
#' add_taxa_to_hmmer_tbl(
#'     data = phmmer_2abl,
#'     mode = "remote",
#'     rank_vc = NULL
#' )
#' @export
#'
add_taxa_to_hmmer_tbl <- function(data, mode = "remote", rank_vc = NULL) {
    inner_function <- function(x) {
        annotate_with_NCBI_taxid(
            taxid = unique(x$hits.taxid),
            mode = mode, rank_vc = rank_vc
        ) %>%
            dplyr::rename_with(~ paste0("taxa.", .)) %>%
            dplyr::right_join(x, by = c("taxa.taxid" = "hits.taxid"))
    }
    group_var <- rlang::sym("hits.taxid")
    data %>%
        dplyr::group_by(!!group_var) %>%
        dplyr::group_split() %>%
        purrr::map_dfr(~ purrr::possibly(inner_function, .)(.))
}
