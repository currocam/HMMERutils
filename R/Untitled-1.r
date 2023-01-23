library(tidyverse)
library(Biostrings)
source("C:/Users/juan.martinez.manjon/Documents/GitHub/HMMERutils/R/search_hmmscan.R")
source("C:/Users/juan.martinez.manjon/Documents/GitHub/HMMERutils/R/utils.R")
source("C:/Users/juan.martinez.manjon/Documents/GitHub/HMMERutils/R/HMMER.R")


protein.sequence <- "https://rest.uniprot.org/uniprotkb/search?compressed=true&format=fasta&query=%28proteome%3AUP000001104%29&size=500" %>%
  readAAStringSet()
hmmdbs <- c("pfam", "tigrfam", "gene3d", "superfamily", "pirsf", "treefam")
data <- search_hmmscan(seq = "SWYHGPVSRNAAEYLLSSGINGSFLVRESESSPGQRSISLRYEGRVYHYRINTASDGKLYVSS", hmmdbs) 

print(data)
