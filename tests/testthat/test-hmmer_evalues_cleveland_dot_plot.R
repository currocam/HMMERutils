    test_that("plot works", {
        data(ABL1_homologous)
        vdiffr::expect_doppelganger(
            "A cleveland_dot_plot",
            hmmer_evalues_cleveland_dot_plot(
                ABL1_homologous,
                threshold = 0.001
            )
        )
    })
