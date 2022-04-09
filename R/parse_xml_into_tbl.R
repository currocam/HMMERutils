parse_xml_into_tbl <- function(hmm) {
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
                    xml <- XML::xmlParse(.x)
                    uuid <- parse_uuid_xml(xml)
                    ## parse xml
                    list(
                        "uuid" = uuid,
                        "url" = get_results_url(uuid),
                        "stats" = parse_hash_xml(xml, "///stats"),
                        "hits" = parse_hash_xml(xml, "///hits"),
                        "domains" = parse_hash_xml(xml, "///domains") %>%
                            purrr::flatten_dfr()
                    )
                }
            )
        ) %>%
        purrr::transpose()
}
