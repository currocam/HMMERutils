
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
[![R-CMD-check-bioc](https://github.com/currocam/HMMERutils/workflows/R-CMD-check-bioc/badge.svg)](https://github.com/currocam/HMMERutils/actions)
<!-- badges: end -->

The goal of `HMMERutils` is to provide convenient functions search for
homologous sequences using the HMMER API, annotate them taxonomically,
calculate physicochemical properties and facilitate exploratory analysis
of homologous sequence data.

## Installation instructions

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

This is a basic example showing how to post a request to HMMER, convert
the information it returns into a tidy HMMERutils’ DataFrame, as well as
add taxonomic and physicochemical information inferred from the
sequence. As an example, we will use the results of the PHMMER example
search, where we searched for sequences homologous to ABL1 in the PDB.

First, we post the request:

``` r
library("HMMERutils")
library(tidyverse)
library(Biobase)
ABL1_seq <- "MGPSENDPNLFVALYDFVASGDNTLSITKGEKLRVLGYNHNGEWCEAQTKNGQGWVPSNYITPVNSLEKHSWYHGPVSRNAAEYLLSSGINGSFLVRESESSPGQRSISLRYEGRVYHYRINTASDGKLYVSSESRFNTLAELVHHHSTVADGLITTLHYPAP"

## Downloaded files from HMMER
HMMER_ABL1_search <- search_phmmer(ABL1_seq,dbs = "pdb", verbose = FALSE)
HMMER_ABL1_search
#> An object of class 'AnnotatedDataFrame'
#>   HMMERqueryNames: 1
#>   varLabels: dbs uuid ... phylip.url (17 total)
#>   varMetadata: labelDescription algorithm
```

The different files that HMMER makes available to us, as well as the
information about the sequences are now contained in
`HMMER_ABL1_search`. Let’s see the metadata of the first 6 variables of
this `AnnotatedDataFrame`:

``` r
head(varMetadata(HMMER_ABL1_search))
#>                                       labelDescription algorithm
#> dbs       Names of target databases used in the search    phmmer
#> uuid                         The unique job identifier    phmmer
#> score.url                 URL with HMMER results score    phmmer
#> stats                                   The stats hash    phmmer
#> hits                          Array of sequence hashes    phmmer
#> domains               Array of sequence domains hashes    phmmer
```

We can then extract this information into a tidy DataFrame, preprocess
the data and add more information to it. The basic workflow is as
follows:

``` r
HMMER_ABL1_data <- HMMER_ABL1_search %>%
  extract_from_HMMER_data_tbl() %>% # extract the information into a DataFrame
  add_fullseq_to_HMMER_tbl(HMMER_ABL1_search$fullfasta.url)%>% #add sequences
  add_taxa_to_HMMER_tbl(mode = "local") %>% # add taxonomic information
  add_physicochemical_properties_to_HMMER_tbl() #calculate theoretical physical and chemical properties
HMMER_ABL1_data
#> An object of class 'AnnotatedDataFrame'
#>   rowNames: 1 2 ... 860 (860 total)
#>   varLabels: uuid hits.name ... properties.Acidic (108 total)
#>   varMetadata: labelDescription
```

Let’s see the metadata of the first 15 variables of this
`AnnotatedDataFrame`:

``` r
head(varMetadata(HMMER_ABL1_data),15)
#>                                                                                                             labelDescription
#> uuid                                                                                               The unique job identifier
#> hits.name                                               Name of the target (sequence for phmmer/hmmsearch, HMM for hmmscan).
#> hits.arch                                                                                      Sequence domain architecture.
#> hits.acc                                                                                            Accession of the target.
#> hits.desc                                                                                         Description of the target.
#> hits.score                                                       Bit score of the sequence (all domains, without correction)
#> hits.pvalue                                                                                            P-value of the score.
#> hits.evalue                                                                                            E-value of the score.
#> hits.nregions                                                                                   Number of regions evaluated.
#> hits.ndom                                                               Total number of domains identified in this sequence.
#> hits.nreported                                                          Number of domains satisfying reporting thresholding.
#> hits.nincluded                                                          Number of domains satisfying inclusion thresholding.
#> hits.taxid                                                       The NCBI taxonomy identifier of the target (if applicable).
#> hits.species                                                                 The species name of the target (if applicable).
#> hits.kg         The kingdom of life that the target belongs to - based on placing in the NCBI taxonomy tree (if applicable).
```

## Citation

Below is the citation output from using `citation('HMMERutils')` in R.
Please run this yourself to check for any updates on how to cite
**HMMERutils**.

``` {r
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
    *[BiocCheck](https://bioconductor.org/packages/3.14/BiocCheck)*.
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

For more details, check the `dev` directory.

This package was developed using
*[biocthis](https://bioconductor.org/packages/3.14/biocthis)*.
