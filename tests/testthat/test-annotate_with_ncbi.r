skip_if_not_installed("taxizedb")

test_that("Danio rerio sequential, length one, offline", {
  df <- annotate_with_NCBI_taxid(7955, "species", mode = "local")
  expect_identical(df$species[[1]], "Danio rerio")
})

test_that(
  "Danio rerio & Phascolarctos cinereus sequential, length 2, offline",
  {
    df <- annotate_with_NCBI_taxid(
      c(7955, 38626), c("species", "phylum"),
      mode = "local"
    )
    check <- c("Danio rerio", "Phascolarctos cinereus")
    df %>%
      dplyr::pull(species) %>%
      expect_setequal(check)
  }
)

test_that("Danio rerio sequential all, offline", {
  annotate_with_NCBI_taxid(7955, mode = "local") %>%
    testthat::expect_error(NA)
})

testthat::skip("No mocking for add fullseqfasta yet")
skip_if_not_installed("taxize")
test_that("Danio rerio sequential, length one, online", {
  df <- annotate_with_NCBI_taxid(7955, "species")
  df_check <- tibble::tibble(species = "Danio rerio", taxid = "7955")
  expect_identical(df, df_check)
})

test_that("Danio rerio & Phascolarctos cinereus sequential, length 2, online", {
  df <- annotate_with_NCBI_taxid(
    c(7955, 38626),
    c("species", "phylum"),
    mode = "remote"
  )
  check <- c("Danio rerio", "Phascolarctos cinereus")
  df %>%
    dplyr::pull(species) %>%
    expect_setequal(check)
})

test_that("Danio rerio sequential all, online", {
  annotate_with_NCBI_taxid(7955, mode = "remote") %>%
    testthat::expect_snapshot()
})
