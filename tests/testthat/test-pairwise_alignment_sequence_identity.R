test_that("pairwise_alignment autoplot works", {
    data(example_phmmer)
    seqs <- example_phmmer$hits.fullfasta[1:5] %>%
      magrittr::set_names(example_phmmer$hits.name[1:5])
    pairwise.object <- pairwise_alignment_sequence_identity(seqs)
    vdiffr::expect_doppelganger(
        "A pairwise histogram",
        plot(pairwise.object)
    )
    vdiffr::expect_doppelganger(
        "A pairwise annotated",
        plot(pairwise.object,
            type = "heatmap",
            annotation = example_phmmer$taxa.phylum[1:5]
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
