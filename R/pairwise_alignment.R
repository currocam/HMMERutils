#' Calculate the percentage of pairwise sequence identity
#'
#' @param seqs A named character vector to convert into a
#'   `Biostrings::AAStringSet` or a `Biostrings::AAStringSet` with the
#'    sequences of interest. If they are not named, arbitrary names
#'    will be given.
#' @param aln_type A character vector of one containing the alignment type.
#'    Possible options are "global" (Needleman-Wunsch),"local" (Smith-Waterman)
#'     and "overlap".
#' @param pid_type A character vector of one containing the definition
#'  of percent sequence identity. Possible options are
#'  "PID1", "PID2", "PID3" and "PID4".
#'
#' @examples
#' data(phmmer_2abl)
#' pairwise_alignment_sequence_identity(
#'     seqs = phmmer_2abl$hits.fullfasta[6:10],
#'     aln_type = "overlap",
#'     pid_type = "PID2"
#' )
#'
#' @section Alignment types:
#' * `global`: align whole strings with end gap
#' penalties (Needleman-Wunsch).
#' * `local`: align string fragments (Smith-Waterman).
#' * `overlap`: align whole strings without end gap penalties.
#'
#' @section Percent sequence identity:
#' * `PID1`: 100 * (identical positions) / (aligned positions + internal
#' gap positions).
#' * `PID2`: 100 * (identical positions) / (aligned positions).
#' * `PID3`: 100 * (identical positions) / (length shorter sequence).
#' * `PID4`: 100 * (identical positions) / (average length of the two
#' sequences).
#'
#' @return A long DataFrame with the results.
#' @export
#'
pairwise_alignment_sequence_identity <- function(seqs, aln_type = "global", pid_type = "PID1") { # nolint
    k <- length(seqs)
    seqs <- check_seqs(seqs)
    # Get all possible but unique combinations
    pairs <- utils::combn(seq_len(k), 2) %>%
        t() %>%
        as.data.frame()
    group_var <- rlang::sym("V1")
    pids <- pairs %>%
        dplyr::group_by(!!group_var) %>%
        dplyr::group_split() %>%
        purrr::map(
            function(x) {
                from_index <- x$V1[[1]]
                to_index <- x$V2
                calculate_percentage_sequence_identity(
                    seqs[[from_index]], seqs[to_index],
                    aln_type = "global", pid_type = "PID1"
                )
            }
        ) %>%
        purrr::flatten_dbl()

    tibble::tibble(
        from = c(names(seqs)[pairs$V1], names(seqs)[pairs$V2]),
        "to" = c(names(seqs)[pairs$V2], names(seqs)[pairs$V1]),
        "PID" = c(pids, pids)
    )
}


#' Plot a heatmap with the pairwise identity percentages.
#'
#' @param data A Data Frame obtained from pairwise_alignment_sequence_identity.
#'
#' @param annotation A character vector with as many elements as sequences.
#'
#' @return A ggplot object
#' @export
#'
#' @examples
#' data(phmmer_2abl)
#' pairwise_alignment_sequence_identity(
#'     seqs = phmmer_2abl$hits.fullfasta[6:10],
#'     aln_type = "overlap",
#'     pid_type = "PID2"
#' ) %>%
#'     pairwise_sequence_identity_histogram()
pairwise_sequence_identity_heatmap <- function(data, annotation = NULL) { # nolint
    rlang::check_installed("pheatmap")
    seqs_names <- unique(data$from)
    data_plot <- tibble::tibble(
        from = seqs_names,
        to = seqs_names,
        PID = rep(100, length(seqs_names))
    ) %>%
        dplyr::bind_rows(data) %>%
        tidyr::pivot_wider(
            names_from = "from",
            values_from = "PID",
            names_repair = "minimal"
        ) %>%
        tibble::column_to_rownames("to")
    data_plot[is.na(data_plot)] <- -1
    cluster_rows <- TRUE
    if (!is.null(annotation)) {
        if (length(data_plot) != length(annotation)) {
            warning(
                "It does not match the length of the annotation ",
                "vector with the length of the number of sequences."
            )
            annotation <- NULL
        } else {
            annotation <- data.frame(
                "annotation" = factor(annotation)
            )
            rownames(annotation) <- rownames(data_plot)
            cluster_rows <- FALSE
        }
    }
    pheatmap::pheatmap(data_plot,
        cluster_rows = cluster_rows,
        annotation_row = annotation,
        show_rownames = FALSE,
        show_colnames = FALSE
    )
}


calculate_percentage_sequence_identity <- function(x, seqs, aln_type, pid_type) { # nolint
    Biostrings::pairwiseAlignment(
        subject = x, pattern = seqs, type = aln_type
    ) %>%
        Biostrings::pid(pid_type)
}
check_seqs <- function(seqs) { # nolint
    if (is.null(names(seqs))) {
        warning("'seqs' has no names or some names are NA")
        names(seqs) <- paste(".", seq_len(length(seqs)))
    }
    names(seqs)[names(seqs) == ""] <- "."
    names(seqs) <- make.unique(names(seqs), sep = "")
    if (!methods::is(seqs, "AAStringSet")) {
        seqs <- seqs %>%
            tidyr::replace_na("") %>%
            Biostrings::AAStringSet()
    }
    seqs
}




#' Plot a histogram with the pairwise identity percentages (without the
#' diagonal).
#'
#' @param data A Data Frame obtained from pairwise_alignment_sequence_identity.
#'
#' @return A ggplot object
#' @export
#'
#' @examples
#' data(phmmer_2abl)
#' pairwise_alignment_sequence_identity(
#'     seqs = phmmer_2abl$hits.fullfasta[6:10],
#'     aln_type = "overlap",
#'     pid_type = "PID2"
#' ) %>%
#'     pairwise_sequence_identity_histogram()
pairwise_sequence_identity_histogram <- function(data) { # nolint
    stopifnot(all(c("from", "to", "PID") %in% colnames(data)))
    data %>%
        ggplot2::ggplot(
            ggplot2::aes(.data$PID) # nolint
        ) +
        ggplot2::geom_histogram(
            binwidth = 1, color =
                "#e9ecef", alpha = 0.8
        ) +
        ggplot2::labs(x = "Pairwise sequence identities", y = "Number")
}
