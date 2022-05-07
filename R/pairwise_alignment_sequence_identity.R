#' Calculate the percentage of pairwise sequence identity
#'
#' @param seqs A named character vector to convert into a
#'   `Biostrings::AAStringSet` or a `Biostrings::AAStringSet` with the
#'    sequences of interest. If they are not named, arbitrary names
#'    will be given.
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
#' data(example_phmmer)
#' pairwise.per <- pairwise_alignment_sequence_identity(
#'     seqs = example_phmmer$hits.fullfasta[1:10],
#'     aln_type = "overlap",
#'     pid_type = "PID2"
#' )
#' plot(pairwise.per)
#' plot(pairwise.per, type = "heatmap", ann = example_phmmer$taxa.phylum[1:10])
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
#' @return A DataFrame of subclass `pairwise_sequence_identity`, so that it has associated S3 methods.
#' @export
#'
pairwise_alignment_sequence_identity <- function(seqs,
    aln_type = "global",
    pid_type = "PID1",
    allow_parallelization = NULL) {
    if (is.null(names(seqs)) && is.character(seqs)) {
      names(seqs) <- paste0("seq", seq(1, length(seqs)))
    }
    if (!methods::is(seqs, "AAStringSet")) {
        seqs <- Biostrings::AAStringSet(seqs)
    }
    if (length(names(seqs)) != length(unique(names(seqs)))) {
        stop("seqs must have unique names.")
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
    matrix_names <- utils::combn(names(seqs), 2)
    matrix_seqs <- seqs %>%
      as.character() %>%
      magrittr::set_names(NULL) %>%
      utils::combn(2)
    if (!is.null(allow_parallelization)) {
        pairwise_alignment_sequence_identity_using_furrr(
          matrix_seqs, aln_type,pid_type, allow_parallelization
        ) -> percentage_sequence_identity
    } else {
        pairwise_alignment_sequence_identity_using_purrr(
          matrix_seqs, aln_type,pid_type
        ) -> percentage_sequence_identity
    }
    df <- tibble::tibble(
        "seq1" = matrix_names[1, ],
        "seq2" = matrix_names[2, ],
        "percentage.sequence.identity" = percentage_sequence_identity
    )
    class(df) <- c("pairwise_sequence_identity", class(df))
    return(df)
}

pairwise_alignment_sequence_identity_using_purrr <- function(matrix_seqs, aln_type, pid_type) {
    purrr::map2_dbl(
      matrix_seqs[1, ],
      matrix_seqs[2, ],
        ~ {
            calculate_percentage_sequence_identity(
                .x, .y, aln_type = aln_type, pid_type = pid_type)
        }
    )
}

pairwise_alignment_sequence_identity_using_furrr <- function(matrix_seqs, aln_type, pid_type, allow_parallelization) {
    if (allow_parallelization == "multisession") {
        future::plan(future::multisession)
    }
    if (allow_parallelization == "multicore") {
        future::plan(future::multicore)
    }
    furrr::future_map2_dbl(
      matrix_seqs[1, ],
      matrix_seqs[2, ],
      ~ {
            calculate_percentage_sequence_identity(
              .x, .y, aln_type = aln_type, pid_type = pid_type)
        }
    ) %>%
        as.numeric()
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

#' Plot a histogram with the pairwise identity percentages.
#'
#' @param object A pairwise_sequence_identity.
#'
#' @return A ggplot object
#' @export
#'
#' @examples
#' data(example_phmmer)
#' pairwise.per <- pairwise_alignment_sequence_identity(
#'     seqs = example_phmmer$hits.fullfasta[1:5],
#'     aln_type = "overlap",
#'     pid_type = "PID2")
#' pairwise_sequence_identity_histogram(pairwise.per)
pairwise_sequence_identity_histogram <- function(object) {
    ggplot2::ggplot(
        object,
        ggplot2::aes(.data$percentage.sequence.identity)
    ) +
        ggplot2::geom_histogram(binwidth = 1, color = "#e9ecef", alpha = 0.9) +
        ggplot2::labs(x = "Pairwise sequence identities", y = "Number")
}

#' Plot a heatmap with the pairwise identity percentages.
#'
#' @param object A pairwise_sequence_identity.
#' @param annotation A character vector with as many elements as sequences.
#'
#' @return A ggplot object
#' @export
#'
#' @examples
#' data(example_phmmer)
#' pairwise.per <- pairwise_alignment_sequence_identity(
#'     seqs = example_phmmer$hits.fullfasta[1:5],
#'     aln_type = "overlap",
#'     pid_type = "PID2")
#' pairwise_sequence_identity_histogram(pairwise.per)
pairwise_sequence_identity_heatmap <- function(object, annotation = NULL) {
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
            warning(
                "It does not match the length of the annotation ",
                "vector with the length of the number of sequences."
            )
            annotation <- NULL
        } else {
            annotation <- data.frame(
                "annotation" = factor(annotation)
            )
            rownames(annotation) <- rownames(data.plot)
            cluster_rows <- FALSE
        }
    }
    pheatmap::pheatmap(data.plot,
        cluster_rows = cluster_rows,
        annotation_row = annotation,
        show_rownames = FALSE,
        show_colnames = FALSE
    )
}

#' @importFrom ggplot2 autoplot
autoplot.pairwise_sequence_identity <- function(object, type = "hist", annotation = NULL, ...) {
    if (!inherits(object, "pairwise_sequence_identity")) {
        stop("autoplot.pairwise_alignment_sequence_identity requires an pairwise_sequence_identity object")
    }
    if (type == "hist") {
        p <- pairwise_sequence_identity_histogram(object)
    }
    if (type == "heatmap") {
        if (!requireNamespace("pheatmap", quietly = TRUE)) {
            stop(
                "Package \"pheatmap\" must be installed to use this method.",
                call. = FALSE
            )
        }
        p <- pairwise_sequence_identity_heatmap(object, annotation)
    }
    return(p)
}


#' @importFrom graphics plot
#' @export
plot.pairwise_sequence_identity <- function(x, ...) {
    print(autoplot(x, ...))
}
