testthat::test_that("Test that pairwise_alignment_sequence_identity works with missing values", {
  phmmer_2abl$hits.fullfasta %>%
    pairwise_alignment_sequence_identity() %>%
    expect_snapshot_value(style = "deparse")
})