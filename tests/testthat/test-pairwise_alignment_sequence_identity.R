test_that("pairwise_alignment autoplot works", {
    pairwise.object <- data.frame(
      "seq1" = c("seq1", "seq1", "seq2"),
      "seq2" = c("seq2", "seq3", "seq3"),
      "percentage.sequence.identity" = c(0.8, 0.5, 0.4))
    class(pairwise.object) <- c("pairwise_sequence_identity", class(pairwise.object))
    vdiffr::expect_doppelganger(
        "A pairwise histogram",
        plot(pairwise.object)
    )
    vdiffr::expect_doppelganger(
        "A pairwise annotated",
        plot(pairwise.object,
            type = "heatmap",
            annotation = c("Chordata", "Chordata", "NonChordata")
        )
    )
})

test_that("pairwise_alignment works", {
  data(example_phmmer)
    seqs <- example_phmmer$hits.fullfasta[1:3] %>%
      magrittr::set_names(example_phmmer$hits.name[1:3])
    pairwise_alignment_sequence_identity(seqs) %>%
        dplyr::pull("percentage.sequence.identity") %>%
        expect_snapshot_value(style = "deparse")
})

testthat::skip_on_ci()
test_that("pairwise_alignment works with furrr", {
    data(example_phmmer)
    example_phmmer$hits.fullfasta[1:3] %>%
      magrittr::set_names(example_phmmer$hits.name[1:3]) %>%
        pairwise_alignment_sequence_identity(
            allow_parallelization = "multisession"
        ) %>%
        dplyr::pull("percentage.sequence.identity") %>%
        expect_snapshot_value(style = "deparse")
})
