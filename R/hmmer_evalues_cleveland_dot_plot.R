#' A Cleveland dot plot with the evalues of the domains and sequences.
#'
#' @param HMMER_tidy_tbl An `AnnotatedDataFrame` obtained through
#'   `extract_from_HMMER_data_tbl`.
#' @param threshold A numeric vector of one with a maximum allowed value
#'    of evalue to draw a line.
#'
#' @return A ggplot2 object.
#' @export
#'
#' @examples
#' data("example_phmmer")
#' hmmer_evalues_cleveland_dot_plot(
#'     example_phmmer,
#'     threshold = 0.001
#' )
#'
hmmer_evalues_cleveland_dot_plot <- function(HMMER_tidy_tbl,
    threshold = 0.01) {
  check_AnnotatedDataFrame(HMMER_tidy_tbl)
  pdata <- Biobase::pData(HMMER_tidy_tbl)
    df <- pdata %>%
        dplyr::group_by(.data$uuid, .data$hits.name, .data$hits.acc) %>%
        dplyr::mutate("best.ievalue" = min(.data$domains.ievalue)) %>%
        dplyr::ungroup()
    p <- df %>%
        dplyr::arrange(-log(.data$best.ievalue)) %>%
        ggplot2::ggplot() +
        ggplot2::geom_segment(
            ggplot2::aes(
                x = .data$hits.name,
                xend = .data$hits.name,
                y = -log(.data$hits.evalue),
                yend = -log(.data$best.ievalue)
            ),
            color = "grey"
        ) +
        ggplot2::geom_point(
            ggplot2::aes(
                x = .data$hits.name,
                y = -log(.data$hits.evalue)
            ),
            color = "green", size = 1, alpha = 0.7
        ) +
        ggplot2::geom_point(
            ggplot2::aes(
                x = .data$hits.name,
                y = -log(.data$domains.ievalue)
            ),
            color = "red", size = 1
        ) +
        ggplot2::coord_flip() +
        ggplot2::theme(
            panel.grid.major.x = ggplot2::element_blank(),
            panel.border = ggplot2::element_blank(),
            axis.ticks.x = ggplot2::element_blank(),
            axis.text.y = ggplot2::element_blank(),
            strip.text.y = ggplot2::element_text(angle = 0),
            strip.text.x = ggplot2::element_text(angle = 0)
        ) +
        ggplot2::xlab("Sequences hits") +
        ggplot2::ylab("-log(E-value)") +
        ggplot2::geom_hline(yintercept = -log(threshold), alpha = 0.5)
    return(p)
}
