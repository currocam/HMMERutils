test_that("pairwise_alignment autoplot works", {
    data(ABL1_homologous)
    seqs <- ABL1_homologous$hits.fullseq.fasta[1:3]
    pairwise.object <- pairwise_alignment_sequence_identity(seqs)
    vdiffr::expect_doppelganger(
        "A pairwise histogram",
        plot(pairwise.object)
    )
    vdiffr::expect_doppelganger(
        "A pairwise annotated",
        plot(pairwise.object,
            type = "heatmap",
            annotation = ABL1_homologous$taxa.phylum[1:3]
        )
    )
})

test_that("pairwise_alignment works", {
    data(ABL1_homologous)
    seqs <- ABL1_homologous$hits.fullseq.fasta[1:3]
    pairwise_alignment_sequence_identity(seqs) %>%
        dplyr::pull("percentage.sequence.identity") %>%
        expect_snapshot_value(style = "deparse")
})

testthat::skip_on_ci()
test_that("pairwise_alignment works with furrr", {
    data(ABL1_homologous)
    ABL1_homologous$hits.fullseq.fasta[1:3] %>%
        pairwise_alignment_sequence_identity(
            allow_parallelization = "multisession"
        ) %>%
        dplyr::pull("percentage.sequence.identity") %>%
        expect_snapshot_value(style = "deparse")
})
