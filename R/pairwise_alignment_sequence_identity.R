#' Calculate the percentage of pairwise sequence identity
#'
#' @param seqs A named character vector to convert into a `Biostrings::AAStringSet` or a `Biostrings::AAStringSet` with the sequences of interest.
#' @param aln_type A character vector of one containing the alignment type.
#'    Possible options are "global" (Needleman-Wunsch),"local" (Smith-Waterman) and "overlap".
#' @param pid_type A character vector of one containing the definition of percent
#'    sequence identity. Possible options are "PID1", "PID2", "PID3" and "PID4".
#' @param allow_parallelization A character vector of one, by default NULL.
#'   If you want to parallelize the alignment of the sequences, speeding up the
#'    process, select `multisession` or `multicore`.
#'
#' @section Visualize:
#' The `plot` method can be called to visualize either a histogram or a default
#'    heatmap. Refer to the "examples" section.
#'
#' @examples
#' pairwise.per <- pairwise_alignment_sequence_identity(
#'     seqs = HMMERutils::ABL1_homologous$hits.fullseq.fasta[1:5],
#'     aln_type = "overlap",
#'     pid_type = "PID2"
#' )
#' plot(pairwise.per)
#' plot(pairwise.per, type = "heatmap")
#'
#' @section Alignment types:
#' * `global`: align whole strings with end gap penalties.
#' * `local`: align string fragments.
#' * `overlap`: align whole strings without end gap penalties.
#'
#' @section Percent sequence identity:
#' * `PID1`: 100 * (identical positions) / (aligned positions + internal gap positions).
#' * `PID2`: 100 * (identical positions) / (aligned positions).
#' * `PID3`: 100 * (identical positions) / (length shorter sequence).
#' * `PID4`: 100 * (identical positions) / (average length of the two sequences).
#'
#' @return A DataFrame of subclass `pairwise_sequence_identity`, so that it has associated S3 methods..
#' @export
#'
pairwise_alignment_sequence_identity <- function(seqs,
    aln_type = "global",
    pid_type = "PID1",
    allow_parallelization = NULL) {
    if (!methods::is(seqs, "AAStringSet")) {
        seqs <- Biostrings::AAStringSet(seqs)
    }
    if (length(names(seqs)) != length(unique(names(seqs)))) {
        stop("AAStringSet must have unique names.")
    }
    if (!is.null(allow_parallelization) && !requireNamespace("furrr", quietly = TRUE)) {
        stop(
            "Package \"furrr\" must be installed to use this function if allow_parallelization = TRUE",
            call. = FALSE
        )
    }
    if (!is.null(allow_parallelization) && !requireNamespace("future", quietly = TRUE)) {
        stop(
            "Package \"future\" must be installed to use this function if allow_parallelization = TRUE",
            call. = FALSE
        )
    }
    matrix <- utils::combn(names(seqs), 2)
    if (!is.null(allow_parallelization)) {
        if (allow_parallelization == "multisession") {
            future::plan(future::multisession)
        }
        if (allow_parallelization == "multicore") {
            future::plan(future::multicore)
        }
        percentage_sequence_identity <- furrr::future_map2_dbl(
            matrix[1, ], matrix[2, ],
            ~ {
                seq1 <- seqs[[.x]]
                seq2 <- seqs[[.y]]
                calculate_percentage_sequence_identity(
                    seq1, seq2,
                    aln_type = aln_type, pid_type = pid_type
                )
            }
        ) %>%
            as.numeric()
    } else {
        percentage_sequence_identity <- purrr::map2_dbl(
            matrix[1, ],
            matrix[2, ],
            ~ {
                seq1 <- seqs[[.x]]
                seq2 <- seqs[[.y]]
                calculate_percentage_sequence_identity(
                    seq1, seq2,
                    aln_type = aln_type, pid_type = pid_type
                )
            }
        )
    }
    df <- tibble::tibble(
        "seq1" = matrix[1, ],
        "seq2" = matrix[2, ],
        "percentage.sequence.identity" = percentage_sequence_identity
    )
    class(df) <- c("pairwise_sequence_identity", class(df))
    return(df)
}

calculate_percentage_sequence_identity <- function(seq1, seq2,
    aln_type, pid_type) {
    Biostrings::pairwiseAlignment(
        pattern = as.character(seq1),
        subject = as.character(seq2),
        type = aln_type
    ) %>%
        Biostrings::pid(pid_type)
}

#' @importFrom ggplot2 autoplot
autoplot.pairwise_sequence_identity <- function(object, type = "hist", annotation = NULL, ...) {
    if (!inherits(object, "pairwise_sequence_identity")) {
        stop("autoplot.pairwise_alignment_sequence_identity requires an pairwise_sequence_identity object")
    }
    if (type == "hist") {
        p <- ggplot2::ggplot(
            object,
            ggplot2::aes(.data$percentage.sequence.identity)
        ) +
            ggplot2::geom_histogram(binwidth = 1, color = "#e9ecef", alpha = 0.9) +
            ggplot2::labs(x = "Pairwise sequence identities", y = "Number")
    }
    if (type == "heatmap") {
        if (!requireNamespace("pheatmap", quietly = TRUE)) {
            stop(
                "Package \"pheatmap\" must be installed to use this method.",
                call. = FALSE
            )
        }
        data.plot <- object %>%
            dplyr::bind_rows(
                tibble::tibble(
                    "seq1" = object$seq2,
                    "seq2" = object$seq1,
                    "percentage.sequence.identity" = object$percentage.sequence.identity
                )
            )
        data.plot <- data.plot %>%
            tidyr::pivot_wider(
                names_from = "seq1",
                values_from = "percentage.sequence.identity",
                names_repair = "minimal"
            ) %>%
            tibble::column_to_rownames("seq2")
        data.plot[is.na(data.plot)] <- 100
        cluster_rows <- TRUE
        if (!is.null(annotation)) {
            if (length(data.plot) != length(annotation)) {
                warning("It does not match the length of the annotation ",
                "vector with the length of the number of sequences.")
                annotation <- NULL
            } else {
                annotation <- data.frame(
                    "annotation" = factor(annotation)
                )
                rownames(annotation) <- rownames(data.plot)
                cluster_rows <- FALSE
            }
        }
        p <- pheatmap::pheatmap(data.plot,
            cluster_rows = cluster_rows,
            annotation_row = annotation,
            show_rownames = FALSE,
            show_colnames = FALSE
        )
    }
    return(p)
}


#' @importFrom graphics plot
#' @export
plot.pairwise_sequence_identity <- function(x, ...) {
    print(autoplot(x, ...))
}
