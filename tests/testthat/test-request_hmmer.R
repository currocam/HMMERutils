aln <- c(
    "FQTWEEFSRAAEKLYLADPMKVRVVLKYRHVDGNLCIKVTDDLVC",
    "-------KYRTWEEFTRAAEKLYQADPMKVRVVLKY----RHCDG",
    "EEYQTWEEFARAAEKLYLTDPMKVRVVLKYRHCDGNLCMKVTDDA"
) %>%
    Biostrings::AAMultipleAlignment() %>%
    AAMultipleAlignment_to_string()
seq <- c("MTEITAAMVKELRESTGAGMMDCKN")

test_that("It gets the UUID", {
  html_response <- '"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\n    <html xmlns=\"http://www.w3.org/1999/xhtml\">\n    <head>\n    <title>Moved</title>\n    </head>\n    <body>\n   <p>This item has moved <a href=\"https://www.ebi.ac.uk/Tools/hmmer/results/DE6D7D3A-0364-11ED-8D4B-A6544806AE6E/score\">here</a>.</p>\n</body>\n</html>\n"
attr(,"Content-Type")
                charset
"text/html"     "utf-8" '
  get_UUID_from_html_response(html_response) %>%
    expect_equal("DE6D7D3A-0364-11ED-8D4B-A6544806AE6E")
})

testthat::skip(message = "Skip request to HMMER")

test_that("hmmsearch works", {
    request_hmmer(
        aln = aln,
        seqdb = "pdb",
        url = "https://www.ebi.ac.uk/Tools/hmmer/search/hmmsearch",
        verbose = TRUE
    ) %>%
        write("hmmsearch_testing.txt")
    expect_snapshot_file("hmmsearch_testing.txt")
})

test_that("phmmer works", {
    request_hmmer(
        seq = seq,
        seqdb = "pdb",
        url = "https://www.ebi.ac.uk/Tools/hmmer/search/phmmer",
        verbose = TRUE
    ) %>%
        write("phmmer_testing.txt")
    expect_snapshot_file("phmmer_testing.txt")
})



test_that("hmmscan works", {
    request_hmmer(
        seq = seq,
        hmmdb = "pfam",
        url = "https://www.ebi.ac.uk/Tools/hmmer/search/hmmscan",
        verbose = TRUE
    ) %>%
        write("hmmscan_testing.txt")
    expect_snapshot_file("hmmscan_testing.txt")
})

test_that("phmmer works", {
    request_hmmer(
        seq = seq,
        seqdb = "pdb",
        url = "https://www.ebi.ac.uk/Tools/hmmer/search/phmmer",
        verbose = TRUE
    ) %>%
        write("phmmer_testing.txt")
    expect_snapshot_file("phmmer_testing.txt")
})
