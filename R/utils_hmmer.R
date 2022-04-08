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

parse_hash_xml <- function(xml, hash) {
    xml %>%
        XML::xpathSApply(hash, XML::xpathSApply, "@*") %>%
        t() %>%
        as.data.frame() %>%
        dplyr::distinct()
}

parse_uuid_xml <- function(xml) {
    xml %>%
        XML::xpathSApply("//data", XML::xpathSApply, "@*") %>%
        magrittr::extract("uuid", 1)
}

numeric_values_in_hmmer_tbl <- function(df) {
    numeric_cols <- c(
        "Z", "Z_setby", "domZ", "domZ_setby", "elapsed",
        "n_past_bias", "n_past_fwd", "n_past_msv", "n_past_vit",
        "nhits", "nincluded", "nmodels", "nreported", "nseqs",
        "page", "sys", "total", "unpacked", "user",
        "bias", "evalue", "flags", "hindex", "ndom", "nincluded",
        "nregions", "nreported", "pvalue", "score", "aliId", "aliIdCount",
        "aliL", "aliM", "aliN", "aliSim", "aliSimCount", "alihindex",
        "alihmmfrom", "alihmmto", "alisqfrom", "alisqto", "bias",
        "bitscore", "cevalue", "iali", "ienv", "ievalue", "jali", "jenv",
        "oasc", "outcompeted", "significant", "uniq"
    )
    cols <- intersect(numeric_cols, colnames(df))
    df %>%
        dplyr::mutate(dplyr::across(cols, as.numeric))
}
