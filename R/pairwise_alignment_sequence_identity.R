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
#' * `global`: align whole strings with end gap penalties (Needleman-Wunsch).
#' * `local`: align string fragments (Smith-Waterman).
#' * `overlap`: align whole strings without end gap penalties.
#'
#' @section Percent sequence identity:
#' * `PID1`: 100 * (identical positions) / (aligned positions + internal gap positions).
#' * `PID2`: 100 * (identical positions) / (aligned positions).
#' * `PID3`: 100 * (identical positions) / (length shorter sequence).
#' * `PID4`: 100 * (identical positions) / (average length of the two sequences).
#'
#' @return A DataFrame of subclass `pairwise_sequence_identity`, so that it has
#'  associated `plot` methods. It consists of a long DataFrame extracted
#'  from the identity square matrix (with the diagonal).
#' @export
#'
pairwise_alignment_sequence_identity <- function(seqs,
    aln_type = "global",
    pid_type = "PID1",
    allow_parallelization = NULL) {
  if (length(names(seqs)) != length(unique(names(seqs)))) {
    warning("`seqs` must have unique names.")
    names(seqs) <- NULL
  }
  if (is.null(names(seqs)) && is.character(seqs)) {
    names(seqs) <- paste0("seq", seq(1, length(seqs)))
  }
  if (!methods::is(seqs, "AAStringSet")) {
      seqs <- Biostrings::AAStringSet(seqs)
  }

  if (is.null(allow_parallelization)){
    pid_list <- pairwise_alignment_sequence_identity_using_purrr(
      seqs, aln_type, pid_type
    )
  }
  if (!is.null(allow_parallelization)){
    pid_list <- pairwise_alignment_sequence_identity_using_furrr(
      seqs, aln_type, pid_type, allow_parallelization
    )
  }
  df <- convert_list_to_identity_long_df(pid_list, names(seqs))
    class(df) <- c("pairwise_sequence_identity", class(df))
    return(df)
}

convert_list_to_identity_long_df <- function(pid_list, seq_names){
  identity_matrix <-pid_list %>%
    purrr::transpose() %>%
    purrr::simplify_all() %>%
    magrittr::extract2("result")

  dim(identity_matrix) <- c(length(seq_names), length(seq_names))
  rownames(identity_matrix)<- seq_names
  colnames(identity_matrix)<- seq_names
  identity_matrix_upper <- upper.tri(identity_matrix, diag = FALSE)
  identity_matrix[identity_matrix_upper]<- NA
  identity_matrix%>%
    as.data.frame()%>%
    tibble::rownames_to_column() %>%
    tidyr::pivot_longer(
      cols = -c("rowname"),
      names_to = "seq2",
      values_to = "percentage.sequence.identity",
      values_drop_na = TRUE
    ) %>%
    dplyr::rename(c("seq1" = "rowname"))
}

pairwise_alignment_sequence_identity_using_purrr <- function(seqs, aln_type, pid_type) {
  otherwise <- rep(NA, length(seqs))
  names(otherwise) <- names(seqs)
  map_function <- purrr::safely(calculate_percentage_sequence_identity, otherwise)
  seqs %>%
    as.list()%>%
    purrr::map(~ map_function(.x, seqs,aln_type, pid_type))
}

pairwise_alignment_sequence_identity_using_furrr <- function(
  seqs, aln_type, pid_type, allow_parallelization) {
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
  if (allow_parallelization == "multisession") {
      future::plan(future::multisession)
  }
  if (allow_parallelization == "multicore") {
      future::plan(future::multicore)
  }

  otherwise <- rep(NA, length(seqs))
  names(otherwise) <- names(seqs)
  map_function <- purrr::safely(calculate_percentage_sequence_identity, otherwise)
  seqs %>%
    as.list()%>%
    furrr::future_map(~ map_function(.x, seqs,aln_type, pid_type),.progress = TRUE)
}

calculate_percentage_sequence_identity <- function(x, seqs,aln_type, pid_type) {
  Biostrings::pairwiseAlignment(subject = x, pattern = seqs,type = aln_type) %>%
        Biostrings::pid(pid_type)
}

#' Plot a histogram with the pairwise identity percentages (without the diagonal).
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
    object %>%
    dplyr::filter(.data$seq1 != .data$seq2) %>%
    ggplot2::ggplot(
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
            "percentage.sequence.identity" = object$percentage.sequence.identity)
          ) %>%
      dplyr::distinct()
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
