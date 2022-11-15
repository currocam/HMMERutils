#' Split a column composed of nested lists into multiple columns.
#'
#' @param data Dataframe whose column is going to be splitted.
#' @param column Column to split.
#'
#' @return A DataFrame with columns `column` splitted into
#' several columns.
#'
#' @examples
#' data(phmmer_2abl)
#' extract_from_hmmer(
#'     data = phmmer_2abl,
#'     column = "hits.domains"
#' )
#' @export
extract_from_hmmer <- function(data, column = "hits.domains") {
    # Create copy of data
    data2 <- data.frame(data)
    # Save number of rows
    n.rows <- nrow(data2)
    # Initialize list with new column
    new.column <- list()
    for (row in seq_len(n.rows)) {
        new.column[[length(new.column) + 1]] <- list()
    }

    # Iterate over each row of dataframe
    for (row in seq_len(n.rows)) {
        # Calculate number of domains/sequences in actual row
        n.elements <- length(data2[row, column][[1]])

        # If there are more than one domain/sequence, add them at the end of
        # dataframe
        if (n.elements > 1) {
            for (el in c(2:n.elements)) {
                data2[nrow(data2) + 1, ] <- data2[row, ]
                assigned.element <- data2[row, column][[1]][[el]]

                if (is.null(assigned.element)) {
                    assigned.element <- NA
                }
                new.column[[length(new.column) + 1]] <- assigned.element
            }
        }
        # Access to actual row list
        assigned.element <- data2[row, column][[1]][[1]]
        if (is.null(assigned.element)) {
            assigned.element <- NA
        }
        new.column[[row]] <- assigned.element
    }
    # Substitute new.column by column name and unnest column list into
    # multiple columns
    data2 <- data2 %>% bind_and_unnest(column, new.column)
    data2
}


bind_and_unnest <- function(data, old.column, new.column) {
    data2 <- data.frame(data)
    data2 <- cbind(data2, I(new.column))

    data2 <- data2 %>%
        dplyr::select(-c({
            old.column
        })) %>%
        dplyr::rename({{ old.column }} := new.column)

    if (old.column != "hits.pdbs") {
        data2 <- data2 %>%
            tidyr::unnest_wider({{ old.column }}, names_sep = ".")
    }

    # Remove empty columns
    data2 <- data2 %>%
        dplyr::select_if(~ any(!is.na(.)))

    # Remove 'hits.' prefix from colnames
    colnames(data2) <- colnames(data2) %>%
        stringr::str_replace_all(
            old.column,
            stringr::str_remove(old.column, "hits.")
        )

    # Coerce some columns to numeric
    to_coerce <- c("domains.ievalue", "domains.bias", "domains.cevalue",
               "domains.oasc")

    data2[to_coerce] <- lapply(data2[to_coerce], as.numeric)  

    # Return new dataframe
    data2
}
