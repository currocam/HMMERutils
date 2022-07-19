aln <- c(
  "FQTWEEFSRAAEKLYLADPMKVRVVLKYRHVDGNLCIKVTDDLVC",
  "-------KYRTWEEFTRAAEKLYQADPMKVRVVLKY----RHCDG",
  "EEYQTWEEFARAAEKLYLTDPMKVRVVLKYRHCDGNLCMKVTDDA"
) %>%
  Biostrings::AAMultipleAlignment()
seq <- c("MTEITAAMVKELRESTGAGMMDCKN")

test_that("phmmer works", {
  httptest::with_mock_api(
    {
      search_phmmer(seqs = seq)%>%
        Biobase::pData()%>%
        expect_snapshot_output()
    }
  )
})

test_that("hmmsearch works", {
  httptest::with_mock_api(
    {
      search_hmmsearch(alns = aln,dbs = "pdb") %>%
        Biobase::pData()%>%
        expect_snapshot_output()
    }
  )

})

test_that("hmmscan works", {
  httptest::with_mock_api(
    {
      search_hmmscan(seq) %>%
        Biobase::pData()%>%
        expect_snapshot_output()
    }
  )
  })


test_that("hmmscan throws warning Bad Request when sequence database", {
  httptest::with_mock_api(
    {
      HMMER_data <- search_hmmscan(seq, dbs = "pdb") %>%
        expect_snapshot_warning()
    }
  )
})






