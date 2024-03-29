testthat::test_that("Test that pairwise_alignment_sequence_identity works with missing values", {
    phmmer_2abl$hits.fullfasta %>%
        pairwise_alignment_sequence_identity() %>%
        expect_snapshot_value(style = "deparse")
})

testthat::test_that("Test that pairwise plots work", {
    phmmer_2abl$hits.fullfasta %>%
        pairwise_alignment_sequence_identity() -> data
    hist_plot <- pairwise_sequence_identity_histogram(data)
    vdiffr::expect_doppelganger("Base graphics histogram", hist_plot)
    heatmap_plot <- pairwise_sequence_identity_heatmap(data)
    vdiffr::expect_doppelganger("Base graphics heatmap", heatmap_plot)
})
