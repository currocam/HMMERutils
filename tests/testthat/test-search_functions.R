httptest::with_mock_api({
    testthat::test_that("mock search_phmmer works", {
        search_phmmer(
            seqdb = c("pdb", "pfam"),
            seq = c(
            "KLRVLGYHNGEWCEAQTKNGQGWVPSNYITPVNSLENSIDKHSWYHGPVSRNAAE",
            "KLRVLGYHNGEWCEAQTKNGQGWVPSNYITPVNSLENSIDKHSWYHGPVSRNAAE"
            )
        ) %>%
            testthat::expect_snapshot()
    })
})

httptest::with_mock_api({
    testthat::test_that("mock search_hmmscan works", {
        search_hmmscan(
            hmmdb = c("pfam", "pdb"),
            seq = c(
                "KLRVLGYHNGEWCEAQTKNGQGWVPSNYITPVNSLENSIDKHSWYHGPVSRNAAE",
                "KLRVLGYHNGEWCEAQTKNGQGWVPSNYITPVNSLENSIDKHSWYHGPVSRNAAE"
            )
        ) %>%
            testthat::expect_snapshot()
    })
})

httptest::with_mock_api({
    testthat::test_that("mock search_hmmsearch works", {
        aln <- Biostrings::readAAMultipleAlignment("alignment.fasta")
        search_hmmsearch(
            seqdb = c("pdb", "pfam"),
            aln = aln
        ) %>%
            testthat::expect_snapshot()
    })
})