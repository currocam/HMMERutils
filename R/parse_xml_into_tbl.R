parse_xml_into_tbl <- function(hmm, type = "default") {
    hmm %>%
        purrr::map(
            purrr::possibly(
                otherwise = list(
                    "uuid" = NA,
                    "url" = NA,
                    "stats" = NA,
                    "hits" = NA,
                    "domains" = NA
                ),
                ~ {
                    xml <- XML::xmlParse(.x$content)
                    file.remove(.x$content)
                    uuid <- .x$uuid
                    ## parse xml
                    list(
                        "uuid" = uuid,
                        "url" = get_results_url(uuid),
                        "stats" = parse_hash_xml(xml, "///stats"),
                        "hits" = parse_hash_xml(xml, "///hits"),
                        "domains" = parse_hash_xml(xml, "///domains") %>%
                          {if(type == "hmmscan") purrr::flatten_dfr(.) else .}
                    )
                }
            )
        ) %>%
        purrr::transpose()
}
