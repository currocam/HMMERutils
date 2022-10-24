
<!-- README.md is generated from README.Rmd. Please edit that file -->

# HMMERutils

<!-- badges: start -->

[![GitHub
issues](https://img.shields.io/github/issues/currocam/HMMERutils)](https://github.com/currocam/HMMERutils/issues)
[![GitHub
pulls](https://img.shields.io/github/issues-pr/currocam/HMMERutils)](https://github.com/currocam/HMMERutils/pulls)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![BioC
status](http://www.bioconductor.org/shields/build/release/bioc/HMMERutils.svg)](https://bioconductor.org/checkResults/release/bioc-LATEST/HMMERutils)
[![R-CMD-check-bioc](https://github.com/currocam/HMMERutils/actions/workflows/R-CMD-check-bioc.yaml/badge.svg)](https://github.com/currocam/HMMERutils/actions/workflows/R-CMD-check-bioc.yaml)
[![Codecov test
coverage](https://codecov.io/gh/currocam/HMMERutils/branch/master/graph/badge.svg)](https://app.codecov.io/gh/currocam/HMMERutils?branch=master)
<!-- badges: end -->

The goal of `HMMERutils` is to provide a bunch of convenient functions
to search for homologous sequences using the HMMER API, annotate them
taxonomically, calculate physicochemical properties and facilitate
exploratory analysis of homologous sequence data.

## Installation instructions

Not yet !

Get the latest stable `R` release from
[CRAN](http://cran.r-project.org/). Then install `HMMERutils` from
[Bioconductor](http://bioconductor.org/) using the following code:

``` r
if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
}

BiocManager::install("HMMERutils")
```

And the development version from
[GitHub](https://github.com/currocam/HMMERutils) with:

``` r
BiocManager::install("currocam/HMMERutils")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library("HMMERutils")
fasta_2abl <- paste0(
    "MGPSENDPNLFVALYDFVASGDNTLSITKGEKLRVLGYNHNGEWCEAQTKNGQGW",
    "VPSNYITPVNSLEKHSWYHGPVSRNAAEYLLSSGINGSFLVRESESSPGQRSISL",
    "RYEGRVYHYRINTASDGKLYVSSESRFNTLAELVHHHSTVADGLITTLHYPAP"
)
data <- search_phmmer(seq = fasta_2abl, seqdb = "swissprot") %>%
    add_sequences_to_hmmer_tbl() %>%
    add_taxa_to_hmmer_tbl() %>%
    add_physicochemical_properties_to_HMMER_tbl()
```

``` r
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
data %>%
    filter(hits.evalue > 10^-5) %>%
    distinct(hits.fullfasta, .keep_all = TRUE) %>%
    group_by(taxa.phylum) %>%
    summarise(
      n = n(),
      "Molecular.Weigth" = mean(properties.molecular.weight, na.rm = TRUE)        )
#> # A tibble: 7 × 3
#>   taxa.phylum        n Molecular.Weigth
#>   <chr>          <int>            <dbl>
#> 1 Arthropoda         2          197779.
#> 2 Artverviricota     3           71266.
#> 3 Ascomycota        19          126362.
#> 4 Basidiomycota      1          139552.
#> 5 Chordata          71           77001.
#> 6 Evosea             3          102576.
#> 7 Nematoda           6           55944.
```

## Citation

Below is the citation output from using `citation('HMMERutils')` in R.
Please run this yourself to check for any updates on how to cite
**HMMERutils**.

``` r
print(citation("HMMERutils"), bibtex = TRUE)
```

Please note that the `HMMERutils` was only made possible thanks to many
other R and bioinformatics software authors, which are cited either in
the vignettes and/or the paper(s) describing this package.

## Code of Conduct

Please note that the `HMMERutils` project is released with a
[Contributor Code of
Conduct](http://bioconductor.org/about/code-of-conduct/). By
contributing to this project, you agree to abide by its terms.

## Development tools

-   Continuous code testing is possible thanks to [GitHub
    actions](https://www.tidyverse.org/blog/2020/04/usethis-1-6-0/)
    through *[usethis](https://CRAN.R-project.org/package=usethis)*,
    *[remotes](https://CRAN.R-project.org/package=remotes)*, and
    *[rcmdcheck](https://CRAN.R-project.org/package=rcmdcheck)*
    customized to use [Bioconductor’s docker
    containers](https://www.bioconductor.org/help/docker/) and
    *[BiocCheck](https://bioconductor.org/packages/3.15/BiocCheck)*.
-   Code coverage assessment is possible thanks to
    [codecov](https://codecov.io/gh) and
    *[covr](https://CRAN.R-project.org/package=covr)*.
-   The [documentation website](http://currocam.github.io/HMMERutils) is
    automatically updated thanks to
    *[pkgdown](https://CRAN.R-project.org/package=pkgdown)*.
-   The code is styled automatically thanks to
    *[styler](https://CRAN.R-project.org/package=styler)*.
-   The documentation is formatted thanks to
    *[devtools](https://CRAN.R-project.org/package=devtools)* and
    *[roxygen2](https://CRAN.R-project.org/package=roxygen2)*.
