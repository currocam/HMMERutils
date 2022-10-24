testthat::skip("No mocking for add remote mode yet")
httptest::with_mock_api({
    testthat::test_that("Adding sequences to phmmer works in local", {
        search_in_hmmer(
            algorithm = "phmmer",
            seqdb = "pdb",
            seq = ">Seq\nKLRVLGYHNGEWCEAQTKNGQGWVPSNYITPVNSLENSIDKHSWYHGPVSRNAAE"
        ) %>%
            add_taxa_to_hmmer_tbl(mode = "local") %>%
            dplyr::select(tidyselect::starts_with("taxa.")) %>%
            testthat::expect_snapshot()
    })
})
testthat::skip("No mocking for add remote mode yet")
httptest::with_mock_api({
    search_in_hmmer(
        algorithm = "phmmer",
        seqdb = "pdb",
        seq = ">Seq\nKLRVLGYHNGEWCEAQTKNGQGWVPSNYITPVNSLENSIDKHSWYHGPVSRNAAE"
    ) %>%
        add_taxa_to_hmmer_tbl() %>%
        dplyr::select(tidyselect::starts_with("taxa.")) %>%
        testthat::expect_snapshot()
})
