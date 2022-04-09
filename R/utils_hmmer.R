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

deal_with_input_sequences <- function(seqs) {
    if (!is_protein_seq(seqs)) {
        stop(
            "`seq` must be a protein sequence.\n",
            "Characters not belonging to the AA standar ",
            "alphabet were found."
        )
    }
    old.names <- names(seqs)
    seqs <- as.character(seqs)
    if (!is.null(old.names)) {
        names(seqs) <- old.names
    }
    return(seqs)
}

AAMultipleAlignment_to_string <- function(alns) {
    if (is(alns, "AAMultipleAlignment")) {
        alns <- c(alns)
    }
    alns %>%
        purrr::map_chr(~ {
            aln.chr <- .x %>%
                Biostrings::unmasked() %>%
                as.character()
            if (is.null(names(aln.chr))) {
                n_seqs <- length(aln.chr)
                names(aln.chr) <- paste0("seq", seq(n_seqs))
            }
            paste(
                collapse = "\n",
                paste0(">", names(aln.chr)),
                "\n", aln.chr
            )
        })
}

parse_hash_xml <- function(xml, hash) {
    xml %>%
        XML::xpathSApply(hash, XML::xpathSApply, "@*") %>%
        t() %>%
        as.data.frame() %>%
        dplyr::distinct() %>%
        add_numeric_values_to_hmmer_tbl()
}

parse_uuid_xml <- function(xml) {
    xml %>%
        XML::xpathSApply("//data", XML::xpathSApply, "@*") %>%
        magrittr::extract("uuid", 1)
}

get_fullseqfasta_url <- function(uuid) {
    paste0(
        "https://www.ebi.ac.uk/Tools/hmmer/download/",
        uuid,
        "/score?format=fullfasta"
    )
}
get_alignment_url <- function(uuid) {
    paste0(
        "https://www.ebi.ac.uk/Tools/hmmer/download/",
        uuid,
        "/score?format=afa"
    )
}
get_results_url <- function(uuid) {
    paste0(
        "http://www.ebi.ac.uk/Tools/hmmer/results/",
        uuid
    )
}




add_numeric_values_to_hmmer_tbl <- function(df) {
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
        dplyr::mutate(
            dplyr::across(
                dplyr::all_of(cols), as.numeric
            )
        )
}
