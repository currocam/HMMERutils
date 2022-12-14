create_hmmer_AnnotatedDataFrame <- function(tbl_list, algorithm) {
    uuids <- tbl_list$HMMER_response %>% purrr::map_chr(~.x$uuid)
    df <- tbl_list %>%
      dplyr::select(-.data$HMMER_response)%>%
        dplyr::mutate(
            "uuid" = uuids,
            "score.url" = tbl_list$HMMER_response %>%
              purrr::map_chr(~.x$url),
            "stats" = tbl_list$HMMER_response%>%
              purrr::map(~.x$stats),
            "hits" = tbl_list$HMMER_response%>%
              purrr::map(~.x$hits),
            "domains" = tbl_list$HMMER_response%>%
              purrr::map(~.x$domains),
        ) %>%
        add_hmmer_urls(uuids, algorithm)
    metaData <- retrieve_hmmer_metadata(colnames(df))
    annData <-Biobase::AnnotatedDataFrame(
        data = df[metaData$label],
        varMetadata = metaData %>%
            dplyr::select("labelDescription") %>%
          dplyr::mutate("algorithm" = algorithm))
    annData@dimLabels <- c("HMMERqueryNames", "columnNames")
    return(annData)
}

retrieve_hmmer_metadata <- function(colnames_vc) {
    label <- c(
        "seq.name", "dbs","uuid", "score.url", "stats", "hits", "domains",
        "text.url", "tab.url", "xml.url", "json.url", "fasta.url",
        "fullfasta.url", "alignedfasta.url", "stockholm.url", "clustalw.url",
        "psiblast.url", "phylip.url"
    )
    desc <- c(
        "Names of sequences used in the search",
        "Names of target databases used in the search",
        "The unique job identifier",
        "URL with HMMER results score",
        "The stats hash",
        "Array of sequence hashes",
        "Array of sequence domains hashes",
        "A plain text file containing the hit alignments and scores.",
        "A tab delimited text file containing the hit information. No alignments.",
        "An XML file formatted for machine parsing of the data.",
        "All the results information encoded as a single JSON string.",
        "Download the significant hits from your search as a gzipped FASTA file.",
        "Full length FASTA",
        "A gzipped file containing the full length sequences for significant search hits.",
        "A gzipped file containing aligned significant search hits in FASTA format.",
        "Download an alignment of significant hits as a gzipped ClustalW file.",
        "Download an alignment of significant hits as a gzipped psiblast file.",
        "Download an alignment of significant hits as a gzipped phylip file."
    )
    data.frame(
        "label" = label,
        "labelDescription" = desc
    ) %>%
        dplyr::filter(.data$label %in% colnames_vc)
}

add_hmmer_urls <- function(df, uuid_ch, type) {
    df <- df %>%
        dplyr::mutate(
            "text.url" = create_download_url_for_hmmer(uuid_ch, "text"),
            "tab.url" = create_download_url_for_hmmer(uuid_ch, "tsv"),
            "xml.url" = create_download_url_for_hmmer(uuid_ch, "xml"),
            "json.url" = create_download_url_for_hmmer(uuid_ch, "json")
        )
    if (type != "hmmscan") {
        df <- df %>%
            dplyr::mutate(
                "fasta.url" = create_download_url_for_hmmer(uuid_ch, "fasta"),
                "fullfasta.url" = create_download_url_for_hmmer(uuid_ch, "fullfasta"),
                "alignedfasta.url" = create_download_url_for_hmmer(uuid_ch, "afa"),
                "stockholm.url" = create_download_url_for_hmmer(uuid_ch, "stockholm"),
                "clustalw.url" = create_download_url_for_hmmer(uuid_ch, "clu"),
                "psiblast.url" = create_download_url_for_hmmer(uuid_ch, "psi"),
                "phylip.url" = create_download_url_for_hmmer(uuid_ch, "phy"),
            )
    }
    return(df)
}

create_download_url_for_hmmer <- function(uuid, format) {
    paste0(
        "https://www.ebi.ac.uk/Tools/hmmer/download/",
        uuid,
        "/score?format=",
        format
    )
}
