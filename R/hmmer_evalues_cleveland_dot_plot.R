#' A Cleveland dot plot with the evalues of the domains and sequences.
#'
#' @param data A Data Frame obtained with HMMERutils
#' @param threshold A numeric vector of one with a maximum allowed value
#'    of evalue to draw a line.
#'
#' @return A ggplot2 object.
#' @export
#'
#' @examples
#' data("phmmer_2abl")
#'
#' hmmer_evalues_cleveland_dot_plot(
#'     phmmer_2abl,
#'     threshold = 0.001
#' )
#'
hmmer_evalues_cleveland_dot_plot <- function(data, threshold = 0.001) { # nolint
    df <- data %>%
        extract_from_hmmer()
    df$domains.ievalue <- as.numeric(df$domains.ievalue)
    df <- df %>%
        dplyr::group_by(.data$uuid, .data$hits.name, .data$hits.acc) %>% # nolint
        dplyr::mutate(
            "best.ievalue" =
                min(as.numeric(.data$domains.ievalue))
        ) %>%
        dplyr::ungroup()
    df %>%
        dplyr::arrange(-log(.data$best.ievalue)) %>% # nolint
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
}
