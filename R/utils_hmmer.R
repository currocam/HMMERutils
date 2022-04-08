is_protein_seq <- function(x) {
    AA_STANDARD <- c(
        "A", "R", "N", "D", "C", "Q", "E", "G", "H", "I",
        "L", "K", "M", "F", "P", "S", "T", "W", "Y", "V"
    )
    x.vc <- x %>%
        as.character() %>%
        strsplit(split = "") %>%
        unlist()
    all(x.vc %in% AA_STANDARD)
}

parse_hash_xml <- function(xml, hash){
  xml %>%
    XML::xpathSApply(hash, XML::xpathSApply, '@*') %>%
    t() %>%
    as.data.frame()%>%
    dplyr::distinct()

}



