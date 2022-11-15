httptest::with_mock_api({
    testthat::test_that("Test that extract hmmer works with phmmer and pdb", {
        data <- search_in_hmmer(
            algorithm = "phmmer",
            seqdb = "pdb",
            seq = ">Seq\nKLRVLGYHNGEWCEAQTKNGQGWVPSNYITPVNSLENSIDKHSWYHGPVSRNAAE"
        )
        data2 <- data %>%
            extract_from_hmmer()
        testthat::expect_equal(sum(data$hits.ndom), nrow(data2))
    })
})


httptest::with_mock_api({
    testthat::test_that("Test that extract hmmer works with hmmscan and pfam", {
        data <- search_in_hmmer(
            algorithm = "hmmscan",
            hmmdb = "pfam",
            seq = ">Seq\nKLRVLGYHNGEWCEAQTKNGQGWVPSNYITPVNSLENSIDKHSWYHGPVSRNAAE"
        )
        data2 <- data %>%
            extract_from_hmmer()
        testthat::expect_equal(sum(data$hits.ndom), nrow(data2))
    })
})



httptest::with_mock_api({
    testthat::test_that("Test that extract hmmer works with hmmscan and pfam", {
        data <- Biostrings::readAAMultipleAlignment("alignment.fasta") %>%
            search_hmmsearch(seqdb = "swissprot")
        data2 <- data %>%
            extract_from_hmmer()
        testthat::expect_equal(sum(data$hits.ndom), nrow(data2))
    })
})

httptest::with_mock_api({
    testthat::test_that("Test that extract hmmer works with phmmer and pdb for extract pdbs using phmmer", {
        data <- search_in_hmmer(
            algorithm = "phmmer",
            seqdb = "pdb",
            seq = ">Seq\nKLRVLGYHNGEWCEAQTKNGQGWVPSNYITPVNSLENSIDKHSWYHGPVSRNAAE"
        )
        data %>%
            extract_from_hmmer("hits.pdbs") %>%
            dplyr::select(tidyselect::starts_with("pdbs")) %>%
            testthat::expect_snapshot()
    })
})

httptest::with_mock_api({
    testthat::test_that("Test that extract hmmer works with phmmer and pdb for extract seqs using phmmer", {
        data <- search_in_hmmer(
            algorithm = "phmmer",
            seqdb = "pdb",
            seq = ">Seq\nKLRVLGYHNGEWCEAQTKNGQGWVPSNYITPVNSLENSIDKHSWYHGPVSRNAAE"
        )
        data %>%
            extract_from_hmmer("hits.seqs") %>%
            dplyr::select(tidyselect::starts_with("seqs")) %>%
            testthat::expect_snapshot()
    })
})

httptest::with_mock_api({
    testthat::test_that("Test that extract hmmer works with hmmscan and pfam for extract pdbs", {
        data <- Biostrings::readAAMultipleAlignment("alignment.fasta") %>%
            search_hmmsearch(seqdb = "swissprot")
        data %>%
            extract_from_hmmer("hits.pdbs") %>%
            dplyr::select(tidyselect::starts_with("pdbs")) %>%
            testthat::expect_snapshot()
    })
})
