testthat::skip("Not mocking yet for add_sequences")
testthat::test_that("Add physicochemical properties works", {
  search_in_hmmer(
    algorithm = "phmmer",
    seqdb = "pdb",
    seq = ">Seq\nKLRVLGYHNGEWCEAQTKNGQGWVPSNYITPVNSLENSIDKHSWYHGPVSRNAAE"
  ) %>%
    add_sequences_to_hmmer_tbl() %>%
    add_physicochemical_properties_to_HMMER_tbl() %>%
    dplyr::select(tidyselect::starts_with("properties")) %>%
    testthat::expect_snapshot()
})
