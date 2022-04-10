    testthat::skip(message = "Skip request to HMMER")

    aln <- c(
        "FQTWEEFSRAAEKLYLADPMKVRVVLKYRHVDGNLCIKVTDDLVC",
        "-------KYRTWEEFTRAAEKLYQADPMKVRVVLKY----RHCDG",
        "EEYQTWEEFARAAEKLYLTDPMKVRVVLKYRHCDGNLCMKVTDDA"
    ) %>%
        Biostrings::AAMultipleAlignment() %>%
        AAMultipleAlignment_to_string()
    seq <- c("MTEITAAMVKELRESTGAGMMDCKN")

    test_that("hmmsearch works", {
        request_hmmer(
            aln = aln,
            seqdb = "pdb",
            url = "https://www.ebi.ac.uk/Tools/hmmer/search/hmmsearch",
            verbose = TRUE,
            fullseqfasta = TRUE,
            alignment = TRUE
        ) %>%
            write("hmmsearch_testing.txt")
        expect_snapshot_file("hmmsearch_testing.txt")
    })


    test_that("phmmer works", {
        request_hmmer(
            seq = seq,
            seqdb = "pdb",
            url = "https://www.ebi.ac.uk/Tools/hmmer/search/phmmer",
            verbose = TRUE,
            fullseqfasta = TRUE,
            alignment = TRUE
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

    test_that("jackhammer works with seq", {
        request_hmmer(
            seq = seq,
            seqdb = "pdb",
            url = "https://www.ebi.ac.uk/Tools/hmmer/search/jackhmmer",
            verbose = TRUE,
            fullseqfasta = TRUE,
            alignment = TRUE
        ) %>%
            write("jackhammer_seq_testing.txt")
        expect_snapshot_file("jackhammer_seq_testing.txt")
    })

    test_that("jackhammer works with aln", {
        request_hmmer(
            aln = aln,
            seqdb = "pdb",
            url = "https://www.ebi.ac.uk/Tools/hmmer/search/jackhmmer",
            verbose = TRUE,
            fullseqfasta = TRUE,
            alignment = TRUE
        ) %>%
            write("jackhammer_aln_testing.txt")
        expect_snapshot_file("jackhammer_aln_testing.txt")
    })
