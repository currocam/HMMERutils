#' Retrieve the taxonomic data for a given NCBI
#'  taxon ID using a local database or as remote data sources.
#'
#' @param taxid A character or numeric vector
#'  containing the target NCBI taxon ID.
#' @param rank_vc A character vector containing the
#' desired taxonomic ranks. If empty, all available
#' taxonomic ranges will be retrieved.
#' @param mode A character vector, if "local" will
#' use a local database instead of remote resources.
#'   You will not have to download the database but it is slower.
#'
#' @return A DataFrame with columns `taxid` and taxonomic ranks.
#' @export
#' @examples
#' annotate_with_NCBI_taxid(7955, "species")
annotate_with_NCBI_taxid <- function(taxid, rank_vc = NULL, mode = "remote") {
    if (!requireNamespace("taxizedb", quietly = TRUE) && mode == "local") {
        stop(
            "Package \"taxizedb\" must be installed to use this function with a local database.",
            call. = FALSE
        )
    }
    if (!requireNamespace("taxize", quietly = TRUE) && mode != "local") {
        stop(
            "Package \"taxize\" must be installed to use this function with remote data sources.",
            call. = FALSE
        )
    }
    taxid <- as.numeric(unique(taxid))
    ## Check arguments
    if (!is.character(rank_vc)) {
        rank_vc <- NULL
    }
    if (mode != "local") {
        tax_cl <- taxize::classification(taxid, db = "ncbi") %>%
            purrr::discard(~ any(is.na(.x)))
    }
    if (mode == "local") {
        tax_cl <- taxizedb::classification(taxid) %>%
            purrr::discard(~ any(is.na(.x)))
    }
    tax_df <- purrr::map2_dfr(tax_cl, names(tax_cl), ~ {
        .x$rank <- make.unique(.x$rank)
        .x %>%
            dplyr::select(name, rank) %>%
            dplyr::mutate("taxid" = as.character(.y)) %>%
            tidyr::pivot_wider(
                names_from = rank,
                values_from = name
            )
    }) %>%
        tibble::as_tibble()
    if (is.character(rank_vc)) {
        tax_df <- tax_df %>%
            dplyr::select(unique(c(rank_vc, "taxid")))
    }
    return(tax_df)
}